#!/usr/bin/env bash
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
runtime_root=/opt/plausible
compose_file="$runtime_root/docker-compose.yml"
compose=(docker compose --project-directory "$runtime_root" --file "$compose_file")
work_dir="$(mktemp -d)"
phase=initialization
root_command=()
if [ "$(id -u)" -ne 0 ]; then
  root_command=(sudo)
fi
host_paths_owned=false

cleanup() {
  status=$?
  set +e
  if [ "$status" -ne 0 ]; then
    echo "Plausible restore rehearsal failed during phase: $phase" >&2
    if [ -f "$compose_file" ]; then
      "${compose[@]}" ps >&2
      "${compose[@]}" logs --tail=120 plausible clickhouse postgres nginx >&2
    fi
  fi
  if [ -f "$compose_file" ]; then
    "${compose[@]}" down --volumes --remove-orphans >/dev/null 2>&1
  fi
  if "$host_paths_owned"; then
    "${root_command[@]}" rm -rf -- \
      /srv/plausible \
      /opt/abpiv-plausible \
      /opt/plausible \
      /run/plausible \
      /var/backups/plausible-migration \
      /var/backups/plausible-migration-packages
  fi
  rm -rf -- "$work_dir"
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT

if [ -n "$(docker ps --all --quiet --filter label=com.docker.compose.project=abpiv-plausible)" ]; then
  echo "Refusing to disturb an existing abpiv-plausible Docker project." >&2
  exit 1
fi

for path in \
  /srv/plausible \
  /opt/abpiv-plausible \
  /opt/plausible \
  /run/plausible \
  /var/backups/plausible-migration \
  /var/backups/plausible-migration-packages; do
  if "${root_command[@]}" test -e "$path"; then
    echo "Refusing to replace existing rehearsal path: $path" >&2
    exit 1
  fi
done
host_paths_owned=true

"${root_command[@]}" install -d -m 0750 \
  /srv/plausible/state \
  /srv/plausible/clickhouse-data \
  /srv/plausible/clickhouse-logs \
  /srv/plausible/clickhouse-backups
"${root_command[@]}" install -d -m 0700 \
  /srv/plausible/postgres \
  /run/plausible \
  /opt/abpiv-plausible
printf %s fixture-password | "${root_command[@]}" tee /run/plausible/POSTGRES_PASSWORD >/dev/null
printf %s fixture-secret-key-base-longer-than-sixty-four-bytes-01234567890123456789 | \
  "${root_command[@]}" tee /run/plausible/SECRET_KEY_BASE >/dev/null
printf %s postgres://plausible:fixture-password@postgres:5432/plausible | \
  "${root_command[@]}" tee /run/plausible/DATABASE_URL >/dev/null
"${root_command[@]}" chmod 0400 /run/plausible/*
"${root_command[@]}" chown -R 70:70 /srv/plausible/postgres
"${root_command[@]}" chown -R 999:65533 /srv/plausible/state
"${root_command[@]}" chown -R 101:101 \
  /srv/plausible/clickhouse-data \
  /srv/plausible/clickhouse-logs \
  /srv/plausible/clickhouse-backups

tar --create --file - --directory "$repository_root/infra/analytics/compute" . | \
  "${root_command[@]}" tar --extract --file - --directory /opt/abpiv-plausible
"${root_command[@]}" cp /opt/abpiv-plausible/nginx/active.conf /opt/abpiv-plausible/nginx/current.conf
"${root_command[@]}" chmod 0755 /opt/abpiv-plausible/scripts/*.sh
"${root_command[@]}" cp -a /opt/abpiv-plausible /opt/plausible

"${compose[@]}" config --quiet
phase=container-startup
"${compose[@]}" up --detach --wait

for service in plausible postgres clickhouse nginx; do
  health="$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' "abpiv-plausible-${service}-1")"
  test "$health" = healthy
done
if docker inspect abpiv-plausible-plausible-1 abpiv-plausible-postgres-1 | grep -Fq 'fixture-password'; then
  echo "A Plausible secret leaked into Docker container metadata." >&2
  exit 1
fi
"${compose[@]}" exec --no-TTY nginx wget --quiet --output-document=- \
  --header='Host: analytics.lobst3rs.com' http://127.0.0.1:8000/healthz/readiness >/dev/null
"${compose[@]}" exec --no-TTY plausible sh -c 'printf %s fixture-state > /var/lib/plausible/migration-fixture.txt'
"${compose[@]}" stop plausible >/dev/null

"${compose[@]}" exec --no-TTY postgres psql --username=plausible --dbname=plausible --set ON_ERROR_STOP=1 \
  --command 'CREATE TABLE migration_fixture (id integer PRIMARY KEY); INSERT INTO migration_fixture VALUES (1), (2), (3);' >/dev/null
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client --multiquery --query \
  'CREATE TABLE plausible_events_db.migration_fixture (id UInt64) ENGINE=MergeTree ORDER BY id; INSERT INTO plausible_events_db.migration_fixture VALUES (1), (2), (3), (4);'
test "$("${compose[@]}" exec --no-TTY clickhouse clickhouse-client --query 'SELECT count() FROM plausible_events_db.migration_fixture')" = 4

count_sql="SELECT format('%I%s%s', tablename, chr(9), (xpath('//row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', tablename), false, true, '')))[1]::text) FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"
"${compose[@]}" exec --no-TTY postgres psql --username=plausible --dbname=plausible \
  --no-align --tuples-only --set ON_ERROR_STOP=1 --command "$count_sql" > "$work_dir/postgres-counts.tsv"
grep -Fxq $'migration_fixture\t3' "$work_dir/postgres-counts.tsv"
phase=encrypted-export
age-keygen --output "$work_dir/age-identity.txt" >/dev/null 2>&1
recipient="$(age-keygen -y "$work_dir/age-identity.txt")"
export_dir="$("${root_command[@]}" env MIGRATION_AGE_RECIPIENT="$recipient" CONFIRM_EXPORT=export-legacy-plausible-data \
  "$repository_root/infra/analytics/compute/scripts/export-legacy-plausible.sh" | tail -n1)"
case "$export_dir" in /var/backups/plausible-migration-packages/*) ;; *) exit 1 ;; esac
phase=package-decryption
"${root_command[@]}" age --decrypt --identity "$work_dir/age-identity.txt" \
  --output "$work_dir/plausible-migration.tar" "$export_dir/plausible-migration.tar.age"
"${root_command[@]}" install -d -m 0700 "$work_dir/package"
"${root_command[@]}" tar --extract --file "$work_dir/plausible-migration.tar" --directory "$work_dir/package" --no-same-owner
"${root_command[@]}" chown -R "$(id -u):$(id -g)" "$work_dir/package" "$work_dir/plausible-migration.tar"
(cd "$work_dir/package" && sha256sum --check SHA256SUMS >/dev/null)
phase=evidence-verification
if ! grep -Fxq $'migration_fixture\t3' "$work_dir/package/source-postgres-counts.tsv"; then
  echo "Exported PostgreSQL evidence omitted or changed the fixture count." >&2
  sed -n '1,120p' "$work_dir/package/source-postgres-counts.tsv" >&2
  exit 1
fi
if ! grep -Fxq $'migration_fixture\t4' "$work_dir/package/source-clickhouse-counts.tsv"; then
  echo "Exported ClickHouse evidence omitted or changed the fixture count." >&2
  sed -n '1,120p' "$work_dir/package/source-clickhouse-counts.tsv" >&2
  exit 1
fi

"${compose[@]}" exec --no-TTY postgres createdb --username=plausible plausible_restore
phase=postgres-restore
"${compose[@]}" exec --no-TTY --interactive postgres pg_restore --username=plausible --dbname=plausible_restore \
  --exit-on-error --no-owner --no-acl < "$work_dir/package/postgres.dump"
"${compose[@]}" exec --no-TTY postgres psql --username=plausible --dbname=plausible_restore \
  --no-align --tuples-only --set ON_ERROR_STOP=1 --command "$count_sql" > "$work_dir/target-postgres-counts.tsv"
cmp --silent "$work_dir/package/source-postgres-counts.tsv" "$work_dir/target-postgres-counts.tsv"

"${compose[@]}" cp "$work_dir/package/clickhouse-plausible-events.zip" clickhouse:/var/lib/clickhouse/backups/fixture.zip
phase=clickhouse-restore
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client --query 'DROP DATABASE plausible_events_db SYNC'
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client \
  --query "RESTORE DATABASE plausible_events_db FROM File('fixture.zip')"
clickhouse_container="$("${compose[@]}" ps --all --quiet clickhouse)"
test -n "$clickhouse_container"
docker exec "$clickhouse_container" clickhouse-client \
  --query "SELECT name FROM system.tables WHERE database='plausible_events_db' ORDER BY name FORMAT TSVRaw" \
  > "$work_dir/target-clickhouse-tables.tsv"
: > "$work_dir/target-clickhouse-counts.tsv"
while IFS= read -r table; do
  count="$(docker exec "$clickhouse_container" clickhouse-client \
    --query "SELECT count() FROM plausible_events_db.\`${table}\`")"
  printf '%s\t%s\n' "$table" "$count" >> "$work_dir/target-clickhouse-counts.tsv"
done < "$work_dir/target-clickhouse-tables.tsv"
cmp --silent "$work_dir/package/source-clickhouse-counts.tsv" "$work_dir/target-clickhouse-counts.tsv"

docker run --rm -v /srv/plausible/state:/state alpine:3.22 sh -c 'find /state -mindepth 1 -delete'
phase=state-restore
docker run --rm --interactive -v /srv/plausible/state:/state alpine:3.22 \
  tar --extract --file - --directory /state < "$work_dir/package/plausible-state.tar"
docker run --rm -v /srv/plausible/state:/state alpine:3.22 chown -hR 999:65533 /state
(
  cd /srv/plausible/state
  find . -type f -print0 | LC_ALL=C sort --zero-terminated | \
    xargs --null --no-run-if-empty sha256sum > "$work_dir/target-state-checksums.tsv"
  find . -printf '%y\t%p\t%l\0' | LC_ALL=C sort --zero-terminated > "$work_dir/target-state-entries.bin"
)
cmp --silent "$work_dir/package/source-state-checksums.tsv" "$work_dir/target-state-checksums.tsv"
cmp --silent "$work_dir/package/source-state-entries.bin" "$work_dir/target-state-entries.bin"

phase=daily-package
install -d -m 0700 "$work_dir/daily-output" "$work_dir/daily-package"
env PACKAGE_DIR="$work_dir/daily-output" BACKUP_AGE_RECIPIENT="$recipient" \
  COMPOSE_DIR=/opt/plausible STATE_DIR=/srv/plausible/state \
  "$repository_root/infra/analytics/compute/scripts/create-backup-package.sh" >/dev/null
(cd "$work_dir/daily-output" && sha256sum --check plausible-backup.tar.age.sha256 >/dev/null)
age --decrypt --identity "$work_dir/age-identity.txt" \
  --output "$work_dir/daily-backup.tar" "$work_dir/daily-output/plausible-backup.tar.age"
if tar --list --file "$work_dir/daily-backup.tar" | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
  echo "Unsafe path in disposable daily backup." >&2
  exit 1
fi
tar --extract --file "$work_dir/daily-backup.tar" --directory "$work_dir/daily-package" --no-same-owner
(cd "$work_dir/daily-package" && sha256sum --check SHA256SUMS >/dev/null)

phase=daily-restore
"${compose[@]}" exec --no-TTY postgres createdb --username=plausible plausible_daily_restore
"${compose[@]}" exec --no-TTY --interactive postgres pg_restore --username=plausible --dbname=plausible_daily_restore \
  --exit-on-error --no-owner --no-acl < "$work_dir/daily-package/postgres.dump"
"${compose[@]}" exec --no-TTY postgres psql --username=plausible --dbname=plausible_daily_restore \
  --no-align --tuples-only --set ON_ERROR_STOP=1 --command "$count_sql" > "$work_dir/daily-target-postgres-counts.tsv"
cmp --silent "$work_dir/daily-package/source-postgres-counts.tsv" "$work_dir/daily-target-postgres-counts.tsv"

"${compose[@]}" cp "$work_dir/daily-package/clickhouse-plausible-events.zip" \
  clickhouse:/var/lib/clickhouse/backups/daily-fixture.zip
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client --query 'DROP DATABASE plausible_events_db SYNC'
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client \
  --query "RESTORE DATABASE plausible_events_db FROM File('daily-fixture.zip')"
docker exec "$clickhouse_container" clickhouse-client \
  --query "SELECT name FROM system.tables WHERE database='plausible_events_db' ORDER BY name FORMAT TSVRaw" \
  > "$work_dir/daily-target-clickhouse-tables.tsv"
: > "$work_dir/daily-target-clickhouse-counts.tsv"
while IFS= read -r table; do
  count="$(docker exec "$clickhouse_container" clickhouse-client \
    --query "SELECT count() FROM plausible_events_db.\`${table}\`")"
  printf '%s\t%s\n' "$table" "$count" >> "$work_dir/daily-target-clickhouse-counts.tsv"
done < "$work_dir/daily-target-clickhouse-tables.tsv"
cmp --silent "$work_dir/daily-package/source-clickhouse-counts.tsv" "$work_dir/daily-target-clickhouse-counts.tsv"

find /srv/plausible/state -mindepth 1 -delete
tar --extract --file "$work_dir/daily-package/plausible-state.tar" --directory /srv/plausible/state --no-same-owner
chown -hR 999:65533 /srv/plausible/state
(
  cd /srv/plausible/state
  find . -type f -print0 | LC_ALL=C sort --zero-terminated | \
    xargs --null --no-run-if-empty sha256sum > "$work_dir/daily-target-state-checksums.tsv"
  find . -printf '%y\t%p\t%l\0' | LC_ALL=C sort --zero-terminated > "$work_dir/daily-target-state-entries.bin"
)
cmp --silent "$work_dir/daily-package/source-state-checksums.tsv" "$work_dir/daily-target-state-checksums.tsv"
cmp --silent "$work_dir/daily-package/source-state-entries.bin" "$work_dir/daily-target-state-entries.bin"

"${compose[@]}" up --detach --wait plausible
phase=final-readiness
"${compose[@]}" exec --no-TTY nginx wget --quiet --output-document=- \
  --header='Host: analytics.lobst3rs.com' http://127.0.0.1:8000/healthz/readiness >/dev/null

echo "Plausible migration and actual daily-package restore rehearsals passed for PostgreSQL, every ClickHouse table, application state, and proxied readiness."

#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

: "${MIGRATION_AGE_RECIPIENT:?Set the public age recipient generated for the target runtime}"
: "${CONFIRM_EXPORT:?Set CONFIRM_EXPORT=export-legacy-plausible-data}"
test "$CONFIRM_EXPORT" = "export-legacy-plausible-data"
test "$(id -u)" -eq 0
command -v age >/dev/null

compose=(docker compose --project-directory /opt/plausible --file /opt/plausible/docker-compose.yml)
plausible_container="$("${compose[@]}" ps --all --quiet plausible)"
test -n "$plausible_container"
test "$(docker inspect --format '{{.State.Running}}' "$plausible_container")" = "false"
for service in postgres clickhouse; do
  container_id="$("${compose[@]}" ps --all --quiet "$service")"
  test -n "$container_id"
  test "$(docker inspect --format '{{.State.Running}}' "$container_id")" = "true"
  test "$(docker inspect --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' "$container_id")" = "healthy"
done

data_bytes=0
for spec in "plausible:/var/lib/plausible" "postgres:/var/lib/postgresql/data" "clickhouse:/var/lib/clickhouse"; do
  service="${spec%%:*}"
  destination="${spec#*:}"
  container_id="$("${compose[@]}" ps --all --quiet "$service")"
  source_path="$(docker inspect --format "{{range .Mounts}}{{if eq .Destination \"${destination}\"}}{{.Source}}{{end}}{{end}}" "$container_id")"
  test -d "$source_path"
  size="$(du --summarize --bytes "$source_path" | cut -f1)"
  data_bytes="$((data_bytes + size))"
done
available_bytes="$(df --block-size=1 --output=avail /var | tail -n1 | xargs)"
required_bytes="$((data_bytes * 4 + 2147483648))"
if [ "$available_bytes" -lt "$required_bytes" ]; then
  echo "Insufficient old-VM space for a rollback-safe encrypted export." >&2
  exit 1
fi

timestamp="$(date --utc +%Y%m%dT%H%M%SZ)"
staging="/var/backups/plausible-migration/${timestamp}"
export_dir="/var/backups/plausible-migration-packages/${timestamp}"
export_complete=false
failure_line=""
trap 'failure_line=$LINENO' ERR
cleanup() {
  status=$?
  if [ "$status" -ne 0 ]; then
    echo "Legacy Plausible export failed at script line ${failure_line:-unknown}." >&2
  fi
  rm -rf -- "$staging"
  if ! "$export_complete"; then
    rm -rf -- "$export_dir"
  fi
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT
install -d -m 0700 "$staging/state"
install -d -m 0700 "$export_dir"

postgres_counts() {
  local output="$1"
  local count_sql
  count_sql="SELECT format('%I%s%s', tablename, chr(9), (xpath('//row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', tablename), false, true, '')))[1]::text) FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"
  "${compose[@]}" exec --no-TTY postgres \
    psql --username=plausible --dbname=plausible --no-align --tuples-only --set ON_ERROR_STOP=1 \
    --command "$count_sql" > "$output"
  test -s "$output"
}

clickhouse_counts() {
  local output="$1"
  local tables_file="${output}.tables"
  local clickhouse_container
  clickhouse_container="$("${compose[@]}" ps --all --quiet clickhouse)"
  test -n "$clickhouse_container"
  : > "$output"
  if ! docker exec "$clickhouse_container" clickhouse-client \
    --query "SELECT name FROM system.tables WHERE database='plausible_events_db' ORDER BY name FORMAT TSVRaw" \
    > "$tables_file"; then
    echo "Unable to enumerate ClickHouse source tables." >&2
    return 1
  fi
  test -s "$tables_file"
  while IFS= read -r table; do
    test -n "$table" || continue
    case "$table" in
      *'`'*) echo "Unsafe ClickHouse table name" >&2; return 1 ;;
    esac
    count="$(docker exec "$clickhouse_container" clickhouse-client \
      --query "SELECT count() FROM plausible_events_db.\`${table}\`")"
    printf '%s\t%s\n' "$table" "$count" >> "$output"
  done < "$tables_file"
  rm -f "$tables_file"
  test -s "$output"
}

postgres_counts "$staging/source-postgres-counts.tsv"
clickhouse_counts "$staging/source-clickhouse-counts.tsv"

"${compose[@]}" exec --no-TTY postgres \
  pg_dump --username=plausible --dbname=plausible --format=custom --no-owner --no-acl \
  > "$staging/postgres.dump"

"${compose[@]}" exec --no-TTY clickhouse rm -f /var/lib/clickhouse/backups/plausible-events.zip
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client \
  --query "BACKUP DATABASE plausible_events_db TO File('plausible-events.zip')"
"${compose[@]}" cp clickhouse:/var/lib/clickhouse/backups/plausible-events.zip "$staging/clickhouse-plausible-events.zip"
"${compose[@]}" exec --no-TTY clickhouse rm -f /var/lib/clickhouse/backups/plausible-events.zip

"${compose[@]}" cp plausible:/var/lib/plausible/. "$staging/state/"
rm -rf -- "$staging/state/tmp"
(
  cd "$staging/state"
  find . -type f -print0 | LC_ALL=C sort --zero-terminated | xargs --null --no-run-if-empty sha256sum \
    > "$staging/source-state-checksums.tsv"
  find . -printf '%y\t%p\t%l\0' | LC_ALL=C sort --zero-terminated > "$staging/source-state-entries.bin"
)
tar --create --file "$staging/plausible-state.tar" --directory "$staging/state" .
rm -rf -- "$staging/state"

postgres_counts "$staging/source-postgres-counts-final.tsv"
clickhouse_counts "$staging/source-clickhouse-counts-final.tsv"
cmp --silent "$staging/source-postgres-counts.tsv" "$staging/source-postgres-counts-final.tsv"
cmp --silent "$staging/source-clickhouse-counts.tsv" "$staging/source-clickhouse-counts-final.tsv"
rm -f "$staging/source-postgres-counts-final.tsv" "$staging/source-clickhouse-counts-final.tsv"

(
  cd "$staging"
  sha256sum postgres.dump clickhouse-plausible-events.zip plausible-state.tar \
    source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv \
    source-state-entries.bin > SHA256SUMS
  sha256sum --check SHA256SUMS >/dev/null
  tar --create --file plausible-migration.tar \
    postgres.dump clickhouse-plausible-events.zip plausible-state.tar \
    source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv \
    source-state-entries.bin SHA256SUMS
  age --encrypt --recipient "$MIGRATION_AGE_RECIPIENT" \
    --output "$export_dir/plausible-migration.tar.age" plausible-migration.tar
  (
    cd "$export_dir"
    sha256sum plausible-migration.tar.age > plausible-migration.tar.age.sha256
    sha256sum --check plausible-migration.tar.age.sha256 >/dev/null
  )
)

export_complete=true
printf '%s\n' "$export_dir"

#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${PACKAGE_DIR:?Set PACKAGE_DIR to an empty private staging directory}"
: "${BACKUP_AGE_RECIPIENT:?Set the public age recipient}"
compose_dir="${COMPOSE_DIR:-/opt/abpiv-plausible}"
state_dir="${STATE_DIR:-/srv/plausible/state}"
compose=(docker compose --project-directory "$compose_dir" --file "$compose_dir/docker-compose.yml")

install -d -m 0700 "$PACKAGE_DIR" "$PACKAGE_DIR/state"
test -d "$state_dir"
package_complete=false
cleanup() {
  status=$?
  rm -rf -- "$PACKAGE_DIR/state"
  rm -f -- "$PACKAGE_DIR/plausible-backup.tar"
  if [ "$status" -ne 0 ] || ! "$package_complete"; then
    rm -f -- "$PACKAGE_DIR/plausible-backup.tar.age" "$PACKAGE_DIR/plausible-backup.tar.age.sha256"
  fi
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT

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
  docker exec "$clickhouse_container" clickhouse-client \
    --query "SELECT name FROM system.tables WHERE database='plausible_events_db' ORDER BY name FORMAT TSVRaw" \
    > "$tables_file"
  test -s "$tables_file"
  : > "$output"
  while IFS= read -r table; do
    test -n "$table" || continue
    case "$table" in
      *'`'*) echo "Unsafe ClickHouse table name." >&2; return 1 ;;
    esac
    count="$(docker exec "$clickhouse_container" clickhouse-client \
      --query "SELECT count() FROM plausible_events_db.\`${table}\`")"
    printf '%s\t%s\n' "$table" "$count" >> "$output"
  done < "$tables_file"
  rm -f "$tables_file"
  test -s "$output"
}

postgres_counts "$PACKAGE_DIR/source-postgres-counts.tsv"
clickhouse_counts "$PACKAGE_DIR/source-clickhouse-counts.tsv"

"${compose[@]}" exec --no-TTY postgres \
  pg_dump --username=plausible --dbname=plausible --format=custom --no-owner --no-acl \
  > "$PACKAGE_DIR/postgres.dump"

"${compose[@]}" exec --no-TTY clickhouse rm -f /var/lib/clickhouse/backups/plausible-events.zip
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client \
  --query "BACKUP DATABASE plausible_events_db TO File('plausible-events.zip')"
"${compose[@]}" cp clickhouse:/var/lib/clickhouse/backups/plausible-events.zip \
  "$PACKAGE_DIR/clickhouse-plausible-events.zip"
"${compose[@]}" exec --no-TTY clickhouse rm -f /var/lib/clickhouse/backups/plausible-events.zip

cp -a "$state_dir/." "$PACKAGE_DIR/state/"
rm -rf -- "$PACKAGE_DIR/state/tmp"
(
  cd "$PACKAGE_DIR/state"
  find . -type f -print0 | LC_ALL=C sort --zero-terminated | \
    xargs --null --no-run-if-empty sha256sum > "$PACKAGE_DIR/source-state-checksums.tsv"
  find . -printf '%y\t%p\t%l\0' | LC_ALL=C sort --zero-terminated > "$PACKAGE_DIR/source-state-entries.bin"
)
tar --create --file "$PACKAGE_DIR/plausible-state.tar" --directory "$PACKAGE_DIR/state" .
rm -rf -- "$PACKAGE_DIR/state"

postgres_counts "$PACKAGE_DIR/source-postgres-counts-final.tsv"
clickhouse_counts "$PACKAGE_DIR/source-clickhouse-counts-final.tsv"
cmp --silent "$PACKAGE_DIR/source-postgres-counts.tsv" "$PACKAGE_DIR/source-postgres-counts-final.tsv"
cmp --silent "$PACKAGE_DIR/source-clickhouse-counts.tsv" "$PACKAGE_DIR/source-clickhouse-counts-final.tsv"
rm -f "$PACKAGE_DIR/source-postgres-counts-final.tsv" "$PACKAGE_DIR/source-clickhouse-counts-final.tsv"

(
  cd "$PACKAGE_DIR"
  sha256sum postgres.dump clickhouse-plausible-events.zip plausible-state.tar \
    source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv \
    source-state-entries.bin > SHA256SUMS
  sha256sum --check SHA256SUMS >/dev/null
  tar --create --file plausible-backup.tar \
    postgres.dump clickhouse-plausible-events.zip plausible-state.tar \
    source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv \
    source-state-entries.bin SHA256SUMS
  age --encrypt --recipient "$BACKUP_AGE_RECIPIENT" \
    --output plausible-backup.tar.age plausible-backup.tar
  sha256sum plausible-backup.tar.age > plausible-backup.tar.age.sha256
  sha256sum --check plausible-backup.tar.age.sha256 >/dev/null
  rm -f postgres.dump clickhouse-plausible-events.zip plausible-state.tar \
    source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv \
    source-state-entries.bin SHA256SUMS plausible-backup.tar
)

package_complete=true
echo "Encrypted Plausible daily package created and locally verified."

#!/usr/bin/env bash
set -euo pipefail

/opt/abpiv-plausible/scripts/assert-data-disk.sh
evidence_dir="${MIGRATION_EVIDENCE_DIR:-$(cat /etc/abpiv-plausible/last-migration-evidence)}"
test -d "$evidence_dir"
for required in source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv source-state-entries.bin; do
  test -f "$evidence_dir/$required"
done
test -s "$evidence_dir/source-postgres-counts.tsv"
test -s "$evidence_dir/source-clickhouse-counts.tsv"

compose=(docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml)
target_dir="$(mktemp -d)"
trap 'rm -rf -- "$target_dir"' EXIT

count_sql="SELECT format('%I%s%s', tablename, chr(9), (xpath('//row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', tablename), false, true, '')))[1]::text) FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"
"${compose[@]}" exec --no-TTY postgres \
  psql --username=plausible --dbname=plausible --no-align --tuples-only --set ON_ERROR_STOP=1 \
  --command "$count_sql" > "$target_dir/target-postgres-counts.tsv"
test -s "$target_dir/target-postgres-counts.tsv"

: > "$target_dir/target-clickhouse-counts.tsv"
clickhouse_container="$("${compose[@]}" ps --all --quiet clickhouse)"
test -n "$clickhouse_container"
if ! docker exec "$clickhouse_container" clickhouse-client \
  --query "SELECT name FROM system.tables WHERE database='plausible_events_db' ORDER BY name FORMAT TSVRaw" \
  > "$target_dir/target-clickhouse-tables.tsv"; then
  echo "Unable to enumerate restored ClickHouse tables." >&2
  exit 1
fi
test -s "$target_dir/target-clickhouse-tables.tsv"
while IFS= read -r table; do
  test -n "$table" || continue
  case "$table" in
    *'`'*) echo "Unsafe ClickHouse table name" >&2; exit 1 ;;
  esac
  count="$(docker exec "$clickhouse_container" clickhouse-client \
    --query "SELECT count() FROM plausible_events_db.\`${table}\`")"
  printf '%s\t%s\n' "$table" "$count" >> "$target_dir/target-clickhouse-counts.tsv"
done < "$target_dir/target-clickhouse-tables.tsv"
rm -f "$target_dir/target-clickhouse-tables.tsv"
test -s "$target_dir/target-clickhouse-counts.tsv"

(
  cd /srv/plausible/state
  find . -type f -print0 | LC_ALL=C sort --zero-terminated | xargs --null --no-run-if-empty sha256sum \
    > "$target_dir/target-state-checksums.tsv"
  find . -printf '%y\t%p\t%l\0' | LC_ALL=C sort --zero-terminated > "$target_dir/target-state-entries.bin"
)

cmp --silent "$evidence_dir/source-postgres-counts.tsv" "$target_dir/target-postgres-counts.tsv"
cmp --silent "$evidence_dir/source-clickhouse-counts.tsv" "$target_dir/target-clickhouse-counts.tsv"
cmp --silent "$evidence_dir/source-state-checksums.tsv" "$target_dir/target-state-checksums.tsv"
cmp --silent "$evidence_dir/source-state-entries.bin" "$target_dir/target-state-entries.bin"

echo "Plausible PostgreSQL, ClickHouse, and application-state evidence matches the legacy source."

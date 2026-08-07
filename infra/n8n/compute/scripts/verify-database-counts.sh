#!/usr/bin/env bash
set -euo pipefail

: "${1:?Pass the source counts TSV path}"
source_counts="$1"
target_counts="$(mktemp)"
trap 'rm -f "$target_counts"' EXIT
compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)

count_sql="SELECT format('%I%s%s', tablename, chr(9), (xpath('//row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', tablename), false, true, '')))[1]::text) FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"
"${compose[@]}" exec --no-TTY postgres psql --username=n8n --dbname=n8n \
  --no-align --tuples-only --set ON_ERROR_STOP=1 --command "$count_sql" > "$target_counts"

if ! diff --unified=0 "$source_counts" "$target_counts"; then
  echo "Database table counts do not match." >&2
  exit 1
fi

for table in workflow_entity credentials_entity execution_entity; do
  grep -Eq "^${table}[[:space:]]" "$target_counts"
done

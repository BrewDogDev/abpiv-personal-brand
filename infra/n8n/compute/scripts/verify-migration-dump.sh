#!/usr/bin/env bash
set -euo pipefail

: "${1:?Pass the migration package directory}"
migration_dir="$1"
/opt/abpiv-n8n/scripts/assert-data-disk.sh
postgres_image="docker.io/library/postgres@sha256:57c72fd2a128e416c7fcc499958864df5301e940bca0a56f58fddf30ffc07777"
container="abpiv-n8n-migration-verify-$$"
data_dir="$(mktemp -d /srv/n8n/migration/disposable-restore.XXXXXX)"
target_counts="$(mktemp)"

cleanup() {
  docker rm --force "$container" >/dev/null 2>&1 || true
  rm -rf -- "$data_dir" "$target_counts"
}
trap cleanup EXIT
chown 70:70 "$data_dir"

docker run --detach --rm --name "$container" \
  --env POSTGRES_PASSWORD=disposable-restore-only \
  --volume "$data_dir:/var/lib/postgresql/data" \
  "$postgres_image" >/dev/null
for _ in $(seq 1 60); do
  if docker exec "$container" pg_isready --username postgres >/dev/null 2>&1; then
    break
  fi
  sleep 1
done
docker exec "$container" pg_isready --username postgres >/dev/null
docker exec "$container" createdb --username postgres --owner postgres n8n
docker exec --interactive "$container" pg_restore --username postgres --dbname n8n \
  --exit-on-error --no-owner --no-acl < "$migration_dir/database.dump"

count_sql="SELECT format('%I%s%s', tablename, chr(9), (xpath('//row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', tablename), false, true, '')))[1]::text) FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"
docker exec "$container" psql --username postgres --dbname n8n --no-align --tuples-only \
  --set ON_ERROR_STOP=1 --command "$count_sql" > "$target_counts"
diff --unified=0 "$migration_dir/source-counts.tsv" "$target_counts"

echo "Disposable restore of the final migration dump passed."

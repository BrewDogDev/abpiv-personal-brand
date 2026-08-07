#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${CLOUD_SQL_HOST:?Set CLOUD_SQL_HOST to the private Cloud SQL address}"
: "${LEGACY_BINARY_BUCKET:?Set LEGACY_BINARY_BUCKET}"
: "${CONFIRM_EXPORT:?Set CONFIRM_EXPORT=export-abpiv-n8n}"
test "$CONFIRM_EXPORT" = "export-abpiv-n8n"
/opt/abpiv-n8n/scripts/assert-data-disk.sh
exec 9>/run/lock/abpiv-n8n-data.lock
flock --wait 60 9

# shellcheck source=/dev/null
. /etc/abpiv-n8n/runtime.conf
/opt/abpiv-n8n/scripts/load-runtime-secrets.sh

postgres_image="docker.io/library/postgres@sha256:57c72fd2a128e416c7fcc499958864df5301e940bca0a56f58fddf30ffc07777"
timestamp="$(date --utc +%Y%m%dT%H%M%SZ)"
staging="/srv/n8n/migration/${timestamp}"
remote_verify=""
trap 'test -z "$remote_verify" || rm -rf -- "$remote_verify"' EXIT
install -d -m 0700 "$staging/binary"

run_source_client() {
  local program="$1"
  shift
  docker run --rm --network host \
    --volume /run/n8n/postgres-password:/run/secrets/postgres-password:ro \
    "$postgres_image" sh -ec '
      program="$1"
      host="$2"
      shift 2
      export PGPASSWORD="$(cat /run/secrets/postgres-password)"
      exec "$program" --host "$host" --username n8n --dbname n8n "$@"
    ' sh "$program" "$CLOUD_SQL_HOST" "$@"
}

psql_source() {
  run_source_client psql --no-align --tuples-only --set ON_ERROR_STOP=1 "$@"
}

active_count="$(psql_source --command "SELECT count(*) FROM execution_entity WHERE status IN ('new','running');")"
test "$active_count" = "0"

count_sql="SELECT format('%I%s%s', tablename, chr(9), (xpath('//row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', tablename), false, true, '')))[1]::text) FROM pg_tables WHERE schemaname='public' ORDER BY tablename;"
psql_source --command "$count_sql" > "$staging/source-counts-first.tsv"
sleep 60
psql_source --command "$count_sql" > "$staging/source-counts.tsv"
cmp --silent "$staging/source-counts-first.tsv" "$staging/source-counts.tsv"
rm -f "$staging/source-counts-first.tsv"

run_source_client pg_dump --format=custom --no-owner --no-acl > "$staging/database.dump"

gcloud storage buckets describe "gs://${LEGACY_BINARY_BUCKET}" >/dev/null
gcloud storage rsync --recursive "gs://${LEGACY_BINARY_BUCKET}" "$staging/binary"
(
  cd "$staging/binary"
  find . -type f -print0 | LC_ALL=C sort --zero-terminated | xargs --null --no-run-if-empty sha256sum > "$staging/binary-checksums.txt"
  find . -type f -printf '.' | wc -c > "$staging/source-binary-count.txt"
)
tar --create --file "$staging/binary-data.tar" --directory "$staging/binary" .
rm -rf -- "$staging/binary"

(
  cd "$staging"
  sha256sum database.dump binary-data.tar binary-checksums.txt source-binary-count.txt source-counts.tsv > SHA256SUMS
  sha256sum --check SHA256SUMS >/dev/null
)

destination="gs://${BACKUP_BUCKET}/migration/${timestamp}"
for name in database.dump binary-data.tar binary-checksums.txt source-binary-count.txt source-counts.tsv SHA256SUMS; do
  gcloud storage cp "$staging/$name" "${destination}/${name}"
done

remote_verify="$(mktemp -d)"
for name in database.dump binary-data.tar binary-checksums.txt source-binary-count.txt source-counts.tsv SHA256SUMS; do
  gcloud storage cp "${destination}/${name}" "$remote_verify/$name" >/dev/null
done
(
  cd "$remote_verify"
  sha256sum --check SHA256SUMS >/dev/null
)
rm -rf -- "$remote_verify"
remote_verify=""
printf '%s\n' "$staging"

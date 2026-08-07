#!/usr/bin/env bash
set -euo pipefail

postgres_image="docker.io/library/postgres@sha256:57c72fd2a128e416c7fcc499958864df5301e940bca0a56f58fddf30ffc07777"
container="abpiv-n8n-restore-rehearsal-$$"
work_dir="$(mktemp -d)"

cleanup() {
  docker rm --force "$container" >/dev/null 2>&1 || true
  rm -rf -- "$work_dir"
}
trap cleanup EXIT

docker run --detach --rm --name "$container" \
  --env POSTGRES_PASSWORD=fixture-only \
  --tmpfs /var/lib/postgresql/data:rw,noexec,nosuid,size=256m \
  "$postgres_image" >/dev/null

for _ in $(seq 1 30); do
  if docker exec "$container" pg_isready --username postgres >/dev/null 2>&1; then
    break
  fi
  sleep 1
done
docker exec "$container" pg_isready --username postgres >/dev/null

docker exec "$container" psql --username postgres --dbname postgres --set ON_ERROR_STOP=1 \
  --command 'CREATE TABLE restore_fixture(id integer PRIMARY KEY); INSERT INTO restore_fixture VALUES (1), (2), (3);' \
  >/dev/null
docker exec "$container" pg_dump --username postgres --dbname postgres --format=custom > "$work_dir/fixture.dump"
docker exec "$container" psql --username postgres --dbname postgres --set ON_ERROR_STOP=1 \
  --command 'DROP TABLE restore_fixture;' >/dev/null
docker exec --interactive "$container" pg_restore --username postgres --dbname postgres --exit-on-error < "$work_dir/fixture.dump"

restored_count="$(docker exec "$container" psql --username postgres --dbname postgres --tuples-only --no-align \
  --command 'SELECT count(*) FROM restore_fixture;')"
test "$restored_count" = "3"

echo "Disposable PostgreSQL backup/restore rehearsal passed."

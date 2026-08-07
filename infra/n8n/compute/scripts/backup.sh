#!/usr/bin/env bash
set -euo pipefail
umask 077

# shellcheck source=/dev/null
. /etc/abpiv-n8n/runtime.conf
test "$(cat /etc/abpiv-n8n/mode)" = "active"
/opt/abpiv-n8n/scripts/assert-data-disk.sh
/opt/abpiv-n8n/scripts/load-runtime-secrets.sh

exec 9>/run/lock/abpiv-n8n-data.lock
flock --wait 60 9

timestamp="$(date --utc +%Y%m%dT%H%M%SZ)"
staging="/srv/n8n/backups/${timestamp}"
remote_verify=""
recovery_needed=false
finish() {
  status=$?
  set +e
  if "$recovery_needed"; then
    "${compose[@]}" up --detach --wait n8n || status=1
    cp /opt/abpiv-n8n/nginx/active.conf /opt/abpiv-n8n/nginx/current.conf || status=1
    "${compose[@]}" up --detach --wait --force-recreate nginx || status=1
    active_body="$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" || status=1
    test "${active_body:-}" = "active-ready" || status=1
  fi
  test -z "$remote_verify" || rm -rf -- "$remote_verify"
  trap - EXIT
  exit "$status"
}
trap finish EXIT
install -d -m 0700 "$staging"
compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)

recovery_needed=true
cp /opt/abpiv-n8n/nginx/maintenance.conf /opt/abpiv-n8n/nginx/current.conf
"${compose[@]}" up --detach --wait --force-recreate nginx
test "$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" = "maintenance-ready"
"${compose[@]}" stop n8n

"${compose[@]}" exec --no-TTY postgres \
  pg_dump --username=n8n --dbname=n8n --format=custom > "$staging/database.dump"
tar --create --file "$staging/n8n-state.tar" --directory /srv/n8n/state .
tar --create --file "$staging/binary-data.tar" --directory /srv/n8n/binary .

(
  cd "$staging"
  sha256sum database.dump n8n-state.tar binary-data.tar > SHA256SUMS
  sha256sum --check SHA256SUMS >/dev/null
)

"${compose[@]}" up --detach --wait n8n
cp /opt/abpiv-n8n/nginx/active.conf /opt/abpiv-n8n/nginx/current.conf
"${compose[@]}" up --detach --wait --force-recreate nginx
test "$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" = "active-ready"
recovery_needed=false

destination="gs://${BACKUP_BUCKET}/daily/${timestamp}"
for name in database.dump n8n-state.tar binary-data.tar SHA256SUMS; do
  gcloud storage cp "$staging/$name" "${destination}/${name}"
done

remote_verify="$(mktemp -d)"
for name in database.dump n8n-state.tar binary-data.tar SHA256SUMS; do
  gcloud storage cp "${destination}/${name}" "$remote_verify/$name" >/dev/null
done
(
  cd "$remote_verify"
  sha256sum --check SHA256SUMS >/dev/null
)
rm -rf -- "$remote_verify"
remote_verify=""
rm -rf -- "$staging"

echo "Backup ${timestamp} uploaded and verified after round-trip download."

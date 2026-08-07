#!/usr/bin/env bash
set -euo pipefail

test "$(cat /etc/abpiv-n8n/mode)" = maintenance
/usr/local/sbin/abpiv-container-firewall --check
/opt/abpiv-n8n/scripts/assert-data-disk.sh
/opt/abpiv-n8n/scripts/load-runtime-secrets.sh
compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)

complete=false
cleanup() {
  status=$?
  if ! "$complete"; then
    set +e
    cp /opt/abpiv-n8n/nginx/maintenance.conf /opt/abpiv-n8n/nginx/current.conf
    "${compose[@]}" stop n8n >/dev/null 2>&1
    "${compose[@]}" up --detach --wait --force-recreate nginx >/dev/null 2>&1
    systemctl restart abpiv-cloudflared.service >/dev/null 2>&1
  fi
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT

"${compose[@]}" up --detach --wait postgres n8n
cp /opt/abpiv-n8n/nginx/precommit.conf /opt/abpiv-n8n/nginx/current.conf
"${compose[@]}" up --detach --wait --force-recreate nginx
systemctl restart abpiv-cloudflared.service
test "$(curl --fail --silent --show-error --header 'Host: forms.allanbpediniv.com' http://127.0.0.1:8080/healthz)" = precommit-ready
curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' \
  http://127.0.0.1:8080/healthz/readiness >/dev/null

complete=true
echo "n8n is healthy behind a read-only precommit ingress; write paths remain closed."

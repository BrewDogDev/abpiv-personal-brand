#!/usr/bin/env bash
set -euo pipefail

test "$(cat /etc/abpiv-plausible/mode)" = maintenance
/usr/local/sbin/abpiv-container-firewall --check
/opt/abpiv-plausible/scripts/assert-data-disk.sh
/opt/abpiv-plausible/scripts/load-runtime-secrets.sh
compose=(docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml)

complete=false
cleanup() {
  status=$?
  if ! "$complete"; then
    set +e
    cp /opt/abpiv-plausible/nginx/maintenance.conf /opt/abpiv-plausible/nginx/current.conf
    "${compose[@]}" stop plausible >/dev/null 2>&1
    "${compose[@]}" up --detach --wait --force-recreate nginx >/dev/null 2>&1
    systemctl restart abpiv-plausible-cloudflared.service >/dev/null 2>&1
  fi
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT

"${compose[@]}" up --detach --wait plausible
cp /opt/abpiv-plausible/nginx/precommit.conf /opt/abpiv-plausible/nginx/current.conf
"${compose[@]}" up --detach --wait --force-recreate nginx
systemctl restart abpiv-plausible-cloudflared.service
/opt/abpiv-plausible/scripts/wait-for-local-runtime.sh precommit-ready true

complete=true
echo "Plausible is healthy behind a read-only precommit ingress; event writes remain closed."

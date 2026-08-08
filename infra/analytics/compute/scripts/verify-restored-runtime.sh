#!/usr/bin/env bash
set -euo pipefail

test "$(cat /etc/abpiv-plausible/mode)" = maintenance
/usr/local/sbin/abpiv-container-firewall --check
/opt/abpiv-plausible/scripts/assert-data-disk.sh
/opt/abpiv-plausible/scripts/load-runtime-secrets.sh
/opt/abpiv-plausible/scripts/verify-migration.sh

compose=(docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml)
cleanup() {
  status=$?
  "${compose[@]}" stop plausible >/dev/null 2>&1 || status=1
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT

"${compose[@]}" up --detach --wait plausible
/opt/abpiv-plausible/scripts/wait-for-local-runtime.sh maintenance-ready false

echo "Restored Plausible data and unchanged secrets passed a sealed pre-activation check."

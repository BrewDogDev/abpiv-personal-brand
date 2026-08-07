#!/usr/bin/env bash
set -euo pipefail

test "$(cat /etc/abpiv-n8n/mode)" = maintenance
/usr/local/sbin/abpiv-container-firewall --check
/opt/abpiv-n8n/scripts/assert-data-disk.sh
/opt/abpiv-n8n/scripts/load-runtime-secrets.sh

compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)
cleanup() {
  status=$?
  "${compose[@]}" stop n8n >/dev/null 2>&1 || status=1
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT

"${compose[@]}" up --detach --wait postgres n8n
test "$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" = maintenance-ready
"${compose[@]}" exec --no-TTY --user node n8n /opt/abpiv-n8n/scripts/verify-credential-decryption.sh

echo "Restored n8n database and encryption key passed a sealed pre-activation check."

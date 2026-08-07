#!/usr/bin/env bash
set -euo pipefail
/opt/abpiv-n8n/scripts/assert-data-disk.sh

compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)
"${compose[@]}" ps --format json | jq --exit-status -s 'length == 3 and all(.Health == "healthy")' >/dev/null

test -L /srv/n8n/state/config
test "$(readlink /srv/n8n/state/config)" = "/run/n8n-runtime/config"
inspect_json="$(mktemp)"
trap 'rm -f "$inspect_json"' EXIT
docker inspect abpiv-n8n-postgres-1 abpiv-n8n-n8n-1 > "$inspect_json"
python3 - "$inspect_json" /run/n8n/encryption-key /run/n8n/postgres-password <<'PY'
import json
import pathlib
import sys

metadata = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
serialized = json.dumps(metadata, sort_keys=True)
for path in map(pathlib.Path, sys.argv[2:]):
    secret = path.read_text(encoding="utf-8")
    if secret and secret in serialized:
        raise SystemExit("secret value persisted in Docker container metadata")
PY

curl --fail --silent --show-error --header 'Host: forms.allanbpediniv.com' \
  http://127.0.0.1:8080/healthz >/dev/null
blocked_status="$(curl --silent --output /dev/null --write-out '%{http_code}' \
  --header 'Host: forms.allanbpediniv.com' http://127.0.0.1:8080/rest/settings)"
test "$blocked_status" = "404"

editor_status="$(curl --silent --output /dev/null --write-out '%{http_code}' \
  --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/)"
case "$editor_status" in
  200|302) ;;
  *) echo "Unexpected local editor response: $editor_status" >&2; exit 1 ;;
esac

systemctl is-active --quiet abpiv-cloudflared.service

"${compose[@]}" exec --no-TTY --user node n8n /opt/abpiv-n8n/scripts/verify-credential-decryption.sh

echo "Local runtime and non-persistent credential-decryption checks passed."

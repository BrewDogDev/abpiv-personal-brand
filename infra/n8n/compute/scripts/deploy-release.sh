#!/usr/bin/env bash
set -euo pipefail

: "${RELEASE_DIR:?Set RELEASE_DIR to the uploaded compute runtime directory}"
current_mode="$(cat /etc/abpiv-n8n/mode 2>/dev/null || printf stopped)"

rsync --archive --delete --exclude tests/ --exclude nginx/current.conf "$RELEASE_DIR/" /opt/abpiv-n8n/
find /opt/abpiv-n8n/scripts -type f -name '*.sh' -exec chmod 0755 {} +
docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml config --quiet
docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml pull --quiet

case "$current_mode" in
  active|maintenance)
    /opt/abpiv-n8n/scripts/runtime-mode.sh "$current_mode"
    ;;
  stopped)
    docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml down --remove-orphans
    ;;
  *)
    echo "Unknown runtime mode: $current_mode" >&2
    exit 1
    ;;
esac

echo "Release deployed; runtime mode remains ${current_mode}."

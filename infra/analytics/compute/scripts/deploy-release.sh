#!/usr/bin/env bash
set -euo pipefail

: "${RELEASE_DIR:?Set RELEASE_DIR to the uploaded Plausible compute release}"
current_mode="$(cat /etc/abpiv-plausible/mode 2>/dev/null || printf stopped)"
rsync --archive --delete --exclude tests/ --exclude nginx/current.conf "$RELEASE_DIR/" /opt/abpiv-plausible/
find /opt/abpiv-plausible/scripts -type f -name '*.sh' -exec chmod 0755 {} +
docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml config --quiet
docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml pull --quiet
for unit in /opt/abpiv-plausible/systemd/*; do
  install -m 0644 "$unit" "/etc/systemd/system/$(basename "$unit")"
done
systemctl daemon-reload

case "$current_mode" in
  active|maintenance)
    /opt/abpiv-plausible/scripts/runtime-mode.sh "$current_mode"
    ;;
  stopped)
    docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml down --remove-orphans
    ;;
  *)
    echo "Unknown Plausible runtime mode: $current_mode" >&2
    exit 1
    ;;
esac

echo "Plausible release deployed; runtime mode remains ${current_mode}."

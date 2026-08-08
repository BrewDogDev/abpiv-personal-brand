#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
compose=(docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml)

case "$mode" in
  maintenance)
    /usr/local/sbin/abpiv-container-firewall --check
    /opt/abpiv-plausible/scripts/assert-data-disk.sh
    /opt/abpiv-plausible/scripts/load-runtime-secrets.sh
    printf '%s\n' maintenance > /etc/abpiv-plausible/mode
    systemctl enable abpiv-plausible.service abpiv-plausible-cloudflared.service
    cp /opt/abpiv-plausible/nginx/maintenance.conf /opt/abpiv-plausible/nginx/current.conf
    "${compose[@]}" stop plausible >/dev/null 2>&1 || true
    "${compose[@]}" up --detach --wait postgres clickhouse
    "${compose[@]}" up --detach --wait --force-recreate nginx
    systemctl restart abpiv-plausible-cloudflared.service
    /opt/abpiv-plausible/scripts/wait-for-local-runtime.sh maintenance-ready false
    ;;
  active)
    /usr/local/sbin/abpiv-container-firewall --check
    /opt/abpiv-plausible/scripts/assert-data-disk.sh
    /opt/abpiv-plausible/scripts/load-runtime-secrets.sh
    printf '%s\n' maintenance > /etc/abpiv-plausible/mode
    cp /opt/abpiv-plausible/nginx/maintenance.conf /opt/abpiv-plausible/nginx/current.conf
    "${compose[@]}" up --detach --wait postgres clickhouse
    "${compose[@]}" up --detach --wait --force-recreate plausible nginx
    cp /opt/abpiv-plausible/nginx/active.conf /opt/abpiv-plausible/nginx/current.conf
    "${compose[@]}" up --detach --wait --force-recreate nginx
    systemctl restart abpiv-plausible-cloudflared.service
    systemctl enable abpiv-plausible.service abpiv-plausible-cloudflared.service abpiv-plausible-backup.timer abpiv-plausible-health.timer
    systemctl start abpiv-plausible-backup.timer abpiv-plausible-health.timer
    printf '%s\n' active > /etc/abpiv-plausible/mode
    /opt/abpiv-plausible/scripts/wait-for-local-runtime.sh active-ready true
    ;;
  stopped)
    printf '%s\n' stopped > /etc/abpiv-plausible/mode
    systemctl stop abpiv-plausible-cloudflared.service 2>/dev/null || true
    "${compose[@]}" down --remove-orphans
    systemctl stop abpiv-plausible-backup.timer abpiv-plausible-health.timer 2>/dev/null || true
    systemctl disable abpiv-plausible.service abpiv-plausible-cloudflared.service abpiv-plausible-backup.timer abpiv-plausible-health.timer >/dev/null 2>&1 || true
    rm -rf /run/plausible
    ;;
  *)
    echo "Usage: runtime-mode.sh maintenance|active|stopped" >&2
    exit 2
    ;;
esac

#!/usr/bin/env bash
set -euo pipefail

mode="${1:-}"
compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)

case "$mode" in
  maintenance)
    /usr/local/sbin/abpiv-container-firewall --check
    /opt/abpiv-n8n/scripts/assert-data-disk.sh
    /opt/abpiv-n8n/scripts/load-runtime-secrets.sh
    printf '%s\n' maintenance > /etc/abpiv-n8n/mode
    systemctl enable abpiv-n8n.service abpiv-cloudflared.service
    cp /opt/abpiv-n8n/nginx/maintenance.conf /opt/abpiv-n8n/nginx/current.conf
    "${compose[@]}" stop n8n >/dev/null 2>&1 || true
    "${compose[@]}" up --detach --wait postgres
    "${compose[@]}" up --detach --wait --force-recreate nginx
    systemctl restart abpiv-cloudflared.service
    test "$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" = "maintenance-ready"
    ;;
  active)
    /usr/local/sbin/abpiv-container-firewall --check
    /opt/abpiv-n8n/scripts/assert-data-disk.sh
    /opt/abpiv-n8n/scripts/load-runtime-secrets.sh
    cp /opt/abpiv-n8n/nginx/maintenance.conf /opt/abpiv-n8n/nginx/current.conf
    "${compose[@]}" up --detach --wait postgres
    "${compose[@]}" up --detach --wait --force-recreate n8n nginx
    cp /opt/abpiv-n8n/nginx/active.conf /opt/abpiv-n8n/nginx/current.conf
    "${compose[@]}" exec --no-TTY nginx nginx -s reload
    systemctl restart abpiv-cloudflared.service
    systemctl enable abpiv-n8n.service abpiv-cloudflared.service abpiv-n8n-backup.timer abpiv-n8n-health.timer
    systemctl start abpiv-n8n-backup.timer abpiv-n8n-health.timer
    printf '%s\n' active > /etc/abpiv-n8n/mode
    test "$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" = "active-ready"
    ;;
  stopped)
    systemctl stop abpiv-cloudflared.service 2>/dev/null || true
    "${compose[@]}" down --remove-orphans
    systemctl stop abpiv-n8n-health.timer 2>/dev/null || true
    systemctl disable abpiv-n8n.service abpiv-cloudflared.service abpiv-n8n-backup.timer abpiv-n8n-health.timer >/dev/null 2>&1 || true
    printf '%s\n' stopped > /etc/abpiv-n8n/mode
    rm -f /run/n8n/runtime.env /run/n8n/postgres.env /run/n8n/postgres-password /run/n8n/encryption-key /run/cloudflared/token
    ;;
  *)
    echo "Usage: runtime-mode.sh maintenance|active|stopped" >&2
    exit 2
    ;;
esac

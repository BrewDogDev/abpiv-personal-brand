#!/usr/bin/env bash
set -euo pipefail

systemctl stop abpiv-plausible-cloudflared.service 2>/dev/null || true
docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml down --remove-orphans
rm -rf /run/plausible

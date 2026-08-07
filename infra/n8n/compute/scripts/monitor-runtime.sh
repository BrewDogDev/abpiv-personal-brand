#!/usr/bin/env bash
set -euo pipefail

test "$(cat /etc/abpiv-n8n/mode 2>/dev/null || true)" = "active" || exit 0
/opt/abpiv-n8n/scripts/assert-data-disk.sh
state_dir="/var/lib/abpiv-n8n-health"
install -d -m 0700 "$state_dir"

if journalctl --dmesg --since '-2 minutes' --no-pager 2>/dev/null | grep -Eqi 'out of memory|oom-kill'; then
  logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=oom"
fi

runtime_fault=false
for service in n8n postgres nginx; do
  container="abpiv-n8n-${service}-1"
  if ! container_state="$(docker inspect --format '{{.RestartCount}} {{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' "$container" 2>/dev/null)"; then
    logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=container_missing service=${service}"
    runtime_fault=true
    continue
  fi
  read -r current health_status <<< "$container_state"
  if ! [[ "$current" =~ ^[0-9]+$ ]]; then
    logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=container_unhealthy service=${service} status=invalid-inspect"
    runtime_fault=true
    continue
  fi
  if [ "$health_status" != "healthy" ]; then
    logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=container_unhealthy service=${service} status=${health_status}"
    runtime_fault=true
  fi
  state_file="$state_dir/${service}.restart-count"
  previous="$(cat "$state_file" 2>/dev/null || printf 0)"
  if [ "$current" -gt "$previous" ]; then
    logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=container_restart service=${service} count=${current}"
  fi
  printf '%s\n' "$current" > "$state_file"
done

if ! latency_seconds="$(curl --fail --silent --show-error --output /dev/null --write-out '%{time_total}' --max-time 5 \
  --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz/readiness)"; then
  logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=request_failure endpoint=n8n_readiness"
  runtime_fault=true
  latency_seconds=5
fi
if awk -v latency="$latency_seconds" 'BEGIN { exit !(latency > 2) }'; then
  logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=request_latency seconds=${latency_seconds}"
fi

if ! systemctl is-active --quiet abpiv-cloudflared.service; then
  logger --tag abpiv-n8n-health -- "ABPIV_N8N_ALERT condition=tunnel_inactive"
fi

if "$runtime_fault"; then
  exit 1
fi

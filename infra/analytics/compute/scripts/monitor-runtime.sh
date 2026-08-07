#!/usr/bin/env bash
set -euo pipefail

test "$(cat /etc/abpiv-plausible/mode 2>/dev/null || true)" = "active" || exit 0
/opt/abpiv-plausible/scripts/assert-data-disk.sh
state_dir=/var/lib/abpiv-plausible-health
install -d -m 0700 "$state_dir"
runtime_fault=false

if journalctl --dmesg --since '-2 minutes' --no-pager 2>/dev/null | grep -Eqi 'out of memory|oom-kill'; then
  logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=oom"
fi

for service in plausible postgres clickhouse nginx; do
  container="abpiv-plausible-${service}-1"
  if ! state="$(docker inspect --format '{{.RestartCount}} {{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' "$container" 2>/dev/null)"; then
    logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=container_missing service=${service}"
    runtime_fault=true
    continue
  fi
  read -r restart_count health_status <<< "$state"
  if ! [[ "$restart_count" =~ ^[0-9]+$ ]] || [ "$health_status" != healthy ]; then
    logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=container_unhealthy service=${service} status=${health_status}"
    runtime_fault=true
  fi
  previous="$(cat "$state_dir/${service}.restart-count" 2>/dev/null || printf 0)"
  if [ "$restart_count" -gt "$previous" ]; then
    logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=container_restart service=${service} count=${restart_count}"
  fi
  printf '%s\n' "$restart_count" > "$state_dir/${service}.restart-count"
done

if ! latency="$(curl --fail --silent --show-error --output /dev/null --write-out '%{time_total}' --max-time 5 \
  --header 'Host: analytics.lobst3rs.com' http://127.0.0.1:8000/healthz/readiness)"; then
  logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=request_failure endpoint=plausible_readiness"
  runtime_fault=true
  latency=5
fi
if awk -v value="$latency" 'BEGIN { exit !(value > 2) }'; then
  logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=request_latency seconds=${latency}"
fi
if ! systemctl is-active --quiet abpiv-plausible-cloudflared.service; then
  logger --tag abpiv-plausible-health -- "ABPIV_PLAUSIBLE_ALERT condition=tunnel_inactive"
  runtime_fault=true
fi
if "$runtime_fault"; then
  exit 1
fi

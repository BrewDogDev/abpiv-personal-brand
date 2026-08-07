#!/usr/bin/env bash
set -euo pipefail
/opt/abpiv-n8n/scripts/assert-data-disk.sh

duration_seconds="${OBSERVATION_SECONDS:-900}"
interval_seconds="${OBSERVATION_INTERVAL_SECONDS:-30}"
end_epoch="$(( $(date +%s) + duration_seconds ))"
previous_cpu_total=""
previous_cpu_idle=""

metadata_machine_type="$(curl --fail --silent --show-error \
  --header 'Metadata-Flavor: Google' \
  http://metadata.google.internal/computeMetadata/v1/instance/machine-type)"
machine_type="${metadata_machine_type##*/}"
case "$machine_type" in
  e2-custom-medium-6144)
    reserved_millicores=1000
    ;;
  e2-standard-2)
    reserved_millicores=2000
    ;;
  *)
    echo "Unexpected live machine type for observation: $machine_type" >&2
    exit 1
    ;;
esac
logical_cpus="$(getconf _NPROCESSORS_ONLN)"
test "$logical_cpus" -gt 0

while [ "$(date +%s)" -lt "$end_epoch" ]; do
  read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
  cpu_idle="$((idle + iowait))"
  cpu_total="$((user + nice + system + idle + iowait + irq + softirq + steal))"
  if [ -n "$previous_cpu_total" ]; then
    total_delta="$((cpu_total - previous_cpu_total))"
    idle_delta="$((cpu_idle - previous_cpu_idle))"
    test "$total_delta" -gt 0
    busy_delta="$((total_delta - idle_delta))"
    cpu_capacity_percent="$((busy_delta * logical_cpus * 100 * 1000 / (total_delta * reserved_millicores)))"
    test "$cpu_capacity_percent" -lt 70
  fi
  previous_cpu_total="$cpu_total"
  previous_cpu_idle="$cpu_idle"

  memory_percent="$(free | awk '/^Mem:/ { printf("%d", 100 * ($2-$7) / $2) }')"
  swap_used_kib="$(free | awk '/^Swap:/ { print $3 }')"
  test "$memory_percent" -lt 75
  test "$swap_used_kib" -lt 65536
  if dmesg --since "${interval_seconds} seconds ago" 2>/dev/null | grep -Eqi 'out of memory|oom-kill'; then
    echo "OOM event detected." >&2
    exit 1
  fi
  for service in n8n postgres nginx; do
    read -r restart_count health_status < <(
      docker inspect --format '{{.RestartCount}} {{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' "abpiv-n8n-${service}-1"
    )
    test "$restart_count" -eq 0
    test "$health_status" = "healthy"
  done
  if [ "$(cat /etc/abpiv-plausible/mode 2>/dev/null || printf stopped)" = active ]; then
    /opt/abpiv-plausible/scripts/assert-data-disk.sh
    for service in plausible postgres clickhouse nginx; do
      read -r restart_count health_status < <(
        docker inspect --format '{{.RestartCount}} {{if .State.Health}}{{.State.Health.Status}}{{else}}missing{{end}}' "abpiv-plausible-${service}-1"
      )
      test "$restart_count" -eq 0
      test "$health_status" = healthy
    done
    plausible_latency="$(curl --fail --silent --show-error --output /dev/null \
      --write-out '%{time_total}' --max-time 5 \
      --header 'Host: analytics.lobst3rs.com' http://127.0.0.1:8000/healthz/readiness)"
    if awk -v latency="$plausible_latency" 'BEGIN { exit !(latency > 2) }'; then
      echo "Plausible readiness latency exceeded two seconds." >&2
      exit 1
    fi
  fi
  latency_seconds="$(curl --fail --silent --show-error --output /dev/null \
    --write-out '%{time_total}' --max-time 5 \
    --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz/readiness)"
  if awk -v latency="$latency_seconds" 'BEGIN { exit !(latency > 2) }'; then
    echo "n8n readiness latency exceeded two seconds." >&2
    exit 1
  fi
  sleep "$interval_seconds"
done

echo "Runtime observation thresholds passed for ${duration_seconds} seconds."

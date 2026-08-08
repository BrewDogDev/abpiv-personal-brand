#!/usr/bin/env bash
set -euo pipefail

expected_mode="${1:-}"
require_readiness="${2:-false}"
case "$expected_mode" in
  maintenance-ready|precommit-ready|active-ready) ;;
  *) echo "Unexpected Plausible local runtime mode: $expected_mode" >&2; exit 2 ;;
esac
case "$require_readiness" in
  true|false) ;;
  *) echo "Readiness requirement must be true or false." >&2; exit 2 ;;
esac

for _ in $(seq 1 30); do
  if response="$(curl --fail --silent --max-time 2 \
    --header 'Host: analytics.lobst3rs.com' http://127.0.0.1:8000/healthz 2>/dev/null)" && \
    [ "$response" = "$expected_mode" ]; then
    if [ "$require_readiness" = false ] || \
      curl --fail --silent --max-time 2 \
        --header 'Host: analytics.lobst3rs.com' \
        http://127.0.0.1:8000/healthz/readiness >/dev/null 2>&1; then
      exit 0
    fi
  fi
  sleep 1
done

echo "Plausible local ingress did not reach ${expected_mode} within 30 attempts." >&2
echo "Safe Docker host-port diagnostics follow." >&2
docker port abpiv-plausible-nginx-1 8000/tcp >&2 || true
docker inspect --format 'ports={{json .NetworkSettings.Ports}} networks={{json .NetworkSettings.Networks}}' \
  abpiv-plausible-nginx-1 >&2 || true
ss --listening --tcp --numeric | grep -E '(^State|:8000[[:space:]])' >&2 || true
iptables --wait 5 --table nat --list-rules DOCKER | grep -F -- '--dport 8000' >&2 || true
exit 1

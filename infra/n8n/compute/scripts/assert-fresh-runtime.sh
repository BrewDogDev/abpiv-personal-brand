#!/usr/bin/env bash
set -euo pipefail

runtime_mode="$(cat /etc/abpiv-n8n/mode)"
case "$runtime_mode" in
  maintenance|active) ;;
  *) echo "Fresh-runtime guard requires maintenance or active mode." >&2; exit 1 ;;
esac
/opt/abpiv-n8n/scripts/assert-data-disk.sh

unexpected_state="$(find /srv/n8n/state -mindepth 1 -maxdepth 1 \
  ! -name config ! -name nodes ! -name n8nEventLog.log -print -quit)"
if [ -n "$unexpected_state" ]; then
  echo "Refusing fresh cutover: durable n8n application state exists at ${unexpected_state}." >&2
  exit 1
fi
if [ -e /srv/n8n/state/config ] || [ -L /srv/n8n/state/config ]; then
  if [ ! -L /srv/n8n/state/config ] || [ "$(readlink /srv/n8n/state/config)" != /run/n8n-runtime/config ]; then
    echo "Refusing fresh cutover: durable n8n config state is present." >&2
    exit 1
  fi
fi

event_log=/srv/n8n/state/n8nEventLog.log
if [ -e "$event_log" ] || [ -L "$event_log" ]; then
  if [ ! -f "$event_log" ] || [ -L "$event_log" ] || [ -s "$event_log" ]; then
    echo "Refusing fresh cutover: the generated n8n event log is not an empty regular file." >&2
    exit 1
  fi
fi

nodes_dir=/srv/n8n/state/nodes
if [ -e "$nodes_dir" ] || [ -L "$nodes_dir" ]; then
  if [ ! -d "$nodes_dir" ] || [ -L "$nodes_dir" ]; then
    echo "Refusing fresh cutover: the generated installed-nodes path is not a directory." >&2
    exit 1
  fi
  unexpected_node="$(find "$nodes_dir" -mindepth 1 -maxdepth 1 ! -name package.json -print -quit)"
  if [ -n "$unexpected_node" ]; then
    echo "Refusing fresh cutover: unexpected installed-node state exists at ${unexpected_node}." >&2
    exit 1
  fi
  package_json="$nodes_dir/package.json"
  if [ ! -f "$package_json" ] || [ -L "$package_json" ] || ! jq --exit-status '
    type == "object" and
    keys == ["dependencies", "name", "private"] and
    .name == "installed-nodes" and
    .private == true and
    .dependencies == {}
  ' "$package_json" >/dev/null; then
    echo "Refusing fresh cutover: installed-nodes package state differs from the pinned empty scaffold." >&2
    exit 1
  fi
fi

empty_dirs=(/srv/n8n/binary)
if [ "$runtime_mode" = maintenance ]; then
  empty_dirs+=(/srv/n8n/backups /srv/n8n/migration)
fi
for empty_dir in "${empty_dirs[@]}"; do
  unexpected_path="$(find "$empty_dir" -mindepth 1 -print -quit)"
  if [ -n "$unexpected_path" ]; then
    echo "Refusing fresh cutover: persisted target data exists at ${unexpected_path}." >&2
    exit 1
  fi
done

compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)
baseline_ok=false
for _ in $(seq 1 12); do
  if "${compose[@]}" exec --no-TTY postgres \
    psql --username=n8n --dbname=n8n --set ON_ERROR_STOP=1 \
    < /opt/abpiv-n8n/scripts/fresh-runtime-baseline.sql; then
    baseline_ok=true
    break
  fi
  sleep 5
done
if [ "$baseline_ok" != true ]; then
  echo "Refusing fresh cutover: the PostgreSQL target does not match the pinned clean-start baseline." >&2
  exit 1
fi

echo "Fresh-runtime guard passed: no workflows, credentials, or executions exist; the owner account is unclaimed."

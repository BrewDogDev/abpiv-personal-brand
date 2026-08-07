#!/usr/bin/env bash
set -euo pipefail

mode="$(cat /etc/abpiv-n8n/mode)"
case "$mode" in
  active|maintenance|stopped)
    exec /opt/abpiv-n8n/scripts/runtime-mode.sh "$mode"
    ;;
  *)
    echo "Refusing to start from unknown persisted runtime mode: $mode" >&2
    exit 1
    ;;
esac

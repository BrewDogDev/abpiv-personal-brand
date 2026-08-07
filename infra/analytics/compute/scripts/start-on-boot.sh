#!/usr/bin/env bash
set -euo pipefail

mode="$(cat /etc/abpiv-plausible/mode)"
case "$mode" in
  active|maintenance|stopped)
    exec /opt/abpiv-plausible/scripts/runtime-mode.sh "$mode"
    ;;
  *)
    echo "Refusing to start unknown Plausible runtime mode: $mode" >&2
    exit 1
    ;;
esac

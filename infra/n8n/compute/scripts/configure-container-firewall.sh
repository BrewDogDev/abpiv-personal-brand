#!/usr/bin/env bash
set -euo pipefail

mode="${1:---enforce}"
metadata_ipv4=169.254.169.254/32

check_rule() {
  iptables --wait 5 --check DOCKER-USER --destination "$metadata_ipv4" --jump DROP
}

case "$mode" in
  --enforce)
    iptables --wait 5 --list DOCKER-USER --numeric >/dev/null
    if ! check_rule >/dev/null 2>&1; then
      iptables --wait 5 --insert DOCKER-USER 1 --destination "$metadata_ipv4" --jump DROP
    fi
    check_rule
    ;;
  --check)
    check_rule
    ;;
  *)
    echo "Usage: configure-container-firewall.sh [--enforce|--check]" >&2
    exit 2
    ;;
esac

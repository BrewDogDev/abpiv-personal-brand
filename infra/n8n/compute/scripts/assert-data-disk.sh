#!/usr/bin/env bash
set -euo pipefail

uuid_file=/etc/abpiv-n8n/data-disk.uuid
mount_path=/srv/n8n

test -s "$uuid_file"
expected_uuid="$(< "$uuid_file")"
actual_uuid="$(findmnt --noheadings --output UUID --target "$mount_path" | xargs)"

if [ -z "$actual_uuid" ] || [ "$actual_uuid" != "$expected_uuid" ]; then
  echo "Expected data disk UUID ${expected_uuid} is not mounted at ${mount_path}." >&2
  exit 1
fi

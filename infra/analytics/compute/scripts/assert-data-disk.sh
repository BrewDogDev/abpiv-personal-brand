#!/usr/bin/env bash
set -euo pipefail

expected_uuid="$(cat /etc/abpiv-plausible/data-disk.uuid)"
actual_uuid="$(findmnt --noheadings --output UUID --target /srv/plausible | xargs)"
test -n "$expected_uuid"
test "$actual_uuid" = "$expected_uuid"
test "$(findmnt --noheadings --output SOURCE --target /srv/plausible | xargs)" != "/dev/root"

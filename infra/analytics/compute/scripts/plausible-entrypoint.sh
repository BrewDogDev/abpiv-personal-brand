#!/bin/sh
set -eu

test "$(id -u)" -eq 0
install -d -m 0700 -o 999 -g 65533 /run/secrets
for name in SECRET_KEY_BASE DATABASE_URL; do
  test -r "/run/host-secrets/$name"
  install -m 0400 -o 999 -g 65533 "/run/host-secrets/$name" "/run/secrets/$name"
done

exec su -p -s /bin/sh plausible -c 'exec "$@"' sh "$@"

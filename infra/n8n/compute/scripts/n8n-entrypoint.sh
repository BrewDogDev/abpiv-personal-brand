#!/bin/sh
set -eu

runtime_dir=/run/n8n-runtime
state_config=/home/node/.n8n/config

test "$(id -u)" -eq 0
test -r /run/host-secrets/encryption-key
test -r /run/host-secrets/postgres-password

install -d -m 0700 -o node -g node "$runtime_dir"
install -m 0400 -o node -g node /run/host-secrets/encryption-key "$runtime_dir/encryption-key"
install -m 0400 -o node -g node /run/host-secrets/postgres-password "$runtime_dir/postgres-password"

if [ -e "$state_config" ] && [ ! -L "$state_config" ]; then
  echo "Refusing to start with a durable n8n config file at ${state_config}." >&2
  exit 1
fi
ln -sfn "$runtime_dir/config" "$state_config"
chown -h node:node "$state_config"

exec su -s /bin/sh node -c 'exec /docker-entrypoint.sh "$@"' -- "$@"

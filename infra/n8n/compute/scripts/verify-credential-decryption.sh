#!/bin/sh
set -eu

output=/run/n8n-runtime/decrypted-credential-check.json
export_pid=""
# shellcheck disable=SC2317,SC2329 # Invoked indirectly by the EXIT trap below.
cleanup() {
  test -z "$export_pid" || kill "$export_pid" >/dev/null 2>&1 || true
  test -z "$export_pid" || wait "$export_pid" >/dev/null 2>&1 || true
  rm -f "$output"
}
trap cleanup EXIT

credential_count="$(node <<'NODE'
const fs = require('fs');
const { Client } = require('/usr/local/lib/node_modules/n8n/node_modules/pg');

(async () => {
  const client = new Client({
    host: process.env.DB_POSTGRESDB_HOST,
    port: Number(process.env.DB_POSTGRESDB_PORT || 5432),
    database: process.env.DB_POSTGRESDB_DATABASE,
    user: process.env.DB_POSTGRESDB_USER,
    password: fs.readFileSync(process.env.DB_POSTGRESDB_PASSWORD_FILE, 'utf8'),
  });
  await client.connect();
  const result = await client.query('SELECT count(*)::int AS count FROM credentials_entity');
  await client.end();
  process.stdout.write(String(result.rows[0].count));
})().catch(() => process.exit(1));
NODE
)"

if [ "$credential_count" -eq 0 ]; then
  echo "Credential decryption check passed: no stored credentials require decryption."
  exit 0
fi

N8N_RUNNERS_ENABLED=false n8n export:credentials --all --decrypted --output="$output" >/dev/null 2>&1 &
export_pid=$!

for _ in $(seq 1 60); do
  if [ -s "$output" ] && node -e 'const fs=require("fs"); const value=JSON.parse(fs.readFileSync(process.argv[1], "utf8")); if (!Array.isArray(value) || value.length !== Number(process.argv[2])) process.exit(1)' "$output" "$credential_count" 2>/dev/null; then
    exit 0
  fi
  if ! kill -0 "$export_pid" 2>/dev/null; then
    wait "$export_pid"
    export_pid=""
    node -e 'const fs=require("fs"); const value=JSON.parse(fs.readFileSync(process.argv[1], "utf8")); if (!Array.isArray(value) || value.length !== Number(process.argv[2])) process.exit(1)' "$output" "$credential_count"
    exit 0
  fi
  sleep 1
done

echo "Timed out waiting for the in-memory credential decryption check." >&2
exit 1

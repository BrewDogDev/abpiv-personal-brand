#!/usr/bin/env bash
set -euo pipefail
umask 077

# shellcheck source=/dev/null
. /etc/abpiv-n8n/runtime.conf

metadata_header="Metadata-Flavor: Google"
access_token="$(curl --fail --silent --show-error \
  --header "$metadata_header" \
  http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token \
  | jq --exit-status --raw-output '.access_token')"

fetch_secret() {
  local secret_id="$1"
  curl --fail --silent --show-error \
    --header "Authorization: Bearer ${access_token}" \
    "https://secretmanager.googleapis.com/v1/projects/${GCP_PROJECT_ID}/secrets/${secret_id}/versions/latest:access" \
    | jq --exit-status --raw-output '.payload.data' \
    | base64 --decode
}

dotenv_quote() {
  python3 -c 'import sys
value = sys.stdin.read()
if "\x00" in value or "\n" in value or "\r" in value:
    raise SystemExit("runtime secrets must be single-line values")
sys.stdout.write("\x27" + value.replace("\x27", "\\\x27") + "\x27")'
}

encryption_key="$(fetch_secret abpiv-n8n-encryption-key)"
postgres_password="$(fetch_secret abpiv-n8n-postgres-password)"
tunnel_token="$(fetch_secret abpiv-n8n-cloudflare-tunnel-token)"

runtime_tmp="$(mktemp /run/n8n/runtime.env.XXXXXX)"
{
  printf 'N8N_ENCRYPTION_KEY=%s\n' "$(printf '%s' "$encryption_key" | dotenv_quote)"
  printf 'DB_POSTGRESDB_PASSWORD=%s\n' "$(printf '%s' "$postgres_password" | dotenv_quote)"
} > "$runtime_tmp"
chmod 0600 "$runtime_tmp"
chown root:root "$runtime_tmp"
mv -f "$runtime_tmp" /run/n8n/runtime.env

postgres_env_tmp="$(mktemp /run/n8n/postgres.env.XXXXXX)"
printf 'POSTGRES_PASSWORD=%s\n' "$(printf '%s' "$postgres_password" | dotenv_quote)" > "$postgres_env_tmp"
chmod 0600 "$postgres_env_tmp"
chown root:root "$postgres_env_tmp"
mv -f "$postgres_env_tmp" /run/n8n/postgres.env

password_tmp="$(mktemp /run/n8n/postgres-password.XXXXXX)"
printf '%s' "$postgres_password" > "$password_tmp"
chmod 0600 "$password_tmp"
chown root:root "$password_tmp"
mv -f "$password_tmp" /run/n8n/postgres-password

encryption_tmp="$(mktemp /run/n8n/encryption-key.XXXXXX)"
printf '%s' "$encryption_key" > "$encryption_tmp"
chmod 0600 "$encryption_tmp"
chown root:root "$encryption_tmp"
mv -f "$encryption_tmp" /run/n8n/encryption-key

tunnel_tmp="$(mktemp /run/cloudflared/token.XXXXXX)"
printf '%s' "$tunnel_token" > "$tunnel_tmp"
chmod 0600 "$tunnel_tmp"
chown root:root "$tunnel_tmp"
mv -f "$tunnel_tmp" /run/cloudflared/token

unset access_token encryption_key postgres_password tunnel_token

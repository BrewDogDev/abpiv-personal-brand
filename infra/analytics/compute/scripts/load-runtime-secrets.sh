#!/usr/bin/env bash
set -euo pipefail
umask 077

# shellcheck source=/dev/null
. /etc/abpiv-plausible/runtime.conf
install -d -m 0700 /run/plausible

fetch_secret() {
  local secret_id="$1"
  local destination="$2"
  local temporary
  temporary="$(mktemp /run/plausible/secret.XXXXXX)"
  if ! gcloud secrets versions access latest \
    --project "$GCP_PROJECT_ID" --secret "$secret_id" > "$temporary"; then
    rm -f "$temporary"
    return 1
  fi
  if [ ! -s "$temporary" ]; then
    rm -f "$temporary"
    return 1
  fi
  chmod 0400 "$temporary"
  mv -f "$temporary" "$destination"
}

fetch_secret abpiv-plausible-secret-key-base /run/plausible/SECRET_KEY_BASE
fetch_secret abpiv-plausible-postgres-password /run/plausible/POSTGRES_PASSWORD
fetch_secret abpiv-plausible-tunnel-token /run/plausible/TUNNEL_TOKEN
fetch_secret abpiv-plausible-backup-age-key /run/plausible/BACKUP_AGE_KEY

postgres_password="$(cat /run/plausible/POSTGRES_PASSWORD)"
if ! [[ "$postgres_password" =~ ^[A-Za-z0-9._~-]+$ ]]; then
  echo "Plausible PostgreSQL password is not URL-safe; refusing to construct DATABASE_URL." >&2
  exit 1
fi
database_url_tmp="$(mktemp /run/plausible/database-url.XXXXXX)"
printf 'postgres://plausible:%s@postgres:5432/plausible\n' "$postgres_password" > "$database_url_tmp"
chmod 0400 "$database_url_tmp"
mv -f "$database_url_tmp" /run/plausible/DATABASE_URL

unset postgres_password

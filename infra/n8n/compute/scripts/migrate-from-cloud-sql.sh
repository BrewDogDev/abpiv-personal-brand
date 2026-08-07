#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${MIGRATION_DIR:?Set MIGRATION_DIR to the checked migration package}"
: "${CONFIRM_RESTORE:?Set CONFIRM_RESTORE=restore-abpiv-n8n}"
test "$CONFIRM_RESTORE" = "restore-abpiv-n8n"
/opt/abpiv-n8n/scripts/assert-data-disk.sh
exec 9>/run/lock/abpiv-n8n-data.lock
flock --wait 60 9

for required in database.dump binary-data.tar binary-checksums.txt source-binary-count.txt source-counts.tsv SHA256SUMS; do
  test -f "$MIGRATION_DIR/$required"
done
(
  cd "$MIGRATION_DIR"
  sha256sum --check SHA256SUMS
)

if tar --list --file "$MIGRATION_DIR/binary-data.tar" | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
  echo "Unsafe path found in binary-data.tar" >&2
  exit 1
fi

/opt/abpiv-n8n/scripts/verify-migration-dump.sh "$MIGRATION_DIR"

/opt/abpiv-n8n/scripts/load-runtime-secrets.sh
compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)
"${compose[@]}" stop n8n >/dev/null 2>&1 || true
"${compose[@]}" up --detach --wait postgres

rollback_dir="/srv/n8n/migration/local-before-restore-$(date --utc +%Y%m%dT%H%M%SZ)"
install -d -m 0700 "$rollback_dir"
tar --create --file "$rollback_dir/n8n-state.tar" --directory /srv/n8n/state .
tar --create --file "$rollback_dir/binary-data.tar" --directory /srv/n8n/binary .

"${compose[@]}" exec --no-TTY postgres dropdb --username=n8n --if-exists n8n
"${compose[@]}" exec --no-TTY postgres createdb --username=n8n --owner=n8n n8n
"${compose[@]}" exec --no-TTY --interactive postgres \
  pg_restore --username=n8n --dbname=n8n --exit-on-error --no-owner --no-acl \
  < "$MIGRATION_DIR/database.dump"

find /srv/n8n/binary -mindepth 1 -delete
tar --extract --file "$MIGRATION_DIR/binary-data.tar" --directory /srv/n8n/binary --no-same-owner
chown -hR 1000:1000 /srv/n8n/state /srv/n8n/binary
(
  cd /srv/n8n/binary
  if [ -s "$MIGRATION_DIR/binary-checksums.txt" ]; then
    sha256sum --check "$MIGRATION_DIR/binary-checksums.txt"
  else
    test -z "$(find . -type f -print -quit)"
  fi
  test "$(find . -type f -printf '.' | wc -c)" = "$(cat "$MIGRATION_DIR/source-binary-count.txt")"
)

/opt/abpiv-n8n/scripts/verify-database-counts.sh "$MIGRATION_DIR/source-counts.tsv"
echo "Migration restored and count verification passed; n8n remains stopped."

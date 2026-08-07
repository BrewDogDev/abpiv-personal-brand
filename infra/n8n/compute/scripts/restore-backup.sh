#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${BACKUP_DIR:?Set BACKUP_DIR to a downloaded daily backup directory}"
: "${CONFIRM_RESTORE:?Set CONFIRM_RESTORE=restore-daily-abpiv-n8n}"
test "$CONFIRM_RESTORE" = "restore-daily-abpiv-n8n"
/opt/abpiv-n8n/scripts/assert-data-disk.sh
exec 9>/run/lock/abpiv-n8n-data.lock
flock --wait 60 9

for required in database.dump n8n-state.tar binary-data.tar SHA256SUMS; do
  test -f "$BACKUP_DIR/$required"
done
(
  cd "$BACKUP_DIR"
  sha256sum --check SHA256SUMS
)

for archive in n8n-state.tar binary-data.tar; do
  if tar --list --file "$BACKUP_DIR/$archive" | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
    echo "Unsafe path found in $archive" >&2
    exit 1
  fi
done

/opt/abpiv-n8n/scripts/load-runtime-secrets.sh
compose=(docker compose --project-directory /opt/abpiv-n8n --file /opt/abpiv-n8n/docker-compose.yml)
printf '%s\n' maintenance > /etc/abpiv-n8n/mode
"${compose[@]}" stop n8n >/dev/null 2>&1 || true
cp /opt/abpiv-n8n/nginx/maintenance.conf /opt/abpiv-n8n/nginx/current.conf
"${compose[@]}" up --detach --wait postgres
"${compose[@]}" up --detach --wait --force-recreate nginx
test "$(curl --fail --silent --show-error --header 'Host: workflows.lobst3rs.com' http://127.0.0.1:8080/healthz)" = "maintenance-ready"

rollback_dir="/srv/n8n/migration/local-before-daily-restore-$(date --utc +%Y%m%dT%H%M%SZ)"
install -d -m 0700 "$rollback_dir"
"${compose[@]}" exec --no-TTY postgres pg_dump --username=n8n --dbname=n8n --format=custom > "$rollback_dir/database.dump"
tar --create --file "$rollback_dir/n8n-state.tar" --directory /srv/n8n/state .
tar --create --file "$rollback_dir/binary-data.tar" --directory /srv/n8n/binary .

"${compose[@]}" exec --no-TTY postgres dropdb --username=n8n --if-exists n8n
"${compose[@]}" exec --no-TTY postgres createdb --username=n8n --owner=n8n n8n
"${compose[@]}" exec --no-TTY --interactive postgres \
  pg_restore --username=n8n --dbname=n8n --exit-on-error --no-owner --no-acl \
  < "$BACKUP_DIR/database.dump"

find /srv/n8n/state /srv/n8n/binary -mindepth 1 -delete
tar --extract --file "$BACKUP_DIR/n8n-state.tar" --directory /srv/n8n/state --no-same-owner
tar --extract --file "$BACKUP_DIR/binary-data.tar" --directory /srv/n8n/binary --no-same-owner
chown -hR 1000:1000 /srv/n8n/state /srv/n8n/binary

echo "Daily backup restored in maintenance mode; n8n remains stopped pending acceptance."

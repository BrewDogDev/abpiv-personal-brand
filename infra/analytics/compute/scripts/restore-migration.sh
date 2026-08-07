#!/usr/bin/env bash
set -euo pipefail
umask 077

: "${MIGRATION_URI:?Set the exact gs:// URI ending in plausible-migration.tar.age}"
: "${CONFIRM_RESTORE:?Set the typed confirmation for the exact restore object}"
case "$MIGRATION_URI" in
  gs://*/plausible/migration/*/plausible-migration.tar.age)
    test "$CONFIRM_RESTORE" = "restore-legacy-plausible-data"
    restore_kind=migration
    ;;
  gs://*/plausible/daily/*/plausible-backup.tar.age)
    test "$CONFIRM_RESTORE" = "restore-plausible-daily-backup"
    restore_kind=daily
    ;;
  *) echo "MIGRATION_URI is not an exact Plausible migration or daily backup object." >&2; exit 1 ;;
esac

/opt/abpiv-plausible/scripts/assert-data-disk.sh
/opt/abpiv-plausible/scripts/load-runtime-secrets.sh
test "$(cat /etc/abpiv-plausible/mode)" = "maintenance"
exec 9>/run/lock/abpiv-plausible-data.lock
flock --wait 60 9

timestamp="$(date --utc +%Y%m%dT%H%M%SZ)"
work_dir="/srv/plausible/migration/restore-${timestamp}"
evidence_dir="/srv/plausible/migration/evidence-${timestamp}"
cleanup() {
  status=$?
  rm -rf -- "$work_dir"
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT
install -d -m 0700 "$work_dir/package" "$evidence_dir"

gcloud storage cp "$MIGRATION_URI" "$work_dir/plausible-migration.tar.age" >/dev/null
gcloud storage cp "${MIGRATION_URI}.sha256" "$work_dir/plausible-migration.tar.age.sha256" >/dev/null
(
  cd "$work_dir"
  sha256sum --check plausible-migration.tar.age.sha256 >/dev/null
  age --decrypt --identity /run/plausible/BACKUP_AGE_KEY \
    --output plausible-migration.tar plausible-migration.tar.age
  if tar --list --file plausible-migration.tar | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
    echo "Unsafe path in Plausible migration archive." >&2
    exit 1
  fi
  tar --extract --file plausible-migration.tar --directory package --no-same-owner
)
for required in postgres.dump clickhouse-plausible-events.zip plausible-state.tar source-postgres-counts.tsv source-clickhouse-counts.tsv source-state-checksums.tsv source-state-entries.bin SHA256SUMS; do
  test -f "$work_dir/package/$required"
done
(
  cd "$work_dir/package"
  sha256sum --check SHA256SUMS >/dev/null
  if tar --list --file plausible-state.tar | grep -Eq '(^/|(^|/)\.\.(/|$))'; then
    echo "Unsafe path in Plausible state archive." >&2
    exit 1
  fi
)

compose=(docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml)
"${compose[@]}" stop plausible >/dev/null 2>&1 || true
"${compose[@]}" up --detach --wait postgres clickhouse nginx

"${compose[@]}" exec --no-TTY postgres dropdb --username=plausible --if-exists --force plausible
"${compose[@]}" exec --no-TTY postgres createdb --username=plausible --owner=plausible plausible
"${compose[@]}" exec --no-TTY --interactive postgres \
  pg_restore --username=plausible --dbname=plausible --exit-on-error --no-owner --no-acl \
  < "$work_dir/package/postgres.dump"

"${compose[@]}" exec --no-TTY clickhouse clickhouse-client \
  --query "DROP DATABASE IF EXISTS plausible_events_db SYNC"
install -d -m 0750 -o 101 -g 101 /srv/plausible/clickhouse-data/backups
install -m 0600 -o 101 -g 101 "$work_dir/package/clickhouse-plausible-events.zip" \
  /srv/plausible/clickhouse-data/backups/plausible-events.zip
"${compose[@]}" exec --no-TTY clickhouse clickhouse-client \
  --query "RESTORE DATABASE plausible_events_db FROM File('plausible-events.zip')"
rm -f /srv/plausible/clickhouse-data/backups/plausible-events.zip

find /srv/plausible/state -mindepth 1 -delete
tar --extract --file "$work_dir/package/plausible-state.tar" --directory /srv/plausible/state --no-same-owner
chown -hR 999:65533 /srv/plausible/state

install -m 0600 "$work_dir/package/source-postgres-counts.tsv" "$evidence_dir/source-postgres-counts.tsv"
install -m 0600 "$work_dir/package/source-clickhouse-counts.tsv" "$evidence_dir/source-clickhouse-counts.tsv"
install -m 0600 "$work_dir/package/source-state-checksums.tsv" "$evidence_dir/source-state-checksums.tsv"
install -m 0600 "$work_dir/package/source-state-entries.bin" "$evidence_dir/source-state-entries.bin"
printf '%s\n' "$evidence_dir" > /etc/abpiv-plausible/last-migration-evidence
chmod 0600 /etc/abpiv-plausible/last-migration-evidence

MIGRATION_EVIDENCE_DIR="$evidence_dir" /opt/abpiv-plausible/scripts/verify-migration.sh
echo "Plausible ${restore_kind} data restored and verified; runtime remains in maintenance pending acceptance."

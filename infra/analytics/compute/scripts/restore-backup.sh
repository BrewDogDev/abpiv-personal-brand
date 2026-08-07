#!/usr/bin/env bash
set -euo pipefail

: "${BACKUP_URI:?Set the exact gs:// URI ending in plausible-backup.tar.age}"
: "${CONFIRM_RESTORE:?Set CONFIRM_RESTORE=restore-plausible-daily-backup}"
case "$BACKUP_URI" in
  gs://*/plausible/daily/*/plausible-backup.tar.age) ;;
  *) echo "BACKUP_URI must identify one exact Plausible daily backup object." >&2; exit 1 ;;
esac
test "$CONFIRM_RESTORE" = "restore-plausible-daily-backup"

exec env \
  MIGRATION_URI="$BACKUP_URI" \
  CONFIRM_RESTORE="$CONFIRM_RESTORE" \
  /opt/abpiv-plausible/scripts/restore-migration.sh

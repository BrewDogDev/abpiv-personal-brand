#!/usr/bin/env bash
set -euo pipefail
umask 077

# shellcheck source=/dev/null
. /etc/abpiv-plausible/runtime.conf
test "$(cat /etc/abpiv-plausible/mode)" = active
/opt/abpiv-plausible/scripts/assert-data-disk.sh
/opt/abpiv-plausible/scripts/load-runtime-secrets.sh

exec 9>/run/lock/abpiv-plausible-data.lock
flock --wait 60 9

timestamp="$(date --utc +%Y%m%dT%H%M%SZ)"
staging="/srv/plausible/backups/${timestamp}"
round_trip=""
recovery_needed=false
cleanup() {
  status=$?
  set +e
  if "$recovery_needed"; then
    /opt/abpiv-plausible/scripts/runtime-mode.sh active || status=1
  fi
  rm -rf -- "$staging"
  test -z "$round_trip" || rm -rf -- "$round_trip"
  trap - EXIT
  exit "$status"
}
trap cleanup EXIT
install -d -m 0700 "$staging"

recovery_needed=true
/opt/abpiv-plausible/scripts/runtime-mode.sh maintenance

recipient="$(age-keygen -y /run/plausible/BACKUP_AGE_KEY)"
env PACKAGE_DIR="$staging" BACKUP_AGE_RECIPIENT="$recipient" \
  /opt/abpiv-plausible/scripts/create-backup-package.sh

/opt/abpiv-plausible/scripts/runtime-mode.sh active
recovery_needed=false

destination="gs://${PLAUSIBLE_BACKUP_BUCKET}/plausible/daily/${timestamp}"
gcloud storage buckets describe "gs://${PLAUSIBLE_BACKUP_BUCKET}" >/dev/null
gcloud storage cp "$staging/plausible-backup.tar.age" "${destination}/plausible-backup.tar.age"
gcloud storage cp "$staging/plausible-backup.tar.age.sha256" "${destination}/plausible-backup.tar.age.sha256"

round_trip="$(mktemp -d /srv/plausible/backups/round-trip.XXXXXX)"
gcloud storage cp "${destination}/plausible-backup.tar.age" "$round_trip/plausible-backup.tar.age" >/dev/null
gcloud storage cp "${destination}/plausible-backup.tar.age.sha256" "$round_trip/plausible-backup.tar.age.sha256" >/dev/null
(
  cd "$round_trip"
  sha256sum --check plausible-backup.tar.age.sha256 >/dev/null
)

echo "Encrypted Plausible backup ${timestamp} uploaded and verified after round-trip download."

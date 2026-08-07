#!/usr/bin/env bash
set -euo pipefail

test "$(id -u)" -eq 0
: "${RELEASE_DIR:?Set RELEASE_DIR to the uploaded Plausible compute release}"
: "${GCP_PROJECT_ID:?Set GCP_PROJECT_ID}"
: "${PLAUSIBLE_BACKUP_BUCKET:?Set PLAUSIBLE_BACKUP_BUCKET}"

data_device=/dev/disk/by-id/google-abpiv-plausible-data
data_mount=/srv/plausible
test -b "$data_device"
if ! blkid "$data_device" >/dev/null 2>&1; then
  mkfs.ext4 -F -L abpiv-plausible-data "$data_device"
fi
data_uuid="$(blkid -s UUID -o value "$data_device")"
install -d -m 0755 "$data_mount" /etc/abpiv-plausible /opt/abpiv-plausible
if ! grep -Fq "UUID=${data_uuid} ${data_mount} " /etc/fstab; then
  sed -i "\| ${data_mount} |d" /etc/fstab
  printf 'UUID=%s %s ext4 defaults 0 2\n' "$data_uuid" "$data_mount" >> /etc/fstab
fi
mount "$data_mount" 2>/dev/null || mount --all
findmnt --noheadings --output UUID --target "$data_mount" | xargs | grep -Fx "$data_uuid" >/dev/null
printf '%s\n' "$data_uuid" > /etc/abpiv-plausible/data-disk.uuid
chmod 0644 /etc/abpiv-plausible/data-disk.uuid

install -d -m 0700 "$data_mount/postgres" "$data_mount/migration" "$data_mount/backups"
install -d -m 0750 "$data_mount/state" "$data_mount/clickhouse-data" "$data_mount/clickhouse-logs" "$data_mount/clickhouse-backups"
chown -R 70:70 "$data_mount/postgres"
chown -R 999:65533 "$data_mount/state"
chown -R 101:101 "$data_mount/clickhouse-data" "$data_mount/clickhouse-logs" "$data_mount/clickhouse-backups"

rsync --archive --delete --exclude tests/ --exclude nginx/current.conf "$RELEASE_DIR/" /opt/abpiv-plausible/
find /opt/abpiv-plausible/scripts -type f -name '*.sh' -exec chmod 0755 {} +
cp /opt/abpiv-plausible/nginx/maintenance.conf /opt/abpiv-plausible/nginx/current.conf

cat > /etc/abpiv-plausible/runtime.conf <<EOF
GCP_PROJECT_ID=${GCP_PROJECT_ID}
PLAUSIBLE_BACKUP_BUCKET=${PLAUSIBLE_BACKUP_BUCKET}
EOF
chmod 0644 /etc/abpiv-plausible/runtime.conf
printf '%s\n' stopped > /etc/abpiv-plausible/mode

for unit in /opt/abpiv-plausible/systemd/*; do
  install -m 0644 "$unit" "/etc/systemd/system/$(basename "$unit")"
done
systemctl daemon-reload
systemctl disable --now abpiv-plausible.service abpiv-plausible-cloudflared.service abpiv-plausible-backup.timer abpiv-plausible-health.timer >/dev/null 2>&1 || true

/opt/abpiv-plausible/scripts/assert-data-disk.sh
/usr/local/sbin/abpiv-container-firewall --check
docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml config --quiet
docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml pull --quiet
docker compose --project-directory /opt/abpiv-plausible --file /opt/abpiv-plausible/docker-compose.yml down --remove-orphans
rm -rf /run/plausible

echo "Plausible shared-host release provisioned; all production containers remain stopped."

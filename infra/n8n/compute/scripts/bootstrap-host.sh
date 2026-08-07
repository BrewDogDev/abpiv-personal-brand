#!/usr/bin/env bash
set -euo pipefail

bootstrap_marker=/var/lib/abpiv-n8n-bootstrap-complete
if [ -f "$bootstrap_marker" ]; then
  exit 0
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --yes --no-install-recommends \
  age ca-certificates curl gnupg iptables jq rsync unattended-upgrades util-linux

install -d -m 0755 /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/docker.asc ]; then
  curl --fail --silent --show-error --location https://download.docker.com/linux/ubuntu/gpg \
    --output /etc/apt/keyrings/docker.asc
  chmod 0644 /etc/apt/keyrings/docker.asc
fi

# shellcheck source=/dev/null
. /etc/os-release
printf '%s\n' \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
  > /etc/apt/sources.list.d/docker.list

if [ ! -f /etc/apt/keyrings/cloud.google.gpg ]; then
  curl --fail --silent --show-error --location https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor --yes --output /etc/apt/keyrings/cloud.google.gpg
  chmod 0644 /etc/apt/keyrings/cloud.google.gpg
fi
printf '%s\n' \
  "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
  > /etc/apt/sources.list.d/google-cloud-sdk.list

apt-get update
apt-get install --yes --no-install-recommends \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin google-cloud-cli

if ! dpkg-query --show --showformat='${Status}' google-cloud-ops-agent 2>/dev/null | grep -Fq 'install ok installed'; then
  ops_agent_installer="$(mktemp)"
  curl --fail --silent --show-error --location \
    https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh \
    --output "$ops_agent_installer"
  bash "$ops_agent_installer" --also-install --version='2.*.*'
  rm -f "$ops_agent_installer"
fi

CLOUDFLARED_VERSION="2026.7.3"
CLOUDFLARED_DEB_SHA256="049777d30f9bf93da6df8bbe31383460eb2aa51a832c6551824d56f9fcc55974"
if ! command -v cloudflared >/dev/null 2>&1 || ! cloudflared version | grep -Fq "$CLOUDFLARED_VERSION"; then
  cloudflared_deb="$(mktemp --suffix=.deb)"
  trap 'rm -f "$cloudflared_deb"' EXIT
  curl --fail --silent --show-error --location \
    "https://github.com/cloudflare/cloudflared/releases/download/${CLOUDFLARED_VERSION}/cloudflared-linux-amd64.deb" \
    --output "$cloudflared_deb"
  printf '%s  %s\n' "$CLOUDFLARED_DEB_SHA256" "$cloudflared_deb" | sha256sum --check --status
  dpkg --install "$cloudflared_deb"
  rm -f "$cloudflared_deb"
  trap - EXIT
fi

install -d -m 0755 /opt/abpiv-n8n /etc/abpiv-n8n
install -d -m 0700 /run/n8n /run/cloudflared

cat > /etc/sysctl.d/70-abpiv-n8n.conf <<'EOF'
vm.swappiness=10
kernel.dmesg_restrict=1
kernel.kptr_restrict=2
fs.protected_hardlinks=1
fs.protected_symlinks=1
EOF
sysctl --system >/dev/null

systemctl enable --now docker
systemctl enable --now google-cloud-ops-agent
systemctl disable --now cloudflared.service 2>/dev/null || true

touch "$bootstrap_marker"

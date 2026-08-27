#!/usr/bin/env bash
# Base setup for the N5105 box: unattended upgrades, firewall, Docker.
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run as root (sudo ./setup.sh)" >&2
  exit 1
fi

echo "==> Updating base system"
apt-get update
apt-get upgrade -y

echo "==> Installing unattended security upgrades"
apt-get install -y unattended-upgrades
dpkg-reconfigure -f noninteractive unattended-upgrades

echo "==> Configuring firewall (SSH + Samba + NFS only)"
apt-get install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 445/tcp   # Samba
ufw allow 2049/tcp  # NFS
ufw --force enable

echo "==> Installing Docker"
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
  usermod -aG docker "${SUDO_USER:-$USER}"
fi

echo "==> Installing lm-sensors for temperature monitoring"
apt-get install -y lm-sensors
sensors-detect --auto

mkdir -p /mnt/storage
echo "==> Done. Log out/in for the docker group to apply, then run: docker compose up -d"

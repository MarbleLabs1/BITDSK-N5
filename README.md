# BITDSK-N5

Setup and monitoring scripts for a home mini-PC/NAS build on an Intel
N5105-based board — the storage and always-on box behind the homelab side of
the MarbleLabs projects (things like `marbleblockchain.homelinux.com` need
somewhere to actually run).

## Why N5105

Low-power (10W TDP), fanless-capable, cheap, and fast enough for file
serving, a handful of Docker containers, and light transcoding — no need for
a full workstation running 24/7 for that.

## What's here

- `setup.sh` — base OS hardening + Docker install for a fresh Debian/Ubuntu
  install on the box.
- `docker-compose.yml` — the services that actually run on it: Samba/NFS
  share, and a Watchtower-style auto-update container.
- `monitor.sh` — a cron-friendly health check (disk usage, temps via `sensors`,
  container status) that writes a one-line status log.

## Setup

```sh
git clone https://github.com/MarbleLabs1/BITDSK-N5.git
cd BITDSK-N5
sudo ./setup.sh
docker compose up -d
```

## Status

Personal homelab config, published for reference — expect it to assume this
specific box's disk layout (`/mnt/storage`) rather than being fully
generic.

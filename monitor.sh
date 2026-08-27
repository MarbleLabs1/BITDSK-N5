#!/usr/bin/env bash
# Cron-friendly health check: disk usage, CPU temp, container status.
# Suggested crontab: */15 * * * * /path/to/monitor.sh >> /var/log/bitdsk-n5.log
set -euo pipefail

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DISK_USED=$(df -h /mnt/storage --output=pcent | tail -1 | tr -d ' %')
TEMP=$(sensors 2>/dev/null | awk '/Package id 0/ {print $4}' | tr -d '+°C')
CONTAINERS_UP=$(docker ps --filter "status=running" --format '{{.Names}}' | wc -l)
CONTAINERS_TOTAL=$(docker ps -a --format '{{.Names}}' | wc -l)

echo "${TIMESTAMP} disk=${DISK_USED}% temp=${TEMP:-n/a}C containers=${CONTAINERS_UP}/${CONTAINERS_TOTAL}"

if [[ "${DISK_USED:-0}" -ge 90 ]]; then
  echo "${TIMESTAMP} WARNING: disk usage at ${DISK_USED}%" >&2
fi

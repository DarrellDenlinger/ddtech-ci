#!/bin/bash
#
# stop-service-base.sh
#
# Reusable base for stopping a systemd service.
# Do not run directly — source this from a service-specific script
# that sets SERVICE before sourcing.
#
# Example:
#   SERVICE="sonoquii"
#   source /var/www/shared/stop-service-base.sh

if [[ -z "${SERVICE:-}" ]]; then
  echo "ERROR: SERVICE is not set. Set it before sourcing stop-base.sh." >&2
  exit 1
fi

if ! systemctl is-active --quiet "$SERVICE"; then
  echo "$SERVICE is not running."
  exit 0
fi

echo ">>> Stopping $SERVICE..."
systemctl stop "$SERVICE"
echo ">>> $SERVICE stopped."

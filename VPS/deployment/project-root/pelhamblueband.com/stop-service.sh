#!/bin/bash
#
# stop.sh
#
# Stops the service.
# Usage: sudo bash /var/www/pelhamblueband.com/stop-service.sh

set -euo pipefail

SERVICE_NAME="pbb-server"

source /var/www/shared/stop-service-base.sh

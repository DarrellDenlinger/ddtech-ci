#!/bin/bash
#
# restart-server.sh
#
# Restarts the pbb-server service.
# Usage: sudo bash /var/www/pelhamblueband.com/restart-server.sh

set -euo pipefail

SERVICE_NAME="pbb-server"

source /var/www/shared/restart-service-base.sh

restart

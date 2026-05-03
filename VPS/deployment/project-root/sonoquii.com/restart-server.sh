#!/bin/bash
#
# /var/www/sonoquii.com/restart-server.sh
#
# Restarts the sonoquii-server service.
# Usage: sudo bash /var/www/sonoquii.com/restart-server.sh

set -euo pipefail

SERVICE="sonoquii-server"

source /var/www/shared/restart-service-base.sh

restart

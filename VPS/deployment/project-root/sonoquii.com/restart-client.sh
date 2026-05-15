#!/bin/bash
#
# /var/www/sonoquii.com/restart-client.sh
#
# Restarts the sonoquii-client service.
# Usage: sudo bash /var/www/sonoquii.com/restart-client.sh

set -euo pipefail

SERVICE_NAME="sonoquii-client"

source /var/www/shared/restart-service-base.sh

restart

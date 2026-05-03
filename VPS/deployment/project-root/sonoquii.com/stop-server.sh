#!/bin/bash
#
# /var/www/sonoquii.com/stop-server.sh
#
# Stops the sonoquii server service.
# Usage: sudo bash /var/www/sonoquii.com/stop-server.sh

set -euo pipefail

SERVICE="sonoquii-server"

source /var/www/shared/stop-service-base.sh

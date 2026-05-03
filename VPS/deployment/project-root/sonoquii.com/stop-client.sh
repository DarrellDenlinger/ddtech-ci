#!/bin/bash
#
# /var/www/sonoquii.com/stop-client.sh
#
# Stops the sonoquii client service.
# Usage: sudo bash /var/www/sonoquii.com/stop-client.sh

set -euo pipefail

SERVICE="sonoquii-client"

source /var/www/shared/stop-service-base.sh

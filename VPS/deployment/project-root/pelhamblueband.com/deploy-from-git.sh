#!/bin/bash
set -euo pipefail


APP_USER="pbb"
PROJECT_DIR="/var/www/pelhamblueband.com/repo"


source /var/www/shared/deploy-base.sh


pull
install_server_dependencies
finish

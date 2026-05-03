#!/bin/bash
set -euo pipefail


APP_USER="sonoquii"
PROJECT_DIR="/var/www/sonoquii.com/repo"


source /var/www/shared/deploy-base.sh


pull
install_server_dependencies
link_server_env
install_client_dependencies
finish

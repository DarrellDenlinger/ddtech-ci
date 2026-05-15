#!/bin/bash
set -euo pipefail


APP_USER="pbb"
PROJECT_DIR="/var/www/pelhamblueband.com"
# expecting PROJECT_DIR to come in something like /var/www/pelhamblueband.com
PROJECT_DIR="${PROJECT_DIR%/}"   # remove trailing slash if any
PROJECT_NAME="${PROJECT_DIR##*/}"  # remove longest string ending in / 


pull() {
    echo ">>> $PROJECT_NAME >>> Pulling latest code..."
    sudo -u "$APP_USER" git -C "$PROJECT_DIR" pull
}

install_server_dependencies() {
    echo ">>> $PROJECT_NAME >>> Installing server dependencies..."
    sudo -u "$APP_USER" npm --prefix "$PROJECT_DIR" install
    echo ">>> $PROJECT_NAME >>> Pruning server dependencies..."
    sudo -u "$APP_USER" npm --prefix "$PROJECT_DIR" prune
}

finish() {
    echo ">>> $PROJECT_NAME >>> Done in ${SECONDS}s."
}


pull
install_server_dependencies
finish

# put this at /var/www/shared/deploy-base.sh
#
# include this in per-project deploy scripts: deploy-from-git.sh
# source /var/www/shared/deploy-base.sh

# sudo chown root:root /var/www/shared/deploy-base.sh
# sudo chmod 755 /var/www/shared/deploy-base.sh

# expecting PROJECT_DIR to come in something like /var/www/sonoquii.com
PROJECT_DIR="${PROJECT_DIR%/}"   # remove trailing slash if any
PROJECT_NAME="${PROJECT_DIR##*/}"  # remove longest string ending in / 

echo ">>> $PROJECT_NAME >>> Starting deploy..."
cd "$PROJECT_DIR"

pull() {
    echo ">>> $PROJECT_NAME >>> Pulling latest code..."
    sudo -u "$APP_USER" git -C "$PROJECT_DIR" pull
}

install_server_dependencies() {
    echo ">>> $PROJECT_NAME >>> Installing server dependencies..."
    sudo -u "$APP_USER" npm --prefix "$PROJECT_DIR/server" install
    echo ">>> $PROJECT_NAME >>> Pruning server dependencies..."
    sudo -u "$APP_USER" npm --prefix "$PROJECT_DIR/server" prune
}

install_client_dependencies() {
    echo ">>> $PROJECT_NAME >>> Installing client dependencies..."
    sudo -u "$APP_USER" npm --prefix "$PROJECT_DIR/client" install
    echo ">>> $PROJECT_NAME >>> Pruning client dependencies..."
    sudo -u "$APP_USER" npm --prefix "$PROJECT_DIR/client" prune
}

# expected directory structure
#   project_root
#        .env.development
#        .env.production
#        repo
#            server
#                [link to .env.development]
#                [link to .env.production]
#                ...
#            client
#                ...
link_server_env() {
    local src_prod="$PROJECT_DIR/.env.production"
    local src_dev="$PROJECT_DIR/.env.development"
    local dest_prod="$PROJECT_DIR/server/.env.production"
    local dest_dev="$PROJECT_DIR/server/.env.development"

    if [[ ! -f "$src_prod" ]]; then
        echo "ERROR: $src_prod not found. Aborting." >&2
        exit 1
    fi

    echo ">>> $PROJECT_NAME >>> Linking .env.production"
    ln -sf "$src_prod" "$dest_prod"

    if [[ ! -f "$src_dev" ]]; then
        echo "WARNING: $src_dev not found. Skipping development env link."
    else
        echo ">>> $PROJECT_NAME >>> Linking .env.development"
        ln -sf "$src_dev" "$dest_dev"
    fi
}

finish() {
    echo ">>> $PROJECT_NAME >>> Done in ${SECONDS}s."
}


# put this at /var/www/shared/deploy-base.sh
#
# include this in per-project deploy scripts: deploy-from-git.sh
# source /var/www/shared/deploy-base.sh

# sudo chown root:root /var/www/shared/deploy-base.sh
# sudo chmod 755 /var/www/shared/deploy-base.sh

# expecting PROJECT_DIR to come in something like:
#   /var/www/sonoquii.com
#
# expected directory structure:
#
#   /var/www/sonoquii.com
#       .env.development
#       .env.production
#       repo
#           server
#               [link to ../.env.production]
#               [link to ../.env.development]
#               ...
#           client
#               ...

PROJECT_DIR="${PROJECT_DIR%/}"        # remove trailing slash if any
PROJECT_NAME="${PROJECT_DIR##*/}"     # remove longest string ending in /
REPO_DIR="$PROJECT_DIR/repo"

echo ">>> Deploy >>> Project: $PROJECT_NAME   Project_dir: $PROJECT_DIR   Repo_dir: $REPO_DIR >>> Starting deploy..."

cd "$REPO_DIR"

pull() {
    echo ">>> $PROJECT_NAME >>> Pulling latest code..."
    sudo -u "$APP_USER" git -C "$REPO_DIR" pull
}

install_server_dependencies() {
    echo ">>> $PROJECT_NAME >>> Installing server dependencies..."
    sudo -u "$APP_USER" npm --prefix "$REPO_DIR/server" install

    echo ">>> $PROJECT_NAME >>> Pruning server dependencies..."
    sudo -u "$APP_USER" npm --prefix "$REPO_DIR/server" prune
}

install_client_dependencies() {
    echo ">>> $PROJECT_NAME >>> Installing client dependencies..."
    sudo -u "$APP_USER" npm --prefix "$REPO_DIR/client" install

    echo ">>> $PROJECT_NAME >>> Pruning client dependencies..."
    sudo -u "$APP_USER" npm --prefix "$REPO_DIR/client" prune
}

link_server_env() {
    local src_prod="$PROJECT_DIR/.env.production"
    local src_dev="$PROJECT_DIR/.env.development"

    local dest_prod="$REPO_DIR/server/.env.production"
    local dest_dev="$REPO_DIR/server/.env.development"

    if [[ ! -f "$src_prod" ]]; then
        echo "ERROR: $src_prod not found. Aborting." >&2
        exit 1
    fi

    if [[ ! -d "$REPO_DIR/server" ]]; then
        echo "ERROR: $REPO_DIR/server not found. Aborting." >&2
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
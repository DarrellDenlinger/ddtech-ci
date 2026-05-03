# restart system service

restart() {
    echo ">>> $SERVICE_NAME >>> Restarting service..."
    sudo systemctl restart "$SERVICE_NAME"
}

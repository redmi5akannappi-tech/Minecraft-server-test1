#!/bin/bash
set -e

LOG_FILE="/server/logs/latest.log"

# Default: assume 0 players
players=0

if [ -f "$LOG_FILE" ]; then
    players=$(grep -c "Player connected" "$LOG_FILE")
    disconnects=$(grep -c "Player disconnected" "$LOG_FILE")
    players=$((players - disconnects))
    [ $players -lt 0 ] && players=0
fi

if [ "$players" -eq 0 ]; then
    echo "[AutoBackup] No players online, running backup..."
    /server/backup.sh
else
    echo "[AutoBackup] $players players online, skipping backup..."
fi

#!/bin/bash
set -e

# Start a dummy HTTP server so Render detects an open TCP port
python3 -m http.server ${PORT:-8080} --bind 0.0.0.0 &
DUMMY_PID=$!

# Start Playit in background
./install_playit.sh &
PLAYIT_PID=$!

# Start auto-backup scheduler (every 30 min)
(
  while true; do
    echo "[AutoBackup] Running check..."
    /server/auto-backup.sh
    sleep 1800  # 30 minutes
  done
) &
BACKUP_PID=$!

# Restart Bedrock to avoid memory leaks
while true; do
    ./start.sh
    echo "Bedrock server stopped or crashed. Restarting in 10 seconds..."
    sleep 10
done

# Cleanup on exit
trap "kill $PLAYIT_PID $DUMMY_PID $BACKUP_PID" EXIT

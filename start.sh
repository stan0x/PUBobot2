#!/bin/bash

LOG_FILE="pubobot.log"
sleeptimer=5

log() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message"
}

run_bot() {
    python3 PUBobot2.py
    local exit_code=$?
    log "PUBobot2.py exited with code $exit_code"
    if [ $exit_code -eq 0 ]; then
        log "PUBobot2.py exited successfully. Respawning.."
        
        # Start countdown timer
        count=$sleeptimer
        while [ $count -gt 0 ]; do
            echo -ne "\rRespawning in $count seconds..."
            sleep 1
            count=$((count - 1))
        done
        echo ""  # Print a newline after the countdown
    else
        log "PUBobot2.py crashed with exit code $exit_code. Respawning.."
    fi
}

handle_error() {
    local exit_code="$?"
    log "Error occurred with exit code $exit_code"
    exit $exit_code
}

trap 'handle_error' ERR

while true; do
    run_bot
done

#!/bin/bash

LOG_FILE="pubobot.log"
SLEEP_TIMER=5

log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="$1"
    echo "$timestamp - $message" | tee -a "$LOG_FILE"
}

run_bot() {
    python3 PUBobot2.py
    local exit_code=$?
    log "PUBobot2.py exited with code $exit_code"

    if [ $exit_code -eq 0 ]; then
        log "PUBobot2.py exited successfully. Respawning.."
    else
        log "PUBobot2.py crashed with exit code $exit_code. Respawning.."
    fi

    respawn_countdown
}

respawn_countdown() {
    local count=$SLEEP_TIMER
    while [ $count -gt 0 ]; do
        echo -ne "\rRespawning in $count seconds..."
        sleep 1
        count=$((count - 1))
    done
    echo ""  # Print a newline after the countdown
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
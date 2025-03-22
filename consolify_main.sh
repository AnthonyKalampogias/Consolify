#!/bin/bash

# Load configuration
SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="$SCRIPT_DIR/config.env"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: config.env not found! Run setup_wol.sh first."
    exit 1
fi

# Read variables from config
source "$CONFIG_FILE"

LOG_FILE="$SCRIPT_DIR/logs/consolify.log"
mkdir -p "$(dirname "$LOG_FILE")"

echo "Starting WOL listener..." >> "$LOG_FILE"

while true; do
    for MAC in "${CONTROLLER_MACS[@]}"; do
        if hcitool scan | grep -q "$MAC"; then
            echo "$(date): Controller $MAC detected! Sending Wake-on-LAN..." >> "$LOG_FILE"
            wakeonlan "$PC_MAC"
            sleep 10  # Prevent multiple WOL packets
        fi
    done
    sleep 5  # Scan every 5 seconds
done

#!/bin/bash

echo "Welcome to Consolify Setup Wizard!"
echo "This script will configure your current machine to wake your PC when it detects a Bluetooth controller."

# Confirm to proceed
read -p "Do you want to proceed with the setup? (y/n): " proceed
if [[ "$proceed" != "y" ]]; then
    echo "Setup aborted."
    exit 1
fi

# Install required packages
echo "Installing dependencies..."
sudo apt update && sudo apt install -y wakeonlan bluetooth bluez

# Ask for PC MAC address
read -p "Enter your PC's MAC address (format: AA:BB:CC:DD:EE:FF): " PC_MAC

# Ask for controllers
CONTROLLER_MACS=()
while true; do
    read -p "Enter a controller's MAC address (leave empty to finish): " mac
    if [[ -z "$mac" ]]; then
        break
    fi
    CONTROLLER_MACS+=("$mac")
done

# Confirm inputs
echo "PC MAC Address: $PC_MAC"
echo "Controller MAC Addresses: ${CONTROLLER_MACS[*]}"
read -p "Is this correct? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo "Setup aborted."
    exit 1
fi

# Save config file
CONFIG_FILE="$(dirname "$0")/config.env"
echo "Saving configuration to $CONFIG_FILE..."
echo "PC_MAC=\"$PC_MAC\"" > "$CONFIG_FILE"
echo "CONTROLLER_MACS=(${CONTROLLER_MACS[*]})" >> "$CONFIG_FILE"

# Set up crontab to start script on boot
SCRIPT_PATH="$(dirname "$0")/consolify.sh"
echo "Configuring startup script..."
(crontab -l 2>/dev/null; echo "@reboot $SCRIPT_PATH &") | crontab -

echo "Setup complete! The script will run on startup. You can also run it manually with:"
echo "$SCRIPT_PATH"

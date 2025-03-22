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

# Ask for custom script path
read -p "Enter the directory where the script should be installed: " SCRIPT_PATH
mkdir -p "$SCRIPT_PATH/logs"

# Create and update the main script
cat <<EOF > "$SCRIPT_PATH/dualsense_wol.sh"
#!/bin/bash

CONTROLLER_MACS=(${CONTROLLER_MACS[*]})
PC_MAC="$PC_MAC"
LOG_FILE="$SCRIPT_PATH/logs/dualsense_wol.log"

echo "Starting WOL listener..." >> "\$LOG_FILE"

while true; do
    for MAC in "\${CONTROLLER_MACS[@]}"; do
        if hcitool scan | grep -q "\$MAC"; then
            echo "\$(date): Controller \$MAC detected! Sending Wake-on-LAN..." >> "\$LOG_FILE"
            wakeonlan "\$PC_MAC"
            sleep 10  # Prevent multiple WOL packets
        fi
    done
    sleep 5  # Scan every 5 seconds
done
EOF

chmod +x "$SCRIPT_PATH/dualsense_wol.sh"

# Add to crontab for auto-start
echo "Configuring startup script..."
(crontab -l 2>/dev/null; echo "@reboot $SCRIPT_PATH/dualsense_wol.sh &") | crontab -

echo "Setup complete! The script will run on startup. You can also run it manually with:"
echo "$SCRIPT_PATH/dualsense_wol.sh"

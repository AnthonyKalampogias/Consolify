# Turn Your PC into a gaming console with Consolify

## Overview

I wanted to replicate the console experience where you press a button on your controller, and the system powers on—no extra devices, no opening an app, just straight from shutdown to running with the controller in my hands.

The windows ecosystem comes with its limitations on this part. With 3 core issues:


## Requirements 
- **PC** (With Bluetooth, either internally or with an adapter)
Ideally I'd suggest making a dualboot system with windows and bazzyteOS or any other combination or straight up windows but make sure you won't have the required login, so on power on you get straight into the action.
- **Raspberry Pi**
I know this comes to a suprise but for at least for my use case it was the only **easy** way to replicate the power on trigger to my PC
- **A controller of your choice**
For obvious reasons :)

Why?

I wanted to replicate the console experience, where pressing the controller button turns on the system—no apps, no terminals, just the controller in hand.

After researching, I realized:

Bluetooth adapters don't usually support waking the PC. Some Xbox dongles have this feature, but my adapter (and my DualSense) didn’t.
Wake-on-LAN works, but it’s not automatic. I could trigger it manually from my Raspberry Pi, but that required extra steps.
So, I wrote this script to let my Raspberry Pi automatically wake my PC when it detects my controller in pairing mode—just like a console.

How It Works

The Raspberry Pi continuously scans for Bluetooth devices.
When it detects a controller in pairing mode, it sends a Wake-on-LAN packet to the PC.
The PC turns on!
⚠ Why pairing mode?
Pressing just the PS button makes the controller try to reconnect to its last known device, which prevents the Pi from discovering it. Pairing mode makes the controller actively visible to the Pi.

Installation

1. Enable Wake-on-LAN on Your PC
Follow the steps for your OS:

Windows:
Open Device Manager → Network Adapters → Your Ethernet/Wi-Fi Adapter → Properties.
Under the Power Management tab, enable "Allow this device to wake the computer."
Under the Advanced tab, enable "Wake on Magic Packet."
Linux:
sudo ethtool -s eth0 wol g
(Replace eth0 with your network interface.)
2. Install Required Packages on Raspberry Pi
sudo apt update && sudo apt install wakeonlan bluetooth bluez
3. Clone the Repo & Set Up the Script
git clone https://github.com/yourusername/dualsense-wol.git
cd dualsense-wol
chmod +x dualsense_wol.sh
4. Edit the Script to Add Your Controller & PC MAC Addresses
Open the script:

nano dualsense_wol.sh
Modify these lines:

CONTROLLER_MACS=("XX:XX:XX:XX:XX:XX" "YY:YY:YY:YY:YY:YY")  # Add multiple controllers here
PC_MAC="AA:BB:CC:DD:EE:FF"  # Your PC’s MAC address
5. Run the Script on Startup
Edit crontab:

crontab -e
Add:

@reboot /home/pi/dualsense-wol/dualsense_wol.sh &
6. Run the Script Manually (Optional)
If you don't want to reboot, start the script manually:

./dualsense_wol.sh
Logging

Logs are stored in logs/dualsense_wol.log for debugging.

Future Improvements

Detect the controller without pairing mode (still looking for a workaround).
Support for more controller types.
# Turn Your PC into a gaming console with Consolify

## Overview

I wanted to replicate the console experience, when you press a button on your controller the system (PS/XBOX) powers on. No login, no opening game apps, just straight from shutdown to running with the controller in my hands and ready to open a game.

While on windows this comes with some key issues:
- How do you power on the computer from a complete shutdown without having to get up and press the damn button?
- How do you 'login' to the current user without having to type your password?
- How do you open your prefered app on boot and be game ready?

With Consolify I wanted to bring a simple and straight-forward approach to be able to power your computer while only holding your controller. 

*As of now Consolify support only power on your computer with a controller and a pi, I will keep updating the README as I go with the rest of the project on my setup and how I believe I should proceed with it. Please feel free to make comments and suggestions!*

## Requirements 
- **PC** (With Bluetooth, either internally or with an adapter)
Ideally I'd suggest making a dualboot system with windows and [https://bazzite.gg] but lets get into details later.
- **Raspberry Pi**
I know this comes to a suprise but for my use case it was the only **easy** way to replicate the power on trigger to my PC, again I will go into details later.
- **A controller of your choice**
For obvious reasons :)

## Project Progress

### Features
- [x] Wake-on-LAN setup for PC
- [x] Raspberry Pi Bluetooth scanning
- [x] Automatic PC wake-up with controller
- [ ] !@$!@$!@$!@$
- [ ] Seamless controller detection without pairing mode*
- [ ] Support for more controller types
- [ ] Full console-like experience (auto-login, app launch)

### Overall Progress
**Current Progress: 50%**
# █████████░░░░░░░░░░

At first, I thought this would be simple. I saw a video where someone used an Xbox dongle with the "allow this device to wake the computer" option, but my Bluetooth adapter didn’t have this feature, and neither did my DualSense. That’s when I came across Wake-on-LAN (WOL) and realized that with a simple command, I could turn on my PC from my a terminal, even when I wasn’t home!

But this still wasn’t seamless! I didn’t want to open a terminal or use an app every time. I wanted it to work just by pressing the controller’s button. That’s when I had the idea: my Raspberry Pi is already running services for my house, why not set it up to handle this too? While searching I found out about Wake-on-LAN, but it’s not 'automatic'. I could trigger it manually from my Raspberry Pi, but that required extra steps. So, I wrote this script to let my Raspberry Pi automatically wake my PC when it detects my controller in pairing mode!

### How It Works

- The Raspberry Pi continuously scans for Bluetooth devices.
- When it detects a controller in pairing mode, it sends a Wake-on-LAN packet to the PC.
    **The PC turns on!**

#### ⚠ Why pairing mode? *
Pressing just the PS button makes the controller try to reconnect to its last known device, which prevents the Pi from discovering it. Pairing mode makes the controller actively visible to the Pi.

## Installation

1. Enable Wake-on-LAN on Your PC
Follow the steps for your OS:

- Windows:
1. Open Device Manager → Network Adapters → Your Ethernet/Wi-Fi Adapter → Properties.
2. Under the Power Management tab, enable "Allow this device to wake the computer."
3. Under the Advanced tab, enable "Wake on Magic Packet."

- Linux:
1. `sudo ethtool -s eth0 wol g`
(Replace eth0 with your network interface.)
2. Install Required Packages on Raspberry Pi
`sudo apt update && sudo apt install wakeonlan bluetooth bluez`
3. Clone the Repo & Set run the wizard
`git clone https://github.com/yourusername/dualsense-wol.git`
chmod +x wizard.sh

### Run the Script Manually (Optional)
If you don't want to reboot, start the script manually:

./dualsense_wol.sh
Logging

Logs are stored in logs/dualsense_wol.log for debugging.
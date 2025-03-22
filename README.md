# Turn Your PC into a Gaming Console with Consolify

## Overview

I wanted to replicate the console experience: press a button on your controller, and the system (PS/XBOX) powers on. No login, no opening apps—just straight from shutdown to running, ready to play.

On Windows, this isn't as simple as it sounds due to key issues:
- How do you power on the computer from a complete shutdown without pressing the power button?
- How do you log in without typing your password?
- How do you open your preferred app on boot and be game-ready?

With **Consolify**, I aimed for a straightforward solution—powering your PC **just by holding your controller**.  

*Currently, Consolify only supports powering on your PC using a Raspberry Pi and a controller. I'll update this README as I expand the project. Feedback and suggestions are welcome!*

---

## Requirements  

- **PC** (with Bluetooth, either built-in or via an adapter)  
  Ideally, I recommend a **dual-boot setup** with Windows and [Bazzite](https://bazzite.gg), but more on that later.  
- **Raspberry Pi**  
  I know this may seem surprising, but for my use case, it was the only **easy** way to trigger power-on. I'll explain why later.  
- **A Controller** (PS5, PS4, Xbox, etc.)  
  For obvious reasons. 🎮  

---

## Project Progress  

### Overall Progress  
**Current Progress: 50%** 
---

<!-- [----------50%----------]
```█████████░░░░░░░░░░``` -->
### Features  
- [x] Wake-on-LAN setup for PC  
- [x] Raspberry Pi Bluetooth scanning  
- [x] Automatic PC wake-up with controller  
- [ ] Seamless controller detection without pairing mode*  
- [ ] Support for more controller types  
- [ ] Full console-like experience (auto-login, app launch)  
 


At first, I thought this would be simple. I saw a video where someone used an **Xbox dongle** with the "allow this device to wake the computer" option. Unfortunately, my **Bluetooth adapter didn’t have this feature**, and neither did my **DualSense**.  

Then I came across **Wake-on-LAN (WOL)** and realized that with a simple command, I could **turn on my PC from a terminal**—even when I wasn’t home!  

But this still wasn’t seamless. I didn’t want to **open a terminal or use an app every time**—I wanted it to work just by **pressing the controller’s button**.  

That’s when it hit me:  
> *My Raspberry Pi is already running services for my house—why not set it up for this too?*  

So, I wrote a script to let my **Raspberry Pi automatically wake my PC when it detects my controller in pairing mode!**  

---

## How It Works  

- The **Raspberry Pi continuously scans for Bluetooth devices**.  
- When it detects a controller in pairing mode, it **sends a Wake-on-LAN packet** to the PC.  
- **The PC turns on!**  

---

### ⚠ Why Pairing Mode?  

Pressing just the **PS/Xbox button** makes the controller **attempt to reconnect to its last paired device**—which prevents the Pi from discovering it.  

Pairing mode makes the controller **actively visible**, allowing the Pi to detect it and trigger the wake command.  

---

## Installation  

### **1. Enable Wake-on-LAN on Your PC**  

#### **Windows**  
1. Open **Device Manager** → **Network Adapters** → Select your Ethernet/Wi-Fi Adapter → **Properties**.  
2. Under the **Power Management** tab, enable **"Allow this device to wake the computer."**  
3. Under the **Advanced** tab, enable **"Wake on Magic Packet."**  

#### **Linux**  
1. Run:  
```bash
sudo ethtool -s eth0 wol g
```
   (Replace eth0 with your network interface.)

2. Install Required Packages on Raspberry Pi
```bash
sudo apt update && sudo apt install wakeonlan bluetooth bluez
```
3. Clone the Repo & Set run the wizard
```bash
git clone https://github.com/AnthonyKalampogias/Consolify.git
cd Consolify
chmod +x wizard.sh
sudo ./wizard.sh
```

### Run the Script Manually (Optional)
If you don't want to reboot, start the script manually:

```
./consolify.sh
```

### Logging

Logs are stored in logs/consolify.log for debugging.


## Future Steps

Setup a dualboot system with Bazzite and have a shared disk partition for the games so both Windows and Bazzite can see the same game library.

So in order to move forward with this project, I need to get the next step ready, which is 

> *On boot, don't require login and open preferred game client immediately*

To do this, my plan is to:

1. Split my disk into 3 partitions (I have a 2TB NVMe on my PC; you can do the same by just having multiple disks or tailoring it according to your setup): one for Windows, one for Bazzite, and the last one for games. I'll expand more on this as I go (ref. [reddit post](https://www.reddit.com/r/ROGAlly/comments/1gtc9qz/bazzite_dual_boot_with_shared_internal_game_drive/)).
2. Set up Steam Big Picture to run on startup.

#!/bin/bash

echo -e "------------------------------------------------"
echo -e "   Sphero Solutions Multicraft Daemon Script    "
echo -e "              Created by Sobriety S             \n"
echo -e " DO NOT CLOSE THE SHELL TAB THROUGHOUT PROCESS! "
echo -e "------------------------------------------------\n"

# Check if the user is root (or using sudo)
if [ "$EUID" -ne 0 ]; then 
    echo "This script must be run as root or with sudo."
    exit 1
fi

echo -e "[INFO] Updating system..."
apt update && apt full-upgrade &> /dev/null
echo -e "[SUCCESS] System updated!"

echo -e "[INFO] Adding Java PPA..."
add-apt-repository ppa:linuxuprising/java
echo -e "[SUCCESS] Java PPA added!"

echo -e "[INFO] Installing required packages..."
apt install -y apt-transport-https ansible rsync openjdk-16-jdk openjdk-11-jdk openjdk-8-jdk git zip unzip
echo -e "[SUCCESS] Packages installed!"

echo -e "[INFO] Downloading Multicraft latest version..."
wget --quiet http://www.multicraft.org/download/linux64 -O multicraft.tar.gz

if [ ! -f ./multicraft.tar.gz ]; then
    echo -e "[FATAL] Failed to download Multicraft."
    exit 1;
fi
echo -e "[SUCCESS] Multicraft downloaded. Prepare to complete configuration!"
tar xvzf multicraft.tar.gz &> /dev/null
cd multicraft
./setup.sh

echo -e "[INFO] Removing Multicraft installers..."
rm -f /var/www/html/multicraft/install.php
cd ..
rm -rf multicraft && rm -f multicraft.tar.gz
echo -e "[SUCCESS] Installers removed!"

echo -e "[INFO] Setting up Systemd Multicraft service..."
wget --quiet http://www.multicraft.org/files/multicraft.service -O /etc/systemd/system/multicraft.service && chmod 644 /etc/systemd/system/multicraft.service && systemctl enable multicraft

if [ ! -f /etc/systemd/system/multicraft.service ]; then
    echo -e "[FATAL] Failed to create Systemd Multicraft service."
    exit 1
fi
echo -e "[SUCCESS] Systemd Multicraft service created and enabled!"

echo -e "[INFO] Removing premade jars and templates..."
rm -rfv /home/minecraft/multicraft/jar/*
rm -rfv /home/minecraft/multicraft/templates/*
echo -e "[SUCCESS] Successfully removed!\n"

echo -e "------------------------------------------------"
echo -e "   Sphero Solutions Multicraft Daemon Script    "
echo -e "              Created by Sobriety S             \n"
echo -e "   MULTICRAFT DAEMON INSTALLATION SUCCESSFUL    "
echo -e "------------------------------------------------\n"

echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo -e "Now: "
echo -e "- Edit /home/minecraft/multicraft/multicraft.conf, and configure daemon name and memory!"
echo -e "- Remember to run /home/minecraft/multicraft/bin/multicraft -v restart after making changes!"
echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

exit

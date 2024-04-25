#!/bin/bash

# post-install script for arch linux (gnome edition)
# to be used after archinstall (systemd-boot, 'minimal' profile, no audio server, with nm)

# update the system
sudo pacman -Syu

# configure entries
entry_dir="/boot/loader/entries/"
for file in $(sudo ls ${entry_dir} | sudo grep 'fallback'); do
  sudo rm "${entry_dir}${file}"
done
entry=$(sudo ls ${entry_dir})
sudo sed -i '/^options / s/$/ quiet splash nvidia_drm.modeset=1/' "${entry_dir}${entry}"

# configure /etc/pacman.conf
sudo sed -i '/#Color/s/^#//' /etc/pacman.conf
sudo sed -i '/#ParallelDownloads = 5/s/^#//; s/5/4/' /etc/pacman.conf

# install gnome, fonts, nvidia drivers, pipewire, bluez and fish
sudo pacman -S \
gnome gnome-tweaks gst-plugins-base gst-plugins-good \
ttf-ibm-plex ttf-joypixels ttf-font-awesome \
nvidia nvidia-utils nvidia-settings nvidia-prime \
pipewire pipewire-audio pipewire-alsa pipewire-jack pipewire-pulse \
bluez bluez-utils \
fish
sudo systemctl enable gdm
sudo systemctl enable bluetooth
chsh -s $(which fish)
xdg-user-dirs-update

# fuck flatpak and listed packages!
sudo pacman -Rdd flatpak ostree gnome-software epiphany

# enable chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo echo | sudo tee -a /etc/pacman.conf > /dev/null
sudo echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf > /dev/null
sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
sudo pacman -Sy

# install misc. stuff
sudo pacman -S nano neofetch menulibre firefox adw-gtk3

# clean up
sudo ./Scripts/cleaner.sh

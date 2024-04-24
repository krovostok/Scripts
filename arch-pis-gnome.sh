#!/bin/bash

# post-install script for arch linux (gnome edition)
# to be used after archinstall ('minimal' profile, no audio server, with nm)

# update the system
yes | sudo pacman -Syu

# configure entries
entry_dir="/boot/loader/entries/"
for file in $(ls ${entry_dir} | grep 'fallback'); do
  rm "${entry_dir}${file}"
done
entry=$(ls ${entry_dir})
sed -i '/^options / s/$/ quiet splash nvidia_drm.modeset=1/' "${entry_dir}${entry}"

# configure /etc/pacman.conf
sudo sed -i '/#Color/s/^#//' /etc/pacman.conf
sudo sed -i '/#ParallelDownloads = 5/s/^#//; s/5/4/' /etc/pacman.conf

# install fonts
yes | sudo pacman -S --needed noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji ttf-ubuntu-font-family ttf-hack

# install nvidia drivers
yes | sudo pacman -S --needed nvidia nvidia-utils nvidia-settings nvidia-prime

# install pipewire
yes | sudo pacman -S --needed pipewire pipewire-audio pipewire-alsa pipewire-jack pipewire-pulse

# install bluez
yes | sudo pacman -S --needed bluez bluez-utils
sudo systemctl enable bluetooth

# install gnome (and strip it a little)
yes | sudo pacman -S --needed gnome gnome-tweaks gst-plugins-base gst-plugins-good adw-gtk3
yes | sudo pacman -R gnome-software
yes | sudo pacman -Rdd flatpak # (fuck flatpak)
sudo systemctl enable gdm

# install fish
yes | sudo pacman -S --needed fish
chsh -s $(which fish)

# enable chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
yes | sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
yes | sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo echo "[chaotic-aur]" >> /etc/pacman.conf
sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
sudo pacman -Sy

# install basic stuff
yes | sudo pacman -S --needed micro neofetch menulibre firefox

# clean up
sudo ./Scripts/cleaner.sh

# reboot
reboot

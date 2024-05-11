#!/bin/bash

# post-install script for archlinux (plasma edition)
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

# install plasma, fonts (i fucking hate noto fonts), nvidia drivers, pipewire, bluez, power profiles
sudo pacman -S \
plasma konsole dolphin ark kate gwenview dragon okular spectacle kdegraphics-thumbnailers ffmpegthumbs \
ttf-ibm-plex ttf-joypixels noto-fonts noto-fonts-cjk \
nvidia nvidia-utils lib32-nvidia-utils nvidia-settings nvidia-prime \
pipewire pipewire-audio pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
bluez bluez-utils \
power-profiles-daemon
sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl enable power-profiles-daemon
xdg-user-dirs-update

# fuck flatpak and listed packages!
sudo pacman -Rdd flatpak flatpak-kcm discover oxygen oxygen-sounds

# enable chaotic-AUR
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
sudo echo | sudo tee -a /etc/pacman.conf > /dev/null
sudo echo "[chaotic-aur]" | sudo tee -a /etc/pacman.conf > /dev/null
sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null
sudo pacman -Sy

# install misc. stuff and apps i use!
sudo pacman -S nano neofetch firefox telegram-desktop discord spotify \
heroic-games-launcher path-of-building-community-git krita qbittorrent onlyoffice

# gaming stuff and libs (from https://github.com/lutris/docs/blob/master/WineDependencies.md)
sudo pacman -S --needed wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

# clean up
sudo pacman -Scc
sudo pacman -Qtdq | sudo pacman -Rns -
sudo pacman -Qqd | sudo pacman -Rsu -

# shout out to Tomas, Igor, Barbim and Sino
# HEIL BEIDAT, HEIL A.O.D.

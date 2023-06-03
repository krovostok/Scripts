#!/bin/bash

sudo systemctl stop --now $1
sudo systemctl disable --now $1
rm /etc/systemd/system/$1
rm /etc/systemd/system/$1 # and symlinks that might be related
rm /usr/lib/systemd/system/$1 
rm /usr/lib/systemd/system/$1 # and symlinks that might be related
systemctl daemon-reload
systemctl reset-failed

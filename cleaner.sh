#!/bin/bash

# this script deletes unneeded packages, clears cache

yes | sudo pacman -Scc
yes | sudo pacman -Qtdq | sudo pacman -Rns -
yes | sudo pacman -Qqd | sudo pacman -Rsu -

clear
echo "cleansing is done."

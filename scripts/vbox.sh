#!/bin/bash

# Instala o yay
sudo pacman -S --needed git base-devel --noconfirm && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm

# Instala o Brave
yay -S brave-bin --noconfirm
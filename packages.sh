#!/bin/bash

echo "Installing base packages..."

if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed yay
fi

echo "Installing applications..."
yay -S --needed \
    mpv \
    obs-studio \
    flameshot \
    neovim \
    kitty \
    zen-browser-bin # Maybe this will finally replace firefox?

echo "Base packages installed successfully!"

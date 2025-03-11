#!/bin/bash

install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        sudo pacman -S --needed yay
    fi
}

install_packages() {
    echo "Installing applications..."
    yay -S --needed \
        mpv \
        obs-studio \
        flameshot \
        neovim \
        kitty \
        ripgrep \
        zen-browser-bin # Maybe this will finally replace firefox?
}

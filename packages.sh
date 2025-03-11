#!/bin/bash

install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        sudo pacman -S --needed yay
    fi
}

install_packages() {
    echo "Installing applications..."
    
    packages=(
        mpv
        obs-studio
        flameshot
        neovim
        kitty
        ripgrep
        arandr
        zen-browser-bin # Will this finally replace firefox?
    )
    
    yay -S --needed "${packages[@]}"
    
    echo "Applications installed successfully!"
}

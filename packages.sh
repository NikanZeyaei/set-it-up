#!/bin/bash

install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        sudo pacman -S --needed yay
    fi
}

install_packages() {
    echo "Installing applications..."
    
    base_packages=(
        neovim
        kitty
        ripgrep
    )
    
    media_packages=(
        mpv
        obs-studio
        handbrake
    )
    
    browsers=(
        zen-browser-bin # Will this finally replace Firefox?
        brave-bin
    )
    
    utilities=(
        arandr
        flameshot
        expressvpn
    )

    display=(
        optimus-manager
        optimus-manager-qt
    )

    all_packages=(
        "${base_packages[@]}"
        "${media_packages[@]}"
        "${browsers[@]}"
        "${utilities[@]}"
        "${display[@]}"
    )
    
    yay -S --needed "${all_packages[@]}"
    
    echo "Applications installed successfully!"
}

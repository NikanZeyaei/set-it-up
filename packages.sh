#!/bin/bash

install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        sudo pacman -S --needed yay
    fi
}

install_apps() {
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

    comms=(
        slack-desktop
    )

    all_packages=(
        "${base_packages[@]}"
        "${media_packages[@]}"
        "${browsers[@]}"
        "${utilities[@]}"
        "${display[@]}"
        "${comms[@]}"
    )
    
    yay -S --needed "${all_packages[@]}"
    
    echo "Applications installed successfully!"
}

# TODO: Doesn't work properly.
install_telegram() {
    echo "Installing Telegram..."
    
    local download_dir="$HOME/Downloads"
    local install_dir="$HOME/.local/bin/telegram"
    local download_url="https://telegram.org/dl/desktop/linux"
    local tar_file="$download_dir/telegram.tar.xz"
    
    mkdir -p "$download_dir"
    mkdir -p "$install_dir"
    
    echo "Downloading Telegram..."
    if curl -L "$download_url" -o "$tar_file"; then
        echo "Download complete."
        
        echo "Extracting to $install_dir..."
        if tar -xf "$tar_file" -C "$install_dir" --strip-components=1; then
            echo "Extraction complete."
            
            chmod +x "$install_dir/Telegram"
            
            ln -sf "$install_dir/Telegram" "$HOME/.local/bin/telegram"
            
            echo "Removing downloaded archive..."
            rm "$tar_file"
        else
            echo "Failed to extract Telegram."
            return 1
        fi
    else
        echo "Failed to download Telegram."
        return 1
    fi
}

install_packages() {
    install_yay
    install_apps
    install_telegram
}

install_telegram

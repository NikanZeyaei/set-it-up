#!/bin/bash

install_packages() {
    __install_yay
    __install_apps
    __install_telegram
    __install_neovim
    __setup_spicetify
}

__install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        sudo pacman -S --needed yay
    fi
}

__install_apps() {
    echo "Installing applications..."
    
    base_packages=(
        neovim
        ghostty
        ripgrep
        docker
        base-devel
        cmake
        ninja
        curl
    )
    
    media_packages=(
        mpv
        obs-studio
        handbrake
        spotify
        spicetify-cli
    )
    
    browsers=(
        zen-browser-bin # Will this finally replace Firefox?
        brave-bin
    )
    
    utilities=(
        flameshot
        expressvpn
    )

    display=(
        optimus-manager
        optimus-manager-qt
        arandr
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
__install_telegram() {
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

__install_neovim() {
    echo "Installing Neovim from source..."

    local build_dir="$HOME/neovim-build"
    local install_dir="/usr/local"

    echo "Cloning Neovim repository..."
    if ! git clone https://github.com/neovim/neovim "$build_dir"; then
        echo "Failed to clone Neovim repository."
        return 1
    fi

    cd "$build_dir" || { echo "Failed to enter build directory."; 

    # # Checkout stable release (optional)
    # echo "Checking out stable release..."
    # git checkout stable

    echo "Building Neovim..."
    if ! make CMAKE_BUILD_TYPE=RelWithDebInfo; then
        echo "Failed to build Neovim."
        return 1
    fi

    echo "Installing Neovim..."
    if ! sudo make install; then
        echo "Failed to install Neovim."
        return 1
    fi

    echo "Cleaning up build directory..."
    cd "$HOME" || return 1
    rm -rf "$build_dir"

    echo "Neovim installed successfully!"
}

__setup_spicetify() {
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
}

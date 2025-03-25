#!/bin/bash

source ./utils/log.sh

DOWNLOAD_DIR="$HOME/Downloads"
INSTALL_DIR="$HOME/.local/bin"
NEOVIM_BUILD_DIR="$HOME/neovim-build"
TELEGRAM_URL="https://telegram.org/dl/desktop/linux"
TELEGRAM_TAR="$DOWNLOAD_DIR/telegram.tar.xz"
TELEGRAM_INSTALL_DIR="$INSTALL_DIR/telegram"

install_packages() {
    __install_yay || return 1
    __install_apps || return 1
    __install_telegram || return 1
    __install_neovim || return 1
    __setup_spicetify || return 1

    log "All installations and setups completed successfully!"
}

__install_yay() {
    if ! command -v yay &> /dev/null; then
        log "Installing yay..."
        sudo pacman -S --needed yay || { log "Failed to install yay."; return 1; }
    fi
}

__install_apps() {
    local base_packages=(neovim ghostty ripgrep docker base-devel cmake ninja curl stow)
    local media_packages=(mpv obs-studio handbrake spotify spicetify-cli)
    local browsers=(zen-browser-bin brave-bin)
    local utilities=(flameshot expressvpn)
    local display=(optimus-manager optimus-manager-qt arandr)
    local comms=(slack-desktop)

    local all_packages=(
        "${base_packages[@]}"
        "${media_packages[@]}"
        "${browsers[@]}"
        "${utilities[@]}"
        "${display[@]}"
        "${comms[@]}"
    )

    log "Installing applications..."
    yay -S --needed "${all_packages[@]}" || { log "Failed to install applications."; return 1; }
    log "Applications installed successfully!"
}

# TODO: Doesn't work properly
# Install Telegram
__install_telegram() {
    log "Installing Telegram..."

    mkdir -p "$DOWNLOAD_DIR"
    mkdir -p "$TELEGRAM_INSTALL_DIR"

    log "Downloading Telegram..."
    if curl -L "$TELEGRAM_URL" -o "$TELEGRAM_TAR"; then
        log "Download complete."

        log "Extracting to $TELEGRAM_INSTALL_DIR..."
        if tar -xf "$TELEGRAM_TAR" -C "$TELEGRAM_INSTALL_DIR" --strip-components=1; then
            log "Extraction complete."

            chmod +x "$TELEGRAM_INSTALL_DIR/Telegram"
            ln -sf "$TELEGRAM_INSTALL_DIR/Telegram" "$INSTALL_DIR/telegram"

            log "Removing downloaded archive..."
            rm "$TELEGRAM_TAR"
        else
            log "Failed to extract Telegram."
            return 1
        fi
    else
        log "Failed to download Telegram."
        return 1
    fi
}

__install_volta() {
    log "Installing Volta ..."

    curl https://get.volta.sh | bash

    log "Volta installed successfully!"
}

__install_neovim() {
    log "Installing Neovim from source..."

    log "Cloning Neovim repository..."
    if ! git clone https://github.com/neovim/neovim "$NEOVIM_BUILD_DIR"; then
        log "Failed to clone Neovim repository."
        return 1
    fi

    cd "$NEOVIM_BUILD_DIR" || { log "Failed to enter build directory."; return 1; }

    log "Building Neovim..."
    if ! make CMAKE_BUILD_TYPE=RelWithDebInfo; then
        log "Failed to build Neovim."
        return 1
    fi

    log "Installing Neovim..."
    if ! sudo make install; then
        log "Failed to install Neovim."
        return 1
    fi

    log "Cleaning up build directory..."
    cd "$HOME" || return 1
    rm -rf "$NEOVIM_BUILD_DIR"

    log "Neovim installed successfully!"
}

__setup_spicetify() {
    log "Setting up Spicetify..."
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    log "Spicetify setup complete!"
}

#!/bin/bash

source ./utils/log.sh

DOTFILES_REPO="https://github.com/nikanzeyaei/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
SCRIPTS_SRC="$DOTFILES_DIR/scripts"
SCRIPTS_DEST="$HOME/.local/bin"

setup_dotfiles() {
    log "Starting dotfiles setup..."
    __clone_dotfiles
    __create_directories
    __create_symlinks
    __setup_scripts
    __setup_tpm
    log "Dotfiles setup complete!"
}

__clone_dotfiles() {
    log "Setting up dotfiles repository..."
    if [ ! -d "$DOTFILES_DIR" ]; then
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        log "Dotfiles directory already exists. Pulling latest changes..."
        cd "$DOTFILES_DIR"
        git pull
        cd - > /dev/null
    fi
    log "Repository setup complete!"
}

__create_directories() {
    log "Creating necessary directories..."
    mkdir -p "$HOME/.config"
    mkdir -p "$SCRIPTS_DEST"
    log "Directories created successfully!"
}

__setup_scripts() {
    log "Setting up scripts..."
    if [ -d "$SCRIPTS_SRC" ]; then
        mkdir -p "$SCRIPTS_DEST"
        
        for script in "$SCRIPTS_SRC"/*; do
            if [ -f "$script" ]; then
                script_name=$(basename "$script")
                cp -f "$script" "$SCRIPTS_DEST/$script_name"
                chmod +x "$SCRIPTS_DEST/$script_name"
                log "Installed script: $script_name"
            fi
        done
        log "Scripts setup complete!"
    else
        log "Scripts directory not found in dotfiles repository."
    fi
}

__create_symlinks() {
    log "Creating symlinks..."
    ln -sf "$DOTFILES_DIR/i3" "$HOME/.config/i3"
    ln -sf "$DOTFILES_DIR/i3status" "$HOME/.config/i3status"
    ln -sf "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/ghostty" "$HOME/.config/ghostty"
    ln -sf "$DOTFILES_DIR/xfce4" "$HOME/.config/xfce4"

    mkdir -p "$HOME/Pictures/wallpapers"

    ln -sf "$DOTFILES_DIR/wallpapers" "$HOME/Pictures/wallpapers"

    log "Symlinks created successfully!"
}

__setup_tpm() {
    log "Setting up Tmux Plugin Manager (TPM)"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    log "Finished Setting up TPM"
}

#!/bin/bash

source ./utils/log.sh

DOTFILES_REPO="https://github.com/nikanzeyaei/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
SCRIPTS_SRC="$DOTFILES_DIR/.config/scripts"
SCRIPTS_DEST="$HOME/.local/bin"

setup_dotfiles() {
    log "Starting dotfiles setup..."
    __clone_dotfiles
    __create_directories
    __apply_stow
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
    mkdir -p "$HOME/Pictures/wallpapers"
    log "Directories created successfully!"
}

__apply_stow() {
    log "Applying dotfiles with Stow..."
    cd "$DOTFILES_DIR" || exit
    stow --target=$HOME .
    log "Dotfiles successfully stowed!"
}

__setup_scripts() {
    log "Setting up scripts..."
    if [ -d "$SCRIPTS_SRC" ]; then
        mkdir -p "$SCRIPTS_DEST"
        
        for script in "$SCRIPTS_SRC"/*; do
            if [ -f "$script" ]; then
                script_name=$(basename "$script")
                ln -sf "$script" "$SCRIPTS_DEST/$script_name"
                chmod +x "$SCRIPTS_DEST/$script_name"
                log "Installed script: $script_name"
            fi
        done
        log "Scripts setup complete!"
    else
        log "Scripts directory not found in dotfiles repository."
    fi
}

__setup_tpm() {
    log "Setting up Tmux Plugin Manager (TPM)"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        log "TPM is already installed, skipping..."
    fi
    log "Finished Setting up TPM"
}

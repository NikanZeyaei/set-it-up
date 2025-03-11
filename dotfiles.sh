#!/bin/bash

DOTFILES_REPO="https://github.com/nikanzeyaei/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
SCRIPTS_SRC="$DOTFILES_DIR/scripts"
SCRIPTS_DEST="$HOME/.local/bin"

setup_tpm() {
    echo "Setting up Tmux Plugin Manager (TPM)"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "Finished Setting up TPM"
}

clone_dotfiles() {
    echo "Setting up dotfiles repository..."
    if [ ! -d "$DOTFILES_DIR" ]; then
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        echo "Dotfiles directory already exists. Pulling latest changes..."
        cd "$DOTFILES_DIR"
        git pull
        cd - > /dev/null
    fi
    echo "Repository setup complete!"
}

create_directories() {
    echo "Creating necessary directories..."
    mkdir -p "$HOME/.config"
    mkdir -p "$SCRIPTS_DEST"
    echo "Directories created successfully!"
}

setup_scripts() {
    echo "Setting up scripts..."
    if [ -d "$SCRIPTS_SRC" ]; then
        mkdir -p "$SCRIPTS_DEST"
        
        for script in "$SCRIPTS_SRC"/*; do
            if [ -f "$script" ]; then
                script_name=$(basename "$script")
                cp -f "$script" "$SCRIPTS_DEST/$script_name"
                chmod +x "$SCRIPTS_DEST/$script_name"
                echo "Installed script: $script_name"
            fi
        done
        echo "Scripts setup complete!"
    else
        echo "Scripts directory not found in dotfiles repository."
    fi
}

create_symlinks() {
    echo "Creating symlinks..."
    ln -sf "$DOTFILES_DIR/.config/i3" "$HOME/.config/i3"
    ln -sf "$DOTFILES_DIR/.config/i3status" "$HOME/.config/i3status"
    ln -sf "$DOTFILES_DIR/.config/tmux" "$HOME/.config/tmux"
    ln -sf "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
    ln -sf "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"
    echo "Symlinks created successfully!"
}

setup_dotfiles() {
    echo "Starting dotfiles setup..."
    clone_dotfiles
    create_directories
    create_symlinks
    setup_scripts
    setup_tpm
    echo "Dotfiles setup complete!"
}

# If the script is being run directly (not sourced), execute the full setup
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    setup_dotfiles
else
    # If the script is being sourced, just make the functions available
    echo "Dotfiles functions loaded. Available functions:"
    echo "- clone_dotfiles: Clone or update the dotfiles repository"
    echo "- create_directories: Create necessary config directories"
    echo "- create_symlinks: Create symlinks to dotfiles"
    echo "- setup_dotfiles: Run the complete setup process"
fi

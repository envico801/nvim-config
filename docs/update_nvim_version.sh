#!/bin/bash

# Whether to add the path of the installed executables to system PATH
ADD_TO_SYSTEM_PATH=true
# select which shell we are using
USE_ZSH_SHELL=true
USE_BASH_SHELL=false

#######################################################################
#                                Nvim install                           #
#######################################################################
NVIM_DIR=$HOME/tools/nvim
NVIM_SRC_NAME=$HOME/packages/nvim-linux64.tar.gz
NVIM_CONFIG_DIR=$HOME/.config/nvim
NVIM_LINK="https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz"

echo "This script will update Neovim to version 0.10.3"
echo "Your configuration in $NVIM_CONFIG_DIR will NOT be touched"

# Create packages directory if it doesn't exist
mkdir -p "$HOME/packages"

# Remove old Neovim (installer) package if it exists
if [[ -f "$NVIM_SRC_NAME" ]]; then
  echo "Old Neovim (installer) package found at $NVIM_SRC_NAME. Removing it..."
    rm -f "$NVIM_SRC_NAME"
fi

# Backup existing installation if it exists
if [[ -d "$NVIM_DIR" ]]; then
    echo "Creating backup of existing Neovim installation"
    backup_dir="${NVIM_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    mv "$NVIM_DIR" "$backup_dir"
    echo "Backup created at: $backup_dir"
fi

echo "Installing Nvim"
echo "Creating nvim directory under tools directory"
mkdir -p "$NVIM_DIR"

if [[ ! -f $NVIM_SRC_NAME ]]; then
    echo "Downloading Nvim"
    wget "$NVIM_LINK" -O "$NVIM_SRC_NAME"
fi

echo "Extracting neovim"
tar zxf "$NVIM_SRC_NAME" --strip-components 1 -C "$NVIM_DIR" > /dev/null

# Add to PATH based on shell preference
#
# if [[ "$ADD_TO_SYSTEM_PATH" = true ]]; then
#     if [[ "$USE_BASH_SHELL" = true ]]; then
#         echo "Adding to bash profile"
#         echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> "$HOME/.bash_profile"
#     fi
#     if [[ "$USE_ZSH_SHELL" = true ]]; then
#         echo "Adding to zsh profile"
#         echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> "$HOME/.zshrc"
#     fi
# fi

echo "Neovim installation complete!"
echo "Your Neovim configuration in $NVIM_CONFIG_DIR remains unchanged"
echo "To verify the installation, run: nvim --version"

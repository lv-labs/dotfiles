#!/bin/bash

# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create .config/aerospace directory if it doesn't exist
mkdir -p ~/.config/aerospace

# Create symlink for aerospace.toml
ln -sf "$DIR/.config/aerospace/aerospace.toml" ~/.config/aerospace/aerospace.toml

echo "Dotfiles setup complete."
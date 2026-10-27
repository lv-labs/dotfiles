#!/bin/sh
set -eu

DOTFILES=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TUNA_SCRIPTS="$HOME/Library/Application Support/Tuna/scripts"
VSCODE_USER="$HOME/Library/Application Support/Code/User"

mkdir -p "$TUNA_SCRIPTS" "$VSCODE_USER"
for destination in "$TUNA_SCRIPTS/current_workspace.py" "$TUNA_SCRIPTS/open_here.py" "$VSCODE_USER/tasks.json"; do
    if [ -e "$destination" ] && [ ! -L "$destination" ]; then
        cp -p "$destination" "$destination.backup-$(date +%Y%m%d-%H%M%S)"
    fi
done
ln -sf "$DOTFILES/tuna/scripts/current_workspace.py" "$TUNA_SCRIPTS/current_workspace.py"
ln -sf "$DOTFILES/tuna/scripts/open_here.py" "$TUNA_SCRIPTS/open_here.py"
ln -sf "$DOTFILES/vscode/tasks.json" "$VSCODE_USER/tasks.json"
echo "Tuna workspace helper and VS Code tasks installed."

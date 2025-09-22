#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Documents/lv-labs/dotfiles"

echo "🔧 Bootstrapping environment..."

# ---------------------------------------------------------
# 1. Homebrew + Brewfile
# ---------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "📦 Installing from Brewfile..."
brew bundle --file="$DOTFILES/brewfile"

# ---------------------------------------------------------
# 2. Symlinks for configs
# ---------------------------------------------------------

# Zsh
ln -sf "$DOTFILES/zshrc" "$HOME/.zshrc"

# Git
ln -sf "$DOTFILES/gitconfig" "$HOME/.gitconfig"
[ -f "$DOTFILES/gitconfig-work" ] && ln -sf "$DOTFILES/gitconfig-work" "$HOME/.gitconfig-work"

# SSH config (⚠️ manual keys still required from 1Password)
if [ -f "$DOTFILES/ssh_config" ]; then
  mkdir -p "$HOME/.ssh"
  ln -sf "$DOTFILES/ssh_config" "$HOME/.ssh/config"
fi

# Ghostty
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/ghostty" "$HOME/.config/ghostty"

# Aerospace
ln -sf "$DOTFILES/aerospace.toml" "$HOME/.aerospace.toml"

# VS Code
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
[ -f "$DOTFILES/vscode/settings.json" ] && ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"
[ -f "$DOTFILES/vscode/keybindings.json" ] && ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
[ -d "$DOTFILES/vscode/snippets" ] && ln -sfn "$DOTFILES/vscode/snippets" "$VSCODE_USER/snippets"

# KiCad prefs (skip thonk libs until setup_kicad.sh)
mkdir -p "$HOME/Library/Preferences/kicad"
[ -d "$DOTFILES/kicad/9.0" ] && ln -sfn "$DOTFILES/kicad/9.0" "$HOME/Library/Preferences/kicad/9.0"

# Karabiner
mkdir -p "$HOME/.config"
[ -d "$DOTFILES/karabiner" ] && ln -sfn "$DOTFILES/karabiner" "$HOME/.config/karabiner"

echo "✨ Symlinks created."

# ---------------------------------------------------------
# 3. Pyenv (install latest Python and set global)
# ---------------------------------------------------------
if command -v pyenv >/dev/null 2>&1; then
  echo "🐍 Setting up latest Python via pyenv..."
  latest=$(pyenv install --list | grep -E "^[[:space:]]*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
  pyenv install -s "$latest"
  pyenv global "$latest"
  echo "✅ pyenv set global Python to $latest"
else
  echo "⚠️ pyenv not found (check Brewfile install?)"
fi

# ---------------------------------------------------------
# 4. Reminders
# ---------------------------------------------------------
echo
echo "✅ Bootstrap complete!"
echo "Next steps:"
echo "  1. Restore SSH keys from 1Password → ~/.ssh/id_ed25519_*"
echo "  2. Run 'ssh-add' to load them into agent"
echo "  3. Switch dotfiles repo remote to SSH if desired"
echo "  4. Clone work repos (e.g. thonk-kicad-lib) once SSH works"
echo "  5. Run ./setup_kicad.sh to finish KiCad setup"
#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Documents/lv-labs/dotfiles"

echo "🔧 bootstrapping environment..."

# ---------------------------------------------------------
# 1. homebrew + brewfile
# ---------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH now
if [ -d /opt/homebrew/bin ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "📦 installing from brewfile..."
brew bundle --file="$DOTFILES/brewfile"

# ---------------------------------------------------------
# 2. oh-my-zsh + plugins
# ---------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🎀 installing oh-my-zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

echo "✨ oh-my-zsh and plugins installed."

# ---------------------------------------------------------
# 3. symlinks for configs
# ---------------------------------------------------------

# zsh
ln -sf "$DOTFILES/zshrc" "$HOME/.zshrc"

# git
ln -sf "$DOTFILES/gitconfig" "$HOME/.gitconfig"
[ -f "$DOTFILES/gitconfig-work" ] && ln -sf "$DOTFILES/gitconfig-work" "$HOME/.gitconfig-work"

# ssh config (keys generated manually after bootstrap)
if [ -f "$DOTFILES/.ssh/config" ]; then
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ln -sf "$DOTFILES/.ssh/config" "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
fi
# ghostty
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/ghostty" "$HOME/.config/ghostty"

# aerospace
ln -sf "$DOTFILES/aerospace.toml" "$HOME/.aerospace.toml"

# vscode
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
[ -f "$DOTFILES/vscode/settings.json" ] && ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"
[ -f "$DOTFILES/vscode/keybindings.json" ] && ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"
[ -d "$DOTFILES/vscode/snippets" ] && ln -sfn "$DOTFILES/vscode/snippets" "$VSCODE_USER/snippets"

# kicad prefs (skip thonk libs until setup_kicad.sh)
mkdir -p "$HOME/Library/Preferences/kicad"
[ -d "$DOTFILES/kicad/9.0" ] && ln -sfn "$DOTFILES/kicad/9.0" "$HOME/Library/Preferences/kicad/9.0"

echo "✨ symlinks created."

# ---------------------------------------------------------
# 4. pyenv (install latest python and set global)
# ---------------------------------------------------------
if command -v pyenv >/dev/null 2>&1; then
  echo "🐍 setting up latest python via pyenv..."
  latest=$(pyenv install --list | grep -E "^[[:space:]]*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
  pyenv install -s "$latest"
  pyenv global "$latest"
  echo "✅ pyenv set global python to $latest"
else
  echo "⚠️ pyenv not found (check brewfile install?)"
fi

echo
echo "✅ bootstrap complete!"
echo "Next steps:"
echo "  1. generate or copy SSH keys manually → ~/.ssh/id_ed25519_*"
echo "  2. run 'ssh-add' to load them into agent"
echo "  3. switch dotfiles repo remote to SSH if desired"
echo "  4. clone work repos (e.g. thonk-kicad-lib, thonk-modules) once SSH works"
echo "  5. run ./setup_kicad.sh to finish kicad setup"
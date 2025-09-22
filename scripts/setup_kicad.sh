#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Documents/lv-labs/dotfiles"
WORK_DIR="$HOME/Documents/thonk"
REPO="git@github.com-work:thonksynth/thonk-kicad-lib.git"
TARGET="$WORK_DIR/thonk-kicad-lib"

echo "🔧 Setting up KiCad work environment..."

# Ensure work dir exists
mkdir -p "$WORK_DIR"

# Clone the work KiCad library if missing
if [ ! -d "$TARGET" ]; then
  echo "📥 Cloning thonk-kicad-lib..."
  git clone "$REPO" "$TARGET"
else
  echo "ℹ️ thonk-kicad-lib already exists at $TARGET"
fi

# Symlink KiCad config from dotfiles
KI_CONFIG="$HOME/Library/Preferences/kicad/9.0"
if [ -d "$DOTFILES/kicad/9.0" ]; then
  echo "🔗 Linking KiCad 9.0 prefs..."
  rm -rf "$KI_CONFIG"
  ln -sfn "$DOTFILES/kicad/9.0" "$KI_CONFIG"
fi

# Set environment variables (in case .zshrc hasn’t been sourced yet)
export THONK_LIB_DIR="$TARGET"
export THONK_3D_MODELS="$THONK_LIB_DIR/3DModels"

echo "✅ KiCad work library setup complete!"
echo
echo "Reminder:"
echo " - THONK_LIB_DIR is set to $THONK_LIB_DIR"
echo " - THONK_3D_MODELS is set to $THONK_3D_MODELS"
echo " - These paths are also exported in your ~/.zshrc"
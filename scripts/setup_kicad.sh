#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Documents/lv-labs/dotfiles"
WORK_DIR="$HOME/Documents/thonk"
REPO="git@github.com-work:thonksynth/thonk-kicad-lib.git"
TARGET="$WORK_DIR/thonk-kicad-lib"

echo "🔧 setting up kicad work environment..."

# ensure work dir exists
mkdir -p "$WORK_DIR"

# clone the work kicad library if missing
if [ ! -d "$TARGET" ]; then
  echo "📥 cloning thonk-kicad-lib..."
  git clone "$REPO" "$TARGET"
else
  echo "ℹ️ thonk-kicad-lib already exists at $TARGET"
fi

# set environment variables.
export THONK_LIB_DIR="$TARGET"
export THONK_3D_MODELS="$THONK_LIB_DIR/3d"

# set them globally for GUI apps (Dock/Finder)
launchctl setenv THONK_LIB_DIR "$THONK_LIB_DIR"
launchctl setenv THONK_3D_MODELS "$THONK_3D_MODELS"

echo "✅ kicad library setup complete!"
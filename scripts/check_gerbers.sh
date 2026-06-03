#!/usr/bin/env bash
set -eEo pipefail

# Usage: ./fix_gerbers_all_gbr.sh <path/to/archive.zip>

ZIPFILE="${1:-}"
if [[ -z "$ZIPFILE" || ! -f "$ZIPFILE" ]]; then
  echo "Usage: $0 <zipfile>"
  exit 1
fi

WORKDIR=$(mktemp -d)
EXT=".gbr"

# === UNZIP ===
unzip -q "$ZIPFILE" -d "$WORKDIR"

# Locate main directory (should contain ok/ and yg/)
# === Find the real root that contains the 'ok' folder ===
# Some zips add an extra top-level directory layer.
POSSIBLE_OK=$(find "$WORKDIR" -type d -name ok -print -quit)

if [[ -z "$POSSIBLE_OK" ]]; then
  echo "Error: could not find 'ok' folder in extracted archive."
  exit 1
fi

# Use parent of ok/ as our root directory
ROOTDIR="$(dirname "$POSSIBLE_OK")"

# Remove YG folder
rm -rf "$ROOTDIR/yg" 2>/dev/null || true

pushd "$ROOTDIR/ok" >/dev/null

echo "🧩 Renaming files in ok/ → *.gbr"
REPORT=""

for f in *; do
  [[ -d "$f" ]] && continue

  # Skip non-Gerber / binary support files
  case "$f" in
    *.ddw|*.tgz|*.zip|*.rar) 
      echo "Skipping non-Gerber file: $f"
      continue
      ;;
  esac

  base="$(basename "$f")"
  new=""

  case "$base" in
    to) new="F_SilkS${EXT}" ;;
    ts) new="F_Mask${EXT}" ;;
    tl) new="F_Cu${EXT}" ;;
    bl) new="B_Cu${EXT}" ;;
    bs) new="B_Mask${EXT}" ;;
    bo) new="B_SilkS${EXT}" ;;
    ko) new="Edge_Cuts${EXT}" ;;
    sk) new="ViaFill${EXT}" ;;
    vcut) new="VCut${EXT}" ;;
    ko_pp) new="Heatsink${EXT}" ;;
    baobian) new="EdgePlating${EXT}" ;;
    l[0-9]*) 
      num="${base#l}"
      new="In${num}_Cu${EXT}" ;;
    *.*)  # already has some extension, skip renaming
      echo "Skipping already-extension file: $f"
      continue ;;
    *) new="${base}${EXT}" ;;
  esac

  if [[ "$new" != "$base" ]]; then
    mv "$base" "$new"
    REPORT+="$base → $new\n"
  fi
done

popd >/dev/null

# === REZIP RESULT ===
OUTPUT_ZIP="${ZIPFILE%.zip}_ok.zip"
cd "$ROOTDIR"
zip -qr "$OUTPUT_ZIP" ok

# === Summary ===
echo -e "\n✅ Renamed files --------------------"
echo -e "$REPORT"

# === Try to open in KiCad ===
if command -v gerbview >/dev/null 2>&1; then
  gerbview "$ROOTDIR/ok"/*.gbr >/dev/null 2>&1 &
  echo "📂 Opened in KiCad GerbView."
else
  echo "⚠️  gerbview not in PATH, skipped auto-open."
fi

echo -e "\n🎯 Cleaned archive: $OUTPUT_ZIP"
echo "Working directory: $ROOTDIR"

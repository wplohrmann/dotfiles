#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

BUNDLE_ID="com.will.editinghostty"
APP_NAME="EditInGhostty"
APP_DIR="$HOME/Applications"
APP_PATH="$APP_DIR/$APP_NAME.app"
CONFIG_DIR="$HOME/.config/edit-in-ghostty"
FALLBACK_FILE="$CONFIG_DIR/fallbacks.txt"

EXTENSIONS=(
  py lua sh bash zsh fish js ts jsx tsx mjs cjs json yaml yml toml
  md txt rst tex c cc cpp h hpp m mm rs go rb java kt swift php
  css scss sass html htm xml svg conf cfg ini env diff patch sql
  log csv tsv applescript dockerfile makefile gitignore gitconfig
)

if ! command -v duti >/dev/null 2>&1; then
  echo "duti is required: brew install duti" >&2
  exit 1
fi

mkdir -p "$APP_DIR" "$CONFIG_DIR"

# Capture original handlers BEFORE we overwrite them, so the fallback path
# can still reach the user's previous default.
if [ ! -s "$FALLBACK_FILE" ]; then
  echo "Capturing current default handlers..."
  : > "$FALLBACK_FILE"
  for ext in "${EXTENSIONS[@]}"; do
    bid=$(duti -x "$ext" 2>/dev/null | tail -n1 || true)
    if [ -n "$bid" ] && [ "$bid" != "$BUNDLE_ID" ]; then
      echo "$ext=$bid" >> "$FALLBACK_FILE"
    fi
  done
  echo "  -> $FALLBACK_FILE"
else
  echo "Existing fallback map at $FALLBACK_FILE — keeping it."
fi

# Compile the AppleScript into an .app bundle.
rm -rf "$APP_PATH"
osacompile -o "$APP_PATH" "$SCRIPT_DIR/EditInGhostty.applescript"

PLIST="$APP_PATH/Contents/Info.plist"
PB=/usr/libexec/PlistBuddy

# Stable bundle id so duti has a target.
$PB -c "Set :CFBundleIdentifier $BUNDLE_ID" "$PLIST" 2>/dev/null \
  || $PB -c "Add :CFBundleIdentifier string $BUNDLE_ID" "$PLIST"

# Hide from Dock + don't activate on launch (so click focus stays in Ghostty).
$PB -c "Set :LSUIElement true" "$PLIST" 2>/dev/null \
  || $PB -c "Add :LSUIElement bool true" "$PLIST"
$PB -c "Set :LSBackgroundOnly true" "$PLIST" 2>/dev/null \
  || $PB -c "Add :LSBackgroundOnly bool true" "$PLIST"

# Declare the document types this app can handle. Without this, duti -s is a
# silent no-op — Launch Services won't grant default-handler status to a bundle
# that doesn't advertise support.
EXT_LIST="${EXTENSIONS[*]}" /usr/bin/python3 - "$PLIST" <<'PY'
import os, plistlib, sys
plist_path = sys.argv[1]
exts = os.environ["EXT_LIST"].split()
with open(plist_path, "rb") as f:
    plist = plistlib.load(f)
plist["CFBundleDocumentTypes"] = [{
    "CFBundleTypeName": "Source Code & Text",
    "CFBundleTypeRole": "Editor",
    "LSHandlerRank": "Alternate",
    "CFBundleTypeExtensions": exts,
    "LSItemContentTypes": [
        "public.text",
        "public.plain-text",
        "public.source-code",
        "public.script",
        "public.shell-script",
        "public.data",
    ],
}]
with open(plist_path, "wb") as f:
    plistlib.dump(plist, f)
PY

# Force Launch Services to re-read the bundle.
touch "$APP_PATH"
/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister \
  -f "$APP_PATH" >/dev/null 2>&1 || true

echo "Registering as default for ${#EXTENSIONS[@]} extensions..."
for ext in "${EXTENSIONS[@]}"; do
  duti -s "$BUNDLE_ID" "$ext" all 2>/dev/null || true
done

# Report which ones actually took. Some extensions resolve to dynamic UTIs
# (no static UTI in macOS for them) and lose to apps like VSCode/Zed that
# import them via UTImportedTypeDeclarations. Those need a per-user override
# via Finder ("Open With > Other > Always Open With") to redirect.
LOST=()
for ext in "${EXTENSIONS[@]}"; do
  bid=$(duti -x "$ext" 2>/dev/null | tail -n1 || true)
  if [ "$bid" != "$BUNDLE_ID" ]; then
    LOST+=("$ext${bid:+ ($bid)}")
  fi
done

echo
echo "Installed: $APP_PATH"
echo "Fallbacks: $FALLBACK_FILE  (edit to tweak per-extension behavior)"
echo "Uninstall: $SCRIPT_DIR/uninstall.sh"
if [ "${#LOST[@]}" -gt 0 ]; then
  echo
  echo "Could not claim ${#LOST[@]} extension(s) — another app has a stronger UTI claim:"
  printf '  %s\n' "${LOST[@]}"
  echo "Override one in Finder: right-click a file -> Open With -> Other -> EditInGhostty -> Always Open With"
fi

#!/usr/bin/env bash
set -euo pipefail

BUNDLE_ID="com.will.editinghostty"
APP_PATH="$HOME/Applications/EditInGhostty.app"
CONFIG_DIR="$HOME/.config/edit-in-ghostty"
FALLBACK_FILE="$CONFIG_DIR/fallbacks.txt"

if ! command -v duti >/dev/null 2>&1; then
  echo "duti is required: brew install duti" >&2
  exit 1
fi

if [ ! -s "$FALLBACK_FILE" ]; then
  echo "No fallback map at $FALLBACK_FILE — nothing to restore." >&2
else
  echo "Restoring previous default handlers from $FALLBACK_FILE..."
  while IFS='=' read -r ext bid; do
    [ -z "$ext" ] || [ -z "$bid" ] && continue
    duti -s "$bid" "$ext" all 2>/dev/null || true
  done < "$FALLBACK_FILE"
fi

if [ -d "$APP_PATH" ]; then
  rm -rf "$APP_PATH"
  echo "Removed $APP_PATH"
fi

echo "Done. (Fallback map kept at $FALLBACK_FILE in case you reinstall.)"

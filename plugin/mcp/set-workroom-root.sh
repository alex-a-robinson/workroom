#!/bin/bash
# Configure the Workroom root directory.
# Called by the onboarding skill to persist the user's chosen path.
# Usage: set-workroom-root.sh /path/to/workroom

if [ $# -ne 1 ]; then
  echo "Usage: set-workroom-root.sh <workroom-directory-path>" >&2
  exit 1
fi

TARGET_PATH="$1"

if [ ! -d "$TARGET_PATH" ]; then
  echo "Error: Path does not exist or is not a directory: $TARGET_PATH" >&2
  exit 1
fi

# Fall back to ~/.workroom if Cowork doesn't pass CLAUDE_PLUGIN_DATA to skill scripts.
PLUGIN_DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.workroom}"
mkdir -p "$PLUGIN_DATA_DIR" || {
  echo "Error: Could not create data directory: $PLUGIN_DATA_DIR" >&2
  exit 1
}

CONFIG_FILE="$PLUGIN_DATA_DIR/config.json"

# Escape path for JSON (handle backslashes and double-quotes).
ESCAPED=$(printf '%s' "$TARGET_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
printf '{"workroomRoot":"%s"}\n' "$ESCAPED" > "$CONFIG_FILE"

echo "Workroom root set to: $TARGET_PATH"
echo "Config written to: $CONFIG_FILE"

#!/bin/bash
set -eu

# Script to configure the Workroom root directory.
# Called by the onboarding skill to persist the user's chosen path.
# Usage: set-workroom-root.sh /path/to/workroom

if [ $# -ne 1 ]; then
  echo "Usage: set-workroom-root.sh <workroom-directory-path>" >&2
  exit 1
fi

TARGET_PATH="$1"

# Validate that the path exists and is a directory.
if [ ! -d "$TARGET_PATH" ]; then
  echo "Error: Path does not exist or is not a directory: $TARGET_PATH" >&2
  exit 1
fi

# Ensure CLAUDE_PLUGIN_DATA directory exists.
PLUGIN_DATA_DIR="${CLAUDE_PLUGIN_DATA}"
if [ -z "$PLUGIN_DATA_DIR" ]; then
  echo "Error: CLAUDE_PLUGIN_DATA environment variable is not set." >&2
  exit 1
fi

if [ ! -d "$PLUGIN_DATA_DIR" ]; then
  mkdir -p "$PLUGIN_DATA_DIR" || {
    echo "Error: Could not create CLAUDE_PLUGIN_DATA directory: $PLUGIN_DATA_DIR" >&2
    exit 1
  }
fi

# Write the config file with the chosen path.
# Use printf to construct plain JSON (no jq dependency).
CONFIG_FILE="${PLUGIN_DATA_DIR}/config.json"
printf '{"workroomRoot":"%s"}\n' "$TARGET_PATH" > "$CONFIG_FILE"

echo "Workroom root set to: $TARGET_PATH"
echo "Config written to: $CONFIG_FILE"

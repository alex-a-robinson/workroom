#!/bin/bash
set -eu

# Wrapper script for the filesystem MCP server.
# Reads the Workroom root from ${CLAUDE_PLUGIN_DATA}/config.json at runtime,
# allowing the user to pick their directory at onboarding time.

CONFIG_FILE="${CLAUDE_PLUGIN_DATA}/config.json"
DEFAULT_ROOT="${HOME}/Documents/Claude/Projects/Workroom"

# Extract workroomRoot from config.json using jq if available, otherwise sed.
if [ -f "$CONFIG_FILE" ]; then
  if command -v jq &> /dev/null; then
    WORKROOM_ROOT=$(jq -r '.workroomRoot // empty' "$CONFIG_FILE")
  else
    # Fallback: use sed/awk to extract the value (simple JSON, no quotes escaping).
    WORKROOM_ROOT=$(sed -n 's/.*"workroomRoot"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG_FILE" | head -1)
  fi
fi

# Use default if config is missing or workroomRoot not found.
WORKROOM_ROOT="${WORKROOM_ROOT:-$DEFAULT_ROOT}"

# Validate that the root exists.
if [ ! -d "$WORKROOM_ROOT" ]; then
  echo "Error: Workroom root does not exist: $WORKROOM_ROOT" >&2
  echo "Set it with: mcp/set-workroom-root.sh <path>" >&2
  exit 1
fi

# Launch the filesystem MCP server with the resolved root.
exec npx -y @modelcontextprotocol/server-filesystem "$WORKROOM_ROOT"

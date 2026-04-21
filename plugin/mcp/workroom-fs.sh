#!/bin/bash
# Wrapper for the bundled @modelcontextprotocol/server-filesystem.
# Resolves the Workroom root at spawn time so users can pick their directory
# during onboarding without editing .mcp.json.
#
# Resolution order:
#   1. workroomRoot field in ${CLAUDE_PLUGIN_DATA:-$HOME/.workroom}/config.json
#   2. $WORKROOM_ROOT env var (escape hatch)
#   3. $HOME/Documents/Claude/Projects/Workroom (default)
#
# Intentionally NOT using `set -eu` — if this script fails, the MCP goes silent.
# We'd rather start with a sensible default than crash.

DATA_DIR="${CLAUDE_PLUGIN_DATA:-$HOME/.workroom}"
CONFIG_FILE="$DATA_DIR/config.json"
DEFAULT_ROOT="$HOME/Documents/Claude/Projects/Workroom"

RESOLVED_ROOT=""

# 1. Try config.json written by the onboarding skill.
if [ -f "$CONFIG_FILE" ]; then
  if command -v jq >/dev/null 2>&1; then
    RESOLVED_ROOT=$(jq -r '.workroomRoot // empty' "$CONFIG_FILE" 2>/dev/null)
  else
    RESOLVED_ROOT=$(sed -n 's/.*"workroomRoot"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$CONFIG_FILE" 2>/dev/null | head -1)
  fi
fi

# 2. Env var escape hatch.
if [ -z "$RESOLVED_ROOT" ] && [ -n "${WORKROOM_ROOT:-}" ]; then
  RESOLVED_ROOT="$WORKROOM_ROOT"
fi

# 3. Default.
if [ -z "$RESOLVED_ROOT" ]; then
  RESOLVED_ROOT="$DEFAULT_ROOT"
fi

# Best-effort: create the directory so the filesystem server has something to serve.
mkdir -p "$RESOLVED_ROOT" 2>/dev/null || true

# Log what we resolved (stderr only, won't pollute the MCP protocol on stdout).
echo "[workroom-fs] serving $RESOLVED_ROOT" >&2

exec npx -y @modelcontextprotocol/server-filesystem "$RESOLVED_ROOT"

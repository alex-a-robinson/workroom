#!/usr/bin/env bash
#
# Tails a signal file and echoes every new line, prefixed so Claude sees it
# as a distinct event type. Demonstrates the pattern a real artefact→chat
# bridge would use: some MCP (or the user, for testing) appends a line to
# the signal file; the monitor sees it and notifies Claude.
#
# To test by hand without writing any code:
#   echo "hello from the artefact" >> "$CLAUDE_PLUGIN_ROOT/signals/signal.log"
# (You'll need to resolve $CLAUDE_PLUGIN_ROOT to the real installed path.)
#
# The production shape would be: a Workroom-custom mailbox MCP exposes a
# `write(msg)` tool to the artefact; the MCP appends to a file the monitor
# watches. The artefact calls mailbox.write → file grows → monitor emits →
# Claude gets a chat notification and reacts.

set -euo pipefail

SIGNAL_FILE="${CLAUDE_PLUGIN_ROOT}/signals/signal.log"

# Make sure the file exists so `tail -F` doesn't error on a missing path.
mkdir -p "$(dirname "$SIGNAL_FILE")"
touch "$SIGNAL_FILE"

# -F (capital) follows the file across rotation / recreation.
# -n 0 so we don't emit backfill on plugin start.
tail -F -n 0 "$SIGNAL_FILE" | while IFS= read -r line; do
  echo "WORKROOM-SIGNAL ${line}"
done

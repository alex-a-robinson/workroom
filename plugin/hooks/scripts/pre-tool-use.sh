#!/usr/bin/env bash
# PreToolUse hook — placeholder.
#
# Real behaviour (not yet wired):
#  - Inspect the tool call metadata passed on stdin.
#  - For tool calls that send external email, create calendar events for third
#    parties, delete files, or push to git: invoke the Pip safety layer to
#    prompt the user with a "this is about to happen — confirm?" nudge.
#  - Non-destructive tools pass through silently.

log_path="${HOME}/.workroom/hook.log"
mkdir -p "$(dirname "$log_path")"
# Drain stdin so Cowork doesn't block on a broken pipe.
input="$(cat)"
echo "[$(date -u +%FT%TZ)] workroom:pre-tool-use fired — input len: ${#input}" >> "$log_path"
exit 0

#!/usr/bin/env bash
#
# Emits a heartbeat line every 60s. The purpose of this monitor is to answer
# ONE question: does a monitor's stdout actually arrive at Claude as a
# chat notification that Claude can see and the user can see?
#
# If yes, we can build the bridge pattern (mailbox MCP + signal-watch) on top.
# If no, monitors are not useful for what we want and we move on.
#
# Cadence is deliberately slow (60s) so the chat doesn't drown in pings
# during the test session. Shorten to 10s if you want to watch it tick in
# real time.

set -euo pipefail

while true; do
  echo "WORKROOM-HEARTBEAT $(date -u +%FT%TZ) — monitor-test plugin is alive"
  sleep 60
done

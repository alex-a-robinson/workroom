#!/usr/bin/env bash
# SessionStart hook — placeholder.
#
# Real behaviour (not yet wired):
#  - If workspace is a git repo, `git fetch` and surface a nudge if the remote
#    has moved since last check.
#  - Detect Workroom onboarding state (has the user scaffolded templates yet?).
#  - Warm Pip's memory from workroom-pip if loaded.

log_path="${HOME}/.workroom/hook.log"
mkdir -p "$(dirname "$log_path")"
echo "[$(date -u +%FT%TZ)] workroom:session-start fired — would check git + onboarding" >> "$log_path"
exit 0

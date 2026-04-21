#!/usr/bin/env bash
# Push current HEAD to origin. Intended for use by the sandboxed Claude in Cowork
# so it can ship commits without any manual token juggling — the credential
# helper wired via `git config credential.helper` picks up the token from
# ../../../.secrets/git-credentials automatically.
set -euo pipefail

cd "$(dirname "$0")/.."

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "error: not inside a git repo ($(pwd))" >&2
  exit 1
fi

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = "HEAD" ]; then
  echo "error: detached HEAD — check out a branch before pushing" >&2
  exit 1
fi

echo "pushing $branch to origin..."
if ! git push origin HEAD; then
  echo "error: git push failed. check:" >&2
  echo "  - credential helper: $(git config --get credential.helper || echo '<unset>')" >&2
  echo "  - remote url:        $(git remote get-url origin 2>/dev/null || echo '<unset>')" >&2
  echo "  - token file exists: $(test -r /Users/alex/Documents/Claude/Projects/Workroom/.secrets/git-credentials && echo yes || echo NO)" >&2
  exit 1
fi

echo "done."

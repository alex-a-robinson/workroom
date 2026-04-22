# Publishing — quick reference

Short cheatsheet for shipping an update. For the full story (why the pipeline looks this way, what Cowork actually checks), see `README.md → Versioning + updates`.

## TL;DR

```bash
# Drop changes under [Unreleased] in CHANGELOG.md as you work.
# When ready to cut:
scripts/release.sh minor          # or patch / major / 0.4.0
```

That's it. The script validates, bumps the version in `marketplace.json`, rotates the CHANGELOG, commits, tags, pushes branch + tag. GitHub Actions picks up the tag and creates a GitHub Release.

## Command reference

| Command | What it does |
|---|---|
| `scripts/validate-manifest.sh` | Dry-run sanity: JSON valid, required fields present, no version in plugin.json, source path resolves, CHANGELOG ok. Safe to run any time. |
| `scripts/bump-version.sh <v>` | Bump marketplace.json plugins[0].version, rotate CHANGELOG, commit, tag. **Does not push.** |
| `scripts/push.sh` | Push current branch + all tags to origin. |
| `scripts/release.sh <v>` | validate → bump → push. The usual one. |

`<v>` is either an explicit semver string (`0.4.0`) or one of `major` / `minor` / `patch`.

## What Cowork actually sees

- Update detection is **commit-SHA-based**. A push to `main` IS a publish, whether or not you bumped the version.
- The `version` field drives what users see in the marketplace UI and in the `workroom-info` skill, but the SHA is what triggers "update available".
- For our relative-path plugin source, version lives in **exactly one place**: `.claude-plugin/marketplace.json → plugins[0].version`. `plugin/.claude-plugin/plugin.json` has no version field — if someone adds one, `validate-manifest.sh` fails because a version in plugin.json silently shadows the marketplace value (per Anthropic's docs).

## What users have to do to pick up an update

1. `/plugin marketplace update` — refreshes the marketplace metadata cache from GitHub.
2. `/plugin` — brings up the plugin UI; install/update the `workroom` plugin.

Inside a session, `workroom-info` shows the currently-loaded version + commit SHA.

## Rules the tooling enforces

- **Version in one place only.** `validate-manifest.sh` fails if `plugin.json` contains a `version` field. For relative-path sources, version lives only in `marketplace.json`.
- **Semver only.** The version must be `MAJOR.MINOR.PATCH`.
- **CHANGELOG must be real.** `bump-version.sh` refuses to cut a release if the `[Unreleased]` section is empty.
- **No tag clobbering.** `bump-version.sh` refuses if `vX.Y.Z` already exists.
- **No unstaged drift.** `bump-version.sh` refuses if `marketplace.json` or `CHANGELOG.md` have unstaged edits — commit or stash first so the release commit is clean.

## CI

- `.github/workflows/validate.yml` — every push + PR, runs `validate-manifest.sh`.
- `.github/workflows/release.yml` — on `v*.*.*` tag push, runs validate + creates a GitHub Release with the CHANGELOG section as the body.

## If something goes wrong

- **Wrong version tagged.** Delete the tag locally (`git tag -d vX.Y.Z`) and on the remote (`git push origin :refs/tags/vX.Y.Z`), then re-run `scripts/release.sh`.
- **`jq` missing locally.** `brew install jq`. CI installs it automatically.

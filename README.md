# workroom

Single-plugin Cowork marketplace. The master Workroom plugin — the thing a new user installs to get the onboarding artefact, the knowledge-base file viewer, the Pip framework, a starter workspace scaffold, and placeholder hooks ready to be wired up.

This repo is the successor to `workroom-monitor-test` (v0.2.x), which was a probe to validate whether Cowork's plugin monitors delivered stdout to chat. They don't (confirmed 2026-04-21). The probe is retired; this plugin reuses the repo identity and git history but ships a different product.

## What's inside

```
workroom/
├── README.md                              — this file
├── CHANGELOG.md                           — version history
├── CLEANUP.sh                             — one-shot: remove legacy monitor files. Run once before first push of v0.3.x.
├── .claude-plugin/marketplace.json        — one-plugin marketplace
└── plugin/
    ├── .claude-plugin/plugin.json         — identity + version
    ├── README.md
    ├── skills/
    │   ├── workroom-onboarding/           — spawns the onboarding artefact + scaffolds a workspace
    │   ├── workroom-file-viewer/          — spawns the knowledge-base file viewer
    │   ├── workroom-pip/                  — loads the Pip framework as behaviour
    │   ├── workroom-info/                 — prints version, changelog, what's loaded
    │   └── workroom-help/                 — what this plugin can do, for new users
    ├── artefacts/                         — HTML files the skills ship as artefacts
    │   ├── onboarding.html                — guided onboarding + learning path + flows (from preview v2)
    │   └── file-viewer.html               — Obsidian-style markdown knowledge-base browser
    ├── templates/                         — starter workspace the onboarding skill copies into the user's picked folder
    │   ├── CLAUDE.md
    │   ├── README.md
    │   ├── overview.md
    │   ├── mvp.md
    │   ├── log.md
    │   ├── open-questions.md
    │   └── concepts/ ideas/ technical/    — empty category folders with .gitkeep
    └── hooks/
        ├── hooks.json                     — SessionStart + PreToolUse stubs (log-and-noop)
        └── scripts/                       — the stub shell scripts
```

Artefacts are not a first-class plugin asset — Anthropic's schema has no `artefacts/` directory. Each skill reads its HTML file from `artefacts/` and passes it to `mcp__cowork__create_artifact` at invocation time. See `technical/plugin-schema-deep-dive.md` in the Workroom repo for context.

Templates are a plugin-shipped starter scaffold. The onboarding skill copies them into the user's chosen workspace folder — the plugin does not auto-install them.

Hooks are placeholders. They log a line and exit 0. The manifest wiring is real; the behaviour is not. Replace the stubs when the git-sync and Pip-safety logic lands.

## Install (as marketplace)

In Cowork: Customize → Personal plugins → `+` → Create plugin → **Add marketplace** → paste `alex-a-robinson/workroom` (or full GitHub URL).

Once the marketplace appears, install the `workroom` plugin from it. Start a fresh chat to activate hooks and skills.

## First run

In a fresh chat, ask Claude to run the `workroom-help` skill. That prints what's inside and suggests the next step — usually invoke `workroom-onboarding` to spawn the onboarding artefact and scaffold your workspace.

## Versioning + updates

Cowork auto-update is **commit-SHA-based**: every push to `main` is a publish. A tagged release is optional polish — it adds a human-readable permalink + changelog page, but is not required for users to see the update.

The `version` field lives in exactly one place: `.claude-plugin/marketplace.json → plugins[0].version`. `plugin/.claude-plugin/plugin.json` has **no** version field — for relative-path plugin sources (`"source": "./plugin"`), Anthropic's docs warn that a plugin-manifest version silently shadows the marketplace value, so we omit it and let `validate-manifest.sh` fail the build if it ever reappears.

To cut a release, drop entries under `## [Unreleased]` in `CHANGELOG.md` as you work, then:

```bash
scripts/release.sh patch   # or minor / major / 0.5.0
```

That validates, bumps `marketplace.json`, rotates the CHANGELOG to a new dated release block, commits, tags `vX.Y.Z`, and pushes branch + tag. A tag push triggers `.github/workflows/release.yml`, which creates a GitHub Release with the CHANGELOG section as the body. See [`PUBLISHING.md`](./PUBLISHING.md) for the full command reference.

Users pick up updates via `/plugin marketplace update` followed by `/plugin` to install/update. Inside a session, the `workroom-info` skill shows the loaded version + commit SHA as a safety net, because plugin updates can silently change MCPs and hooks.

## Provenance

Forked-in-place from `workroom-monitor-test v0.2.0`. Monitor probe retired — see `CHANGELOG.md`. Original probe code lives in the git history.

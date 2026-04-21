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

Version lives in `plugin/.claude-plugin/plugin.json` and the marketplace entry. Both must stay in sync. Every release bumps:

1. `plugin/.claude-plugin/plugin.json → version`
2. `.claude-plugin/marketplace.json → plugins[0].version`
3. `CHANGELOG.md` — what changed, when, who / why

Cowork refreshes marketplace metadata on a cadence and shows users a notification to run `/reload-plugins` when a new version is ready. Orphaned cached versions are cleaned after 7 days. Trust is identity-based — updates can change MCPs and hooks silently, so the `workroom-info` skill surfaces what's currently loaded as a safety net.

## Provenance

Forked-in-place from `workroom-monitor-test v0.2.0`. Monitor probe retired — see `CHANGELOG.md`. Original probe code lives in the git history.

---
name: workroom-help
description: Greet new users and show what Workroom can do. Triggers on "what can Workroom do", "Workroom help", "getting started with Workroom", "what skills does Workroom have", "first time using Workroom", "workroom overview"
---

# Welcome to Workroom

Workroom is an activation plugin for Claude. It ships guided onboarding, a live knowledge-base dashboard backed by a bundled filesystem MCP, education + admin surfaces, the Pip coaching framework, curated starter routines, and a workspace scaffold that gets out of your way.

## What you can do right now

- **workroom-onboarding** — Three-step guided setup. Infers your role from memory + connected tools, suggests the connectors you're missing, and helps you pick a first routine.
- **workroom-file-viewer** — Open the Workroom dashboard: an Obsidian-style markdown browser backed by the `workroom-fs` MCP. Actually reads your real files.
- **workroom-education** — Shows your learning path — in-progress routine, what's next, and the upcoming queue.
- **workroom-admin** — Team-overview with invite-code CTA. Placeholder data until the invite backend ships.
- **workroom-pip** — Load the Pip coaching framework as in-session behaviour (coaching + teaching + pushback modes).
- **workroom-invite** — Generate a teammate invite code. Placeholder for now; real distribution lands later.
- **workroom-info** — Version, recent changelog, what skills / hooks / MCPs are loaded in this session.
- **workroom-help** — This guide.

## Start here

Run **workroom-onboarding**. It will pick your workspace directory (for the filesystem MCP), suggest essential connectors for your role, and put you on a first routine.

**v0.4.0 notes:** The dashboard is real, the onboarding is real, the MCP is real. Admin is a placeholder and hooks are still log-and-noop. See `workroom-info` for full changelog.

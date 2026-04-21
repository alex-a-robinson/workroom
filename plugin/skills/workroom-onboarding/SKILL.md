---
name: workroom-onboarding
description: Onboard a new user to Workroom. Set up your Workroom, choose your role and tools, start your learning path, and scaffold a workspace directory structure.
---

# Workroom Onboarding

Read the HTML artefact from `${CLAUDE_PLUGIN_ROOT}/artefacts/onboarding.html`, then spawn it as a Cowork artefact titled "Workroom — Onboarding".

After the artefact renders, ask the user whether they'd like you to scaffold a starter Workroom directory structure in a folder of their choice. Explain: a CLAUDE.md with conventions, blank overview.md / mvp.md / log.md / open-questions.md, and empty concepts/ ideas/ technical/ folders.

If yes:
- Ask for the target directory path.
- Copy the template files and folders from `${CLAUDE_PLUGIN_ROOT}/templates/` into that path.
- Confirm when done.

If no or unsure, leave the artefact open and offer to scaffold later.

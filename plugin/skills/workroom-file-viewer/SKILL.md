---
name: workroom-file-viewer
description: Open the Workroom dashboard — a live markdown browser over your knowledge base, backed by the workroom-fs MCP.
---

# Workroom File Viewer

Check that the user has set up their workspace via the `workroom-onboarding` skill. If not, direct them to run onboarding first and do not open the artefact.

If they have set up their workspace, call `mcp__cowork__create_artifact` with the HTML from `${CLAUDE_PLUGIN_ROOT}/artefacts/dashboard.html`, title "Workroom Dashboard".

The dashboard loads your file tree from the workroom-fs MCP and renders markdown files live in the browser. If the MCP is not available, it shows a fallback empty state with setup instructions.

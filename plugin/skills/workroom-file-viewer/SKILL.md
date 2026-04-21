---
name: workroom-file-viewer
description: Browse your knowledge base. View folders, click to read markdown files. Obsidian-style Workroom markdown browser. Open file viewer, show me the Workroom files, browse my notes.
---

# Workroom File Viewer

Ask the user which directory they want to browse. Default: the current working directory or the Workroom folder they set up.

Read the HTML from `${CLAUDE_PLUGIN_ROOT}/artefacts/file-viewer.html`.

Find the placeholder token `__DEFAULT_WORKSPACE__` in the HTML (it's in the input field's `value=` attribute) and replace it with the user's chosen directory path (string literal, quoted in the HTML).

Call `mcp__cowork__create_artifact` with the modified HTML, title "Knowledge base".

Tell the user: "If the filesystem MCP isn't connected, the viewer's JSON fallback will work. Ask me to list a folder or read a file and I'll give you JSON to paste in."

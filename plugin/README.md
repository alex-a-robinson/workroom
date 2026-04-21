# workroom (plugin)

The plugin itself. Sits inside a one-plugin marketplace at the repo root.

For the full picture — install flow, versioning conventions, what's loaded — see the top-level `README.md`.

## Workspace directory

The plugin talks to a single user-picked root directory — your Workroom knowledge base. During onboarding, you'll be prompted to choose a directory (or create one from the provided scaffold).

To update the root directory later, run:

```bash
${CLAUDE_PLUGIN_ROOT}/mcp/set-workroom-root.sh /path/to/your/workroom
```

This path is read at server launch time by the bundled filesystem MCP. If the file-viewer artefact shows errors or an empty tree, check that the path exists and is correct.

For debugging, see `mcp/README.md`.

## Skills

| Skill | Purpose |
|---|---|
| `workroom:workroom-help` | First-time orientation. What this plugin offers and what to invoke next. |
| `workroom:workroom-onboarding` | Spawn the onboarding artefact. Offer to scaffold a Workroom-style workspace. |
| `workroom:workroom-file-viewer` | Spawn the knowledge-base file viewer (Obsidian-style). |
| `workroom:workroom-pip` | Load the Pip framework as session behaviour (coaching + teaching + pushback). |
| `workroom:workroom-info` | Print version, recent changelog, what's loaded in the current session. |

## Artefacts

HTML templates shipped with the plugin. Each skill reads its own file and passes it to `mcp__cowork__create_artifact` at invocation time. Plugins don't have a first-class artefact slot in the manifest — this is the pattern that works.

- `artefacts/onboarding.html` — the preview-v2 artefact ported here.
- `artefacts/file-viewer.html` — new knowledge-base browser.

## Templates

`templates/` is a starter scaffold the onboarding skill copies into the user's chosen workspace. It's the Workroom-repo shape, minus any actual content — blank docs, empty category folders, a CLAUDE.md with the conventions we've converged on.

## Hooks

`hooks/hooks.json` wires two events:

- `SessionStart` — runs once per chat open. Logs a line noting what it *would* do (git-fetch-and-nudge on any workspace repo; detect onboarding state). No side effects.
- `PreToolUse` — runs before every tool call. Logs a line noting what it *would* do (Pip safety check on destructive tool calls). No side effects.

Both stubs just `echo` and exit. Replace with real logic when the underlying features are ready. Manifest wiring is correct so the swap is a one-file change.

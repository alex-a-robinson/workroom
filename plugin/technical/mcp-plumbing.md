# MCP Plumbing for Workroom Knowledge-Base Viewer

**Scope:** How a Cowork plugin artefact calls the filesystem MCP to list and read Workroom directory files.

**Status:** Technical spec, ready for implementation. Based on research into plugin `.mcp.json` schema, filesystem MCP server capabilities, and confirmed Cowork artefact API (verified 2026-04-21).

---

## Architecture Overview

The artefact (running sandboxed in the browser) needs real filesystem access. Cowork artefacts cannot fetch from arbitrary URLs or directly access the filesystem. They *can* call MCP tools via `window.cowork.callMcpTool()`.

**Solution:** Bundle the official `@modelcontextprotocol/server-filesystem` MCP server in the plugin, declare it in `.mcp.json` with a scoped root, and invoke it from the artefact.

```
┌─────────────────────────────────────┐
│  Cowork Artefact (browser sandbox)  │
│  - HTML + vanilla JS                │
│  - calls MCP tools                  │
└──────────┬──────────────────────────┘
           │ window.cowork.callMcpTool()
           ↓
┌──────────────────────────────────────┐
│  Workroom Plugin MCP: filesystem     │
│  - @modelcontextprotocol/server-fs   │
│  - scoped to ${WORKROOM_ROOT}        │
│  - spawned on plugin init            │
└──────────────────────────────────────┘
```

---

## `.mcp.json` Declaration

Place `.mcp.json` at the plugin root (`/Users/alex/Documents/Claude/Projects/Workroom/build/prototypes/workroom/plugin/.mcp.json`).

### Structure

```json
{
  "mcpServers": {
    "workroom-fs": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "${WORKROOM_ROOT}"
      ],
      "env": {
        "WORKROOM_ROOT": "${CLAUDE_PLUGIN_DATA}/workroom-root"
      }
    }
  }
}
```

### Field Meanings

| Field | Value | Notes |
|-------|-------|-------|
| `mcpServers` | object | Top-level key for all bundled MCPs. |
| `"workroom-fs"` | object key | **Server name** used in tool invocations (see below). Must be a valid identifier; will become part of `mcp__workroom-fs__<tool>`. |
| `"command"` | `"npx"` | Launch via npx (fetches `@modelcontextprotocol/server-filesystem` from npm on first run). |
| `"args"` | array | First element is package name; subsequent elements are positional arguments to the server. The filesystem MCP server takes allowed directories as arguments. |
| `"${WORKROOM_ROOT}"` | substitution | Cowork substitutes this with the value from `env.WORKROOM_ROOT`. This is the **single allowed directory** the filesystem MCP can access. |
| `"env"` | object | Environment variables set when the command launches. |
| `"${CLAUDE_PLUGIN_DATA}"` | substitution | Cowork-provided path to persistent plugin data (survives plugin updates). Equivalent to `~/.claude/plugins/data/<plugin-id>/` or similar. |

### How the Scoped Root Works

1. On plugin load, Cowork reads `.mcp.json`.
2. It spawns the filesystem server with args `["${WORKROOM_ROOT}"]`, which becomes `/Users/alex/.claude/plugins/data/<plugin-id>/workroom-root` (the actual path).
3. The server's `list_allowed_directories` tool will report that single root.
4. All `read_text_file`, `list_directory`, etc. calls are restricted to that root and its children.

---

## Setting the Root at Install / First Run

The `${WORKROOM_ROOT}` directory must be created and pointed to the user's actual Workroom knowledge base. Three options:

### Option A: Skill-Driven Onboarding (Recommended)

1. The plugin bundles a skill `workroom:workroom-setup` (or reuses an existing onboarding skill).
2. On first install, the skill prompts: "Where is your Workroom directory?" (defaults to `~/Documents/Claude/Projects/Workroom` or user's chosen location).
3. The skill writes the chosen path to a config file in `${CLAUDE_PLUGIN_DATA}/workroom-config.json`:
   ```json
   { "workroomRoot": "/Users/alex/Documents/Claude/Projects/Workroom" }
   ```
4. **Caveat:** The `.mcp.json` substitution cannot read this config file at launch time (it only knows `${WORKROOM_ROOT}` env var, not arbitrary JSON). So the skill must also:
   - Call a Cowork API to write the env var to the plugin's persistent config.
   - Or store it in a way the shell can read (e.g. a `.env` file sourced by a wrapper script).

### Option B: Environment Variable at Plugin Installation

The user or their workspace admin sets an env var `WORKROOM_ROOT` before installing the plugin. Cowork might support plugin-level env vars (not yet confirmed), but if so:

```json
{
  "env": {
    "WORKROOM_ROOT": "${WORKROOM_ROOT}"  // pass through from system/Cowork config
  }
}
```

**Status:** Not yet validated. Likely requires Cowork to expose an API for plugin-level env config.

### Option C: Hardcoded Path (Dev Only)

For testing:
```json
{
  "env": {
    "WORKROOM_ROOT": "/Users/alex/Documents/Claude/Projects/Workroom"
  }
}
```

Never ship this way; paths are machine-specific.

---

## Artefact Invocation: Tool Names and Calling Pattern

### The Server Name in Cowork

When the plugin loads, Cowork wires the `workroom-fs` MCP into the session. Tools from that server appear as:

```
mcp__workroom-fs__<tool-name>
```

### Filesystem MCP Tools Available

The `@modelcontextprotocol/server-filesystem` exposes:

| Tool | Input | Notes |
|------|-------|-------|
| `read_text_file` | `path` (string) | Read file as UTF-8 text. |
| `list_directory` | `path` (string) | List contents of a directory. |
| `directory_tree` | `path` (string), `excludePatterns` (array, optional) | Recursive JSON tree of directory structure. |
| `search_files` | `path`, `pattern` (string), `excludePatterns` (array, optional) | Glob-style search. |
| `get_file_info` | `path` (string) | Metadata: size, mtime, type, perms. |
| `list_allowed_directories` | (no args) | Returns the scoped root(s). |

### Calling from the Artefact

The artefact JavaScript (inside the HTML) calls:

```javascript
const res = await window.cowork.callMcpTool('mcp__workroom-fs__<tool>', args);
// Returns { content, structuredContent, isError }
```

#### Example: List the root directory

```javascript
const res = await window.cowork.callMcpTool('mcp__workroom-fs__list_directory', {
  path: '/'  // relative to the scoped root
});

if (res.isError) {
  console.error('Failed to list:', res.content);
} else {
  const listing = res.content?.[0]?.text;  // string of file listing
  console.log(listing);
}
```

#### Example: Read a markdown file

```javascript
const res = await window.cowork.callMcpTool('mcp__workroom-fs__read_text_file', {
  path: '/concepts/01-guided-onboarding.md'
});

if (!res.isError) {
  const markdown = res.content?.[0]?.text;
  // Render markdown into the artefact UI
}
```

#### Example: Get directory tree (best for the file viewer)

```javascript
const res = await window.cowork.callMcpTool('mcp__workroom-fs__directory_tree', {
  path: '/',
  excludePatterns: ['.git', 'node_modules', '__pycache__']
});

if (!res.isError) {
  const tree = res.structuredContent ?? JSON.parse(res.content?.[0]?.text);
  // tree is an array of { name, type, children? }
  // Render as a sidebar tree UI
}
```

---

## Response Shape (from Artefact API Spec)

All `window.cowork.callMcpTool()` calls return an object with:

```typescript
{
  content?: Array<{ type: string; text: string }>;
  structuredContent?: any;  // for tools that return structured data
  isError?: boolean;
}
```

**Parse pattern:**
```javascript
if (res.isError) {
  // handle error
} else if (res.structuredContent) {
  // structured response (rare, but directory_tree might use it)
  const data = res.structuredContent;
} else if (res.content?.[0]?.text) {
  // text response, often JSON for connectors
  const text = res.content[0].text;
  try {
    const parsed = JSON.parse(text);
  } catch {
    // plain text listing
  }
}
```

---

## Runtime Dependencies

### What Cowork Provides

- `${CLAUDE_PLUGIN_DATA}` — persistent directory where the plugin can store state.
- `${CLAUDE_PLUGIN_ROOT}` — the plugin's installation directory (read-only).
- `window.cowork.callMcpTool()` — the API for the artefact to invoke MCP tools.
- `npx` — available in the environment where the MCP server spawns.

### What Needs to Be Verified

1. **Does Cowork allow env var substitution in `.mcp.json`?** The `${WORKROOM_ROOT}` and `${CLAUDE_PLUGIN_DATA}` syntax is standard in Claude Code; needs confirmation it works in Cowork plugin context.
2. **Can the plugin write a config file at install time?** The skill-driven setup assumes we can persist the chosen root path. If plugin data directories are sandboxed differently in Cowork than in Claude Code, this may fail.
3. **Are `directory_tree` responses actually structured, or always returned as text?** The API doc says `structuredContent` *may* be undefined; the filesystem server may not set it. Assume text and parse JSON.

---

## Caveats and Fallback Plan

### If Directory Substitution Fails

If Cowork doesn't support `${WORKROOM_ROOT}` env var substitution, fall back to:
- **Option 1:** Ship a wrapper shell script (`plugin/mcp/wrapper.sh`) that reads the config file and launches the filesystem server.
  ```json
  {
    "command": "${CLAUDE_PLUGIN_ROOT}/mcp/wrapper.sh"
  }
  ```
- **Option 2:** Ask the user to set the env var in their system before opening Cowork (least user-friendly).

### If the Artefact Can't Call the Tool

Symptom: `mcp__workroom-fs__list_directory` returns a 400 error or "tool not found" even though the plugin is installed.

**Diagnosis:**
1. Check that the plugin is enabled in Cowork: Settings → Plugins → Workroom (should have a checkmark).
2. Restart Cowork completely (not just a new chat).
3. Try calling `mcp__workroom-fs__list_allowed_directories` (no args) to confirm the server is wired in.

**If still broken:**
- The server may not have spawned at plugin init. Check Cowork logs (`~/.claude/logs/cowork*`).
- The tool name format may differ. Try `workroom-fs_list_directory` (underscore instead of double-underscore). This is a known inconsistency in Cowork plugin tool naming.

---

## Next Steps for the Builder

1. **Create `.mcp.json`** with the configuration above (use Option A for the env var: write a config file in the onboarding skill).
2. **Test locally:**
   - Install the plugin in Cowork.
   - Create a test artefact with a simple `list_directory('/')` call.
   - Verify the listing appears.
3. **Validate** against the caveats above:
   - Env var substitution works.
   - Config file is readable by the skill.
   - Tool is callable from the artefact.
4. **Build the UI:** Once the MCP plumbing is confirmed, the artefact can use `directory_tree` to populate a sidebar tree and `read_text_file` to load content on click.

---

## References

- [Filesystem MCP Server (official)](https://github.com/modelcontextprotocol/servers/tree/main/src/filesystem) — source and docs.
- [Cowork artefact API (verified 2026-04-21)](file:///Users/alex/Documents/Claude/Projects/Workroom/technical/artefact-prototype-findings.md#L161) — `window.cowork.callMcpTool()` signature and response shape.
- [Claude Knowledge-Work-Plugins `.mcp.json` example](https://raw.githubusercontent.com/anthropics/knowledge-work-plugins/main/marketing/.mcp.json) — HTTP MCPs, different transport, but same structure.
- [Cowork plugin manifest spec](file:///Users/alex/Documents/Claude/Projects/Workroom/.claude-plugin/plugin.json) — plugin.json reference (workroom plugin itself).

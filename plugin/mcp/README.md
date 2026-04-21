# Workroom Filesystem MCP

The Workroom plugin bundles the official `@modelcontextprotocol/server-filesystem` MCP server, scoped to a single user-chosen directory. This allows Cowork artefacts (the file viewer, onboarding steps) to list and read files from your Workroom knowledge base.

## How It Works

1. **`.mcp.json` declaration** (at the plugin root) names the server `workroom-fs` and points to the wrapper script.
2. **`workroom-fs.sh` wrapper** reads the config file at server-launch time, extracts the path, validates it, and spawns the filesystem server with that root.
3. **`set-workroom-root.sh`** writes the config when the onboarding skill runs or when you explicitly update the root.

## Setting Your Workroom Root

During onboarding, the plugin skill will prompt you to choose a directory. Under the hood, it calls:

```bash
mcp/set-workroom-root.sh /your/chosen/path
```

This writes the path to `${CLAUDE_PLUGIN_DATA}/config.json` so the wrapper can find it on next launch.

To update the root later, run:

```bash
${CLAUDE_PLUGIN_ROOT}/mcp/set-workroom-root.sh /new/path
```

## Debugging

If the file viewer artefact shows an empty tree or "directory not found" error:

1. **Check the config file exists:**
   ```bash
   cat ${CLAUDE_PLUGIN_DATA}/config.json
   ```
   It should contain `{"workroomRoot":"/your/path"}`.

2. **Verify the path is correct:**
   ```bash
   ls -la /your/path
   ```

3. **Check server startup:** Cowork logs are at `~/.claude/logs/cowork*`. Look for errors from the wrapper script.

4. **Re-set the root:**
   ```bash
   mcp/set-workroom-root.sh /correct/path
   ```
   Then restart Cowork completely.

## Tool Names

When you call MCP tools from an artefact, use these names:

- `mcp__workroom-fs__read_text_file` — read a file as UTF-8 text
- `mcp__workroom-fs__list_directory` — list directory contents
- `mcp__workroom-fs__directory_tree` — recursive JSON tree of directory structure
- `mcp__workroom-fs__search_files` — glob-style search across files
- `mcp__workroom-fs__get_file_info` — file metadata (size, mtime, type, perms)
- `mcp__workroom-fs__list_allowed_directories` — confirm the scoped root

## Examples

From an artefact:

```javascript
// List the root directory
const res = await window.cowork.callMcpTool('mcp__workroom-fs__list_directory', {
  path: '/'
});

// Read a markdown file
const res = await window.cowork.callMcpTool('mcp__workroom-fs__read_text_file', {
  path: '/concepts/01-guided-onboarding.md'
});

// Get the full directory tree (best for a file sidebar)
const res = await window.cowork.callMcpTool('mcp__workroom-fs__directory_tree', {
  path: '/',
  excludePatterns: ['.git', 'node_modules', '__pycache__']
});
```

All tools return `{ content?, structuredContent?, isError? }`. Check `res.isError` first; if false, use `res.content?.[0]?.text` or `res.structuredContent` to read the result.

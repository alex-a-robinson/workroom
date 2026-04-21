#!/bin/bash
set -eu

# Optional manual test runner for the filesystem MCP.
# Sets up a fake plugin data directory, writes a config, and tests the wrapper.

TEST_DATA_DIR="/tmp/workroom-test-data"
TEST_WORKROOM_DIR="/tmp/test-workroom"
WRAPPER_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/workroom-fs.sh"

echo "=== Workroom Filesystem MCP Test ==="
echo

# Clean up any previous test state.
rm -rf "$TEST_DATA_DIR" "$TEST_WORKROOM_DIR"
mkdir -p "$TEST_DATA_DIR" "$TEST_WORKROOM_DIR"

# Create a minimal test Workroom structure.
mkdir -p "$TEST_WORKROOM_DIR/concepts" "$TEST_WORKROOM_DIR/ideas"
touch "$TEST_WORKROOM_DIR/README.md"
touch "$TEST_WORKROOM_DIR/concepts/01-test.md"
echo "# Test Concept" > "$TEST_WORKROOM_DIR/concepts/01-test.md"

echo "Test Workroom created at: $TEST_WORKROOM_DIR"
echo "Test plugin data dir: $TEST_DATA_DIR"
echo

# Write the config file.
printf '{"workroomRoot":"%s"}\n' "$TEST_WORKROOM_DIR" > "$TEST_DATA_DIR/config.json"
echo "Config written:"
cat "$TEST_DATA_DIR/config.json"
echo

# Test the wrapper by running it with a JSON-RPC tools/list request.
# The filesystem server responds to "tools/list" on stdin and outputs JSON-RPC.
echo "Starting wrapper (this will listen for JSON-RPC messages)..."
echo "Sending tools/list request..."
echo

export CLAUDE_PLUGIN_DATA="$TEST_DATA_DIR"

# Create a simple test request: JSON-RPC 2.0 "tools/list" to enumerate available tools.
TEST_REQUEST='{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'

# Run the wrapper with the test request piped in, capture output, and kill after 5 seconds.
{
  echo "$TEST_REQUEST"
  sleep 2
} | timeout 5 "$WRAPPER_SCRIPT" 2>&1 | head -50 || {
  EXIT_CODE=$?
  if [ $EXIT_CODE -eq 124 ]; then
    echo "(Server timed out as expected after 5 seconds — this is normal.)"
  else
    echo "Wrapper exited with code: $EXIT_CODE"
  fi
}

echo
echo "Test complete. Clean up with:"
echo "  rm -rf $TEST_DATA_DIR $TEST_WORKROOM_DIR"

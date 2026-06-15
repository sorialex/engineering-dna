#!/usr/bin/env bash

# Remind to update SESSION.md if it wasn't modified this session.
# Installed as a Claude Code Stop hook.

SESSION_FILE=".claude/SESSION.md"

if [ ! -f "$SESSION_FILE" ]; then
  exit 0
fi

# Check if SESSION.md was modified in the last hour (rough proxy for "this session")
if [[ "$OSTYPE" == "darwin"* ]]; then
  modified=$(stat -f %m "$SESSION_FILE")
else
  modified=$(stat -c %Y "$SESSION_FILE" 2>/dev/null || echo 0)
fi

now=$(date +%s)
age=$(( now - modified ))

# If not modified in the last hour, emit a reminder
if [ "$age" -gt 3600 ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Remember to update SESSION.md with your session state."
  echo "  What was done, what's next, current branch."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

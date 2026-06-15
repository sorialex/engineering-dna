# Hooks

Claude Code hooks execute shell commands in response to session lifecycle events. They run outside Claude's context — they can't block or modify Claude's behavior, but they can log, remind, and alert.

engineering-dna does not ship any active hooks. This directory exists as infrastructure for projects that need them.

---

## Hook Events

Claude Code supports hooks for several events:

| Event | Trigger |
|-------|---------|
| `Stop` | Session ends (user stops or Claude finishes) |
| `PreToolUse` | Before any tool call |
| `PostToolUse` | After any tool call |
| `Notification` | When Claude sends a notification |

---

## Writing Your Own Hooks

Hooks are plain shell scripts. Requirements:
- Must be executable (`chmod +x`)
- Exit 0 for success, non-zero to signal an error (logged but does not block Claude)
- Output to stdout is shown to the user; stderr is logged

The hook runs in the directory where Claude Code was launched.

Example — log all session endings with a timestamp:

```bash
#!/usr/bin/env bash
echo "[$(date -Iseconds)] Session ended in $(pwd)" >> ~/.claude/session-log.txt
```

---

## Installing a Hook

Add the hook to `~/.claude/settings.json` under the relevant event key:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/your-hook.sh"
          }
        ]
      }
    ]
  }
}
```

Place the script in `~/.claude/hooks/` and make it executable. Hooks in this repo's `hooks/` directory can be copied there and customized.

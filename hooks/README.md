# Hooks

Claude Code hooks execute shell commands in response to session lifecycle events. They run outside Claude's context — they can't block or modify Claude's behavior, but they can log, remind, and alert.

`install.sh` handles hook installation automatically. This document explains how it works and how to add your own.

---

## Installing the Session-End Hook

Add the following to `~/.claude/settings.json` under the `hooks` key:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/on-session-end.sh"
          }
        ]
      }
    ]
  }
}
```

`install.sh` performs this merge automatically if `jq` is available. If `jq` is not installed, it prints the JSON block above and asks you to add it manually.

---

## Hook Events

Claude Code supports hooks for several events:

| Event | Trigger |
|-------|---------|
| `Stop` | Session ends (user stops or Claude finishes) |
| `PreToolUse` | Before any tool call |
| `PostToolUse` | After any tool call |
| `Notification` | When Claude sends a notification |

For most governance use cases, `Stop` is sufficient.

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

## Included Hooks

**`on-session-end.sh`**
Checks whether `.claude/SESSION.md` was modified in the last hour. If not, emits a reminder to update session state before closing. Useful when you forget to update SESSION.md mid-task.

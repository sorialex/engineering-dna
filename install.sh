#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

if [ ! -t 1 ]; then
  RED='' GREEN='' YELLOW='' BOLD='' RESET=''
fi

DNA_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

log_ok()   { echo -e "${GREEN}[ok]${RESET}     $1"; }
log_done() { echo -e "${GREEN}[created]${RESET} $1"; }
log_skip() { echo -e "         ${RESET}$1 (already set up)"; }
log_warn() { echo -e "${YELLOW}[warn]${RESET}   $1"; }

echo -e "${BOLD}engineering-dna installer${RESET}"
echo "  Source: $DNA_HOME"
echo "  Target: $CLAUDE_DIR"
echo ""

# --- Preflight: Claude Code must be installed ---
if [ ! -d "$CLAUDE_DIR" ]; then
  echo -e "${RED}[error]${RESET} ~/.claude/ not found. Is Claude Code installed?"
  echo "  Install Claude Code first: https://claude.ai/code"
  exit 1
fi
log_ok "~/.claude/ exists"

# --- 1. Create ~/.claude/rules/ ---
if [ ! -d "$CLAUDE_DIR/rules" ]; then
  mkdir -p "$CLAUDE_DIR/rules"
  log_done "~/.claude/rules/"
else
  log_skip "~/.claude/rules/"
fi

# --- 2. Symlink ~/.claude/rules/engineering-dna → $DNA_HOME/rules ---
GLOBAL_LINK="$CLAUDE_DIR/rules/engineering-dna"
GLOBAL_TARGET="$DNA_HOME/rules"

if [ -L "$GLOBAL_LINK" ]; then
  current="$(readlink "$GLOBAL_LINK")"
  if [ "$current" = "$GLOBAL_TARGET" ]; then
    log_skip "~/.claude/rules/engineering-dna symlink"
  else
    ln -sfn "$GLOBAL_TARGET" "$GLOBAL_LINK"
    log_done "~/.claude/rules/engineering-dna → $GLOBAL_TARGET (updated)"
  fi
elif [ -e "$GLOBAL_LINK" ]; then
  log_warn "~/.claude/rules/engineering-dna exists but is not a symlink — skipping"
else
  ln -sfn "$GLOBAL_TARGET" "$GLOBAL_LINK"
  log_done "~/.claude/rules/engineering-dna → $GLOBAL_TARGET"
fi

# --- 3. Update ~/.claude/CLAUDE.md ---
GLOBAL_CLAUDE="$CLAUDE_DIR/CLAUDE.md"
MARKER="# engineering-dna"

if [ -f "$GLOBAL_CLAUDE" ] && grep -qF "$MARKER" "$GLOBAL_CLAUDE"; then
  log_skip "~/.claude/CLAUDE.md (engineering-dna block present)"
else
  cat >> "$GLOBAL_CLAUDE" << 'EOF'

# engineering-dna

Shared engineering rules are loaded from ~/.claude/rules/engineering-dna/.
These rules apply to all projects. Project-specific rules in .claude/rules/ take precedence.

Key rules active globally:
- ai-agent-behavior.md: no scope creep, no phantom context, minimal diff
- commit-conventions.md: conventional commits with mandatory scope
- session-tracking.md: update SESSION.md at end of each session
EOF
  log_done "~/.claude/CLAUDE.md (appended engineering-dna block)"
fi

# --- 4. Install hooks ---
HOOKS_DIR="$CLAUDE_DIR/hooks"
if [ ! -d "$HOOKS_DIR" ]; then
  mkdir -p "$HOOKS_DIR"
  log_done "~/.claude/hooks/"
fi

HOOK_DEST="$HOOKS_DIR/on-session-end.sh"
HOOK_SRC="$DNA_HOME/hooks/on-session-end.sh"
if [ -f "$HOOK_DEST" ]; then
  log_skip "~/.claude/hooks/on-session-end.sh"
else
  cp "$HOOK_SRC" "$HOOK_DEST"
  chmod +x "$HOOK_DEST"
  log_done "~/.claude/hooks/on-session-end.sh"
fi

# --- 5. Wire hook into settings.json ---
SETTINGS="$CLAUDE_DIR/settings.json"

HOOK_JSON='{
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
}'

if command -v jq &>/dev/null; then
  if [ -f "$SETTINGS" ]; then
    # Merge: add Stop hook if not already present
    if jq -e '.hooks.Stop' "$SETTINGS" &>/dev/null; then
      log_skip "~/.claude/settings.json Stop hook (already configured)"
    else
      tmp="$(mktemp)"
      jq '. * {"hooks": {"Stop": [{"matcher": "", "hooks": [{"type": "command", "command": "~/.claude/hooks/on-session-end.sh"}]}]}}' "$SETTINGS" > "$tmp"
      mv "$tmp" "$SETTINGS"
      log_done "~/.claude/settings.json (merged Stop hook)"
    fi
  else
    echo "$HOOK_JSON" > "$SETTINGS"
    log_done "~/.claude/settings.json"
  fi
else
  log_warn "jq not found — add Stop hook to ~/.claude/settings.json manually:"
  echo ""
  echo "$HOOK_JSON"
  echo ""
fi

# --- 6. Add bin/ to PATH hint ---
echo ""
echo -e "${BOLD}Setup complete.${RESET}"
echo ""
echo "Next steps:"
echo "  1. Add bin/ to your PATH so cc-init, cc-doctor, cc-status are available:"
echo "     export PATH=\"\$PATH:$DNA_HOME/bin\""
echo "     (add this to ~/.bashrc or ~/.zshrc)"
echo ""
echo "  2. Bootstrap a project:"
echo "     cd ~/projects/my-project && cc-init"
echo ""
echo "  3. Verify setup:"
echo "     cc-doctor"

# How It Works

## Architecture

engineering-dna has three layers, each mapping directly to Claude Code's native infrastructure.

### Layer 1: Base Image (`~/.claude/`)

Claude Code loads `~/.claude/CLAUDE.md` and all files in `~/.claude/rules/` for every session, regardless of which project you're in. This is the "always on" layer.

`install.sh` sets this up once:
- Creates `~/.claude/rules/engineering-dna` as a symlink to this repo's `rules/` directory
- Appends an import block to `~/.claude/CLAUDE.md` referencing the shared rules
- Installs the session-end hook

After install, every Claude Code session starts with engineering-dna rules already loaded. Zero per-project work.

### Layer 2: Scaffold (`cc-init`)

For projects that need the full setup — session tracking, local overrides, settings — run `cc-init` once at project root. It:

1. Creates `.claude/rules/shared/` as a symlink to `$CC_DNA_HOME/rules/`
2. Copies `templates/SESSION.md` to `.claude/SESSION.md` (if missing)
3. Copies `templates/CLAUDE.md` to `CLAUDE.md` (if missing, warns if present but incomplete)
4. Copies `templates/settings.local.json` to `.claude/settings.local.json` (if missing)
5. Updates `.gitignore` with required exclusions

`cc-init` is idempotent. Running it twice on the same project is safe.

### Layer 3: Healthcheck (`cc-doctor`)

Over time, projects drift. Someone deletes a symlink. Someone commits `SESSION.md`. Someone's override file grows stale. `cc-doctor` catches this:

```bash
cc-doctor              # Check current project
cc-doctor --all        # Check all projects in $CC_PROJECTS
```

Exit code 0 means all checks pass. Exit code 1 means something needs attention. Integrate into CI if you want hard enforcement.

---

## How Symlinks Propagate Updates

```
~/engineering-dna/rules/           ← the source of truth
        ↑
~/.claude/rules/engineering-dna    ← symlink (global layer)
        ↑
project/.claude/rules/shared/      ← symlink (per-project layer)
```

When you edit a rule in `~/engineering-dna/rules/`, both the global layer and every project layer see the change immediately. No syncing. No copying. No stale versions.

---

## Override Mechanism

Claude Code loads rules from `.claude/rules/` in alphabetical order. Files outside the `shared/` symlink take precedence because they load after (or instead of) the shared version, and Claude Code uses last-write-wins for conflicting directives.

To override a shared rule in a specific project:

```
project/.claude/rules/
├── shared/                        ← symlink to engineering-dna/rules/
│   ├── ai-agent-behavior.md
│   ├── testing-strategy.md
│   └── ...
└── testing-override.md            ← project-specific override
```

`testing-override.md` loads alongside (and can supersede) `shared/testing-strategy.md`. The override file stays with the project; the shared rule stays shared.

See `examples/override-example.md` for a concrete walkthrough.

---

## Contribute-Back Workflow

Rules start local, graduate to shared:

1. **Identify**: You write a rule in `.claude/rules/` for a specific project.
2. **Validate**: It proves useful across multiple sessions. Other projects would benefit.
3. **Promote**: Move the file to `~/engineering-dna/rules/`.
4. **Commit**: Push to the engineering-dna repo.
5. **Propagate**: Every project with the symlink picks it up automatically.
6. **Cleanup**: Delete the local copy (it's now in shared/).

See `examples/contribute-back.md` for the full workflow.

---

## Session Tracking

Each project has `.claude/SESSION.md` — a plain markdown file that tracks working state between sessions. It's gitignored (personal state, not project history).

The workflow:
- **Session start**: Claude reads `SESSION.md` to reconstruct context
- **Session end**: Claude updates `SESSION.md` with what was done, what's next
- **Cross-project**: `cc-status` reads all `SESSION.md` files and prints a summary

The session-end hook (`hooks/on-session-end.sh`) reminds you to update `SESSION.md` if it wasn't modified during the session.

---

## Hooks

Claude Code hooks execute shell commands in response to lifecycle events (session start, session end, pre-tool, etc.). They can't block Claude but they can log, remind, and alert.

engineering-dna ships one hook: `on-session-end.sh`. It checks whether `SESSION.md` was modified and emits a reminder if not.

Install by adding to `~/.claude/settings.json`:

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

`install.sh` handles this automatically if `jq` is available.

---

## Claude Code Memory Hierarchy

Claude Code loads context in this order (later = higher precedence):

1. `~/.claude/CLAUDE.md` — global rules
2. `~/.claude/rules/*.md` — global rules directory
3. `project/CLAUDE.md` — project rules
4. `project/.claude/rules/*.md` — project rules directory
5. `project/CLAUDE.local.md` — personal overrides (gitignored)

engineering-dna layers on top of this hierarchy without replacing it. Layer 1 (install.sh) populates levels 1-2. Layer 2 (cc-init) populates levels 3-4. Level 5 is always available for personal overrides that shouldn't be shared.

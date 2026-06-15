# Project: [NAME]

## Build & Test

```bash
# Install dependencies
# [your install command]

# Run tests
# [your test command]

# Start dev server / build
# [your run command]
```

## Architecture

[One-sentence description of what this project does and its main components.]

## Shared Rules

Shared engineering rules are loaded from `.claude/rules/shared/`. They cover agent behavior, testing strategy, commit conventions, documentation, session tracking, and code review standards.

Project-specific overrides live in `.claude/rules/` alongside (not inside) the `shared/` symlink.

For personal overrides that should not be committed, use `CLAUDE.local.md` (gitignored).

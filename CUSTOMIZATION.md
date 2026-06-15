# Customization Guide

This guide is for people who fork engineering-dna and adapt it to their own organization or workflow.

---

## What to Edit

### `rules/` — Edit freely

These are the files you should make your own. Every rule here reflects an opinion. Change the opinions:

- Disagree with the commit conventions? Edit `commit-conventions.md`.
- Have a different testing philosophy? Rewrite `testing-strategy.md`.
- Need stricter agent behavior rules? Add rules to `ai-agent-behavior.md`.

Rules files are plain markdown. Claude Code reads them as instructions. Keep them concise and actionable — under 50 lines each. Dense rules outperform verbose ones.

### `templates/` — Edit to match your defaults

`templates/CLAUDE.md` is what new projects start with. Add your project scaffold (architecture section, common commands, preferred patterns).

`templates/settings.local.json` is what gets copied to `.claude/settings.local.json`. Add permissions your projects commonly need.

### `install.sh` — Edit paths and hooks if needed

If your `~/.claude/` structure differs, or you want to install additional hooks, edit `install.sh`. It's well-commented and straightforward bash.

---

## What to Leave Alone

### `bin/` — The CLI tools

`cc-init`, `cc-doctor`, and `cc-status` implement the framework's mechanics. Unless you're adding new checks or changing the bootstrap logic, leave them as-is. They depend on the directory structure and naming conventions.

### Directory structure

The symlink layout (`shared/` inside `.claude/rules/`) is what the CLI tools expect. Don't rename it.

---

## Adding New Rules

1. Create a new file in `rules/`, e.g., `rules/security.md`.
2. Write rules in imperative, actionable form. One rule per bullet or short paragraph.
3. Run `cc-doctor --all` to verify no projects are broken by the addition.
4. Commit.

All projects with the symlink pick up the new rule automatically on their next session.

---

## Project-Specific Overrides

Never touch shared rules to fix a project-specific problem. Instead:

1. Create `.claude/rules/project-override.md` in the project.
2. Write the override rule there.
3. It loads alongside shared rules and takes precedence for conflicting directives.

The override stays with the project. Shared rules stay shared. When the project no longer needs the override, delete the file.

See `examples/override-example.md` for a complete example.

---

## Adding a New Check to cc-doctor

Open `bin/cc-doctor`. Each check follows this pattern:

```bash
check "Description of check" "command that returns 0 for pass"
```

Add your check in the `run_checks()` function. The `check` helper handles colored output and pass/fail tracking automatically.

---

## Integrating with Your Monitoring Stack

`cc-doctor` exits 0 on success, 1 on failure. That's enough for most CI integrations:

```yaml
# GitHub Actions
- name: Validate Claude Code setup
  run: cc-doctor
```

`cc-status --json` outputs machine-readable session state. Pipe it to whatever dashboard you use:

```bash
cc-status --json | your-ingest-command
```

---

## Managing Multiple Forks

If you maintain engineering-dna for multiple organizations, use branches:

- `main` — your personal defaults
- `org/acme` — ACME Corp's standards
- `org/personal-projects` — lighter rules for side projects

Each checkout can live at a different path, and `CC_DNA_HOME` lets projects point to the right one:

```bash
export CC_DNA_HOME=~/engineering-dna-acme
cc-init
```

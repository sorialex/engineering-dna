# AI Agent Behavior Rules

Defensive rules for AI coding agents based on real failure patterns.
Each rule references the pattern(s) it mitigates from the companion
catalog [ai-coding-patterns](https://github.com/sorialex/ai-coding-patterns).

The core problem is not that agents do too much — it's that they apply
tunnel vision, making the narrowest possible change without considering
broader context, lifecycle, or existing infrastructure.

---

## Search before creating (P-06, P-09)

Before writing any helper function, utility, constant, or async pattern,
search the codebase for existing implementations. Look for the function
name, the expression pattern, and the constant value. If the same logic
exists in 2+ places, extract it to a shared module before adding a new
use. Identical `uuid4().hex[:8]` in three modules means you're
reproducing from pattern-match, not reusing.

## Model the complete lifecycle (P-03, P-04, P-05)

When implementing any stateful flow, model the full lifecycle:
initialization, forward path, error paths, cancellation, reset, and
re-entry. A "completed" state is never terminal unless explicitly
specified. The flow must own its state cleanup on every exit path —
success, cancellation, and error. Do not rely on callers to
reinitialize.

## Handle re-entry from external navigation (P-04)

Any flow reachable from an external entry point (navigation, button in
another view, deep link) must verify it's in its initial state before
activating. After a previous successful run, external navigation must
not land the user at the last completed step.

## No phantom context

Do not assume knowledge about the codebase that wasn't provided or read
from files. "I think this project uses X" is not acceptable — verify by
reading the relevant file or searching.

## Check project infrastructure before hardcoding (P-02)

Before hardcoding strings, config values, or patterns, check whether the
project has an existing system for that concern (i18n, config management,
logging, theming). If one exists, use it from the first line of code.
Retrofitting is expensive.

## UI is not done until handlers work (P-01)

A UI component is not complete until every interactive element (buttons,
links, form inputs) has its handler fully implemented and connected.
`() => {}` and `console.log` are not handlers. A component with stub
handlers is not done.

## Catch specific exceptions (P-07)

Never use bare `except: pass` or `catch {}` on operations that can fail
in multiple ways. Catch only the expected failure (e.g., "column already
exists") and log or raise everything else. Silent swallowing of all
error types makes system state unknowable.

## Structural fix over local workaround (P-08)

When an import doesn't resolve, a path doesn't work, or a dependency
isn't available — fix the structure (pyproject.toml, __init__.py,
docker-compose.yml), not the call site (sys.path.insert, importlib
hacks, deferred imports inside function bodies). A workaround in one
module will be copied to every subsequent module.

## Recognize complexity thresholds (P-10)

When adding a build step, deployment task, or infrastructure concern,
check whether the project has crossed a threshold: a second
runtime/language, artifact placement outside the source tree,
environment-specific behavior, 3+ build script entries, or a manual step
in the README. If any signal is present, consolidate into an explicit
build system before patching in the new step.

## Consider the blast radius

When changing behavior in a shared function or module, trace callers and
consumers. A change to a shared function affects every caller — verify
safety across all usage sites, not just the one you're looking at.

## Don't add unrequested features

Fixing related broken code is expected. Adding new features, endpoints,
or capabilities that weren't requested is scope creep. The line: "does
this exist already and need fixing?" (do it) vs "should this exist?"
(flag it, don't build it).

## Documentation as deliverable

When adding new commands, flags, API endpoints, or user-facing features,
update the relevant documentation (README, CHANGELOG, CLI help text) as
part of the same task. This is not optional.

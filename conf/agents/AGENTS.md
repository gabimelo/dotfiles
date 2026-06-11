## Working Style

- Keep changes scoped to the user's request.
- Read the existing code before choosing an implementation.
- Prefer simple, idiomatic, maintainable code over clever abstractions.
- Do not revert changes you did not make.
- If a worktree is dirty, treat unrelated changes as user-owned.
- Do not leave breadcrumbs when deleting or moving code.
- Use comments sparingly; add them only when they clarify non-obvious logic.
- Fix problems at the source instead of layering workarounds on top.

## Tools

- Prefer `rg` for text search and `rg --files` for file discovery.
- Prefer structured parsers or AST-aware tools when they materially reduce risk.
- When a repo uses a task runner, follow the repo's existing build and test conventions.
- Use `git status` and `git diff` as read-only inspection tools unless explicitly asked to change git state.

## Testing

- Prefer real unit or end-to-end tests.
- Avoid mock-heavy tests unless the user explicitly asks for that tradeoff.
- Run the tests that cover the touched behavior.

## Handoff

- Summarize changed files and why they changed.
- List commands or tests that were run.
- Call out any remaining uncertainty or follow-up work.

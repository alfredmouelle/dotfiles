---
name: commit
description: >-
  Commit when the user explicitly asks for a commit.
---

# Commit

1. Stage. `git status --short`. Clean tree: stop. Nothing staged: `git add -A`. Already staged: keep it.
   **Done when:** `git diff --cached --name-only` lists the files, or you stopped on a clean tree.

2. Format. `pnpm check:write` if that script exists, else the project's formatter `--write`. Then `git add -u`.
   **Done when:** staged files match the formatter, or no formatter is configured.

3. Read `git diff --cached`. Assign every staged file a type and a scope. Note any breaking change.
   **Done when:** every staged file is accounted for, and you know whether this is one commit or a split.

4. Message: `<type>(<scope>): <description>`. Types: `feat` · `fix` · `refactor` · `perf` · `style` · `docs` · `test` · `chore`.
   - English, imperative present, no period, ~72 chars
   - Scope: lowercase, one concern (`auth`, `ui`, `api`, `db`)
   - Breaking: `!` on the type and footer `BREAKING CHANGE: <what broke>`
   - Two types or two scopes with separable hunks: split into those commits
   - Body only when the why is non-obvious
   - Footers: `BREAKING CHANGE` only

5. `git commit -m "<subject>" -m "<body if needed>"` (no confirmation). Print the message.
   **Done when:** those staged files are committed and the user has the message.

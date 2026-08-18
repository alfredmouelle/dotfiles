---
name: commit
description: >-
  Commit repository changes when the user explicitly asks for a commit.
---

# Commit

## 1. Fix the scope

Read the repository instructions and `git status --short`. A clean tree ends the
run. Existing staged changes define the commit scope; preserve unstaged changes.
When nothing is staged, stage the current worktree with `git add -A`. Record the
scoped paths from `git diff --cached --name-only`.

**Done when:** the index contains a non-empty, explicit set of paths and unrelated
unstaged work remains unstaged.

## 2. Audit the staged diff

Read `git diff --cached` in full. Account for every staged file and hunk. Remove
accidental generated files or unrelated changes from the index while leaving
their worktree contents intact. Stop and report any credential, private key, or
other likely secret instead of committing it.

**Done when:** every staged hunk belongs to the requested change and contains no
likely secret.

## 3. Format without widening scope

Follow the repository's documented formatter or package scripts. Prefer a
write-mode formatter targeted at the scoped paths, then re-stage only those
paths. When safe targeting is unavailable, run its non-mutating check and report
any failure. Re-read the staged diff after formatting.

**Done when:** the staged files pass the configured format check and the set of
staged paths has not widened.

## 4. Plan the commit set

Repository commit rules override this fallback. Otherwise use
`<type>(<scope>): <description>`:

- Types: `feat`, `fix`, `refactor`, `perf`, `style`, `docs`, `test`, `build`,
  `ci`, `chore`, `revert`.
- Write an English imperative description, no period, at most 72 characters for
  the whole subject.
- Use a lowercase, single-concern scope such as `auth`, `ui`, `api`, or `db`.
- Mark a breaking change with `!` and a `BREAKING CHANGE: <impact>` footer.
- Add a body only when the reason is not evident from the diff.
- Split independent concerns when they can be separated without ambiguous hunks.

**Done when:** every staged hunk belongs to exactly one planned commit and each
commit has its final subject, optional body, and optional breaking footer.

## 5. Commit and verify

Create each planned commit without another confirmation. Use one `-m` for the
subject and additional `-m` arguments only for content that exists. After each
commit, inspect `git show --stat --oneline HEAD`; after the last, inspect
`git status --short` and report every commit hash and subject.

**Done when:** every planned hunk is committed exactly once, the remaining
worktree state is understood, and the user has each hash and subject.

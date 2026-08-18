---
name: publish
description: Detect uncommitted or unapplied dotfiles changes, commit them, and push to remote on demand.
disable-model-invocation: true
---

# Publish

Detect, audit, commit, and push pending changes in this dotfiles repository.

## 1. Detect pending changes

Inspect the repository and chezmoi state:
1. Run `chezmoi status` to detect drifted files between `$HOME` and the repository.
2. Run `git status --short` to list uncommitted and untracked repository changes.
3. Run `git log @{u}..HEAD --oneline` (or `git status`) to check for unpushed commits.

When all three checks show zero changes, stop and report that the repository is clean and up to date.

**Done when:** the presence of pending changes is determined; clean status ends the run immediately.

## 2. Sync and audit staged diff

1. If local `$HOME` files were modified, re-add them to chezmoi with `chezmoi add <path>`.
2. Stage all intended changes with `git add -A` or specific paths.
3. Review the complete staged diff with `git diff --cached`.
4. Stop and report if any credential, secret, API key, or unintended file is present in the diff.

**Done when:** all intended changes are staged, unintended paths are unindexed, and the diff contains no secrets.

## 3. Commit

Commit the staged changes following the repository commit conventions (`commit` skill).

**Done when:** staged changes are committed to git and the working tree index is clean.

## 4. Push on demand

Determine push intent from the invocation prompt:
- If the prompt contains `-p`, `--push`, or explicitly requests pushing: run `git push origin HEAD`.
- Otherwise: report the commit summary and state that the branch is ready to push.

**Done when:** changes are pushed to remote if flagged (`-p` or `--push`), or unpushed status is clearly reported.

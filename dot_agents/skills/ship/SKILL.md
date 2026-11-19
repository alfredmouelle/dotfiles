---
name: ship
description: Ship the session's work as one PR, or merge it and clean up.
argument-hint: "[reviewer] | merge [all]"
disable-model-invocation: true
---

# Ship

Without `merge`, **open**: the session's work becomes one commit on a pushed branch with a PR awaiting review. With `merge`, **land**: the PR merges and its leftovers go; only `merge all` also removes a worktree and its local branch.

`<default>` is `origin`'s default branch (`git symbolic-ref refs/remotes/origin/HEAD`).

## Open

1. **One commit**: `git fetch origin`. The user's commits since the merge-base with `origin/<default>` and any uncommitted work become one commit, unless the user asked this session for several; other authors' commits stay. Squash with `git reset --soft <base>` when every commit is the user's; else fix them up into the first with a rebase whose todo list `GIT_SEQUENCE_EDITOR` rewrites, since interactive rebase is unavailable. Message in the `commit` skill's format. Done when the user's work since the base is one commit (or the split they asked for) and the tree is clean.
2. **Rebase and check**: rebase onto `origin/<default>` (conflicts through the `resolving-merge-conflicts` skill), then run the check commands the `pre-push` hook does not. Done when the branch sits on `origin/<default>` and the checks pass.
3. **PR**: with no PR open, file one with the `file-pr` skill. With one open, push with `--force-with-lease` and update its body when the work changed what it says. Request review from the reviewer in the arguments, else the one the repository's instructions name, else nobody. Done when the PR shows the pushed commit, its reviewer requested when one was named. Report its URL.

## Land

1. **Merge** with the `merge-pr` skill. Done when it completes.
2. **Clean up**: in a worktree, apply `~/.agents/skills/worktree-cleanup/SKILL.md`, passing `all` when the arguments carry it. Otherwise: switch to `<default>`, `git pull --ff-only`, `git branch -D <branch>`, `git fetch --prune`. Done when, outside a worktree or with `all`, the branch is gone from the local repository; the local `<default>` matches `origin`.

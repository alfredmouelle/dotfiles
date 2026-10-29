---
name: ship
description: Ship the session's work as one PR, or merge it and clean up.
argument-hint: "[reviewer] [wip] | merge [all]"
disable-model-invocation: true
---

# Ship

Without `merge`, **open**: the session's work becomes one commit on a pushed branch with a PR awaiting review. With `merge`, **land**: the PR merges and its leftovers go; only `merge all` also removes a worktree and its local branch.

The **forge** hosts `origin`: GitHub through `gh`, Gitea through `tea`, flags from their `--help`. `<default>` is `origin`'s default branch (`git symbolic-ref refs/remotes/origin/HEAD`).

## Open

1. **Branch**: `<type>/<slug>`, the work's Conventional Commit type and a few words of its subject. Create it from `<default>`; rename an agent-named branch (`ag/…`, `claude/…`) with `git branch -m` before its first push. A branch already on `origin` keeps its name. Done when `HEAD` is on a `<type>/<slug>` branch or a branch already on `origin`.
2. **One commit**: `git fetch origin`. The user's commits since the merge-base with `origin/<default>` and any uncommitted work become one commit, unless the user asked this session for several; other authors' commits stay. Squash with `git reset --soft <base>` when every commit is the user's; else fix them up into the first with a rebase whose todo list `GIT_SEQUENCE_EDITOR` rewrites, since interactive rebase is unavailable. Message in the `commit` skill's format. Done when the user's work since the base is one commit (or the split they asked for) and the tree is clean.
3. **Rebase and check**: rebase onto `origin/<default>` (conflicts through the `resolving-merge-conflicts` skill), then run the check commands the `pre-push` hook does not. Done when the branch sits on `origin/<default>` and the checks pass.
4. **Push and PR**: `git push -u origin <branch>`, with `--force-with-lease` when steps 2 or 3 rewrote a branch already on `origin`. With no PR open, create one written with the `pr` skill, a draft under `wip` (the forge's draft flag, else a `WIP:` title prefix); with one open, update its body when the work changed what it says. Request review from the reviewer in the arguments, else the one the repository's instructions name, else nobody. Done when the PR shows the pushed commit, its reviewer requested when one was named. Report its URL.

## Land

1. **Merge**: when the PR is behind `<default>` or conflicts, rebase as in Open step 3 and push with lease. Wait for its required checks, then merge with the method the repository allows (when several, the one `<default>`'s history shows). A failed check, a missing approval or any refusal stops the run with the forge's message. Done when the PR is merged.
2. **Close the issues** the PR or its commits close (`Closes #N`, `Fixes #N`, `Resolves #N`): for each still open, tick the description checkboxes this PR delivers (re-read the body just before editing), then close it. Done when every such issue is closed, its delivered checkboxes ticked.
3. **Clean up**: in a worktree, apply `~/.agents/skills/worktree-cleanup/SKILL.md`, passing `all` when the arguments carry it. Otherwise: switch to `<default>`, `git pull --ff-only`, `git branch -D <branch>`, `git push origin --delete <branch>` when it still exists, `git fetch --prune`. Done when the branch is gone from `origin` and, outside a worktree or with `all`, from the local repository; the local `<default>` matches `origin`.

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

1. **Merge**: when the PR is behind `<default>` or conflicts, rebase as in Open step 2 and push with `--force-with-lease`. Wait for its required checks with `~/.agents/skills/babysit-pr/scripts/pr-wait <pr> --until green`, run as the `babysit-pr` skill describes. Right before merging, `git fetch` and check the PR again: when it became BEHIND or DIRTY, or a base commit that landed after the last green run touches its files, rebase, push, and wait again. Merge with the method the repository allows (when several, the one `<default>`'s history shows). A failed check, a missing approval or any refusal stops the run with GitHub's message. Done when the PR is merged.
2. **Close the issues** the PR or its commits close (`Closes #N`, `Fixes #N`, `Resolves #N`): for each still open, tick the description checkboxes this PR delivers (re-read the body just before editing), then close it. Done when every such issue is closed, its delivered checkboxes ticked.
3. **Clean up**: in a worktree, apply `~/.agents/skills/worktree-cleanup/SKILL.md`, passing `all` when the arguments carry it. Otherwise: switch to `<default>`, `git pull --ff-only`, `git branch -D <branch>`, `git push origin --delete <branch>` when it still exists, `git fetch --prune`. Done when the branch is gone from `origin` and, outside a worktree or with `all`, from the local repository; the local `<default>` matches `origin`.

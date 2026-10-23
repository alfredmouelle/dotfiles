---
name: ship
description: Ship the session's work as one PR, or merge it and clean up.
argument-hint: "[reviewer] [wip] | merge [all]"
disable-model-invocation: true
---

# Ship

Two runs share this skill. Without `merge`, **open**: the session's work becomes one commit on a pushed branch with a PR awaiting review. With `merge`, **land**: the PR merges and everything it leaves behind goes, except a worktree and its local branch, which only `merge all` removes.

The **forge** is whatever hosts `origin` (`git remote get-url origin`): GitHub through `gh`, Gitea through `tea`, any other through its CLI. Take each command's flags from its `--help`. `<default>` is `origin`'s default branch (`git symbolic-ref refs/remotes/origin/HEAD`).

## Open

### 1. Branch

The branch is `<type>/<slug>`: `<type>` is the work's Conventional Commit type (`feat`, `fix`, `refactor`…), `<slug>` a few words of its subject. On `<default>`, create it; on an agent-named branch (`ag/…`, `claude/…`), rename it with `git branch -m` before its first push. A branch already on `origin` keeps its name.

**Done when:** `HEAD` is on a `<type>/<slug>` branch or on a branch already on `origin`.

### 2. One commit

`git fetch origin`, then list the user's commits since the merge-base with `origin/<default>`. The user's commits and any uncommitted work become one commit, unless the user asked in this session for separate ones; commits by other authors stay as they are. When every commit since the base is the user's, squash with `git reset --soft <base>`; otherwise fix the user's commits up into the first with a rebase. Write the message in the `commit` skill's format.

**Done when:** the user's work since the base is one commit (or the split the user asked for) and the tree is clean.

### 3. Rebase and check

Rebase onto `origin/<default>`, resolving conflicts with the `resolving-merge-conflicts` skill. Run the project's check commands (typecheck, lint, tests) that its `pre-push` hook does not already run.

**Done when:** the branch sits on `origin/<default>` and the checks pass.

### 4. Push and PR

Push with `git push -u origin <branch>`; when the branch was already on `origin` and steps 2 or 3 rewrote it, push with `--force-with-lease`.

With no PR open for the branch, create one: title and body written with the `pr` skill (the title defaulting to the commit subject), opened as a draft when the arguments say `wip` (the forge's draft flag, or a `WIP:` title prefix when it has none). With a PR already open, update its body when the work changed what it says.

Request the review from the reviewer in the arguments, else the one the repository's instructions name; with neither, the PR goes out without a reviewer.

**Done when:** the PR shows the pushed commit, with the reviewer requested when one was named. Report its URL.

## Land

### 1. Merge

Find the branch's PR and read its state. When it is behind `<default>` or conflicts, rebase as in Open step 3 and push with lease. Wait for its required checks to finish, then merge with the method the repository's settings allow (when several are allowed, the one `<default>`'s recent history shows). A failed check, a missing approval, or any refusal stops the run with the forge's message.

**Done when:** the PR state is merged.

### 2. Close the issues

The issues are those the PR or its commits name with a closing keyword (`Closes #N`, `Fixes #N`, `Resolves #N`). For each issue still open, tick the checkboxes of its description that this PR delivers (re-read the body just before editing it), then close it.

**Done when:** every referenced issue is closed, its delivered checkboxes ticked.

### 3. Clean up

Inside a worktree, read and apply `~/.agents/skills/worktree-cleanup/SKILL.md`, passing `all` only when the arguments carry it. Otherwise, from the main checkout: switch to `<default>`, `git pull --ff-only`, `git branch -D <branch>`, `git push origin --delete <branch>` when it still exists, `git fetch --prune`.

**Done when:** the branch is gone from `origin` and, outside a worktree or with `all`, from the local repository; the local `<default>` matches `origin`.

---
name: worktree-cleanup
description: Tear down a finished worktree's databases, running processes and remote branch; with `all`, the worktree and its local branch too.
disable-model-invocation: true
---

# Worktree cleanup

Undo what `~/.agents/docs/worktree.md` set up for a worktree, once the work has landed. The **footprint** is everything this worktree owns: its databases and their containers, the processes it runs, its untracked overrides, its branches.

## Arguments

`all` also removes the worktree and its local branch. Without it, the run skips step 7.

## 1. Map the footprint

Resolve the worktree path, its branch, and the main checkout (`git worktree list`). Read the branch's PR state from `origin`'s forge, with its CLI, else ask. Then list each footprint item with its evidence:

- **Databases**: every database named in the worktree's untracked overrides (`.env.local`, `.env.test.local`, any file marked `git update-index --skip-worktree`) that differs from the main checkout's own env files, plus any container created for one of them.
- **Processes**: every process whose working directory is inside the worktree (`lsof -d cwd`, filtered on its path): dev servers, bundlers, watchers, plus any preview server this session started. Shared tools such as emulators and simulators, and this session's own process, stay out.
- **Overrides**: the untracked files the setup layered on top of the copied config (`.env.local`, `.env.test.local`, launch entries). The copied config itself (`.env` and the like) stays with the worktree.
- **Branches**: the remote branch (`git ls-remote --heads origin <branch>`) and, with `all`, the local one.

An item counts only when its evidence ties it to this worktree. Shared items belong to the main checkout, outside the footprint; an ambiguous item is kept and reported with its reason.

**Done when:** every footprint item is listed with its evidence, and the PR state is known.

## 2. Gate on the PR

Proceed when the PR is merged or closed. When it is open or absent, stop and ask: the branch may still carry the only copy of the work.

With `all`, also check `git status --short` and unpushed commits (`git log @{u}..` or, with no upstream, `git log origin/HEAD..`). Uncommitted or unpushed work stops the run with a question.

**Done when:** the PR is merged or closed and, with `all`, the tree is clean with nothing unpushed, or the user said to go ahead.

## 3. Stop the processes

Stop each process from step 1: the host's preview-stop tool for a preview server, otherwise kill it.

**Done when:** no process runs from inside the worktree.

## 4. Drop the databases

Drop each worktree database, then remove each container created for it with its volume. Remove the overrides from step 1 and clear any `skip-worktree` flag (`git update-index --no-skip-worktree <file>` after restoring the file).

**Done when:** each worktree database and container is gone, the main checkout's databases still answer, and the worktree holds no override pointing at a removed database.

## 5. Delete the remote branch

`git push origin --delete <branch>`, then `git fetch --prune`.

**Done when:** `git ls-remote --heads origin <branch>` prints nothing.

## 6. Update the default branch

Fast-forward the main checkout's local default branch to `origin`: `git -C <main> pull --ff-only` when the main checkout has it checked out, otherwise `git -C <main> fetch origin <default>:<default>`. When the fast-forward fails, keep the branch as it is and report why.

**Done when:** the local default branch matches `origin/<default>`, or the failure is reported.

## 7. With `all`: worktree and local branch

When this session runs inside the worktree, leave it first through the host's worktree-exit tool if it has one: the session's working directory disappears with it. Then run from the main checkout, since a checked-out branch cannot be deleted: `git -C <main> worktree remove <path>`, `git -C <main> worktree prune`, then `git -C <main> branch -D <branch>`. A squash merge leaves the branch unmerged in git's eyes, so the PR state from step 2 is the proof of landing.

**Done when:** the worktree is absent from `git worktree list` and the branch from `git branch`.

## 8. Report

Report each ambiguous item kept, with its reason. Without `all`, name `/worktree-cleanup all` for the worktree and local branch.

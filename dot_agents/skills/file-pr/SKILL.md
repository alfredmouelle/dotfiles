---
name: file-pr
description: File a concise pull request. Use when the user asks to open a PR.
metadata:
  credits:
    skill: file-pr
    author: Theo Browne
    url: "https://github.com/t3dotgg/tstack/blob/main/skills/file-pr/SKILL.md"
---

# File PR

## 1. Check

Run `gh pr view` for the current branch; an existing PR ends the run with its URL. Fetch, then read the full diff against the base branch (usually `origin/main`) and compare it with the user's goal.

**Done when:** no PR covers the branch and every hunk serves the goal.

## 2. Branch

Name the branch `<type>/<kebab-case-description>` per the Conventional Branch spec (e.g. `feat/websocket-compression`); a different convention visible in the repository's branches takes precedence. From the default branch, move the work to a new branch (`git switch -c`, then reset the local default branch to its remote). From a branch named otherwise, rename it with `git branch -m`, and delete the old name from the remote when it is there. Push the branch, with `--force-with-lease` when its history was rewritten since the last push.

**Done when:** the branch follows the naming convention and the remote branch matches the local one.

## 3. Title

PR titles usually become commit messages: follow the repository's title conventions, taken from recently merged PRs and Git history. Write a concise, human-readable title that states the outcome and why it matters, in the project's domain language (`GLOSSARY.md` when present):

> ❌ perf(server): negotiate permessage-deflate on the websocket
>
> ✅ perf(server): cut websocket frame size by 70%+ with gzipping

**Done when:** a reader who skips the diff knows what got better.

## 4. Description

Open with the problem in plain words, drawn from the user's original prompt, then explain the solution in a sentence or two. The diff carries the implementation inventory:

> ❌ Removed implicit workspace carry-over from every "new thread" entry point (cmd+n / cmd+shift+o, sidebar v1/v2 buttons, command palette). New threads inherit only the project from context; branch, worktree, and env mode always come from the configured defaults. Deleted buildContextualThreadOptions, startNewThreadInProjectFromContext, and the v1 sidebar's seed-context machinery.
>
> ✅ My "new worktree" default was ignored when starting new threads on existing worktrees. Super unintuitive. Now your preferences always apply.

**Done when:** the description is problem first, solution second, and short enough to read in one glance.

## 5. File

Scan the title, description, quotes, and attachments for secrets and private details; stop and report any you find. Open a ready-for-review PR so review bots run. If `gh pr create` fails because the GraphQL rate limit is used up, open it through REST: `gh api repos/<owner>/<repo>/pulls -f title=... -f head=... -f base=... -F body=@<file>`. The PR body carries the whole message: add a PR comment only when the user's request needs one. When the user also asked to babysit the PR, continue with the `babysit-pr` skill.

**Done when:** the PR is open and its URL is reported.

---
name: merge-pr
description: Merge a pull request and close the issues it resolves. Use when the user asks to merge a PR.
---

# Merge PR

A failed check, a missing approval, or any refusal stops the run with GitHub's message.

## 1. Sync

When the PR is BEHIND or DIRTY, rebase onto the fetched base (conflicts through the `resolving-merge-conflicts` skill) and push with `--force-with-lease`.

**Done when:** the PR sits on its current base.

## 2. Wait

Wait for the required checks with the `babysit-pr` skill's `scripts/pr-wait <pr> --until green`, run as that skill describes. Right before merging, `git fetch` and check the PR again: when it became BEHIND or DIRTY, or a base commit that landed after the last green run touches its files, return to step 1.

**Done when:** the required checks are green on the head, the PR is neither BEHIND nor DIRTY, and no base commit since the last green run touches its files.

## 3. Merge

Merge with the method the repository allows (when several, the one the base branch's history shows), then delete the PR's branch from the remote.

**Done when:** the PR is merged and its branch is gone from the remote.

## 4. Close the issues

For each issue the PR or its commits close (`Closes #N`, `Fixes #N`, `Resolves #N`) that is still open, tick the description checkboxes this PR delivers (re-read the body just before editing), then close it.

**Done when:** every such issue is closed, its delivered checkboxes ticked.

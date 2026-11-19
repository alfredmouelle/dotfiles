---
name: modernize
description: Rebase an aging PR and reassess whether it still belongs in the product.
disable-model-invocation: true
metadata:
  credits:
    skill: modernize
    author: Theo Browne
    url: "https://github.com/t3dotgg/tstack/blob/main/skills/modernize/SKILL.md"
---

# Modernize

Modernize the idea, not just the branch: a clean rebase proves nothing about whether the PR still belongs in the product.

Modernizing authorizes rebasing and force-pushing the PR branch. Merging, closing, changing the base branch, and widening scope stay with the user. Existing worktree changes are user-owned: work in a disposable worktree when the active one is dirty or busy. Report in chat; comment on the PR only when the user asks.

## 1. Intent

Fetch the latest PR head, its actual base branch, and any related branch. Record the PR's URL, state, base, head repository and branch, head SHA, author, checks, and review state. Read the title, body, linked issues, commits, review threads, and complete diff. Record the merge base, so the PR's own changes and the base's later changes compare separately.

**Done when:** you can state the smallest coherent goal the PR set out to reach, in one sentence.

## 2. Drift

Inspect the commits and diffs that landed on the base since the merge base. Search merged and open PRs when titles, code paths, or behavior suggest a replacement or a competing implementation. Look past overlapping lines:

- Is the same user-facing problem already solved?
- Did APIs, types, schemas, dependencies, or architectural boundaries change?
- Do both sides now claim ownership of the same behavior or invariant?
- Was the code being changed deleted, moved, or intentionally simplified?
- Would landing the PR restore an old behavior or create two ways to do one thing?
- Is the original benefit still worth its maintenance cost?

**Done when:** every question has an answer backed by a commit, PR, or file.

## 3. Disposition

Pick one, before any push:

- **MODERNIZE**: the goal is still useful and the implementation keeps the right shape. Continue to step 4.
- **REWORK**: the goal is still useful, but a mechanical rebase would preserve the wrong implementation. Describe the smallest credible rewrite and stop, unless the user also asked for the rework.
- **CLOSE**: the PR is superseded, obsolete, directionally wrong, or no longer worth its cost. Cite the evidence and stop; closing it is the user's call.

Recommend `CLOSE` whenever the evidence supports it: age alone is no evidence, and sunk effort is no reason to keep a PR alive.

**Done when:** the disposition rests on the evidence from step 2.

## 4. Rebase

1. Create a local branch or disposable worktree at the recorded PR head.
2. Rebase its commits onto the freshly fetched base.
3. Resolve each conflict by the PR's intent and the base's newer invariants. When a conflict reveals a product or architecture disagreement, return to step 3.
4. Compare the series before and after with `git range-diff`, then read the final diff.
5. Run the project's checks for the touched area; tell real failures from pre-existing or infrastructure ones.
6. Push with `--force-with-lease=<branch>:<head SHA from step 1>`. When the lease fails, fetch and return to step 2.

**Done when:** no intended behavior disappeared, no already-landed behavior came back, the checks pass, and the push succeeded.

## 5. Report

Lead with the disposition and its reason, then: meaningful base changes, conceptual conflicts (or none found), the rebase and push result, checks and their results, what could not be verified, and the remaining decision, with the PR link. Mark each point as observed fact or judgment.

**Done when:** the report covers every item above.

---
name: babysit-pr
description: Watch a pull request through review and CI until it is ready. Use when the user asks to babysit or monitor a PR.
metadata:
  credits:
    skill: babysit-pr
    author: Theo Browne
    url: "https://github.com/t3dotgg/tstack/blob/main/skills/babysit-pr/SKILL.md"
---

# Babysit PR

Babysitting authorizes committing fixes and pushing them, rebases included (`--force-with-lease`), to the PR's own branch. Merging stays with the user unless they asked for it.

## 1. Catch up

Read the PR's current checks, reviews, and unresolved threads, and handle them as in step 3.

**Done when:** every finding on the current head is fixed or answered.

## 2. Watch

Wait with `scripts/pr-wait` from this skill's directory, by its absolute path. It is the only watcher: it holds a per-PR lock, shares the account's GitHub rate limit, and remembers what it already reported across restarts.

```bash
pr-wait <pr> [--repo owner/name] [--until ready|green|any-change]
```

- `ready` (default): required checks green, Greptile or Macroscope reviewed the head, no unresolved threads. Use it when the repo runs Greptile or Macroscope.
- `green`: required checks only. Use it everywhere else, since `ready` would wait forever.

In Claude Code, run it with the Monitor tool (`timeout_ms: 3600000`) so each printed line wakes you; elsewhere, run it as one long command. Exit codes: `0` goal met or PR merged, `1` the PR needs you (failed required check, conflict, unresolved threads, BEHIND, closed), `2` bad input or another pr-wait already watches the PR. On a `2` for an existing watcher, keep it, and kill it only when its events stop reaching you.

Restart it after each push, after handling an exit `1`, and after a resume.

**Done when:** pr-wait exits.

## 3. Handle events

Act on checks and comments newer than the latest push. When an event needs no action, end the turn silently.

- **Findings**: verify each bot or reviewer finding against the source. Fix real bugs in the intended case with the smallest change, preferring the fix that deletes or narrows code. Answer a false positive or an out-of-scope finding with a one-line written reason, resolve its thread, and list it as a follow-up. Out of scope means unneeded tests, guards for edge cases that do not matter, extra compatibility, small performance costs: the PR stays the size the user's goal needs.
- **Macroscope**: read `.macroscope/check-run-agents/*.md` when present before answering its findings; they cite those rules.
- **CodeRabbit**: advisory; treat its findings like any other, and hold nothing for it.
- **CI failures**: tell repository failures from infrastructure flakes; fix the first, rerun the second.
- **BEHIND or DIRTY**: rebase onto the fetched base and push with `--force-with-lease`.
- **Obsolete**: when an overlapping PR makes this one obsolete, stop watching and ask the user before closing it.

GitHub's GraphQL and REST rate limits are separate. When `gh pr view` or `gh pr checks` hit the GraphQL limit, read through REST: `gh api repos/<owner>/<repo>/pulls/<n>` for the PR, `gh api repos/<owner>/<repo>/commits/<sha>/check-runs` for checks.

**Done when:** every finding on the current head is fixed or answered, and the fixes are pushed; then return to step 2.

## 4. Stop

Stop when pr-wait exits `0`. When the user asked for a merge, run `git fetch`, then check the PR again: merge only when it is neither BEHIND nor DIRTY and no base commit landed after the last green run touches its files; otherwise rebase, push, and return to step 2. Without a merge request, report the PR as ready.

**Done when:** the PR is merged as requested, or reported ready with its URL.

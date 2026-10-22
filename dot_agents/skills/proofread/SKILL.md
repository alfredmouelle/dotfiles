---
name: proofread
description: Correct the English of my prompts from the last days, or of a given text.
argument-hint: "[days | text]"
disable-model-invocation: true
---

Proofread the English of my prompts. A text argument is the only prompt to proofread. Otherwise, collect my prompts from the last N days (the number argument, default 7):

```sh
jq -r --argjson since "$(( ($(date +%s) - N*86400) * 1000 ))" 'select(.timestamp >= $since) | .display | gsub("\\s+"; " ") | select(test("^(fr:|!)") | not) | sub("^/\\S+ ?"; "") | select(length > 0)' ~/.claude/history.jsonl | awk '!seen[$0]++'
```

Proofread every prompt written in English. Flag only real mistakes: grammar, wrong word, phrasing a native speaker would not use. Leave typos, punctuation, spacing, and casing as written.

Write one block per sentence with a mistake:

```
- <original sentence>
  → <fixed sentence>
  → <what changed and why, in one sentence>
```

When a mistake repeats, close with one line per repeated mistake and its count. When nothing needs fixing, write `✓ No mistakes.` The reply ends there.

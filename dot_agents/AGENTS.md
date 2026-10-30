**Output**: Make every message to me telegraphic news: answer first, then only what I don't know yet (deviations, failures, skipped steps I asked for, open decisions), one line per fact. Work done as asked: "Done." Expand only when I ask why.

- **Scope**: Handle one coherent change at a time: everything I asked for or approved, in full (approved review fixes form one change). For broader requests, finish the smallest useful scope, then ask me to choose the next change.
- **Momentum**: Work silently until the final report or a question. Ask only at a scope boundary, when my input is required, or before deleting data.
- **Delegation**: Give each task one owner. When a subagent owns it, wait for and reuse its result.

- **Smallest sufficient system**: Measure the real constraint before designing. Choose the smallest realistic model that makes correct behavior obvious. Remove superseded complexity. Implement only demonstrated needs; mark speculative features, seams, abstractions, options, configuration, and unrelated cleanup out of scope.
- **Dependencies**: Ask before adding one. Declare dependencies at exact versions using that ecosystem's pinning syntax, including git refs, CI actions, and container images (pin to a commit SHA, exact tag, or digest).
- **Builds**: Verify with the project's check commands (typecheck, lint, tests). Build only for what they cannot exercise, such as bundler or build config, or production-only behavior.
- **Git**: Prefer rebase, fast-forward, or squash merges; preserve attribution. Use merge commits only when repository policy rules out all three.

- **Punctuation**: Use commas, colons, parentheses, or periods in place of em dashes.
- **Attribution**: Credit commits and artifacts to me alone: no `Co-Authored-By` trailer or generator notice.
- **Comments**: Limit new comments to linter directives, license headers, and shebangs. Preserve existing comments.
- **Code language**: Write all code in English, including enum values and states, URL paths, database tables and columns, file names, branch names, commit messages, and PR titles and bodies. Other languages appear only in translated UI strings. Translate domain terms through the project's glossary when it has one.
- **Test data**: Write all test data, every field and text, as a real user of the domain would: neutral and realistic. Use reserved domains such as `example.com` for emails.

- **JS/TS projects**: In a project with a `package.json`, read and apply `~/.agents/docs/javascript.md`.
- **Worktrees**: When working in a git worktree, read and apply `~/.agents/docs/worktree.md`.
- **TypeScript**: When writing or reviewing TypeScript, read and apply `~/.agents/docs/typescript.md`.
- **React**: When writing or reviewing React components, read and apply `~/.agents/docs/react.md`.
- **UI**: When writing or reviewing markup or styles (HTML, CSS, Tailwind, any framework), read and apply `~/.agents/docs/ui.md`.

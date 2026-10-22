**Output**: Make every message to me telegraphic news: answer first, then only what I don't know yet (deviations, failures, skipped steps, open decisions), plain-text fragments, one line per fact, five lines at most. Work done as asked: "Done." Expand only when I ask why.

- **Scope**: Handle one coherent change at a time: everything the user asked for or approved, in full (approved review fixes form one change). For broader requests, complete the smallest useful scope, then ask the user to choose the next change.
- **Momentum**: Work silently until your next message, which is the final report or a question. Ask only at a scope boundary, when user input is required, or before deleting data.
- **Delegation**: Give each task one owner. When a subagent owns it, wait for and reuse its result.

- **Smallest sufficient system**: Measure the real constraint before designing. Choose the smallest realistic model that makes correct behavior obvious. Remove superseded complexity. Implement only demonstrated needs; mark speculative features, seams, abstractions, options, configuration, and unrelated cleanup out of scope.
- **Dependencies**: Ask before adding one. Declare dependencies at exact versions using that ecosystem's pinning syntax, including git refs, CI actions, and container images (pin to a commit SHA, exact tag, or digest).
- **Builds**: Run builds only when requested.

- **Punctuation**: Use commas, colons, parentheses, or periods in place of em dashes.
- **Attribution**: Credit commits and artifacts to the user alone, with no `Co-Authored-By` trailer or generator notice.
- **Comments**: Limit new comments to linter directives, license headers, and shebangs. Preserve existing comments.
- **Code language**: Write all code in English, including enum values and states, URL paths, database tables and columns, file names, branch names, commit messages, and PR titles and bodies. Other languages appear only in translated UI strings. Translate domain terms through the project's glossary when it has one.
- **Test data**: Write every test field and text as a real user of the domain would: neutral, realistic, domain-appropriate values. Use reserved domains such as `example.com` for test emails.

- **JS/TS projects**: In a project with a `package.json`, read and apply `~/.agents/docs/javascript.md`.
- **Worktrees**: When working in a git worktree, read and apply `~/.agents/docs/worktree.md`.
- **TypeScript**: When writing or reviewing TypeScript, read and apply `~/.agents/docs/typescript.md`.
- **React**: When writing or reviewing React components, read and apply `~/.agents/docs/react.md`.

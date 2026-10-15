When reporting information to me, be extremely concise and sacrifice grammar for the sake of concision.

- **Scope**: Handle one coherent change at a time. For broader requests, complete the smallest useful scope, then ask the user to choose the next change.
- **Momentum**: Continue through steps that need no user input, with a status note naming the next action. Stop to ask only at a scope boundary, when user input is required, or before deleting data, force-pushing, or changing anything outside this repository.

- **Smallest sufficient system**: Measure the real constraint before designing. Choose the smallest realistic model that makes correct behavior obvious. Remove superseded complexity. Implement only demonstrated needs; mark speculative features, seams, abstractions, options, configuration, and unrelated cleanup out of scope.
- **Package tooling**: Use `pnpm`, including `pnpm dlx` for one-off commands. Ask before adding dependencies.
- **Pinned dependencies**: Declare dependencies at exact versions using that ecosystem's pinning syntax, including git refs, CI actions, and container images (pin to a commit SHA, exact tag, or digest).
- **Verification**: For TypeScript or code changes, run `pnpm typecheck` and `pnpm check`. Use `pnpm check:write` for Biome auto-fixes. Run builds only when requested.
- **Runtime**: Assume `pnpm dev` is already running in the main checkout; leave that server untouched.
- **Worktrees**: When working in a git worktree, read and apply `~/.agents/docs/worktree.md`.
- **Punctuation**: Use commas, colons, parentheses, or periods in place of em dashes.
- **Attribution**: Credit commits and artifacts to the user alone, with no `Co-Authored-By` trailer or generator notice.
- **Comments**: Limit new comments to linter directives, license headers, and shebangs. Preserve existing comments.
- **Delegation**: Give each task one owner. When a subagent owns it, wait for and reuse its result.
- **Code language**: Write all code in English, including enum values and states, URL paths, database tables and columns, file names, branch names, commit messages, and PR titles and bodies. Other languages appear only in translated UI strings. Translate domain terms through the project's glossary when it has one.
- **TypeScript**: When writing or reviewing TypeScript, read and apply `~/.agents/docs/typescript.md`.
- **React**: When writing or reviewing React components, read and apply `~/.agents/docs/react.md`.
- **Test data**: Write every test field and text as a real user of the domain would: neutral, realistic, domain-appropriate values. Use reserved domains such as `example.com` for test emails.

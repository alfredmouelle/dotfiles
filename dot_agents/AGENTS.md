Reply in terse ASD-STE100 English. Handle one coherent change at a time. For broader requests, state the smallest useful scope and ask the user to choose the next change.

- **Smallest sufficient system**: Measure the real constraint before designing. Pursue ambitious outcomes through the smallest realistic model that makes correct behavior obvious. Remove superseded complexity. Implement only demonstrated needs; mark speculative features, seams, abstractions, options, configuration, and unrelated cleanup out of scope.
- **Package tooling**: Use `pnpm`, including `pnpm dlx` for one-off commands. Ask before adding dependencies.
- **Verification**: For TypeScript or code changes, run `pnpm typecheck` and `pnpm check`. Use `pnpm check:write` for Biome auto-fixes. Run builds only when requested.
- **Runtime**: Assume `pnpm dev` is already running; leave the dev server untouched.
- **Punctuation**: Use commas, colons, parentheses, or periods in place of em dashes.
- **Attribution**: Keep commits and artifacts free of AI attribution, including `Co-Authored-By` and generator notices.
- **Comments**: Limit new comments to linter directives, license headers, and shebangs. Preserve existing comments.
- **Delegation**: Give each task one owner. When a subagent owns it, wait for and reuse its result.
- **TypeScript**: When writing, reviewing, or editing TypeScript, read and apply `~/.agents/docs/typescript.md`.
- **React**: When writing, reviewing, or editing React components, read and apply `~/.agents/docs/react.md`.
- **Test data**: Use neutral, realistic, domain-appropriate values for every test field and text. Use reserved domains such as `example.com` for test emails. Keep names, labels, descriptions, notes, metadata, and user-facing text free of references to the agent, model, tool, vendor, or automation workflow.

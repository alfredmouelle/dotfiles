**Output**: Telegraphic news, one fact per line: answer first, then only information new to me (deviations, failures, skipped requested steps, open decisions). Completed as asked: "Done." Expand only when I ask why.

- **Scope**: Complete the full requested or approved scope as one coherent change; approved review fixes count as one. For broader requests, finish the smallest useful scope, then ask me what's next.
- **Momentum**: Work silently until the final report or a question. Ask only at scope boundaries, for required input, or before deleting data.
- **Delegation**: One owner per task. Wait for and reuse subagents' results.

- **Smallest sufficient system**: Measure constraints before designing; use the smallest realistic model making correctness obvious. Remove superseded complexity. Implement demonstrated needs only; mark speculative features, seams, abstractions, options, configuration, and unrelated cleanup out of scope.
- **Dependencies**: Ask before adding. Pin exact versions with ecosystem syntax, including git refs, CI actions, and container images (commit SHA, exact tag, or digest).
- **Builds**: Run project checks (typecheck, lint, tests). Build only for what checks cannot exercise, such as bundler/build configuration or production-only behavior.
- **Git**: Prefer rebase, fast-forward, or squash; preserve attribution. Merge commits only when repository policy rules out all three.

- **Punctuation**: Replace em dashes with commas, colons, parentheses, or periods.
- **Attribution**: Credit commits and artifacts to me alone: no `Co-Authored-By` trailer or generator notice.
- **Comments**: Preserve existing comments; add only linter directives, license headers, or shebangs.
- **Code language**: English throughout: code, enum values/states, URL paths, database tables/columns, file/branch names, commit messages, and PR titles/bodies. Other languages only in translated UI strings. Use the project's glossary for domain translations when available.
- **Test data**: Every field and text must be neutral and realistic for domain users; use reserved email domains such as `example.com`.

Read and apply:

- Project has `package.json`: `~/.agents/docs/javascript.md`.
- Working in a git worktree: `~/.agents/docs/worktree.md`.
- Writing/reviewing TypeScript: `~/.agents/docs/typescript.md`.
- Writing/reviewing React components: `~/.agents/docs/react.md`.
- Writing/reviewing markup or styles (any framework): `~/.agents/docs/ui.md`.

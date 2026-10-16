A git worktree runs in isolation: it never collides with the main checkout or a concurrent worktree.

1. **Env**: Copy `.env` from the main checkout if missing and keep it exactly as copied; when the copy is denied, ask the user to run `! cp <main-checkout>/.env <worktree>/.env`. When the project has no `.worktreeinclude`, add one listing `.env` and commit it with the current change.
2. **Databases**: Create two new databases named after the worktree, one for the app and one for the tests, and apply the migrations to each. Write their URLs to the local override file the project loads before `.env` (usually `.env.local`); keep edits to tracked env files out of commits with `git update-index --skip-worktree`. Every existing database stays untouched.
3. **Dev server**: Pick a free port in 3000–3100 (the OAuth callback range). In `.env.local`, override every localhost URL listed in `.env.example` with that port. Start `pnpm dev` on it and confirm its output shows that port.

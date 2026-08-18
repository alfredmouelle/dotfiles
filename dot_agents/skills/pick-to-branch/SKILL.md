---
name: pick-to-branch
description: Cherry-pick commits onto a target branch (default develop) with the commit date rewritten to now.
disable-model-invocation: true
---

# Pick to branch

Cherry-pick a change from a source branch onto a target branch (default `develop`), forcing the **author date** to the current moment so `git log` shows when it landed on the target — not the original commit date.

## Arguments

Parse from the invocation (free-form, in any order):

- **SHA(s)** — one or more commit hashes to pick. Required. May be a list.
- **target branch** — where to land the change. Optional, **defaults to `develop`**.
- **push flag** — whether to push the target branch automatically once the pick is done. Optional, **defaults to no push**. Recognize words like `push`, `--push`, `-p`, `et push`, `puis push` as opt-in; `no-push`, `--no-push` as explicit opt-out.

If no SHA is given, **stop** and ask which commit(s) to pick (offer to run `git log --oneline <target>..<source>` if a source branch is mentioned).

## Step 1 — Guard the working tree

```bash
git status --short
git branch --show-current
```

- If the tree is **dirty** (staged or unstaged changes): **stop** and ask the user before switching branches — do not stash silently. Note the current branch to restore it later.
- Record the current branch so you can return to it at the end.

## Step 2 — Switch to the target branch

```bash
git checkout <target>
```

Default `<target>` to `develop` when none was given.

## Step 3 — Cherry-pick each SHA with the current date

Process commits **one by one**, in chronological order (oldest first) if several were given. For each SHA:

```bash
git cherry-pick <sha>
```

### 3a — Conflict?

If `cherry-pick` reports a conflict: **stop**, show the conflicting files, ask the user to resolve, then continue with `git cherry-pick --continue`. Proceed to 3b once the working tree is clean.

### 3b — Schema change? (Drizzle migrations)

**Dual mode:** the target branch (`develop`) uses **versioned migrations** (baseline established 2026-06-19, commit `46695cf`); other branches and local dev still use `drizzle-kit push`. So we generate the migration **at pick time**, on the target, giving its live DB ordered, idempotent deltas. Never run `db:push` against the live target DB. Check whether the picked commit touches the schema:

```bash
git show --name-only --format= HEAD | grep -E 'src/server/db/schemas/.*\.schema\.ts'
```

If it matches, generate the delta migration from the new schema state, then fold it into the pick:

```bash
pnpm db:generate --name <short_descriptive_name>   # diffs schema files vs drizzle/meta snapshot → drizzle/NNNN_*.sql
git add drizzle/
```

- If generate reports **"No schema changes"** (file touched but no structural change), skip — nothing to add.
- **Inspect the new SQL for destructive ops before going further:**

  ```bash
  ls -t drizzle/*.sql | head -1 | xargs grep -iE 'drop table|drop column|drop constraint|alter .* drop'
  ```

  If any match: **stop**, show them, and confirm with the user — `db:migrate` on the **live** target DB will execute these and can lose data.

### 3c — Finalize the commit (current date)

```bash
git commit --amend --no-edit --date=now
```

- `--amend --date=now` rewrites the **author date** to now (committer date is already now) and folds any migration file into the picked commit.

### 3d — Applying the migration to the target DB

When `develop` is pushed and deploys on Vercel, migrations apply **automatically** in the production build (`vercel-build` → `scripts/predeploy-migrate.sh`, gated on `VERCEL_ENV=production`). So **no manual step is normally needed** — pushing the pick is enough.

Only run it by hand when applying out-of-band (before pushing/deploying):

```bash
DATABASE_URL="<prod develop url>" pnpm db:migrate
```

- The inline `DATABASE_URL` overrides `.env.local`/`.env`; ensure it targets the **live develop** DB.
- Idempotent — already-applied migrations are skipped.

## Step 4 — Report (and push only if asked)

Show the new commit(s):

```bash
git log --oneline -n <count> --format='%h %ad %s' --date=short
```

### 4a — Push (only when the push flag was given)

If the push flag was opted into, push the target branch **while still on it** (before restoring the original branch):

```bash
git push origin <target>
```

- Pushing `develop` triggers the Vercel production deploy, which applies any folded migration automatically (see Step 3d).
- If push is **not** opted into (default): do not push — leave it for the user.

### 4b — Restore and report

Restore the user's original branch **only if they were not already on the target**, then report:

- **Push opted in:** confirm the pick landed and was pushed (mention the migration will apply on deploy if one was folded in).
- **No push (default):** tell them the pick is done and ready to `git push` when they choose.

**Never push automatically unless the push flag was explicitly given.**

## Notes

- Picked commits get a **new hash** — they will exist in duplicate when branches later merge. For the final reconciliation, prefer a merge/rebase over re-picking.
- If commits depend on each other, keep the original order to avoid conflicts.
- **Schema/code coupling:** never pick code that reads a column without also picking (or having already picked) the schema commit that defines it — otherwise the live app breaks.
- **Migrations diverge per branch:** since migrations are generated on the target branch, `drizzle/meta/_journal.json` may conflict when the source branch later merges. Resolve by keeping the target's journal and re-generating if needed.
- **Baseline already done** (2026-06-19): commit `46695cf` on develop holds `0000_baseline`, marked as already-applied in `drizzle.__drizzle_migrations` on the live DB. No action needed. A baseline is only required again when introducing versioned migrations to a *new* already-populated environment.

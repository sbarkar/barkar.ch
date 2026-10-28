---
name: steward
description: How to drive a pull request in barkar.ch to a mergeable state — validation commands, CI expectations, Dependabot PRs and review-comment policy. Read before acting on CI failures or review comments on a PR.
---

# Stewarding PRs in barkar.ch

This is a small, single-maintainer static site. Keep PRs small and boring.

## Before every push

Run these and only push when all pass (they mirror `.github/workflows/ci.yml`):

```bash
yarn install --frozen-lockfile
yarn build      # includes TypeScript type-checking
yarn lint
npx prettier --check .
```

If `prettier --check` fails on files you touched, run `npx prettier --write <files>`.
Do not reformat files the PR does not otherwise touch.

## CI

- `CI` (`ci.yml`) is the only required check: install → build → lint.
- `Deploy to GitHub Pages` (`deploy.yml`) only runs on `main`; it is not a PR check.
- Vercel posts preview deployments on PRs. A failed preview with a green `CI` usually
  means a Vercel-side issue — report it, don't change code to chase it.
- Node 20 in CI. If something passes locally but fails in CI, check the Node version first.

## Dependabot PRs

- `dependabot-automerge.yml` auto-approves and squash-merges minor/patch bumps once CI is green.
  Leave those alone unless CI is red.
- For a red Dependabot PR: fix forward on the Dependabot branch with a merge commit
  (never rebase/force-push it), or report the breaking change if the fix is non-trivial.
- Major-version bumps need the maintainer's call — summarize the breaking changes and stop.
- Never edit `yarn.lock` by hand; regenerate with `yarn install`.

## Review comments

- Optional/nit findings: reply once with what you'll do, and fold plainly-correct nits into
  the next push that already touches those files. Don't push solely for a nit.
- Anything that changes the shape of `RESUME_DATA`, the print layout, or removes Plausible
  analytics needs the maintainer's explicit OK (see `CLAUDE.md`).
- Content changes to `src/data/resume-data.tsx` (jobs, dates, wording) are the maintainer's
  personal CV — never invent or "improve" facts; ask.

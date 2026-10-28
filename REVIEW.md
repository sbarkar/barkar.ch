# REVIEW.md — review guidance for barkar.ch

Guidance for automated (Claude Code Review) and human reviewers. Conventions live in
`CLAUDE.md`; this file says what is worth flagging.

## Always flag (blocking)

- `npm`/`pnpm` usage, or a `package-lock.json` / `pnpm-lock.yaml` added.
- `yarn.lock` changes that don't correspond to a `package.json` change (outside Dependabot).
- `any` types, `@ts-ignore`, or disabled ESLint rules without a reason.
- `dangerouslySetInnerHTML`.
- `target="_blank"` without `rel="noopener noreferrer"`.
- Images without meaningful `alt` text.
- `"use client"` added to a component that uses no hooks, events or browser APIs.
- Removal of the Plausible script in `src/app/layout.tsx`, or new analytics/tracking scripts.
- Anything that breaks `output: "export"` in `next.config.js` (API routes, server actions,
  dynamic server-only features) — the site deploys as static files.
- Renamed/removed keys in `RESUME_DATA` without matching updates in `src/app/page.tsx`.
- Secrets, tokens or personal data beyond what is already public on the CV.

## Worth a comment (non-blocking)

- Print layout regressions (missing `print:hidden`, content that won't fit on PDF pages).
- Whole-library imports (e.g. `import * as Icons from "lucide-react"`).
- Tailwind v3 patterns (`@tailwind base;`, `theme.extend` for new tokens) instead of v4 `@theme`.
- Non-`@/` relative imports across directories.

## Don't flag

- Class ordering — `prettier-plugin-tailwindcss` handles it.
- CV wording or content choices in `src/data/resume-data.tsx`.
- Routine Dependabot bumps with green CI.

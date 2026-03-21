# CLAUDE.md — barkar.ch

Context file for Claude Code and AI coding assistants working on this repository. Read this before making any changes.

> A more verbose version of these instructions (for GitHub Copilot) lives at `.github/copilot-instructions.md`.

---

## Project Overview

Personal CV/portfolio website at **barkar.ch**. It is a single-page, static Next.js site that renders entirely from one central data object. There is no backend, no database, and no API routes.

**Stack:**
- **Next.js 16** (App Router, static export)
- **React 19**
- **TypeScript 5** (strict mode)
- **Tailwind CSS 4** (utility-first, `@theme` directive)
- **shadcn/ui** primitives backed by Radix UI
- **Yarn 1.22** (only — no npm, no pnpm)

---

## Repository Structure

```
barkar.ch/
├── src/
│   ├── app/
│   │   ├── layout.tsx          # Root layout: fonts, metadata, Plausible analytics
│   │   ├── page.tsx            # Single CV page (server component)
│   │   └── globals.css         # Tailwind @import + @theme CSS variables + print styles
│   ├── components/
│   │   ├── ui/                 # shadcn/ui primitives (Avatar, Badge, Button, Card, Command, Dialog, Drawer, Section)
│   │   ├── icons/              # Custom SVG icon components (GitHub, LinkedIn, X)
│   │   ├── command-menu.tsx    # Client component — ⌘J / Ctrl+J command palette
│   │   ├── print-drawer.tsx    # Client component — print UI via vaul drawer
│   │   └── project-card.tsx    # Memoized project card (React.memo)
│   ├── data/
│   │   └── resume-data.tsx     # SINGLE SOURCE OF TRUTH — all CV content lives here
│   ├── images/logos/           # Company / project logos (PNG + SVG)
│   ├── lib/
│   │   └── utils.ts            # cn() helper (clsx + tailwind-merge)
│   └── types/
│       └── images.d.ts         # Image module type declarations
├── public/                     # Static assets (OG image, sitemap, robots, PWA manifest)
├── .github/
│   ├── copilot-instructions.md # Detailed AI instructions (Copilot-oriented)
│   ├── workflows/
│   │   ├── ci.yml              # Build + lint on every push / PR
│   │   ├── deploy.yml          # Deployment workflow
│   │   └── dependabot-automerge.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/                       # Developer checklists and setup guides
├── next.config.js
├── tailwind.config.js
├── tsconfig.json
├── Dockerfile                  # Multi-stage Node 20 Alpine build
├── docker-compose.yaml
└── vercel.json
```

---

## Key Files — What to Edit for Common Tasks

| Task | File |
|---|---|
| Add/update resume content | `src/data/resume-data.tsx` |
| Change page layout or sections | `src/app/page.tsx` |
| Change global styles or CSS variables | `src/app/globals.css` |
| Update fonts, metadata, analytics | `src/app/layout.tsx` |
| Add/modify a UI primitive | `src/components/ui/<name>.tsx` |
| Add a higher-level component | `src/components/<name>.tsx` |
| Add a logo or image asset | `src/images/logos/` |
| Adjust build / Next.js config | `next.config.js` |
| Adjust Tailwind config | `tailwind.config.js` |
| Docker / self-hosting | `Dockerfile`, `docker-compose.yaml` |
| Vercel deployment config | `vercel.json` |

---

## Development Commands

```bash
# Install (always use --frozen-lockfile)
yarn install --frozen-lockfile

# Local development
yarn dev          # http://localhost:3000

# Production build (also runs TypeScript type-checking)
yarn build

# Run production server locally
yarn start

# Lint
yarn lint

# Format (sorts Tailwind classes automatically)
npx prettier --write .

# Docker
docker compose build
docker compose up -d
docker compose down
```

**Package manager rule:** Always use `yarn`. Never use `npm` or `pnpm`. The project has a `yarn.lock` and a `packageManager` field in `package.json` that pin Yarn 1.22.22. All CI uses `yarn install --frozen-lockfile`.

---

## Code Conventions

### TypeScript
- Strict mode is enabled — fix type errors, never use `any` (use `unknown` or a proper type)
- Use `as const` for static data to get precise literal types (see `RESUME_DATA`)
- Prefer named exports over default exports (better tree-shaking, easier refactoring)
- Use `export type` for type-only exports

### Imports
- Use the `@/` alias for all internal imports (maps to `src/` — see `tsconfig.json`)
- Import only what you need from libraries (never `import * as Icons from 'lucide-react'`)

### Server vs Client Components
- Files in `src/app/` are **server components by default** — do not add `"use client"` unless necessary
- Add `"use client"` only when a component needs: hooks, event handlers, or browser APIs
- Keep client components small and focused (see `command-menu.tsx`, `print-drawer.tsx`)

### Naming
- Component files: `kebab-case.tsx` (e.g., `project-card.tsx`)
- Component exports: `PascalCase` (e.g., `export const ProjectCard = ...`)
- Directories: `kebab-case`

### External Links
Always include `rel="noopener noreferrer"` on `target="_blank"` links to prevent tabnabbing.

---

## Data-Driven Architecture

All CV content is in **one place**: `src/data/resume-data.tsx`, exported as `RESUME_DATA` with `as const` typing.

```
RESUME_DATA
├── name, initials, location, locationLink
├── about, summary
├── avatarUrl, personalWebsiteUrl
├── contact: { email, tel, social[] }
├── education[]
├── work[]
├── projects[]
└── skills[]
```

**Preferred workflow:** When adding or removing resume sections, mutate `RESUME_DATA` rather than editing `page.tsx` markup. The page reads from this object — most content changes never require touching the layout.

**Do not change the shape of `RESUME_DATA`** (rename/remove keys) without updating all usages in `page.tsx`. The TypeScript compiler will catch breakage if strict mode is respected.

---

## Styling Conventions

- **Tailwind CSS 4** — uses the `@import "tailwindcss"` syntax and `@theme` directive in `globals.css`. Do not mix v3 patterns.
- CSS variables for theming live in the `@theme {}` block in `globals.css`.
- Prefer Tailwind utility classes over custom CSS.
- **Print design:** The site is optimized for printing to PDF. Use `print:hidden`, `print:block`, and the `.print-force-new-page` helper class for print-specific behavior. Do not break print layout.
- **Class ordering:** `prettier-plugin-tailwindcss` sorts classes automatically — always run `npx prettier --write .` after editing class strings.
- Dark mode: configured as `darkMode: ["class"]` in `tailwind.config.js` (class-based toggle).

---

## Component Patterns

- **UI primitives** in `src/components/ui/` follow shadcn/ui conventions. Reuse them for consistent styles and built-in accessibility.
- Use **Radix UI** primitives (via shadcn wrappers) for interactive elements — they handle keyboard navigation and ARIA automatically.
- Use **`class-variance-authority` (CVA)** for components with multiple visual variants (see `button.tsx`).
- Use **`React.memo`** on components that receive stable props and appear in lists (e.g., `ProjectCard`). Add `displayName` for debugging.
- The `cn()` utility (`src/lib/utils.ts`) combines `clsx` and `tailwind-merge` — use it for all conditional class construction.

---

## Analytics

Plausible Analytics is loaded via a CDN `<script>` tag in `src/app/layout.tsx`. It is privacy-focused (no cookies, no personal data). **Do not remove it** unless explicitly instructed. Do not add other analytics scripts without discussion.

---

## CI / CD

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | Every push / PR | `yarn install --frozen-lockfile` → `yarn build` → `yarn lint` |
| `deploy.yml` | Configured trigger | Deploys to production |
| `dependabot-automerge.yml` | Dependabot PRs | Auto-approves and merges minor/patch updates when CI passes |

- **Vercel** is the primary deployment target. Pushing to `main` triggers a production deploy.
- **Docker** (`Dockerfile` + `docker-compose.yaml`) supports self-hosting on Node 20 Alpine.
- CI must pass before merging any PR to `main`.

---

## Common Pitfalls

- Do not use `npm` — yarn only.
- Do not use `any` — use proper types or `unknown`.
- Do not add `"use client"` unnecessarily — keep server components wherever possible.
- Do not import entire icon libraries — import specific icons.
- Do not skip `alt` text on images.
- Do not remove Plausible analytics without confirmation.
- Do not rename keys in `RESUME_DATA` without updating all usages in `page.tsx`.
- Do not use `dangerouslySetInnerHTML`.
- Do not mix Tailwind v3 and v4 patterns.

---

## Pre-Commit Validation Checklist

1. `yarn lint` — no ESLint errors
2. `npx prettier --write .` — classes and formatting are clean
3. `yarn build` — production build succeeds, no TypeScript errors
4. Visual check at `http://localhost:3000`
5. Check print layout (`Ctrl+P` / `Cmd+P`) if you changed visible content
6. Test keyboard navigation if you changed interactive elements
7. Test responsive layout at mobile, tablet, and desktop widths

---

## Notes on Copilot Instructions

`.github/copilot-instructions.md` contains a more verbose version of these guidelines aimed at GitHub Copilot inline completions. Both files should agree on all conventions. If you spot a discrepancy, this `CLAUDE.md` is the authoritative source for Claude Code.

One known inconsistency in the Copilot file (line 33): it lists `yarn install (or npm install)` — **ignore the npm option**. Yarn is the only permitted package manager in this repository.

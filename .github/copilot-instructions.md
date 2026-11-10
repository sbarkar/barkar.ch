<!-- Copilot / AI agent instructions for the sbarkar.com repo -->

# Copilot Instructions — sbarkar.com

Purpose: make AI coding agents immediately productive editing this Next.js CV site while maintaining performance, accessibility, and best practices.

**Big Picture:**

- **Framework:** Next.js (app router), React, TypeScript, TailwindCSS (shadcn/ui primitives).
- **Single-page CV:** `src/app/page.tsx` renders the whole CV using a single canonical data object `src/data/resume-data.tsx`.
- **UI pattern:** small reusable primitives live under `src/components/ui/*` (Buttons, Card, Badge, Avatar, Command, etc.) and are composed by higher-level components in `src/components`.
- **Static assets:** logos and image exports under `src/images/logos` and icons in `src/components/icons`.
- **Analytics/telemetry:** `src/app/layout.tsx` includes Plausible Analytics via CDN script for privacy-focused analytics — avoid removing unless instructed.

**Key files to edit (common tasks):**

- Add/update resume content: `src/data/resume-data.tsx` (single source of truth).
- Change layout or global CSS: `src/app/layout.tsx`, `src/app/globals.css`.
- Add/change components: `src/components/*` and shared primitives in `src/components/ui/*`.
- Images/logos: `src/images/logos/*` (exports used from `resume-data.tsx`).
- Dev / deploy config: `package.json`, `next.config.js`, `Dockerfile`, `docker-compose.yaml`.

**Conventions & patterns to follow:**

- Import alias: use `@/` to reference `src/*` (see `tsconfig.json` paths).
- Client vs Server components: the app router (files in `src/app`) are server components by default — add a top-line `"use client";` for client components (see `src/components/command-menu.tsx`).
- UI primitives follow shadcn conventions; try to reuse `src/components/ui/*` for consistent styles and accessibility.
- Print-friendly design: project uses Tailwind print utilities and a `.print-force-new-page` helper in `globals.css` — prefer CSS classes for print behavior.
- Data-driven pages: adding/removing resume sections is usually done by mutating `RESUME_DATA` (typed `as const`) rather than editing `page.tsx` markup when possible.

**Dev & build workflows (commands):**

- Install: `yarn install --frozen-lockfile` (Yarn only; never npm or pnpm).
- Dev: `yarn dev` (runs `next dev`).
- Build: `yarn build` (runs `next build`).
- Start (production): `yarn start` (runs `next start`).
- Lint: `yarn lint`.
- Docker: `docker compose build` then `docker compose up -d`; stop with `docker compose down`.

**Package manager (important):**

- **Always use `yarn`** for this repository. The project is locked to Yarn (see `yarn.lock` and `package.json` `packageManager` field). Use `yarn install --frozen-lockfile` locally and in CI to ensure deterministic installs. Do not switch to `npm` or use `package-lock.json`.

When making changes that affect rendering, run `yarn dev` and open `http://localhost:3000`.

**Examples (concrete edits):**

- Add a new project: edit `src/data/resume-data.tsx` -> `projects` array; include `title`, `description`, `techStack`, optional `link` object.
- Add a new UI primitive: create `src/components/ui/<name>.tsx` and export it from `src/components/ui/index` (follow existing file structure).
- Make a component client-side: add `"use client";` at top; prefer small, focused client components (command menu, interactive controls).

**Integration points & external deps:**

- Plausible Analytics via CDN script for privacy-focused analytics (layout). Keep it for telemetry.
- Tailwind CSS 4.1 + `prettier-plugin-tailwindcss` used for style ordering — run formatter after edits.
- No test suite is present; rely on manual dev server and visual checks.
- Next.js 16 with React 19 — follow latest app router patterns.

**TypeScript notes:**

- `tsconfig.json` is strict. Keep types and `as const` shapes intact to avoid cascading type errors.

**Do not change without confirmation:**

- `src/data/resume-data.tsx` object keys used across site (name, contact, projects, work, education) — preserve shape unless updating all usages.
- `src/app/layout.tsx` analytics imports.

If anything above is unclear or you want me to include additional examples (e.g., a step-by-step to add a new project card or add a social link), tell me which area and I'll iterate.

---

**Quick Edit Examples**

- Add a project to `src/data/resume-data.tsx` (append to `projects`):

```ts
{
	title: "Example Project",
	techStack: ["Next.js", "TypeScript"],
	description: "Short description",
	link: { label: "GitHub", href: "https://github.com/your/repo" },
}
```

- Make an existing component client-side (when it uses state/effects/DOM):

```tsx
"use client";
import React, { useEffect } from "react";
// component code with useEffect or event handlers
```

- Add a simple UI primitive: create `src/components/ui/Label.tsx` and export it:

```tsx
export const Label = ({ children }: { children: React.ReactNode }) => (
  <span className="text-sm font-medium">{children}</span>
);
```

Then export from `src/components/ui/index` (follow existing index pattern).

**Formatting & Lint**

- Format and lint after edits:

```bash
yarn lint
npx prettier --write .
```

Note: project uses `prettier-plugin-tailwindcss` — run the formatter to keep class ordering consistent.

**Local dev tips & troubleshooting**

- Dev server: `http://localhost:3000`.
- If CSS/utility changes don't appear, restart the dev server — Tailwind can be cached by Next's dev server.
- Avatar images currently use direct `src` on `AvatarImage` (not `next/image`). If migrating to `next/image`, update imports and verify SSR behavior.

**Next.js 16 & React 19 specifics**

- App router files in `src/app` are server components by default — avoid client hooks unless you add `"use client";`.
- `tsconfig.json` defines `@/*` alias. Use `@/` imports for consistency.
- `package.json` lists `next@^16.0.10`, `react@^19.0.0`, and `react-dom@^19.1.0` — upgrading major versions may introduce breaking changes; test thoroughly when bumping.
- React 19 features: Use React Compiler optimizations when available, leverage improved hooks and transitions.
- Next.js 16: Takes advantage of improved bundle optimization, faster builds, and enhanced App Router stability.

**CI / Deployment notes**

- Vercel: the project is ready for Vercel; pushing to `main` or using the Vercel dashboard will deploy automatically with default settings.
- GitHub Actions: CI runs on every push/PR with `yarn build` and `yarn lint` (see `.github/workflows/ci.yml`).
- Dependabot: Automated dependency updates configured (see `.github/dependabot.yml`).
- Docker: Production-ready Dockerfile and docker-compose.yaml for self-hosting.

**Files to avoid changing (without coordination)**

- `src/data/resume-data.tsx`: central data shape — changing keys will break `page.tsx`.
- `src/app/layout.tsx`: contains analytics and speed-insights imports.

**Per-change validation checklist (for PRs / edits)**

- Run `yarn dev` and visually verify the change at `http://localhost:3000`.
- Run `npx prettier --write .` and `yarn lint`.
- Run a local production build to catch SSR/TypeScript issues: `yarn build`.
- Keep changes minimal and data-driven edits in `resume-data.tsx` when possible.

---

**Repository hygiene suggestions (optional tasks)**

- Add a simple GitHub Actions CI (added): `.github/workflows/ci.yml` runs `yarn install`, `yarn build`, and `yarn lint`.
- Add a PR template to remind contributors to run the validation checklist (added): `.github/PULL_REQUEST_TEMPLATE.md`.
- Add a short developer checklist `docs/DEV_CHECKLIST.md` (added) summarizing these steps.

---

## Automation & Workflows

**GitHub Actions workflows:**

- **CI (`.github/workflows/ci.yml`)**: Runs on every push/PR. Executes `yarn install --frozen-lockfile`, `yarn build`, and `yarn lint`. Required to pass before merging.
- **Deploy (`.github/workflows/deploy.yml`)**: Handles deployment to production (if configured).

**Dependabot configuration:**

- Updates Node.js dependencies daily using yarn ecosystem (see `.github/dependabot.yml`)
- Uses commit prefix `chore(deps)` for consistency

**Branch protection (recommended setup):**

- Require PR reviews before merging
- Require CI status checks to pass
- Keep branches up to date before merging

---

## Performance & Optimization Guidelines

**When making changes, always consider these performance best practices:**

### Bundle Optimization

- Use dynamic imports for large components that aren't immediately needed: `const Component = dynamic(() => import('./Component'))`
- Keep component files focused and single-purpose to enable better tree-shaking
- Import only what you need from libraries (e.g., `import { specificIcon } from 'lucide-react'` not `import * as Icons`)
- The `next.config.js` has `optimizePackageImports` configured for common libraries — add new heavy libraries there

### Image Optimization

- Always use Next.js `<Image>` component for images when possible (not applicable to avatar due to external URL)
- Supported formats: AVIF (preferred), WebP (fallback), then PNG/JPG
- Place images in `public/` or `src/images/` and import them
- For logos/icons: prefer SVG for vector graphics, PNG for raster images
- Lazy load images that are below the fold

### Metadata & SEO

- Always update both `page.tsx` metadata and root `layout.tsx` metadata when changing content
- Include OpenGraph and Twitter Card metadata for all pages
- Keep titles under 60 characters, descriptions under 160 characters
- Update `public/sitemap.xml` when adding new pages
- Use semantic HTML (`<header>`, `<main>`, `<section>`, `<article>`, etc.)

### Component Optimization

- Use `React.memo()` for components that receive stable props and render frequently (e.g., list items)
- Add `displayName` to memoized components for better debugging
- Prefer server components (default in app router) over client components
- Only use `"use client"` when you need: hooks, event handlers, browser APIs
- Extract static data to constants (see `RESUME_DATA`)

### CSS & Styling

- Prefer Tailwind utility classes over custom CSS
- Use CSS variables (in `globals.css` `@theme` block) for consistent theming
- Group related utilities: layout → spacing → colors → typography → effects
- Use print utilities (`print:hidden`, `print:block`) for print-specific styles
- The project uses Tailwind CSS 4 with `@theme` directive — don't mix with v3 patterns

### Code Quality

- Always add `rel="noopener noreferrer"` to external links (`target="_blank"`)
- Keep TypeScript strict mode enabled — fix type errors, don't suppress with `any`
- Use `as const` for static data to get precise type inference
- Prefer named exports over default exports (easier to refactor, better tree-shaking)
- Keep functions small and focused (single responsibility)

### Accessibility (a11y)

- All interactive elements must be keyboard accessible
- Use semantic HTML elements
- Add descriptive `alt` text to images
- Maintain color contrast ratios (WCAG AA minimum)
- Test with keyboard navigation (Tab, Enter, Escape)
- Radix UI components are accessible by default — preserve their props

### Testing & Validation Workflow

1. Make the change
2. Run `yarn lint` to check for issues
3. Run `yarn build` to verify production build works (when possible)
4. Test in browser at `localhost:3000`
5. Test print layout (Cmd/Ctrl+P)
6. Test responsive breakpoints (mobile, tablet, desktop)
7. Test keyboard navigation if you changed interactive elements

### Common Pitfalls to Avoid

- ❌ Don't use `any` type — use `unknown` or proper types
- ❌ Don't import entire icon libraries — import specific icons
- ❌ Don't add client components unnecessarily — server components are faster
- ❌ Don't skip `alt` text on images
- ❌ Don't forget `noopener noreferrer` on external links
- ❌ Don't modify `RESUME_DATA` shape without updating all usages in `page.tsx`
- ❌ Don't remove analytics (Plausible) without asking

### Security Best Practices

- Never commit API keys, tokens, or sensitive data (use `.env.example` as template)
- Validate and sanitize all user inputs (if you add forms)
- Use environment variables for configuration (not hardcoded)
- Keep dependencies updated regularly (Dependabot enabled)
- Always use `rel="noopener noreferrer"` on external links to prevent tabnabbing
- Review Dependabot security alerts promptly
- Use TypeScript strict mode to catch type-related security issues
- Avoid dangerouslySetInnerHTML; use proper React escaping

### When Adding New Features

1. Check if a similar component already exists in `src/components/ui/`
2. Follow the existing file structure and naming conventions
3. Add types in the same file or in a `types/` folder if shared
4. Consider mobile-first responsive design
5. Test the print layout if the feature is visible on page
6. Update this document if you add patterns others should follow
7. Prefer server components unless interactivity is needed
8. Use React 19 features (improved hooks, transitions) when applicable
9. Leverage Next.js 16 optimizations (turbopack in dev, improved caching)

### Quick Command Reference

```bash
# Development
yarn dev          # Start dev server (http://localhost:3000)
yarn build        # Production build + typecheck
yarn start        # Start production server
yarn lint         # Run ESLint

# Formatting
npx prettier --write .  # Format all files

# Docker
docker compose build    # Build container
docker compose up -d    # Run container
docker compose down     # Stop container
```

---

## Environment Variables & Configuration

**Analytics setup:**

- Uses Plausible Analytics via CDN script for privacy-focused analytics
- Configured in `src/app/layout.tsx` using Next.js Script component with `data-domain` attribute
- Script loads from `https://plausible.io/js/script.js` with `defer` and `afterInteractive` strategy
- Respects user privacy and doesn't require cookie consent in most jurisdictions

**Environment files:**

- `.env.example` provides template for required variables
- Create `.env.local` for local development (gitignored)
- Add production env vars in Vercel dashboard or deployment platform

**Next.js configuration (`next.config.js`):**

- `optimizePackageImports`: Pre-configured for common heavy libraries (lucide-react, etc.)
- Add new large dependencies here for better bundle optimization
- Uses TypeScript for type-safe config

**Tailwind configuration (`tailwind.config.js`):**

- Uses Tailwind CSS 4 with `@theme` directive in `globals.css`
- Custom print styles via `@media print` and utility classes
- Animations enabled via `tailwindcss-animate` plugin

**Interactive features:**

- **Command Menu** (`src/components/command-menu.tsx`): Client component using `cmdk`. Triggered with `⌘J` / `Ctrl+J`. Provides quick navigation to social links and site sections.
- **Print Drawer** (`src/components/print-drawer.tsx`): Client component using `vaul`. Provides print functionality via drawer UI.
- Both use Radix UI primitives for accessibility and keyboard navigation.

# Visionary Founder Overhaul Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reposition the public site around Allan B. Pedin IV as a visionary operator CEO expanding individual agency through coordinating technology.

**Architecture:** Keep the Docusaurus structure intact and overhaul the primary public surfaces: homepage hero, proof navigation cards, latest content framing, featured appearances, author metadata, and theme tokens. Add a lightweight source-content verification script so the CEO narrative remains explicit and older product-first positioning does not return.

**Tech Stack:** Docusaurus 3.10, React 19, TypeScript, CSS modules, Node validation scripts, npm typecheck/build.

---

### Task 1: Add Brand Narrative Guard

**Files:**
- Create: `content-site/scripts/check-visionary-brand-content.mjs`
- Modify: `content-site/package.json`

- [ ] **Step 1: Write the failing content check**

Create `content-site/scripts/check-visionary-brand-content.mjs` with checks for:

```javascript
import {readFileSync} from 'node:fs';
import {join} from 'node:path';

const files = [
  'src/components/HomeHero/index.tsx',
  'src/components/SectionCards/index.tsx',
  'src/components/LatestPosts/index.tsx',
  'src/pages/featured/index.tsx',
  'src/data/featured.ts',
  'authors.yml',
  'docusaurus.config.ts',
];

const content = files
  .map((file) => readFileSync(join(process.cwd(), file), 'utf8'))
  .join('\n');

const required = [
  'expanding individual agency',
  'coordinating technology',
  'Vision, execution, trust',
  'research, venture work, and public explanation',
  'CEO & Co-Founder | Visionary Operator',
];

const forbidden = [
  'Redefining the Internet to be: Intelligent, Transparent, Inclusive, Decentralized',
  'Tech First Entrepenuer',
];

const missing = required.filter((phrase) => !content.includes(phrase));
const presentForbidden = forbidden.filter((phrase) => content.includes(phrase));

if (missing.length || presentForbidden.length) {
  if (missing.length) {
    console.error(`Missing visionary founder phrases:\n- ${missing.join('\n- ')}`);
  }
  if (presentForbidden.length) {
    console.error(`Forbidden legacy phrases still present:\n- ${presentForbidden.join('\n- ')}`);
  }
  process.exit(1);
}
```

- [ ] **Step 2: Add npm script**

Add `"check:visionary-brand": "node scripts/check-visionary-brand-content.mjs"` to `content-site/package.json`.

- [ ] **Step 3: Verify red**

Run `npm run check:visionary-brand` from `content-site`.

Expected: FAIL because the current site lacks the new CEO narrative and still includes old positioning.

### Task 2: Rebuild Homepage Hero As CEO Thesis Surface

**Files:**
- Modify: `content-site/src/components/HomeHero/index.tsx`
- Modify: `content-site/src/components/HomeHero/styles.module.css`
- Modify: `content-site/src/pages/index.tsx`

- [ ] **Step 1: Replace hero copy and structure**

Update the hero so the first viewport contains:
- eyebrow: `Visionary Operator CEO`
- H1: `Allan B. Pedin IV`
- thesis: `Expanding individual agency through emerging technologies that help people and systems coordinate.`
- supporting paragraph focused on friction, access, trust, markets, systems, and institutions.
- proof chips: `Published AI research`, `Blockchain security research`, `CipherPlay / RANDAO founder`, `Public voice on Web3 trust`
- CTA pair: `Read the thesis` to `/insights` and `Review proof` to `/research`.
- founder portrait as a trust signal beside a restrained system-map motif.

- [ ] **Step 2: Replace hero styles**

Use a full-width, unframed hero with a deep near-black/navy background, cyan system accents, sparse amber proof accents, responsive two-column layout, high contrast text, and no oversized decorative card around the primary experience.

- [ ] **Step 3: Update page metadata**

Set homepage `Layout` description to `Allan B. Pedin IV builds emerging technology that expands individual agency through better coordination.`

### Task 3: Reframe Navigation Cards As Proof Paths

**Files:**
- Modify: `content-site/src/components/SectionCards/index.tsx`
- Modify: `content-site/src/components/SectionCards/styles.module.css`

- [ ] **Step 1: Replace card model**

Update section cards to show:
- `Research` as technical credibility across AI, blockchain security, voting, and decentralized infrastructure.
- `Featured Voice` as public explanation on RANDAO, randomness, Web3 trust, and founder-led growth.
- `Founder Notes` as reflections on moving from interesting technology to real customer problems.
- `Newsroom` as venture milestones and public updates.

- [ ] **Step 2: Add proof labels**

Add compact labels such as `Diligence signal`, `Public voice`, `Operator learning`, and `Venture proof` near titles.

- [ ] **Step 3: Restyle cards**

Use subtle proof tiles with 8px radius, cyan borders on hover, amber labels, and concise descriptions. Keep cards scannable and investor-oriented.

### Task 4: Rebuild Latest Content Framing

**Files:**
- Modify: `content-site/src/components/LatestPosts/index.tsx`
- Modify: `content-site/src/components/LatestPosts/styles.module.css`

- [ ] **Step 1: Remove inline styles**

Move `LatestPosts` styling from inline objects into the existing CSS module.

- [ ] **Step 2: Add narrative headings**

Frame latest sections as:
- `Research Proof`
- `Founder Notes`
- `Venture Updates`

Add one concise intro line: `Recent artifacts that show the thesis moving from research to execution.`

- [ ] **Step 3: Restyle latest cards**

Use compact cards with metadata, high-contrast links, and a proof-library feel that matches the homepage.

### Task 5: Update Featured Page And Appearance Copy

**Files:**
- Modify: `content-site/src/pages/featured/index.tsx`
- Modify: `content-site/src/pages/featured/styles.module.css`
- Modify: `content-site/src/data/featured.ts`
- Modify: `content-site/src/components/FeaturedCard/index.tsx`
- Modify: `content-site/src/components/FeaturedCard/styles.module.css`

- [ ] **Step 1: Update featured page positioning**

Change the page description from generic appearances to public explanation of technology, agency, coordination, randomness, trust, and founder-led growth.

- [ ] **Step 2: Update appearance descriptions**

Rewrite descriptions so each item supports the broader founder thesis instead of staying narrowly product-specific.

- [ ] **Step 3: Polish featured cards**

Use card labels and CTA language like `Watch / listen`, preserve accessible image alt text, and style cards as executive proof objects.

### Task 6: Update Global Narrative And Theme Tokens

**Files:**
- Modify: `content-site/docusaurus.config.ts`
- Modify: `content-site/authors.yml`
- Modify: `content-site/src/css/custom.css`

- [ ] **Step 1: Update site title and nav language**

Use `Allan B. Pedin IV` as the site title, keep `ABPIV` as compact navbar identity, and keep routes unchanged.

- [ ] **Step 2: Update author title**

Set author title to `CEO & Co-Founder | Visionary Operator`.

- [ ] **Step 3: Update color tokens**

Define a deeper CEO palette with near-black/navy surfaces, cyan active coordination accents, and restrained amber human-agency accents. Maintain strong text contrast.

### Task 7: Verify And Inspect

**Files:**
- Read: all modified files

- [ ] **Step 1: Run content guard**

Run `npm run check:visionary-brand` from `content-site`.

Expected: PASS.

- [ ] **Step 2: Run typecheck**

Run `npm run typecheck` from `content-site`.

Expected: PASS.

- [ ] **Step 3: Run production build**

Run `npm run build` from `content-site`.

Expected: PASS, allowing known Docusaurus warnings listed in `AGENTS.md`.

- [ ] **Step 4: Start local server and inspect in browser**

Run `npm run start` from `content-site`, open `http://localhost:3001/info/`, inspect desktop and mobile widths, and correct text overlap, contrast, or layout issues before reporting completion.

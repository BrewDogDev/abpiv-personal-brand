# ABPIV — Allan B. Pedin IV Personal Brand Design System

A design system for the personal brand of **Allan B. Pedin IV** (**ABPIV**) — a visionary founder positioned as a *Visionary Operator CEO*. It exists to produce premium, capital-worthy brand artifacts: marketing animations for social media, founder-thesis decks, the personal site, and proof-driven content for investors, partners, media, collaborators, talent, and technical audiences.

> **Primary brief / stated deliverable:** a *premium personal-brand marketing animation for social media*. This system is tuned for that first (see `ui_kits/social/`), then for the marketing site and slide artifacts.

---

## 1. Who / What

**Allan B. Pedin IV** — founder, researcher, operator.

- **Core positioning:** Expanding individual agency through emerging technologies that help people and systems coordinate.
- **Archetype:** Visionary Operator CEO — vision plus the discipline to ship.
- **Credibility signals (verbatim from source, do not embellish):**
  - Published AI & Blockchain Researcher
  - CipherPlay / RANDAO founder
  - Web3 Thought Leader
- **Operating thesis (3 pillars):** *Build, explain, earn trust.*
  - **Insight** — AI, blockchain, and spatial computing are changing how we interact with the world around us.
  - **Vision** — A new age of technology should expand human capability and make systems easier to navigate.
  - **Execution** — Bringing that future closer through systems people can use, trust, and build on.
- **Audience priority order:** Investors → partners → media → collaborators → talent → technical audiences.

### Surfaces / "products"
1. **The personal site** — `allanbpediniv.com/info/` — a calm, executive content hub. Three content rails: **Insights** (short essays), **News & Publications** (launch notes, research papers, updates), **Featured On** (podcasts, interviews, conference appearances). Recreated in `ui_kits/site/`.
2. **Social marketing animations** — the headline deliverable: short, premium, directional motion pieces leading with a hook/thesis, supported by 1–3 proof signals, closing on the ABPIV wordmark. Built in `ui_kits/social/`.

### Real, verifiable facts only (content guardrails)
Do **not** invent claims, traction, customers, partners, investors, revenue, or metrics. The known true signals are the credibility lines above, the three pillars, the published research topics (*truly random number generation for decentralized applications*; *digital asset ownership, recovery & smart-contract security*), and public appearances on randomness / Web3 trust / founder-led growth. Channels: GitHub `BrewDogDev`, X `@AllanRANDAO`, LinkedIn `allan-b-pedin-iv`, plus HackerNoon, Crunchbase, F6S, YouTube `@AllanBPedinIV`.

---

## 2. Sources

These are the materials this system was derived from. The reader may or may not have access — links stored for provenance.

- **Live site:** https://allanbpediniv.com/info/ (Docusaurus-based content hub). Copy, structure, link graph, and the headshot were pulled from here.
- **Brand brief:** the look-and-feel / motion / content brief supplied with the project request (deep navy canvas, cyan systems accent, sparse amber human-agency accent, restrained directional motion). This brief is the **design intent source of truth** — the live site is plain Docusaurus and does *not* yet reflect this premium direction, so the visuals here are built to the brief, not copied from the live site.
- **Asset pulled:** `assets/headshot.png` (the public headshot from the site).

> ⚠️ **No codebase or Figma file was provided.** UI in this system is built to the written brand brief, not reverse-engineered from production code or a Figma library. If a real codebase/Figma exists, re-attach it so the UI kits can be made pixel-accurate.

---

## 3. CONTENT FUNDAMENTALS

How ABPIV writes. Match this voice in every artifact.

- **Voice:** visionary but grounded; an operator who builds *and* explains. Confident, never hype. The throughline is **trust earned through clarity** — "Build, explain, earn trust."
- **Person:** third person for the brand frame ("Allan connects published research…"), first-person-plural for the thesis ("how *we* interact with the world"). Avoid "I". Address the reader implicitly, rarely with "you".
- **Sentence shape:** short, declarative, load-bearing. One idea per line. Verbs of building and coordinating: *expand, connect, build, explain, evaluate, navigate, trust, coordinate*.
- **Casing:** Sentence case for headlines and body. Title Case only for proper section names (Insights, News & Publications, Featured On). UPPERCASE reserved for monospace eyebrows/meta chips.
- **Numbers & labels:** sections are numbered as zero-padded monospace indices (`01`, `02`, `03`). Dates are plain and human (`Apr 30, 2026`).
- **Emoji:** **none.** Not part of the brand. Do not introduce them.
- **Punctuation:** minimal. No exclamation marks. Em-dashes for asides. Arrows (`->`) as quiet "continue" affordances ("Read insights ->", "Explore ->").
- **What it is NOT:** not a crypto-influencer pitch, not an academic abstract, not generic AI-startup copy. No buzzword stacking, no rocket-ship energy, no "revolutionary/disruptive".

**Verbatim examples to echo (tone reference):**
- Hook: *"Expanding individual agency through emerging technologies that help people and systems coordinate."*
- Thesis tagline: *"Build, explain, earn trust."*
- Pillar copy: *"A new age of technology should expand human capability and make systems easier to navigate."*
- Quiet CTA: *"Explore the work"* / *"Start here"* / *"Read the notes"*

---

## 4. VISUAL FOUNDATIONS

The look: a **capital-worthy founder thesis** rendered as a quiet, technical executive interface. See `colors_and_type.css` for the exact tokens.

### Canvas & color
- **Background:** deep near-black **navy**, not pure black — `--bg-0 #070B14`, deepening to `--bg-void #04070D` for letterbox/outer fields, rising to cool panels `--bg-1/2/3`. Seriousness, focus, technical credibility. Backgrounds are flat or carry a *very* subtle radial cyan lift; never loud gradients.
- **Cyan** (`--cyan #2CC8DC`, bright `#5FE6F4`) = intelligence, systems, coordination, active movement. Used for route/signal lines, eyebrows, links, the moving/aligning parts.
- **Amber** (`--amber #F4A63C`) = human agency, trust, emphasis. **Sparse** — one amber moment per frame at most: the destination node, the single emphasized word, a key proof.
- **Text:** high-contrast light — `--fg-0 #F3F7FC` headings, `--fg-1` body, `--fg-2` meta, `--fg-3` faint.
- **Ratio discipline:** ~90% navy + light text, ~8% cyan, ≤2% amber. Amber must always feel earned.

### Typography
- **Sans (display + body):** **Schibsted Grotesk** — confident modern grotesque, editorial, less overused than Inter/Roboto. Display weight 800 at `-0.03em` tracking, tight 0.98 line-height; body 400.
- **Mono:** **IBM Plex Mono** — *only* for small proof chips, research signals, protocol details, section indices, and technical metadata. Never for body.
- Strong hierarchy, big jumps between display and body. Eyebrows are uppercase mono with wide `0.18em` tracking.

### Backgrounds & texture
- No photographic backgrounds behind text. The headshot is used **as-is — full color, no duotone or desaturation** (per brand preference); frame it with a hairline border + radius, with a subtle navy bottom scrim only where text overlays. Optional faint **system-map** texture: thin cyan route lines, alignment grids, signal traces at 6–14% opacity — structural, never decorative node-spam.
- No glow soup, no particle fields, no purple gradients.

### Motion
- **Restrained, directional, premium, readable.** Things *align*, *resolve*, *reveal*. Routes draw in (stroke-dashoffset), proof chips fade-and-rise, parts converge to a node, the amber emphasis gives a single soft pulse.
- Easing: `--ease-out cubic-bezier(0.22,1,0.36,1)` for settles. Durations 160–640ms. Stagger reveals ~60–90ms apart.
- **Avoid:** constant ambient motion, excessive particles, generic AI glow, decorative node spam, hypey transitions, unreadable kinetic text.

### Surfaces, borders, elevation
- **Cards/panels:** `--bg-2`, hairline border `--line` (cool, low-alpha), radius `--r-md 12px` (chips use `--r-pill`). Shadows are cool-cast and restrained; cyan/amber "glow" shadows exist as `--shadow-cyan/amber` but are used rarely for the focal object only.
- **Borders** do most of the structural work, not shadows — this is an interface aesthetic.

### States
- **Hover:** lift to `--bg-3`, border → `--line-strong`, cyan text brightens to `--cyan-bright`. Subtle, ~160ms.
- **Press:** scale 0.98, no color flash.
- **Focus:** 2px cyan ring at low alpha.
- **Transparency/blur:** used sparingly for sticky nav (navy at ~70% + backdrop-blur) and overlay scrims; not as decoration.

### Layout
- Generous margins, executive whitespace, strong left-alignment. Content sits on a clear grid. Zero-padded numeric section markers. Fixed/sticky top nav; everything else flows.

---

## 5. ICONOGRAPHY

- **No icon set ships on the live site** (it is plain Docusaurus content). This system standardizes on **Lucide** (https://lucide.dev) loaded from CDN — thin **1.75px stroke**, rounded caps/joins. Lucide matches the brand's clean, technical, geometric line language and pairs with the cyan route-line motif. *(Substitution flagged: not pulled from a real ABPIV codebase — swap for the production set if one exists.)*
- **Stroke / fill:** strokes only, no filled icons. Color: `--fg-2` at rest, `--cyan` when active/accent, `--amber` only on a single emphasized affordance.
- **Brand device:** the brand mark is **typographic** — the `ABPIV` lettermark / `Allan B. Pedin IV` wordmark in Schibsted Grotesk 800, single color (light on dark). No pictorial glyph. `assets/favicon.svg` is a minimal navy tile with an `AP` monogram + cyan baseline, used only as favicon/app icon.
- **Arrows:** the quiet `->` continue affordance is text/Lucide `arrow-right`, never a heavy button glyph.
- **Emoji / unicode-as-icon:** not used. Do not introduce.
- **Wordmark:** typographic, set in Schibsted Grotesk 800. `ABPIV` (compact) and `Allan B. Pedin IV` (full). See the Brand cards in `preview/`.

---

## 6. INDEX / MANIFEST

Root files:
- `README.md` — this file.
- `colors_and_type.css` — all color + type tokens (foundational and semantic). Import this everywhere.
- `SKILL.md` — Agent-Skills-compatible entry point.
- `fonts/` — self-hosted woff2 (Schibsted Grotesk 400–800, IBM Plex Mono 400–600).
- `assets/` — `headshot.png`, `favicon.svg` (AP monogram tile for favicon/app icon).
- `preview/` — Design System tab cards (colors, type, spacing, components, brand).

UI kits:
- `ui_kits/site/` — recreation of the ABPIV personal site in the premium brand language (nav, hero, three-pillar thesis, work rails, footer). `index.html` is the interactive landing.
- `ui_kits/social/` — the headline deliverable: premium social marketing **animation** frames (hook → proof → wordmark), with playback controls.

> Each `ui_kits/<surface>/` has its own `README.md` documenting components.

---

## 7. CAVEATS

- Built to the **written brand brief**, not a real codebase or Figma — re-attach those for pixel accuracy.
- **Fonts substituted** to the nearest premium grotesque (Schibsted Grotesk) + technical mono (IBM Plex Mono); both self-hosted. If brand fonts are licensed, drop the woff2s into `fonts/` and rewire `@font-face`.
- **Icons substituted** to Lucide (CDN) — swap if a production set exists.
- The headshot is the only real brand image; no logo file existed, so the brand mark is purely typographic (ABPIV lettermark / wordmark) and `favicon.svg` is a minimal AP-monogram tile.

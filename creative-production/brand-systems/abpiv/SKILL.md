---
name: abpiv-design
description: Use this skill to generate well-branded interfaces and assets for ABPIV (Allan B. Pedin IV) — a visionary-operator founder personal brand — for production or throwaway prototypes/mocks/social animations. Contains essential design guidelines, colors, type, fonts, assets, and UI kit components for prototyping.
user-invocable: true
---

Read the `README.md` file within this skill, and explore the other available files.

For Creative Production workflows, also read `CREATIVE_PRODUCTION.md`, `creative-production.manifest.json`, `prompt-contract.md`, and `style-intake.json`. They adapt this design system into the plugin's Explore, Mood boards, Scenes, Offers, Ads, Shots, Logos, and Assets paths.

If creating visual artifacts (slides, mocks, throwaway prototypes, social animations, etc), copy assets out and create static HTML files for the user to view. If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand.

If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.

## Fast orientation
- **Brand:** Allan B. Pedin IV / ABPIV — "Visionary Operator CEO". Positioning: *expanding individual agency through emerging technologies that help people and systems coordinate.* Thesis: **Build, explain, earn trust** (Insight · Vision · Execution).
- **Look:** deep navy-black canvas, **cyan** systems accent, **sparse amber** human-agency accent, high-contrast light text, Schibsted Grotesk display + IBM Plex Mono for chips/metadata only.
- **Audience:** investors first, then partners, media, collaborators, talent, technical.
- **Do not invent** claims, traction, customers, partners, investors, revenue, or metrics. Use only the verifiable signals in `README.md`.

## Files
- `colors_and_type.css` — import this for all tokens (color, type, spacing, radii, shadow, motion) + semantic classes. Self-hosted fonts in `fonts/`.
- `README.md` — full content fundamentals, visual foundations, iconography.
- `assets/` — `headshot.png`, `favicon.svg` (AP monogram tile). The brand mark is typographic (ABPIV lettermark / wordmark) — no pictorial glyph.
- `preview/` — token + component cards (reference).
- `ui_kits/site/` — personal-site components (Nav, Hero, Thesis, Work, Footer, Chip).
- `ui_kits/social/` — the marketing-animation engine + scenes (the headline format).

## Rules of thumb
- Amber is precious: one emphasis per frame, max. Cyan carries everything that coordinates/moves.
- Mono is for proof chips, indices, and technical metadata only — never body.
- Motion is restrained and directional: things align, resolve, reveal. No ambient particle noise, no glow soup, no emoji.

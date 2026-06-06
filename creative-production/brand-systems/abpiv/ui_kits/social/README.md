# Social Marketing Animation — Allan B. Pedin IV

The headline deliverable: a premium, restrained personal-brand marketing **animation** for social media (4:5 portrait, **1080×1350**, loops ~15.2s). Built on the `animations.jsx` timeline engine.

## Run
Open `index.html`. Space = play/pause · ←/→ seek (Shift = 1s) · 0 = reset. The playhead persists across reloads.

## Narrative arc (per the brand brief)
Lead with the hook → support with 1–3 proof signals → close on the wordmark.
1. **Hook** — "Expanding individual **agency**." (agency in amber = human agency) over cyan route lines resolving to an amber node.
2. **Proof** — three verifiable signals revealed along drawn route lines: Published AI & Blockchain Researcher · CipherPlay / RANDAO founder · Web3 Thought Leader.
3. **Thesis** — "Build, explain, **earn trust.**" with Insight / Vision / Execution aligning onto one route, amber node at the end.
4. **Close** — coordination mark → "Allan B. Pedin **IV**" wordmark → amber underline pulse → `ABPIV · allanbpediniv.com`.

## Files
- `animations.jsx` — timeline engine (Stage / Sprite / Easing). Starter, unmodified.
- `primitives.jsx` — brand motion helpers: `Anim` (entry/exit fade-up), `RouteLine` (self-drawing path), `Node` (pop + pulse), `Eyebrow`.
- `scenes.jsx` — `BackgroundField` (faint parallax system map), `Chrome` (persistent ABPIV tag + scene dots), the four scenes, and `MarketingFilm` (the Stage).

## Motion rules honored
Restrained & directional: routes draw in, proof rises, parts converge to a node, one amber pulse per scene. No ambient particle noise, no glow soup, no kinetic text. Easing is `easeOutCubic`/`easeOutBack` for premium settle.

## Reusing / re-cutting
Change copy in the scene arrays (`PROOF`, `PILLARS`) and the scene `start/end` windows in `scenes.jsx`. Keep amber to one emphasis per scene. For other formats, change `W`/`H` and `Stage` dims (1:1 → 1080×1080, story → 1080×1920) and re-flow the y-coordinates.

## Export to video
Screen-record the looping canvas, or capture frames via the scrubber. (No built-in encoder.)

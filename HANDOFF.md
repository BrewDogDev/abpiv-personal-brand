# Handoff

## Goal

Integrate the approved Intent-First Navigator visual brand strategy into the Allan B. Pedin IV personal brand site. The immediate goal is a homepage-first refresh that makes investors remember Allan as the pathfinder for intent-first commerce, then quickly shows enough proof to believe the thesis.

## Current Progress

- Brand strategy spec exists at `docs/superpowers/specs/2026-05-29-intent-first-commerce-brand-design.md`.
- The approved visual direction is **A. Intent-First Navigator**.
- Investor-conversion stack is: **Memorability -> Diligence Belief -> Human Confidence**.
- Recommended integration scope is homepage-first with reusable tokens for later site-wide rollout.
- Current homepage implementation lives mainly in:
  - `content-site/src/components/HomeHero/index.tsx`
  - `content-site/src/components/HomeHero/styles.module.css`
  - `content-site/src/css/custom.css`
  - `content-site/src/pages/index.tsx`
- Existing site look is dark Docusaurus, bright blue accents, centered founder-card hero, circular headshot, and generic section cards.
- Accessible visual reference mockup was preserved at `docs/superpowers/specs/2026-05-29-intent-first-commerce-visual-reference.html`.

## What Worked

- Leading with the category thesis should convert more investors than leading with technical proof alone.
- The strongest investor path is:
  1. Make the thesis memorable: intent-first commerce, destination/journey language, route/path motif.
  2. Place proof nearby: AI research, blockchain/security research, RANDAO, founder execution, public appearances.
  3. Add human confidence: founder portrait, clear voice, visible judgment.
- Deep navy, cyan, and sparing warm amber support the brand: serious, intelligent, human-directed.
- Thin path and route cues work better than heavy visual metaphors.
- Proof chips or proof tiles are important because the thesis can sound speculative if proof is not visible quickly.

## What Didn't Work

- A prior visual mockup used a large white diagonal hero shape. It looked conceptually aligned but hurt readability and accessibility.
- Do not use large light shapes behind important hero text.
- Do not let the brand lead with generic Web3, AI glow, crypto-grid aesthetics, or pure research/protocol visuals.
- Do not make Allan's headshot the entire brand idea. Use it as trust support after the thesis is clear.

## Next Steps

1. Update the homepage hero to lead with:
   - Kicker: `Intent-first commerce`
   - Headline: `Humans state the destination.`
   - Supporting copy: Allan builds emerging technology for a future where people express outcomes and intelligent systems coordinate market activity needed to make them happen.
2. Add a proof strip near the hero with confirmed-public proof points such as AI research, blockchain/security research, RANDAO, and founder execution.
3. Replace the large gradient-card hero with a high-contrast editorial hero using the Intent-First Navigator system.
4. Introduce reusable CSS tokens in `content-site/src/css/custom.css` for deep navy, cyan, amber, surface, muted text, and border colors.
5. Implement the route/path motif as a subtle decorative accent. Keep it secondary and accessible.
6. Update section cards so Research, Featured, Insights, and Newsroom reinforce the new belief order: thesis, proof, voice, updates.
7. Run local verification from `content-site`:
   - `npm run typecheck`
   - `npm run build`
8. Use the in-app browser to verify desktop and mobile readability, especially hero contrast, text wrapping, and proof-chip layout.

## Important References

- Brand strategy spec: `docs/superpowers/specs/2026-05-29-intent-first-commerce-brand-design.md`
- Current hero component: `content-site/src/components/HomeHero/index.tsx`
- Current hero styles: `content-site/src/components/HomeHero/styles.module.css`
- Global theme CSS: `content-site/src/css/custom.css`
- Project guidance: `AGENTS.md`

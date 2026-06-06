# Site UI Kit — Allan B. Pedin IV

A high-fidelity recreation of the ABPIV personal site, rebuilt in the premium brand language (deep navy canvas, cyan systems accent, sparse amber). Content is sourced verbatim from `allanbpediniv.com/info/` — see `data.js`. The live site is plain Docusaurus; this kit applies the brand brief's intended direction.

## Run
Open `index.html`. React + Babel via CDN; imports `../../colors_and_type.css` and `../../assets/`.

## Components (`components.jsx`)
- **`Nav`** — sticky blurred top nav, wordmark + mark, section links, "Start here" CTA.
- **`Hero`** — eyebrow → display headline (cyan accent word) → lede → CTAs → proof chips, with a treated duotone portrait and animated cyan route lines (`HeroRoutes`) resolving to an amber node.
- **`Thesis`** — the three pillars (Insight / Vision / Execution) under the "Build, explain, earn trust" eyebrow.
- **`Work`** — tabbed work rails (Insights / News & Publications / Featured On) rendering work cards; tabs filter the grid.
- **`SubscribeBand`** — email field with validating subscribe (fake) state.
- **`Footer`** — full wordmark, tagline, link columns, copyright.
- **`Chip`** — proof / signal chip (cyan default, amber variant).

## Data
`data.js` → `window.ABPIV_DATA`. All copy is real and verifiable — do not invent traction, metrics, partners, or investors.

## Interactions
- Nav + footer links scroll to and switch the Work tab.
- Work tabs swap the card grid.
- Subscribe validates an `@` and shows a confirmation chip.

## Notes
- Built to the brand brief, not a production codebase. Re-attach real source for pixel accuracy.
- Icons: none required here; the arrow `→` is plain text. Use Lucide (CDN) if more are needed.

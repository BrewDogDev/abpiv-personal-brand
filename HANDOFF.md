# Handoff

## Goal

Incorporate the Visionary Founder / CEO narrative overhaul into `abpiv-personal-brand-clone`, using the spec at `docs/superpowers/specs/2026-05-30-visionary-founder-brand-design.md`.

The site should feel like a serious founder/operator profile: strong enough for investors, technical peers, media, and collaborators, but not bloated with brand jargon. The current navigation priority is:

`Insights` -> `News & Publications` -> `Featured On`

Research and newsroom content should now be presented as one combined `News & Publications` surface and one combined RSS feed.

## Current Progress

- Visual overhaul has been implemented across the Docusaurus `content-site`.
- Homepage hero now leads with Allan B. Pedin IV, founder/CEO positioning, proof chips, headshot, and a darker editorial visual system.
- Top bar has been reordered and simplified:
  - `Insights`
  - `News & Publications`
  - `Featured On`
- The old standalone `Research` and `Newsroom` nav entries were removed from primary navigation.
- A new combined page exists at `content-site/src/pages/news-publications/`.
- Research/news feed generation is consolidated through `content-site/plugins/news-publications-feed/`.
- Individual Docusaurus blog RSS feeds were disabled in `content-site/docusaurus.config.ts`; the remaining combined feed is `/info/news-publications/rss.xml`.
- Publication titles were renamed for broader audience clarity:
  - `RANDAO White Paper V1` -> `Truly Random Number Generation`
  - `Smart Contract Social Recovery Wallet` -> `Digital Asset Ownership`
  - `Secure Decentralized Anonymous E-voting` -> `Secure Digital Voting`
  - `Predicting Road Quality Using High Resolution Satellite Imagery: A Transfer Learning Approach` -> `Artificially Intelligent Satellite Imagery Classification`
- The hero signal language was softened and updated around AI, blockchain, spatial computing, human capability, and future-facing execution.
- A content guard script exists at `content-site/scripts/check-visionary-brand-content.mjs`.
- A mobile sidebar fallback client module was added at `content-site/src/clientModules/mobileSidebarFallback.js` and registered in `content-site/docusaurus.config.ts`.

Important changed areas:

- `content-site/src/components/HomeHero/`
- `content-site/src/components/SectionCards/`
- `content-site/src/components/LatestPosts/`
- `content-site/src/components/FeaturedCard/`
- `content-site/src/pages/index.tsx`
- `content-site/src/pages/featured/`
- `content-site/src/pages/news-publications/`
- `content-site/src/css/custom.css`
- `content-site/docusaurus.config.ts`
- `content-site/research/*.mdx`
- `content-site/newsroom/*.mdx`
- `content-site/plugins/news-publications-feed/`
- `content-site/src/utils/`

## What Worked

- Combining research and newsroom into `News & Publications` makes the site simpler and matches the user's direction.
- One combined RSS feed works; route check returned HTTP `200` for `/info/news-publications/rss.xml`.
- The renamed publication titles read better for a general founder/investor/media audience than the original paper-style titles.
- The News & Publications layout is responsive:
  - desktop: three-card grid
  - tablet: two-card grid
  - mobile: single-card feed
- The current page keeps direct links into source material while avoiding separate research/news silos.
- The darker founder narrative system is visually stronger than the previous generic Docusaurus presentation.
- Verification passed from `content-site`:
  - `npm run check:visionary-brand`
  - `npm run typecheck`
  - `npm run build`
  - `git diff --check`
- Local HTTP checks returned `200` for:
  - `/info/`
  - `/info/news-publications`
  - `/info/featured`
  - `/info/insights`
  - `/info/news-publications/rss.xml`

## What Didn't Work

- The earlier homepage copy drifted too far into "branding terminology." The user specifically asked to reduce that, so keep language concrete and founder/proof oriented.
- Docusaurus `docusaurus serve` and `docusaurus start` were unreliable in the sandbox during QA. A small local static server was used against `content-site/build` instead.
- The in-app browser currently has a transparent comment overlay from prior visual comments. It can intercept pointer clicks, so hamburger-menu click testing there is not fully trustworthy.
- Screenshot capture began timing out after several browser QA passes, although existing screenshots were saved under `/private/tmp/`.
- The mobile hamburger/touch target is still visually around `30x30`, below the ideal `44x44`.
- Footer social icon targets are also below ideal touch size.
- `/info/insights` is the stock Docusaurus blog listing and currently has no visible `h1`.
- Some internal elements report scroll-width overflow, mostly decorative route-line elements and stock Docusaurus blog headers, but document-level horizontal overflow stayed false at tested breakpoints.
- Docusaurus build warnings remain:
  - missing default `blogDir`
  - undefined tags `entrepreneurship` and `randao`
  - update-check permission warning under `/Users/user/.config`

## Next Steps

1. Decide whether to keep or remove legacy routes:
   - `/info/research`
   - `/info/newsroom`
   They are no longer in top navigation, but Docusaurus still builds them because the content plugins remain active.
2. Improve touch targets:
   - mobile hamburger
   - search input/button
   - footer social icons
   - small text links such as `View all ->`
3. Add a proper visible `h1` or custom listing shell for `/info/insights`.
4. Re-test hamburger menu in a clean browser session without the in-app comment overlay.
5. Consider adding redirects from old `research` and `newsroom` index routes to `/news-publications` if the goal is true repo-level consolidation.
6. Keep copy concrete. Prefer:
   - what Allan built
   - what the work proves
   - why the technologies matter
   Avoid repeated abstract labels like "visionary," "operator," "trust," and "execution" unless they are doing real work on the page.
7. Re-run verification from `content-site` before handoff/commit:
   - `npm run check:visionary-brand`
   - `npm run typecheck`
   - `npm run build`
   - `git diff --check`

## Useful QA Artifacts

Screenshots from the latest responsive pass:

- `/private/tmp/abpiv-qa-desktop-news-publications.png`
- `/private/tmp/abpiv-qa-tablet-news-publications.png`
- `/private/tmp/abpiv-qa-mobile-news-publications.png`
- `/private/tmp/abpiv-qa-mobile-home.png`

The local static server used for the last QA run served `content-site/build` at:

`http://127.0.0.1:52741/info/`

If that port is stale, rebuild from `content-site` and restart a local server before browser QA.

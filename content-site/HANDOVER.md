# Personal Brand Content Site — Implementation Handover

**Location:** `W:\code\abpiv-personal-brand\content-site\`
**Status:** Build passes, deployment-ready after placeholder replacement.
**Last updated:** 2026-04-30

---

## What Was Built

### Architecture

A Docusaurus v3 (TypeScript) personal brand site with **four content sections**:

| Route | Plugin | Notes |
|-------|--------|-------|
| `/research` | `@docusaurus/plugin-content-blog` (id: `research`) | Long-form blog, RSS at `/research/rss.xml` |
| `/insights` | `@docusaurus/plugin-content-blog` (id: `default`) | Default blog slot, RSS at `/insights/rss.xml` |
| `/newsroom` | `@docusaurus/plugin-content-blog` (id: `newsroom`) | Announcements blog, RSS at `/newsroom/rss.xml` |
| `/featured` | Custom React page `src/pages/featured/index.tsx` | Showcase grid with tag filter, search, URL-reflected state |
| `/about` | MDX page `src/pages/about.mdx` | Bio page |
| `/` | Custom `src/pages/index.tsx` | Homepage: Hero + SectionCards + LatestPosts |

### Key Implementation Details

**Docusaurus config** (`docusaurus.config.ts`):
- `docs: false` in preset, BUT a stub docs plugin is needed to prevent `@easyops-cn/docusaurus-search-local` from crashing during SSG (it calls `useDocsData` internally). This is why there's a `docs/placeholder.md` and `docs/sidebars.js`. The docs route is hidden via `routeBasePath: 'none'`.
- Three blog plugins registered via `plugins` array (not preset — preset only holds the default/insights instance).
- `onBrokenLinks: 'warn'` (not `throw`) because footer RSS links are not recognized as valid static files by Docusaurus (they exist at build time but the checker doesn't see them).
- `trailingSlash: false` for GitHub Pages compatibility.

**Search** (`@easyops-cn/docusaurus-search-local`):
- Registered as a plugin (not theme — the package's client code ships its own SearchBar component that gets swizzled).
- `indexBlog: true`, `blogRouteBasePath: ['/research', '/insights', '/newsroom']` — indexes all three blog instances.
- `indexDocs: false` (docs are hidden anyway).

**Analytics** (`docusaurus-plugin-plausible`):
- Requires `domain` option — placeholder `your-domain.com` is used. Plugin only emits events when the deployed hostname matches the configured domain, so dev builds are safe.

**Blog URL structure**:
- Default blog post URLs are `/routeBasePath/YYYY/MM/DD/slug`.
- `slug:` frontmatter on every post overrides this to `/routeBasePath/<slug>`.
- All three seed posts use `slug:` to demonstrate clean URLs (e.g., `/research/intro`).

**Homepage LatestPosts** (`src/components/LatestPosts/index.tsx`):
- Uses `useGlobalData()` to access `docusaurus-plugin-content-blog-instance-<id>` for each blog instance.
- Keys: `research`, `default` (for insights), `newsroom`.

---

## File Structure

```
content-site/
├── .github/workflows/deploy.yml    # GitHub Pages deploy
├── docs/
│   ├── placeholder.md                # Stub doc (satisfies docs plugin)
│   └── sidebars.js                  # Empty sidebar array
├── insights/                        # Default blog instance
│   ├── 2026-04-30-welcome.mdx
│   ├── authors.yml
│   └── tags.yml
├── newsroom/                        # Newsroom blog instance
│   ├── 2026-04-30-site-launch.mdx
│   ├── authors.yml
│   └── tags.yml
├── research/                        # Research blog instance
│   ├── 2026-04-30-intro.mdx
│   ├── authors.yml
│   └── tags.yml
├── src/
│   ├── components/
│   │   ├── FeaturedCard/            # Card for featured page
│   │   ├── FeaturedFilters/         # Tag multi-select + search bar
│   │   ├── HomeHero/                # Hero section
│   │   ├── LatestPosts/             # Homepage latest posts (3 feeds)
│   │   └── SectionCards/            # Four section cards
│   ├── data/
│   │   ├── featured.ts              # Featured item data (add real items here)
│   │   └── featuredTags.ts          # Tag definitions (11 tag types)
│   ├── pages/
│   │   ├── about.mdx                # Bio page
│   │   ├── featured/
│   │   │   ├── index.tsx            # Showcase page
│   │   │   └── styles.module.css
│   │   └── index.tsx                # Homepage
│   └── css/custom.css               # Brand palette + GitHub icon CSS
├── static/img/
│   ├── featured/                    # Add featured item screenshots here
│   │   └── placeholder.svg          # Remove and add real images
│   ├── logo.svg                     # Replace with actual logo
│   └── social-card.png              # Replace with actual social card
├── docusaurus.config.ts             # Main config (replace TODOs)
├── package.json
└── tsconfig.json
```

---

## Remaining Work

### High Priority (before first deploy)

1. **Replace all `TODO:` placeholders** in `docusaurus.config.ts`:
   - `title`, `tagline` (site metadata)
   - `url` (e.g., `https://your-domain.com`)
   - `organizationName` (your GitHub org/user)
   - Plausible `domain` (your actual domain)
   - Navbar GitHub link href
   - Footer social links

2. **Replace `TODO:` placeholders** in `src/css/custom.css`:
   - Brand primary color palette (currently uses default green Docusaurus theme)

3. **Replace placeholder assets** in `static/img/`:
   - `logo.svg` — your logo
   - `social-card.png` — OG image
   - `featured/placeholder.svg` — remove and add real featured item screenshots

4. **Add real featured items** to `src/data/featured.ts`:
   - Replace the single placeholder `FeaturedItem` with real appearances
   - Add screenshots/logos to `static/img/featured/`

5. **Deploy decision — `baseUrl`:**
   - If deploying to custom apex domain → keep `baseUrl: '/'`
   - If deploying to `https://<user>.github.io/abpiv-personal-brand/` → change to `baseUrl: '/abpiv-personal-brand/'`

### Medium Priority (before public launch)

6. **Write real bio** in `src/pages/about.mdx`

7. **Add real author info** to all three `authors.yml` files (they currently have placeholder values):
   - `research/authors.yml`
   - `insights/authors.yml`
   - `newsroom/authors.yml`

8. **Add more seed content** — currently there's 1 post per blog:
   - More research posts (long-form studies)
   - More insights posts
   - More newsroom posts

9. **Add `static/CNAME`** when custom domain is confirmed

10. **Configure RSS metadata** — verify feed titles/descriptions are correct

### Lower Priority (future improvements)

11. **Add truncation markers** (`<!-- truncate -->`) to blog posts if you want shorter previews on listing pages (current warnings about this are safe to ignore with `onUntruncatedBlogPosts: 'warn'`)

12. **Suppress author warnings** — if you use the same author key across all three `authors.yml` files and reference them properly in frontmatter, the warnings go away. Currently using `author: default` in frontmatter matching the `default:` key in each authors file.

13. **Delete `docs/placeholder.md`** once you have real docs or once the search plugin is fixed (the placeholder exists because the docs plugin requires at least one doc to load)

14. **Consider Algolia DocSearch** — local search is functional; Algolia is the upgrade path noted in the plan

15. **Add Giscus comments** to blog posts (plan deferred this for v1)

---

## Known Issues / Notes

- **Footer RSS links generate `onBrokenLinks` warnings** but do work at runtime — the RSS files are generated during build. The warning is a Docusaurus SSG limitation where it doesn't recognize that `to: '/research/rss.xml'` resolves to a real file.

- **Stub docs plugin** is required because `@easyops-cn/docusaurus-search-local` internally calls `useDocsData` from `@docusaurus/plugin-content-docs/client`. Without a docs plugin registered, the search bar crashes during SSG. The docs route is hidden via `routeBasePath: 'none'`.

- **`onBrokenMarkdownLinks` is deprecated** — Docusaurus v4 will require moving this to `siteConfig.markdown.hooks.onBrokenMarkdownLinks`. The current config still works but generates a deprecation warning.

- **The `blogDir` warning** ("blogDir doesn't exist") is harmless — it refers to the old default blog path that was renamed to `insights/`.

---

## Commands

```bash
# Development server
cd content-site && npm start

# Production build
cd content-site && npm run build

# Type check
cd content-site && npm run typecheck

# Serve built site locally
cd content-site && npm run serve

# Clear cache
cd content-site && npm run clear
```

---

## References

- Plan file: `.kilo/plans/1777572573826-mighty-cactus.md`
- Docusaurus docs: https://docusaurus.io/docs
- `@easyops-cn/docusaurus-search-local`: https://github.com/easyops-cn/docusaurus-search-local
- `docusaurus-plugin-plausible`: https://github.com/facebook/docusaurus/tree/main/packages/docusaurus-plugin-plausible
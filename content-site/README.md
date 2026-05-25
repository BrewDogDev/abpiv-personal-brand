# Personal Brand Content Site - Documentation

## Overview

This is a Docusaurus v3 (TypeScript) personal brand site located in `content-site/`. It serves as a hub for showcasing work across multiple content sections.

---

## Architecture

### Routes & Plugins

| Route       | Plugin                                             | Notes                                          |
| ----------- | -------------------------------------------------- | ---------------------------------------------- |
| `/research` | `@docusaurus/plugin-content-blog` (id: `research`) | Long-form research, RSS at `/research/rss.xml` |
| `/insights` | `@docusaurus/plugin-content-blog` (id: `default`)  | Blog-style posts, RSS at `/insights/rss.xml`   |
| `/newsroom` | `@docusaurus/plugin-content-blog` (id: `newsroom`) | Announcements, RSS at `/newsroom/rss.xml`      |
| `/featured` | Custom React page `src/pages/featured/index.tsx`   | Showcase of appearances                        |
| `/`         | Custom `src/pages/index.tsx`                       | Homepage with Hero, SectionCards, LatestPosts  |

### Key Files

- **`docusaurus.config.ts`** - Main configuration. All social links are imported from `links.ts`. Footer displays navigation + RSS links only. Social icons are rendered via swizzled Footer component.
- **`links.ts`** - Single source of truth for all social/website URLs. Contains: github, linkedin, x, facebook, instagram, youtube, hackernoon, hackernews, crunchbase, f6s, strava, tiktok, email
- **`src/theme/Footer/index.tsx`** - Ejected and customized Footer. Replaces standard footer links with a centered row of social icons using FontAwesome. Uses `@fortawesome/react-fontawesome` package.
- **`src/css/custom.css`** - Dark theme with electric blue (`#00AAFF`) primary color. Dark-only mode (no theme switching).

---

## Custom Components

### `src/components/`
- **HomeHero** - Hero section on homepage with name "Allan B. Pedin IV" and tagline: `CEO | Redefining the Internet to be: Intelligent • Transparent • Inclusive • Decentralized | CEO & Co-Founder at CipherPlay & randao.net | Published AI & Blockchain Researcher`
- **SectionCards** - Four section cards for Research, Featured, Insights, Newsroom
- **LatestPosts** - Shows recent posts from all three blog instances
- **FeaturedCard** - Card component for featured items

### `src/data/`
- **featured.ts** - Featured items array with YouTube videos. Uses `hqdefault.jpg` thumbnails from YouTube image service. Each item has: title, outlet, description, preview (image URL), website (link), tags, date
- **featuredTags.ts** - Tag definitions: podcast, interview, article, guest-post, talk, keynote, video, panel, newsletter, book, favorite

---

## Content Sections

### Research (`research/` directory)
- Blog-style posts for published research
- Currently contains 3 published papers:
  1. "Secure and Decentralized Anonymous E-Voting Scheme" - ACM 2023, CNU
  2. "Smart Contract-Based Social Recovery Wallet Management Scheme" - ACM 2023, CNU
  3. "Predicting Road Quality Using High Resolution Satellite Imagery" - PLOS ONE 2021, William & Mary (under Ethan Brewer)

### Insights (`insights/` directory)
- General blog posts
- Currently has 1 seed post

### Newsroom (`newsroom/` directory)
- Announcements and milestones
- Currently has 1 seed post

---

## Author System

All three blog instances (`research/`, `insights/`, `newsroom/`) use the shared `authors.yml` file at the `content-site/` root via `authorsMapPath: '../authors.yml'`:
```yaml
allan:
  name: "Allan B. Pedin IV"
  title: "CEO & Co-Founder | Tech First Entrepreneur"
  image_url: "https://brewdogdev.github.io/info/img/headshot.png"
  socials:
    github: "https://github.com/BrewDogDev?utm_source=abpiv&utm_medium=you-are-welcome"
    x: "https://x.com/AllanRANDAO?utm_source=abpiv&utm_medium=you-are-welcome"
    linkedin: "https://www.linkedin.com/in/allan-b-pedin-iv/?utm_source=abpiv&utm_medium=you-are-welcome"
```

All blog posts frontmatter should use `author: allan`.

---

## Deployment

- **baseUrl**: `/info/`
- **url**: `https://abpiv.github.io`
- GitHub Actions workflow in `.github/workflows/deploy.yml` builds the site from `content-site/`
- Staging: Firebase Hosting deploy on push/merge to `main`, with manual `target=staging` dispatch available
- Staging domain target: `https://personal-brand-staging.lobst3rs.com/info/`
- Legacy comparison: GitHub Pages still deploys on push to `main`, but it is no longer the requested staging environment
- Production: automatic Firebase Hosting deploy on push/merge to `main`, with manual `target=production` dispatch available from `main`
- Production domain target: `https://allanbpediniv.com/info/`
- Firebase config: `firebase.json` serves production from `firebase-public/`; `firebase.staging.json` serves staging through the `staging` Firebase Hosting target. Both redirect `/` to `/info/` and cache `/info/assets/**` immutably. CI packages the Docusaurus `build/` output under `firebase-public/info/` before Firebase deploys.
- Cloudflare DNS/Firebase custom-domain setup is account-side work. Staging uses the `lobst3rs.com` Cloudflare zone; production uses the `allanbpediniv.com` Cloudflare zone. See `../DEPLOYMENT_PLAN.md`

---

## Build Commands

```bash
cd content-site
npm start        # Development server
npm run build    # Production build
npm run serve    # Serve built site
npm run clear    # Clear cache
```

`npm run deploy` is the stock Docusaurus deploy script and is not used by the current GitHub Actions deployment flow. CI deploys Firebase staging and production with the Firebase CLI, and keeps GitHub Pages as a legacy comparison deploy.

---

## Known Issues / Notes

- Footer RSS links generate `onBrokenLinks` warnings - these are harmless, the RSS files are generated but Docusaurus SSG checker doesn't recognize them as static files
- `blogDir` warning refers to old default path - harmless
- Dark-only theme enforced via `colorMode.disableSwitch: true`
- Social icons in footer use `@fortawesome/react-fontawesome` (brands + solid packages installed)

---

## Adding Content

### New Featured Item
Add to `src/data/featured.ts`:
```typescript
{
  title: 'Video Title',
  outlet: 'Channel Name',
  description: 'Brief description.',
  preview: 'https://i.ytimg.com/vi/[VIDEO_ID]/hqdefault.jpg',
  website: 'https://youtube.com/watch?v=[VIDEO_ID]',
  tags: ['podcast', 'video'],
  date: '2025-MM-DD',
}
```

### New Research Post
Create new file in `research/` directory with frontmatter:
```yaml
---
slug: url-friendly-slug
title: "Post Title"
author: allan
tags: [research]
date: 2025-MM-DD
description: "Brief description for SEO"
---
```

### Update Social Links
Edit `links.ts` - changes automatically propagate to footer icons and navbar.

---

## Theme Customization

- **Primary color**: Electric blue `#00AAFF` (light mode: `#0066FF`)
- **Background**: Dark `#0d1117`
- **Surface**: `#161b22`
- **Font**: system-ui

All changes made in `src/css/custom.css`

# abpiv-personal-brand

Public Docusaurus site and supporting infrastructure for [allanbpediniv.com/info/](https://allanbpediniv.com/info/).

## Agent And Maintainer Start

Future agents start with [`AGENTS.md`](AGENTS.md), then route through the canonical [`agents/context/`](agents/context/CONTEXT.md) source of truth. The [repository map](agents/context/references/repository-map.md) identifies the live implementation and operator documentation for each domain.

## Repository Areas

- [`content-site/`](content-site/README.md): Docusaurus content and application code deployed through Cloudflare Pages.
- [`infra/analytics/`](infra/analytics/README.md): shared Plausible Community Edition analytics infrastructure and same-origin collection proxy.
- [`infra/n8n/`](infra/n8n/README.md): self-hosted n8n forms and editor infrastructure.
- [`creative-production/brand-systems/abpiv/`](creative-production/brand-systems/abpiv/README.md): ABPIV brand-system source package.

For content-site deployment details and base-path gotchas, retain the operator entrypoint at [`content-site/AI_HANDOFF.md`](content-site/AI_HANDOFF.md).

# abpiv-personal-brand

Docusaurus content site deployed to Cloudflare Pages at `https://allanbpediniv.com/info/`.

For future coding agents, start with [`AGENTS.md`](AGENTS.md). It captures the current production state, analytics deployment map, workflow approval flow, and verification commands.

The site lives in `content-site/`. GitHub Actions builds, typechecks, auto-deploys preview, and manually deploys production through the `Content Site` workflow.

Shared Plausible Analytics infrastructure lives in [`infra/analytics/`](infra/analytics/). It is repo-level infrastructure, not content-site-specific, so future sites should reuse the same OpenTofu, Ansible, and Worker patterns.

The `Content Site` workflow in [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) runs content-site CI, deploys `preview`, and supports manual production dispatch from `main`. Manual analytics infrastructure workflows live in [`.github/workflows/analytics-apply.yml`](.github/workflows/analytics-apply.yml) and [`.github/workflows/analytics-provision.yml`](.github/workflows/analytics-provision.yml).

## Deployment and Forms Infrastructure

The content site uses the CipherPlay-style branch model:

- `preview` auto-deploys to `https://content-site.lobst3rs.com/info/`.
- `main` runs CI.
- Production deploys from `main` only by manual `Content Site` workflow dispatch with `target=production`.
- Pull requests into `main` must come from `preview`.

Self-hosted n8n forms infrastructure lives in `infra/n8n/`.

- Public forms hostname: `forms.allanbpediniv.com`
- Private editor hostname: `workflows.lobst3rs.com`
- Editor access: Cloudflare Access for `allanblankpedin@gmail.com`
- GCP project: `abpiv-personal-brand`
- GCP region: `us-east1`

The existing Plausible analytics stack remains in `infra/analytics/`.

For the next AI or maintainer, start with the content-site handoff: [`content-site/AI_HANDOFF.md`](content-site/AI_HANDOFF.md).

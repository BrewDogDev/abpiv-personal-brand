# ABPIV n8n Infrastructure

This directory contains the isolated infrastructure for ABPIV's self-hosted n8n Community Edition instance. It is a sibling to `infra/analytics` and does not share OpenTofu state, modules, workflows, or provisioning scripts with analytics.

## Architecture

```text
Public user
  -> Cloudflare DNS/WAF/rate limiting
  -> GCP external HTTPS load balancer
  -> Cloud Run n8n service
  -> Cloud SQL PostgreSQL private IP
```

The public forms hostname is `forms.allanbpediniv.com`. When `N8N_ENABLE_CLOUDFLARE_EDGE=true`, OpenTofu manages Cloudflare DNS plus hostname-specific WAF and rate-limit rules.

The editor/admin hostname is `workflows.lobst3rs.com`. It points to the same backend, is protected by Cloudflare Access before n8n's own login, and allows `allanblankpedin@gmail.com`.

## Runtime Contract

- GCP project: `abpiv-personal-brand`
- GCP region: `us-east1`
- Image: `docker.io/n8nio/n8n:stable`
- Cloud Run CPU: 1 vCPU
- Cloud Run memory: 2 GiB
- CPU allocation: always allocated
- Cloud Run instances: min 1, max 1
- Concurrency: 10
- Database: Cloud SQL PostgreSQL over private IP
- Binary data mode: n8n filesystem mode at `/mnt/n8n-binary-data`
- Binary data backing store: mounted Cloud Storage bucket
- OpenTofu state prefix: `infra/n8n`

The service is capped at one instance because Cloud Storage FUSE is not a fully POSIX multi-writer filesystem and should not be treated as a shared locking disk.

## Workflows

- `.github/workflows/n8n-validate.yml`: validates formatting and OpenTofu configuration for n8n changes.
- `.github/workflows/n8n-apply.yml`: manual production-approved OpenTofu plan and apply.
- `.github/workflows/n8n-redeploy.yml`: manual production-approved Cloud Run redeploy to the current Cloud Run-compatible stable n8n image.

All GCP authentication uses GitHub OIDC. Do not add service account JSON keys.

## Required GitHub Settings

Use the table below as the complete operations checklist across content-site and n8n workflows. The settings fall into these categories:

- Required for n8n workflows: `N8N_GCP_PROJECT_ID`, `N8N_GCP_REGION`, `N8N_GCP_SERVICE_ACCOUNT`, and `N8N_GCP_WORKLOAD_IDENTITY_PROVIDER`.
- Required when `N8N_ENABLE_CLOUDFLARE_EDGE=true`: `CLOUDFLARE_ACCOUNT_ID`, `CLOUDFLARE_ZONE_ID_ALLANBPEDINIV`, `CLOUDFLARE_ZONE_ID_LOBST3RS`, and `CLOUDFLARE_API_TOKEN`.
- Editor/defaulted n8n variables: `N8N_EDITOR_HOSTNAME`, `N8N_EDITOR_ZONE_ID` defaulting to `CLOUDFLARE_ZONE_ID_LOBST3RS`, `N8N_EDITOR_ZONE_NAME`, `N8N_EDITOR_ACCESS_ALLOWED_EMAILS`, `N8N_EDITOR_ACCESS_ALLOWED_GROUP_IDS`, `N8N_CLOUDFLARE_ACCESS_AUTH_DOMAIN`, `N8N_CLOUDFLARE_ACCESS_ORGANIZATION_NAME`, `N8N_MANAGE_CLOUDFLARE_ACCESS_ORGANIZATION`, and `N8N_ENABLE_CLOUDFLARE_EDGE`.
- Content-site deployment variables/env: `CLOUDFLARE_PAGES_PROJECT`, `PRODUCTION_DOMAIN`, `SITE_URL`, and `PLAUSIBLE_SITE_DOMAIN`.

| Name | Type | Expected value |
| --- | --- | --- |
| `CLOUDFLARE_ACCOUNT_ID` | variable | Cloudflare account ID |
| `CLOUDFLARE_ZONE_ID_ALLANBPEDINIV` | variable | Zone ID for `allanbpediniv.com` |
| `CLOUDFLARE_ZONE_ID_LOBST3RS` | variable | Zone ID for `lobst3rs.com` |
| `CLOUDFLARE_PAGES_PROJECT` | variable | `abpiv-personal-brand` |
| `PRODUCTION_DOMAIN` | variable | Discovered live production domain, usually `allanbpediniv.com` |
| `SITE_URL` | environment variable | Production: `https://<PRODUCTION_DOMAIN>`; Preview: `https://content-site.lobst3rs.com` |
| `PLAUSIBLE_SITE_DOMAIN` | environment variable | Production: `<PRODUCTION_DOMAIN>`; Preview: `content-site.lobst3rs.com` if analytics route exists |
| `N8N_GCP_PROJECT_ID` | variable | `abpiv-personal-brand` |
| `N8N_GCP_REGION` | variable | `us-east1` |
| `N8N_GCP_SERVICE_ACCOUNT` | variable | GitHub deployer service account email after bootstrap |
| `N8N_GCP_WORKLOAD_IDENTITY_PROVIDER` | variable | Workload Identity provider resource |
| `N8N_EDITOR_HOSTNAME` | variable | `workflows.lobst3rs.com` |
| `N8N_EDITOR_ZONE_ID` | variable | same value as `CLOUDFLARE_ZONE_ID_LOBST3RS` |
| `N8N_EDITOR_ACCESS_ALLOWED_EMAILS` | variable | `["allanblankpedin@gmail.com"]` |
| `N8N_ENABLE_CLOUDFLARE_EDGE` | variable | `true` when ready to manage DNS/WAF/Access |
| `CLOUDFLARE_API_TOKEN` | secret | Cloudflare token for Pages, DNS, WAF, and Access resources |

Optional repository variables:

- `N8N_EDITOR_ACCESS_ALLOWED_GROUP_IDS` as a JSON list
- `N8N_EDITOR_ZONE_NAME`
- `N8N_CLOUDFLARE_ACCESS_AUTH_DOMAIN`
- `N8N_CLOUDFLARE_ACCESS_ORGANIZATION_NAME`
- `N8N_MANAGE_CLOUDFLARE_ACCESS_ORGANIZATION`
- `N8N_GITHUB_OIDC_PRINCIPAL_SET`
- `N8N_CLOUD_RUN_SERVICE`

Preview analytics collection uses `PLAUSIBLE_SITE_DOMAIN=content-site.lobst3rs.com` and same-origin `/_analytics/*` paths, but the current analytics infrastructure only provisions `allanbpediniv.com/_analytics/*`. Extend the separate analytics infrastructure/route before expecting preview analytics collection.

## Bootstrap Sequence

1. Confirm or create the GCS state bucket `abpiv-personal-brand-opentofu-state`.
2. Run `n8n-validate`.
3. Run `n8n-apply` with `confirm_apply=apply`.
4. Create the Cloud SQL user `n8n` out of band.
5. Populate Secret Manager secret `abpiv-n8n-postgres-password`.
6. Populate Secret Manager secret `abpiv-n8n-encryption-key`.
7. Re-run or redeploy n8n after secrets exist.
8. Confirm `https://forms.allanbpediniv.com` loads public n8n form/webhook surfaces.
9. Confirm `https://workflows.lobst3rs.com` is Cloudflare Access protected and admits only `allanblankpedin@gmail.com`.

The first apply creates infrastructure and Secret Manager containers; n8n should not be considered healthy until the Cloud SQL user exists, both secret versions exist, and apply or redeploy has run again.

## Verification

```bash
tofu fmt -check -recursive infra/n8n/opentofu
tofu -chdir=infra/n8n/opentofu init -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Post-deploy checks should confirm that `forms.allanbpediniv.com` resolves through Cloudflare, loads a public n8n-created form, uses the public forms hostname in generated production URLs, writes binary data to the mounted path, and does not expose secret values in logs.

Before the first successful Cloud Run startup, create the `n8n` Cloud SQL user out of band and populate the `abpiv-n8n-postgres-password` and `abpiv-n8n-encryption-key` Secret Manager secrets. Keep a separate personal recovery copy of the n8n encryption key and bootstrap credentials outside this repo and outside GitHub.

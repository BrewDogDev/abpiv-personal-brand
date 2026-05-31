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

Repository variables:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_ZONE_ID_ALLANBPEDINIV`
- `CLOUDFLARE_ZONE_ID_LOBST3RS`
- `N8N_GCP_PROJECT_ID`
- `N8N_GCP_REGION`
- `N8N_GCP_SERVICE_ACCOUNT`
- `N8N_GCP_WORKLOAD_IDENTITY_PROVIDER`
- `N8N_EDITOR_HOSTNAME`
- `N8N_EDITOR_ACCESS_ALLOWED_EMAILS`
- `N8N_ENABLE_CLOUDFLARE_EDGE`

Expected values:

- `N8N_GCP_PROJECT_ID=abpiv-personal-brand`
- `N8N_GCP_REGION=us-east1`
- `N8N_EDITOR_HOSTNAME=workflows.lobst3rs.com`
- `N8N_EDITOR_ACCESS_ALLOWED_EMAILS=["allanblankpedin@gmail.com"]`
- `N8N_ENABLE_CLOUDFLARE_EDGE=true`

Optional repository variables:

- `N8N_EDITOR_ACCESS_ALLOWED_GROUP_IDS` as a JSON list
- `N8N_GITHUB_OIDC_PRINCIPAL_SET`
- `N8N_CLOUD_RUN_SERVICE`

Repository secrets:

- `CLOUDFLARE_API_TOKEN`

## Verification

```bash
tofu fmt -check -recursive infra/n8n/opentofu
tofu -chdir=infra/n8n/opentofu init -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Post-deploy checks should confirm that `forms.allanbpediniv.com` resolves through Cloudflare, loads a public n8n-created form, uses the public forms hostname in generated production URLs, writes binary data to the mounted path, and does not expose secret values in logs.

Before the first successful Cloud Run startup, create the `n8n` Cloud SQL user out of band and populate the `abpiv-n8n-postgres-password` and `abpiv-n8n-encryption-key` Secret Manager secrets. Keep a separate personal recovery copy of the n8n encryption key and bootstrap credentials outside this repo and outside GitHub.

# ABPIV n8n Forms and Preview/Main Deployment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Mirror CipherPlay's n8n public-forms infrastructure and preview/main content-site deployment strategy in `BrewDogDev/abpiv-personal-brand` without replacing the existing content-site or Plausible analytics stack.

**Architecture:** Add a new sibling `infra/n8n` OpenTofu project that provisions n8n on GCP Cloud Run, Cloud SQL PostgreSQL, GCS binary-data storage, a Google HTTPS load balancer, Cloudflare DNS/WAF/rate limiting for public forms, and Cloudflare Access for the private editor. Separately, convert content-site deployment to CipherPlay's branch model: `preview` auto-deploys preview, `main` runs CI, production deploys only by manual workflow dispatch from `main`, and PRs into `main` must come from `preview`.

**Tech Stack:** Docusaurus 3, GitHub Actions, Cloudflare Pages, Cloudflare DNS/Access, OpenTofu, GCP Cloud Run v2, Cloud SQL PostgreSQL, Secret Manager, GCS, n8n Community Edition.

---

## Confirmed Decisions

- Source reference repo: `https://github.com/CipherPlayLabs/mono`
- Reference commit inspected: `508e0904fb1294627744af68163e1a2dd71bc767`
- Copy: n8n forms infrastructure pattern.
- Copy: preview/main deployment workflow style.
- Do not copy: Plausible analytics stack; this repo already has `infra/analytics`.
- Do not copy: content-site foundation; this repo already has `content-site`.
- Public n8n forms hostname: `forms.allanbpediniv.com`
- Private n8n editor/workflows hostname: `workflows.lobst3rs.com`
- Cloudflare Access allowed email: `allanblankpedin@gmail.com`
- Preview content-site domain: `content-site.lobst3rs.com`
- Production content-site domain: discover the already-live domain, choosing between `allanbpediniv.com` and `www.allanbpediniv.com`.
- Branching strategy: exact CipherPlay strategy.
- Public content-site CTAs do not need to point to n8n yet because no forms currently exist.

## Current Target Repo Facts

- Repo root: `/Users/user/Documents/abpiv-personal-brand/abpiv-personal-brand-clone`
- Current production docs name GCP project as `abpiv-personal-brand`.
- Current production docs name OpenTofu state bucket as `abpiv-personal-brand-opentofu-state`.
- Existing Cloudflare zone variables referenced by analytics workflows:
  - `CLOUDFLARE_ZONE_ID_ALLANBPEDINIV`
  - `CLOUDFLARE_ZONE_ID_LOBST3RS`
- Existing Cloudflare Pages project in current workflow: `abpiv-personal-brand`.
- Existing deploy workflow is `.github/workflows/deploy.yml`, currently named `Site and Analytics`.
- Existing Plausible workflows to preserve:
  - `.github/workflows/analytics-apply.yml`
  - `.github/workflows/analytics-provision.yml`
- Existing Plausible infra to preserve:
  - `infra/analytics/`

## File Structure

Create:

- `infra/n8n/README.md`: ABPIV n8n operator docs.
- `infra/n8n/opentofu/.terraform.lock.hcl`: copied provider lockfile from CipherPlay reference after `tofu init`.
- `infra/n8n/opentofu/README.md`: ABPIV n8n OpenTofu docs.
- `infra/n8n/opentofu/versions.tf`: provider versions and GCS backend.
- `infra/n8n/opentofu/providers.tf`: Google, google-beta, Cloudflare providers.
- `infra/n8n/opentofu/variables.tf`: ABPIV n8n variables.
- `infra/n8n/opentofu/locals.tf`: naming, env vars, hostnames, labels.
- `infra/n8n/opentofu/gcp.tf`: GCP Cloud Run, Cloud SQL, GCS, LB, cert resources.
- `infra/n8n/opentofu/cloudflare.tf`: Cloudflare DNS, public forms protection, editor Access.
- `infra/n8n/opentofu/iam.tf`: runtime and GitHub deployer IAM.
- `infra/n8n/opentofu/outputs.tf`: deploy/runtime output values.
- `.github/workflows/n8n-validate.yml`: validate n8n IaC on PR/push/manual.
- `.github/workflows/n8n-apply.yml`: manual production OpenTofu apply.
- `.github/workflows/n8n-redeploy.yml`: manual Cloud Run image redeploy.
- `.github/workflows/main-source-guard.yml`: require PRs into `main` to originate from `preview`.
- `.github/workflows/content-site-setup.yml`: manual Cloudflare Pages project/domain/DNS bootstrap, adapted from CipherPlay.

Modify:

- `.github/workflows/deploy.yml`: convert to CipherPlay content-site deployment model and remove analytics validation/deploy coupling from this workflow.
- `content-site/docusaurus.config.ts`: make `url` and Plausible `data-domain` environment-driven like CipherPlay while preserving same-origin `/_analytics/*` paths.
- `README.md`: document preview/main deployment and n8n infra.
- `AGENTS.md`: update production snapshot, workflow map, and verification commands.
- `content-site/AI_HANDOFF.md`: update content-site deployment notes.
- `content-site/README.md`: update deployment section.

Do not modify:

- `infra/analytics/**`, except docs only if absolutely necessary to mention that analytics remains separate.
- Public site form CTAs/routes. n8n form URLs are not integrated in this phase.

---

### Task 1: Preflight And Reference Checkout

**Files:**
- Read: `AGENTS.md`
- Read: `.github/workflows/deploy.yml`
- Read: `/private/tmp/cipherplay-mono-reference` if present
- Clone if missing: `/private/tmp/cipherplay-mono-reference`

- [ ] **Step 1: Confirm clean target repo**

Run:

```bash
cd /Users/user/Documents/abpiv-personal-brand/abpiv-personal-brand-clone
git status --short --branch
```

Expected if this plan file has already been committed:

```text
## main...origin/main
```

Expected if the handoff plan is present but not committed:

```text
## main...origin/main
?? docs/superpowers/plans/2026-05-31-abpiv-n8n-forms-preview-main-deployment.md
```

If there are any other uncommitted changes, stop and inspect them with `git status --short` and `git diff --stat`. Do not overwrite unrelated user work.

- [ ] **Step 2: Create implementation branch**

Run:

```bash
git switch -c codex/abpiv-n8n-preview-main-deployment
```

Expected:

```text
Switched to a new branch 'codex/abpiv-n8n-preview-main-deployment'
```

- [ ] **Step 3: Clone or refresh CipherPlay reference**

Run:

```bash
if [ ! -d /private/tmp/cipherplay-mono-reference/.git ]; then
  git clone https://github.com/CipherPlayLabs/mono.git /private/tmp/cipherplay-mono-reference
fi
git -C /private/tmp/cipherplay-mono-reference fetch origin main
git -C /private/tmp/cipherplay-mono-reference checkout 508e0904fb1294627744af68163e1a2dd71bc767
git -C /private/tmp/cipherplay-mono-reference rev-parse HEAD
```

Expected final line:

```text
508e0904fb1294627744af68163e1a2dd71bc767
```

- [ ] **Step 4: Discover production content-site domain**

Run:

```bash
for domain in allanbpediniv.com www.allanbpediniv.com; do
  printf '%s ' "$domain"
  curl -sS -L -o /tmp/abpiv-domain-check.html -w '%{http_code} %{url_effective}\n' "https://${domain}/info/"
done
```

Expected:

- At least one domain returns `200`.
- If both return `200`, use `allanbpediniv.com` as the canonical production domain because current repo docs already identify it as production.
- If only one returns `200`, use that domain as `PRODUCTION_DOMAIN`.

Record the chosen value for later workflow/docs updates:

```bash
export ABPIV_PRODUCTION_DOMAIN="allanbpediniv.com"
```

Use `www.allanbpediniv.com` instead only if the discovery command shows `www` is the existing working domain and the apex does not work.

- [ ] **Step 5: Confirm GCP project and state bucket**

Run:

```bash
gcloud projects list --filter='projectId:abpiv OR name:abpiv' --format='table(projectId,name,lifecycleState)'
```

Expected:

- A project with project ID `abpiv-personal-brand`, matching `AGENTS.md`.

Run:

```bash
gcloud storage buckets describe gs://abpiv-personal-brand-opentofu-state --format='value(name)'
```

Expected:

```text
abpiv-personal-brand-opentofu-state
```

If either command fails because local GCP auth is unavailable, do not invent alternate names. Use the documented values:

- `gcp_project_id = "abpiv-personal-brand"`
- backend bucket `abpiv-personal-brand-opentofu-state`
- `gcp_region = "us-east1"`

- [ ] **Step 6: Commit the implementation plan if it is untracked**

Run:

```bash
git status --short
```

If the only output is this plan file:

```text
?? docs/superpowers/plans/2026-05-31-abpiv-n8n-forms-preview-main-deployment.md
```

commit it:

```bash
git add docs/superpowers/plans/2026-05-31-abpiv-n8n-forms-preview-main-deployment.md
git commit -m "Add ABPIV n8n implementation plan"
```

Expected:

```text
[codex/abpiv-n8n-preview-main-deployment <sha>] Add ABPIV n8n implementation plan
```

If the plan file is already tracked and `git status --short` is empty, skip this step.

---

### Task 2: Add ABPIV n8n OpenTofu Infrastructure

**Files:**
- Create: `infra/n8n/**`
- Source: `/private/tmp/cipherplay-mono-reference/infra/n8n/**`

- [ ] **Step 1: Copy n8n infra source**

Run:

```bash
cd /Users/user/Documents/abpiv-personal-brand/abpiv-personal-brand-clone
mkdir -p infra/n8n
cp -R /private/tmp/cipherplay-mono-reference/infra/n8n/. infra/n8n/
rm -rf infra/n8n/opentofu/.terraform
```

Expected:

```bash
test -f infra/n8n/README.md
test -f infra/n8n/opentofu/variables.tf
test -f infra/n8n/opentofu/gcp.tf
test -f infra/n8n/opentofu/cloudflare.tf
test -f infra/n8n/opentofu/iam.tf
```

- [ ] **Step 2: Rename project, resources, and hostnames**

Edit `infra/n8n/opentofu/versions.tf` so the backend block is:

```hcl
terraform {
  required_version = ">= 1.8.0"

  backend "gcs" {
    bucket = "abpiv-personal-brand-opentofu-state"
    prefix = "infra/n8n"
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5.8.2, < 6.0.0"
    }

    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 7.0.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 6.0.0, < 7.0.0"
    }
  }
}
```

Edit `infra/n8n/opentofu/variables.tf` with these ABPIV values and names:

```hcl
variable "gcp_project_id" {
  description = "Existing Google Cloud project that hosts ABPIV n8n. This OpenTofu project never creates the project."
  type        = string
  default     = "abpiv-personal-brand"
}

variable "gcp_region" {
  description = "Google Cloud region for Cloud Run, Cloud SQL, networking, and the binary-data bucket."
  type        = string
  default     = "us-east1"
}

variable "allanbpediniv_zone_id" {
  description = "Cloudflare zone ID for allanbpediniv.com."
  type        = string
  default     = ""

  validation {
    condition     = !var.enable_cloudflare_edge || var.allanbpediniv_zone_id != ""
    error_message = "allanbpediniv_zone_id is required when enable_cloudflare_edge is true."
  }
}

variable "enable_cloudflare_edge" {
  description = "Whether to manage Cloudflare DNS, public forms protection, and optional editor Access resources."
  type        = bool
  default     = false
}

variable "cloudflare_access_organization_name" {
  description = "Cloudflare Zero Trust organization display name used when the optional editor hostname is enabled."
  type        = string
  default     = "ABPIV Internal"
}

variable "cloudflare_access_auth_domain" {
  description = "Unique Cloudflare Access auth domain used only when OpenTofu manages the account-level Access organization."
  type        = string
  default     = "lobst3rs.cloudflareaccess.com"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.cloudflareaccess\\.com$", var.cloudflare_access_auth_domain))
    error_message = "cloudflare_access_auth_domain must be a lowercase cloudflareaccess.com hostname."
  }
}

variable "forms_hostname" {
  description = "Public hostname used by n8n-generated forms and production webhooks."
  type        = string
  default     = "forms.allanbpediniv.com"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)+$", var.forms_hostname))
    error_message = "forms_hostname must be a lowercase DNS hostname."
  }
}
```

Keep the rest of the CipherPlay variables unless they contain `cipherplay` naming. Do not hardcode the editor hostname in Terraform defaults; pass it through GitHub variables so local `tofu validate` works without Cloudflare lookups.

Edit `infra/n8n/opentofu/locals.tf` so these values are exact:

```hcl
locals {
  name_prefix = "abpiv-n8n"

  labels = {
    app         = "n8n"
    component   = "automation"
    environment = "production"
    managed_by  = "opentofu"
  }
```

In the same file, ensure `hostname_zone_ids` maps forms to `var.allanbpediniv_zone_id`:

```hcl
hostname_zone_ids = merge(
  {
    forms = var.allanbpediniv_zone_id
  },
  local.editor_enabled ? {
    editor = local.editor_cloudflare_zone_id
  } : {}
)
```

Edit `infra/n8n/opentofu/cloudflare.tf` so public forms DNS/rules use `var.allanbpediniv_zone_id` instead of the CipherPlay zone variable:

```hcl
resource "cloudflare_dns_record" "forms" {
  count = var.enable_cloudflare_edge ? 1 : 0

  zone_id = var.allanbpediniv_zone_id
  name    = var.forms_hostname
  content = google_compute_global_address.n8n_lb.address
  type    = "A"
  ttl     = 1
  proxied = true
}
```

Also update `cloudflare_ruleset.forms_firewall_custom.zone_id` and `cloudflare_ruleset.forms_rate_limit.zone_id` to `var.allanbpediniv_zone_id`.

- [ ] **Step 3: Remove CipherPlay-specific text**

Run:

```bash
rg -n "CipherPlay|cipherplay|CIPHERPLAY|forms\\.cipherplay\\.net|cipherplay-production|cipherplay-n8n" infra/n8n
```

Expected:

```text
```

No output. If output appears, replace it with ABPIV-specific names:

- `CipherPlay` -> `ABPIV`
- `cipherplay-production` -> `abpiv-personal-brand`
- `cipherplay-n8n` -> `abpiv-n8n`
- `forms.cipherplay.net` -> `forms.allanbpediniv.com`

- [ ] **Step 4: Update n8n README files**

Edit `infra/n8n/README.md` so the architecture and runtime contract describe:

- Public forms hostname: `forms.allanbpediniv.com`
- Editor/admin hostname: `workflows.lobst3rs.com`
- Editor protected by Cloudflare Access.
- Allowed editor email: `allanblankpedin@gmail.com`
- GCP project: `abpiv-personal-brand`
- GCP region: `us-east1`
- Cloud Run image: `docker.io/n8nio/n8n:stable`
- OpenTofu state prefix: `infra/n8n`

Edit `infra/n8n/opentofu/README.md` so required variables are:

```text
CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_ZONE_ID_ALLANBPEDINIV
CLOUDFLARE_ZONE_ID_LOBST3RS
N8N_GCP_PROJECT_ID
N8N_GCP_REGION
N8N_GCP_SERVICE_ACCOUNT
N8N_GCP_WORKLOAD_IDENTITY_PROVIDER
N8N_EDITOR_HOSTNAME
N8N_EDITOR_ACCESS_ALLOWED_EMAILS
N8N_ENABLE_CLOUDFLARE_EDGE
```

Document these expected values:

```text
N8N_GCP_PROJECT_ID=abpiv-personal-brand
N8N_GCP_REGION=us-east1
N8N_EDITOR_HOSTNAME=workflows.lobst3rs.com
N8N_EDITOR_ACCESS_ALLOWED_EMAILS=["allanblankpedin@gmail.com"]
N8N_ENABLE_CLOUDFLARE_EDGE=true
```

- [ ] **Step 5: Run OpenTofu formatting**

Run:

```bash
tofu fmt -recursive infra/n8n/opentofu
```

Expected:

- Command exits `0`.
- It may rewrite copied `.tf` files.

- [ ] **Step 6: Validate n8n OpenTofu locally**

Run:

```bash
tofu -chdir=infra/n8n/opentofu init -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Expected:

```text
Success! The configuration is valid.
```

If the GCS backend cannot initialize due local auth, retry validation without backend:

```bash
tofu -chdir=infra/n8n/opentofu init -backend=false -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Expected:

```text
Success! The configuration is valid.
```

- [ ] **Step 7: Commit n8n infra**

Run:

```bash
git add infra/n8n
git commit -m "Add ABPIV n8n forms infrastructure"
```

Expected:

```text
[codex/abpiv-n8n-preview-main-deployment <sha>] Add ABPIV n8n forms infrastructure
```

---

### Task 3: Add n8n GitHub Actions

**Files:**
- Create: `.github/workflows/n8n-validate.yml`
- Create: `.github/workflows/n8n-apply.yml`
- Create: `.github/workflows/n8n-redeploy.yml`
- Source: `/private/tmp/cipherplay-mono-reference/.github/workflows/n8n-validate.yml`
- Source: `/private/tmp/cipherplay-mono-reference/.github/workflows/n8n-apply.yml`
- Source: `/private/tmp/cipherplay-mono-reference/.github/workflows/n8n-redeploy.yml`

- [ ] **Step 1: Copy source workflows**

Run:

```bash
cp /private/tmp/cipherplay-mono-reference/.github/workflows/n8n-validate.yml .github/workflows/n8n-validate.yml
cp /private/tmp/cipherplay-mono-reference/.github/workflows/n8n-apply.yml .github/workflows/n8n-apply.yml
cp /private/tmp/cipherplay-mono-reference/.github/workflows/n8n-redeploy.yml .github/workflows/n8n-redeploy.yml
```

- [ ] **Step 2: Adapt workflow variable mapping**

In `.github/workflows/n8n-validate.yml` and `.github/workflows/n8n-apply.yml`, replace the CipherPlay zone mapping with ABPIV zone variables:

```yaml
env:
  TOFU_DIR: infra/n8n/opentofu
  TF_VAR_cloudflare_account_id: ${{ vars.CLOUDFLARE_ACCOUNT_ID }}
  TF_VAR_cloudflare_access_auth_domain: ${{ vars.N8N_CLOUDFLARE_ACCESS_AUTH_DOMAIN || 'lobst3rs.cloudflareaccess.com' }}
  TF_VAR_cloudflare_access_organization_name: ${{ vars.N8N_CLOUDFLARE_ACCESS_ORGANIZATION_NAME || 'ABPIV Internal' }}
  TF_VAR_allanbpediniv_zone_id: ${{ vars.CLOUDFLARE_ZONE_ID_ALLANBPEDINIV }}
  TF_VAR_enable_cloudflare_edge: ${{ vars.N8N_ENABLE_CLOUDFLARE_EDGE || 'false' }}
  TF_VAR_gcp_project_id: ${{ vars.N8N_GCP_PROJECT_ID }}
  TF_VAR_gcp_region: ${{ vars.N8N_GCP_REGION }}
  TF_VAR_editor_hostname: ${{ vars.N8N_EDITOR_HOSTNAME }}
  TF_VAR_editor_zone_id: ${{ vars.N8N_EDITOR_ZONE_ID || vars.CLOUDFLARE_ZONE_ID_LOBST3RS }}
  TF_VAR_editor_zone_name: ${{ vars.N8N_EDITOR_ZONE_NAME || 'lobst3rs.com' }}
  TF_VAR_editor_access_allowed_emails: ${{ vars.N8N_EDITOR_ACCESS_ALLOWED_EMAILS || '["allanblankpedin@gmail.com"]' }}
  TF_VAR_editor_access_allowed_group_ids: ${{ vars.N8N_EDITOR_ACCESS_ALLOWED_GROUP_IDS || '[]' }}
  TF_VAR_manage_cloudflare_access_organization: ${{ vars.N8N_MANAGE_CLOUDFLARE_ACCESS_ORGANIZATION || 'false' }}
  TF_VAR_github_oidc_principal_set: ${{ vars.N8N_GITHUB_OIDC_PRINCIPAL_SET }}
```

In the "Check required configuration" steps, require:

```bash
N8N_GCP_PROJECT_ID
N8N_GCP_REGION
N8N_GCP_SERVICE_ACCOUNT
N8N_GCP_WORKLOAD_IDENTITY_PROVIDER
```

When `N8N_ENABLE_CLOUDFLARE_EDGE` is `true`, also require:

```bash
CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_ZONE_ID_ALLANBPEDINIV
CLOUDFLARE_ZONE_ID_LOBST3RS
```

When `N8N_EDITOR_HOSTNAME` is configured, require either:

```bash
N8N_EDITOR_ZONE_ID
```

or:

```bash
N8N_EDITOR_ZONE_NAME
```

and require at least one of:

```bash
N8N_EDITOR_ACCESS_ALLOWED_EMAILS
N8N_EDITOR_ACCESS_ALLOWED_GROUP_IDS
```

- [ ] **Step 3: Adapt redeploy workflow**

In `.github/workflows/n8n-redeploy.yml`, make these values ABPIV-specific:

```yaml
env:
  N8N_IMAGE: docker.io/n8nio/n8n:stable
  N8N_CLOUD_RUN_SERVICE: ${{ vars.N8N_CLOUD_RUN_SERVICE || 'abpiv-n8n' }}
  N8N_GCP_PROJECT_ID: ${{ vars.N8N_GCP_PROJECT_ID }}
  N8N_GCP_REGION: ${{ vars.N8N_GCP_REGION }}
```

- [ ] **Step 4: Check workflow names**

Run:

```bash
rg -n "^name:|cipherplay|CipherPlay|CIPHERPLAY|CLOUDFLARE_ZONE_ID_CIPHERPLAY|cipherplay-production|cipherplay-n8n" .github/workflows/n8n-*.yml
```

Expected output should include only the workflow `name:` lines and no CipherPlay/CIPHERPLAY matches:

```text
.github/workflows/n8n-apply.yml:name: Apply n8n Infrastructure
.github/workflows/n8n-redeploy.yml:name: Redeploy n8n
.github/workflows/n8n-validate.yml:name: Validate n8n Infrastructure
```

- [ ] **Step 5: Commit n8n workflows**

Run:

```bash
git add .github/workflows/n8n-validate.yml .github/workflows/n8n-apply.yml .github/workflows/n8n-redeploy.yml
git commit -m "Add ABPIV n8n workflows"
```

Expected:

```text
[codex/abpiv-n8n-preview-main-deployment <sha>] Add ABPIV n8n workflows
```

---

### Task 4: Convert Content-Site Deployment To Preview/Main Strategy

**Files:**
- Modify: `.github/workflows/deploy.yml`
- Create: `.github/workflows/main-source-guard.yml`
- Create: `.github/workflows/content-site-setup.yml`
- Modify: `content-site/docusaurus.config.ts`
- Source: `/private/tmp/cipherplay-mono-reference/.github/workflows/deploy.yml`
- Source: `/private/tmp/cipherplay-mono-reference/.github/workflows/main-source-guard.yml`
- Source: `/private/tmp/cipherplay-mono-reference/.github/workflows/content-site-setup.yml`

- [ ] **Step 1: Replace deploy workflow with content-site-only model**

Replace `.github/workflows/deploy.yml` with an ABPIV-adapted version of CipherPlay's `.github/workflows/deploy.yml`.

Use this required workflow shape:

```yaml
name: Content Site

on:
  pull_request:
    branches: [main]
    paths:
      - 'content-site/**'
      - '.github/workflows/deploy.yml'
  push:
    branches: [preview, main]
    paths:
      - 'content-site/**'
      - '.github/workflows/deploy.yml'
  workflow_dispatch:
    inputs:
      target:
        description: Deployment target.
        required: true
        type: choice
        options:
          - preview
          - production
        default: preview

permissions:
  contents: read
  deployments: write

concurrency:
  group: content-site-${{ github.event.pull_request.number || github.ref || inputs.target }}
  cancel-in-progress: true

env:
  NODE_VERSION: '20'
  CONTENT_DIR: content-site
  DEPLOY_DIR: content-site/cloudflare-pages
```

The `ci` job must run:

```yaml
- name: Install dependencies
  run: npm ci
  working-directory: ${{ env.CONTENT_DIR }}

- name: Typecheck
  run: npm run typecheck
  working-directory: ${{ env.CONTENT_DIR }}

- name: Build website
  run: npm run build
  working-directory: ${{ env.CONTENT_DIR }}
```

The preview deploy condition must be:

```yaml
if: >-
  (github.event_name == 'push' && github.ref == 'refs/heads/preview') ||
  (github.event_name == 'workflow_dispatch' && inputs.target == 'preview')
```

The production deploy condition must be:

```yaml
if: >-
  github.event_name == 'workflow_dispatch' &&
  inputs.target == 'production' &&
  github.ref == 'refs/heads/main'
```

Both deploy jobs must prepare the Cloudflare Pages artifact:

```bash
rm -rf cloudflare-pages
mkdir -p cloudflare-pages/info
cp -R build/. cloudflare-pages/info/
cp static/_redirects cloudflare-pages/_redirects
cp static/_headers cloudflare-pages/_headers
```

Preview environment values:

```yaml
environment:
  name: preview
  url: https://content-site.lobst3rs.com/info/
env:
  CLOUDFLARE_ACCOUNT_ID: ${{ vars.CLOUDFLARE_ACCOUNT_ID }}
  CLOUDFLARE_PAGES_PROJECT: ${{ vars.CLOUDFLARE_PAGES_PROJECT || 'abpiv-personal-brand' }}
  SITE_URL: https://content-site.lobst3rs.com
  PLAUSIBLE_SITE_DOMAIN: content-site.lobst3rs.com
  DEPLOY_BRANCH: preview
```

Production environment values:

```yaml
environment:
  name: production
  url: https://${{ vars.PRODUCTION_DOMAIN || 'allanbpediniv.com' }}/info/
env:
  CLOUDFLARE_ACCOUNT_ID: ${{ vars.CLOUDFLARE_ACCOUNT_ID }}
  CLOUDFLARE_PAGES_PROJECT: ${{ vars.CLOUDFLARE_PAGES_PROJECT || 'abpiv-personal-brand' }}
  SITE_URL: https://${{ vars.PRODUCTION_DOMAIN || 'allanbpediniv.com' }}
  PLAUSIBLE_SITE_DOMAIN: ${{ vars.PLAUSIBLE_SITE_DOMAIN || vars.PRODUCTION_DOMAIN || 'allanbpediniv.com' }}
  DEPLOY_BRANCH: main
```

Use `cloudflare/wrangler-action@v3` with:

```yaml
command: >-
  pages deploy ${{ env.DEPLOY_DIR }}
  --project-name=${{ env.CLOUDFLARE_PAGES_PROJECT }}
  --branch=${{ env.DEPLOY_BRANCH }}
  --commit-hash=${{ github.sha }}
```

Do not include analytics OpenTofu validation in this workflow. Plausible remains managed by `.github/workflows/analytics-apply.yml` and `.github/workflows/analytics-provision.yml`.

- [ ] **Step 2: Add main source guard**

Copy and keep `.github/workflows/main-source-guard.yml` from CipherPlay with the same rule:

```yaml
name: Main Source Guard

on:
  pull_request:
    branches: [main]

permissions:
  contents: read

jobs:
  require-preview-source:
    name: Require preview source
    runs-on: ubuntu-latest
    steps:
      - name: Check pull request source branch
        env:
          HEAD_REF: ${{ github.head_ref }}
        run: |
          if [ "$HEAD_REF" != "preview" ]; then
            echo "::error title=Invalid source branch::Only the preview branch may open pull requests into main. Current source branch: ${HEAD_REF}"
            exit 1
          fi
```

- [ ] **Step 3: Add content site setup workflow**

Copy `/private/tmp/cipherplay-mono-reference/.github/workflows/content-site-setup.yml` to `.github/workflows/content-site-setup.yml`.

Adapt it to ABPIV:

```yaml
name: Setup Content Site Hosting
```

Required environment values:

```yaml
CLOUDFLARE_ACCOUNT_ID: ${{ vars.CLOUDFLARE_ACCOUNT_ID }}
CLOUDFLARE_PAGES_PROJECT: ${{ vars.CLOUDFLARE_PAGES_PROJECT || 'abpiv-personal-brand' }}
PRODUCTION_BRANCH: main
PRODUCTION_DOMAIN: ${{ vars.PRODUCTION_DOMAIN || 'allanbpediniv.com' }}
PREVIEW_DOMAIN: content-site.lobst3rs.com
```

The workflow should:

- create/update the Cloudflare Pages project
- attach the production domain
- attach `content-site.lobst3rs.com`
- point DNS CNAMEs at the Cloudflare Pages aliases

If discovery in Task 1 showed `www.allanbpediniv.com` is the only working production domain, set the fallback to `www.allanbpediniv.com` instead of `allanbpediniv.com`.

- [ ] **Step 4: Make Docusaurus URL and Plausible domain environment-driven**

Modify `content-site/docusaurus.config.ts` near the existing `isProduction` constant:

```ts
const isProduction = process.env.NODE_ENV === 'production';
const siteUrl = process.env.SITE_URL || 'https://allanbpediniv.com';
const plausibleSiteDomain = process.env.PLAUSIBLE_SITE_DOMAIN || new URL(siteUrl).hostname;
```

Change config `url`:

```ts
url: siteUrl,
```

Change production script data domain:

```ts
'data-domain': plausibleSiteDomain,
```

Keep:

```ts
src: '/_analytics/js/script.js',
'data-api': '/_analytics/api/event',
```

Do not change the same-origin analytics paths in this task.

- [ ] **Step 5: Create or update preview branch**

After the deployment workflow changes are committed and pushed to a feature branch, the maintainer can create/update `preview` from `main` using:

```bash
git fetch origin
git switch main
git pull --ff-only origin main
git switch -C preview
git push -u origin preview
```

Expected:

```text
* [new branch] preview -> preview
```

If `preview` already exists, use:

```bash
git fetch origin preview
git switch preview
git merge --ff-only main
git push origin preview
```

- [ ] **Step 6: Commit deployment workflow changes**

Run:

```bash
git add .github/workflows/deploy.yml .github/workflows/main-source-guard.yml .github/workflows/content-site-setup.yml content-site/docusaurus.config.ts
git commit -m "Adopt preview main content deployment"
```

Expected:

```text
[codex/abpiv-n8n-preview-main-deployment <sha>] Adopt preview main content deployment
```

---

### Task 5: Document Required GitHub Variables, Secrets, And Bootstrap

**Files:**
- Modify: `README.md`
- Modify: `AGENTS.md`
- Modify: `content-site/README.md`
- Modify: `content-site/AI_HANDOFF.md`
- Modify: `infra/n8n/README.md`
- Modify: `infra/n8n/opentofu/README.md`

- [ ] **Step 1: Update root README**

Add a section named `Deployment and Forms Infrastructure` to `README.md` with this content:

```markdown
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
```

- [ ] **Step 2: Update AGENTS.md**

Add these bullets to the production snapshot:

```markdown
- Preview content site: `https://content-site.lobst3rs.com/info/`
- Public n8n forms hostname: `https://forms.allanbpediniv.com`
- Private n8n editor: `https://workflows.lobst3rs.com`
- n8n OpenTofu state prefix: `infra/n8n`
```

Update workflow map:

```markdown
- `.github/workflows/deploy.yml`: content-site CI plus preview auto-deploy and manual production deploy.
- `.github/workflows/main-source-guard.yml`: allows PRs into `main` only from `preview`.
- `.github/workflows/content-site-setup.yml`: manual Cloudflare Pages/domain/DNS bootstrap.
- `.github/workflows/n8n-validate.yml`: validates n8n OpenTofu changes.
- `.github/workflows/n8n-apply.yml`: manual production apply for n8n OpenTofu.
- `.github/workflows/n8n-redeploy.yml`: manual n8n Cloud Run stable-image redeploy.
```

Add n8n verification:

```markdown
Local checks for n8n infrastructure:

```bash
tofu fmt -check -recursive infra/n8n/opentofu
tofu -chdir=infra/n8n/opentofu init -input=false
tofu -chdir=infra/n8n/opentofu validate
```
```

- [ ] **Step 3: Update content-site docs**

In `content-site/README.md` and `content-site/AI_HANDOFF.md`, change deployment notes to:

```markdown
- Preview branch: `preview`
- Preview URL: `https://content-site.lobst3rs.com/info/`
- Production branch: `main`
- Production URL: the existing live `allanbpediniv.com` or `www.allanbpediniv.com` domain discovered during implementation
- Production deploys: manual `Content Site` workflow dispatch from `main` with `target=production`
```

- [ ] **Step 4: Document required repo variables and secrets**

In `infra/n8n/README.md`, include this table:

```markdown
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
```

Add this bootstrap sequence:

```markdown
1. Confirm or create the GCS state bucket `abpiv-personal-brand-opentofu-state`.
2. Run `n8n-validate`.
3. Run `n8n-apply` with `confirm_apply=apply`.
4. Create the Cloud SQL user `n8n` out of band.
5. Populate Secret Manager secret `abpiv-n8n-postgres-password`.
6. Populate Secret Manager secret `abpiv-n8n-encryption-key`.
7. Re-run or redeploy n8n after secrets exist.
8. Confirm `https://forms.allanbpediniv.com` loads public n8n form/webhook surfaces.
9. Confirm `https://workflows.lobst3rs.com` is Cloudflare Access protected and admits only `allanblankpedin@gmail.com`.
```

- [ ] **Step 5: Commit docs**

Run:

```bash
git add README.md AGENTS.md content-site/README.md content-site/AI_HANDOFF.md infra/n8n/README.md infra/n8n/opentofu/README.md
git commit -m "Document ABPIV n8n and deployment operations"
```

Expected:

```text
[codex/abpiv-n8n-preview-main-deployment <sha>] Document ABPIV n8n and deployment operations
```

---

### Task 6: Final Verification

**Files:**
- Verify all changed files.

- [ ] **Step 1: Check for forbidden source leftovers**

Run:

```bash
rg -n "CipherPlay|cipherplay|CIPHERPLAY|forms\\.cipherplay\\.net|content-site\\.cipherplay\\.net|cipherplay-production|cipherplay-n8n|CLOUDFLARE_ZONE_ID_CIPHERPLAY" \
  infra/n8n .github/workflows README.md AGENTS.md content-site/README.md content-site/AI_HANDOFF.md
```

Expected:

```text
```

No output.

- [ ] **Step 2: Verify content site**

Run:

```bash
cd content-site
npm run typecheck
npm run build
```

Expected:

- `typecheck` exits `0`.
- `build` exits `0`.
- Existing non-blocking Docusaurus warnings may remain.

- [ ] **Step 3: Verify n8n OpenTofu**

Run:

```bash
cd /Users/user/Documents/abpiv-personal-brand/abpiv-personal-brand-clone
tofu fmt -check -recursive infra/n8n/opentofu
tofu -chdir=infra/n8n/opentofu init -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Expected:

```text
Success! The configuration is valid.
```

If backend init cannot run locally because of credentials, run:

```bash
tofu -chdir=infra/n8n/opentofu init -backend=false -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Expected:

```text
Success! The configuration is valid.
```

- [ ] **Step 4: Verify workflow syntax by dry-reading triggers**

Run:

```bash
rg -n "branches: \\[preview, main\\]|target:|refs/heads/preview|refs/heads/main|confirm_apply|confirm_redeploy|HEAD_REF != \"preview\"" .github/workflows
```

Expected matches include:

- `.github/workflows/deploy.yml` with `branches: [preview, main]`
- `.github/workflows/deploy.yml` with manual `target`
- `.github/workflows/main-source-guard.yml` with `HEAD_REF != "preview"`
- `.github/workflows/n8n-apply.yml` with `confirm_apply`
- `.github/workflows/n8n-redeploy.yml` with `confirm_redeploy`

- [ ] **Step 5: Verify no analytics infra was accidentally changed**

Run:

```bash
git diff --name-only origin/main...HEAD | rg '^infra/analytics/' || true
```

Expected:

```text
```

No output unless documentation was intentionally updated to reference the new deployment model. Do not modify analytics code for this plan.

- [ ] **Step 6: Verify whitespace**

Run:

```bash
git diff --check
```

Expected:

```text
```

No output.

- [ ] **Step 7: Final commit if verification changed generated files**

If `tofu init` updates `.terraform.lock.hcl`, commit it:

```bash
git add infra/n8n/opentofu/.terraform.lock.hcl
git commit -m "Lock n8n OpenTofu providers"
```

Skip this step if `git status --short` is clean.

---

### Task 7: Push And PR Flow

**Files:**
- No additional file edits.

- [ ] **Step 1: Push implementation branch**

Run:

```bash
git status --short
git push -u origin codex/abpiv-n8n-preview-main-deployment
```

Expected:

```text
branch 'codex/abpiv-n8n-preview-main-deployment' set up to track 'origin/codex/abpiv-n8n-preview-main-deployment'
```

- [ ] **Step 2: Open PR into `preview` first**

Run:

```bash
gh pr create \
  --base preview \
  --head codex/abpiv-n8n-preview-main-deployment \
  --title "Add n8n forms infra and preview deployment strategy" \
  --body "$(cat <<'EOF'
## Summary
- Adds ABPIV n8n forms infrastructure modeled after CipherPlay.
- Converts content-site deployment to preview auto-deploy and manual production deployment.
- Adds n8n validation/apply/redeploy workflows and main-source guard.

## Test Plan
- npm run typecheck
- npm run build
- tofu fmt -check -recursive infra/n8n/opentofu
- tofu -chdir=infra/n8n/opentofu validate
- git diff --check
EOF
)"
```

Expected:

- GitHub creates a PR targeting `preview`.

- [ ] **Step 3: After preview is accepted, merge `preview` into `main` by PR**

Use GitHub UI or CLI after the preview deployment is verified. The main-source guard requires the PR source branch to be exactly `preview`.

Expected branch flow:

```text
codex/abpiv-n8n-preview-main-deployment -> preview -> main
```

---

## Self-Review Checklist

- Spec coverage:
  - n8n forms infra copied: Task 2 and Task 3.
  - Public forms hostname: Task 2 docs and variables.
  - Private editor hostname and Access email: Task 3 and Task 5.
  - Preview/main branch strategy: Task 4 and Task 7.
  - Existing Plausible setup preserved: Task 4, Task 5, Task 6.
  - Existing content-site foundation preserved: Task 4 only changes deploy config and environment-driven `url`.
- Placeholder scan:
  - The plan does not ask the worker to invent hostnames, project names, or email access.
  - Domain discovery has a deterministic choice rule.
- Type/name consistency:
  - Terraform variable names use `allanbpediniv_zone_id`, `editor_zone_id`, and `forms_hostname`.
  - GitHub variables map to `TF_VAR_allanbpediniv_zone_id`.
  - n8n resource prefix is consistently `abpiv-n8n`.

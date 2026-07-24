# Google Cloud Profile: ABPIV Personal Brand

## Service Handle

| Field | Value |
| --- | --- |
| Profile id | `abpiv-personal-brand` |
| Service | Google Cloud |
| Environment | Production |
| Project id | `abpiv-personal-brand` |
| Default region for n8n infrastructure | `us-east1` |

## Approved Means Of Access

- [`gcloud-cli`](../interfaces/gcloud-cli.md)
- Google Cloud SDK authentication or approved service-account impersonation
- Repository GitHub Actions through Workload Identity Federation when an
  authorized workflow owns the operation

## Credential Boundary

Required references may include:

- Google Cloud SDK configuration `abpiv-personal-brand`
- Local binding `google-cloud.abpiv-personal-brand`
- Impersonation binding `ABPIV_GCP_IMPERSONATE_SERVICE_ACCOUNT`
- Repository workflow variables `N8N_GCP_PROJECT_ID`,
  `N8N_GCP_SERVICE_ACCOUNT`, and `N8N_GCP_WORKLOAD_IDENTITY_PROVIDER`

Values live in Google Cloud, GitHub encrypted configuration, platform auth, or
ignored local bindings and are governed by the
[`secret boundary`](../../../references/secret-boundary.md).

## Verification

Run before meaningful work:

```powershell
gcloud auth list
gcloud config list
gcloud projects describe abpiv-personal-brand
```

The explicit project must resolve to `abpiv-personal-brand`. Record the active
account identifier without recording credential material.

## Allowed Actions

- List or describe accessible resources, enabled services, buckets, Cloud Run
  services, infrastructure metadata, IAM bindings, and log metadata.
- Draft commands, plans, or infrastructure changes without applying them.

## Approval-Gated Or Denied Actions

Require explicit authority for resource creation or mutation, IAM or identity
changes, API enablement, quotas, budgets or billing, deployments, jobs, data
movement, public access, destructive operations, secret access, or interactive
shell/tunnel sessions. Creating or exporting key material is denied unless a
separately governed security task explicitly authorizes it.

## Stop Rules

Stop on project mismatch, stale auth, insufficient permissions, ambiguous region
or resource ownership, missing authority, or unsafe secret handling.

## Reporting Requirements

Report profile id, project id, active account identifier, interface, checks,
action class, affected resource handles, permission failures, and skipped gates.

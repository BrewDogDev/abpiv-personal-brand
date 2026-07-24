# gcloud CLI Interface

## Purpose

Use the local Google Cloud CLI for read-only verification and task-authorized
Google Cloud operations against an explicitly selected profile.

## Inputs

| Layer | Source | Use |
| --- | --- | --- |
| Stable service context | [`../CONTEXT.md`](../CONTEXT.md) | Service-wide gates |
| Stable profile | [`../profiles/abpiv-personal-brand.md`](../profiles/abpiv-personal-brand.md) | Exact project and reporting contract |
| Runtime binding | Google Cloud SDK auth, shell-scoped variables, or approved impersonation | Credential values outside Git |

## Process

1. Confirm `gcloud` is available.
2. Run `gcloud auth list` and `gcloud config list` without printing credential
   files.
3. Run `gcloud projects describe abpiv-personal-brand`.
4. Pass `--project=abpiv-personal-brand` on project-scoped commands where
   supported; do not rely on ambient defaults.
5. Prefer `list` and `describe` operations.
6. Confirm explicit authority before any mutation, deployment, data movement,
   permission change, billing effect, interactive session, or secret access.

## Stop Rules

Stop if the CLI is unavailable, auth is stale, the selected project does not
match, required permissions are absent, or diagnosis would expose local auth
material.

## Reporting

Report the active account identifier returned by the CLI, project id, commands
used, read-only or mutating class, permission failures, and skipped gated
actions. Do not report credential values.

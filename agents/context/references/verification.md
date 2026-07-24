# Verification Reference

Select checks by affected domain. Documentation-only work does not authorize runtime, infrastructure, deployment, or external-state changes.

## Universal Checks

From the repository root:

```powershell
git diff --check
git status --short
git diff --stat
```

Before committing, enumerate the intended paths, stage those exact paths, review `git diff --cached`, and run a targeted tracked-text scan for private-key blocks, credential-shaped values, and machine-local cache paths. Variable names and redacted placeholders are not credential values.

For Markdown changes, programmatically extract local inline links, strip anchors, resolve them relative to each document, and require every target to exist. Remote URLs do not satisfy or block this local check.

## Agent Context And Documentation

- Verify local links in every changed Markdown file and neighboring route or registry.
- Confirm stable guidance is Layer 3 and Projects, working files, runs, learning logs, and handoffs remain Layer 4.
- Confirm active Project discovery is only in `agents/context/projects/ROUTING.md`.
- Confirm no route invents an absent Workflow, tool, access profile, MCP server, or adapter.
- Compare branch and deployment claims to [`.github/workflows/`](../../../.github/workflows/) and the current Git graph.
- Scan tracked changes for credential values and machine-local plugin cache paths.

## Content Site

The [`Content Site`](../../../.github/workflows/deploy.yml) workflow installs dependencies, typechecks, builds, and checks homepage Insights alignment. For content-site changes:

```powershell
Set-Location content-site
npm ci
npm run typecheck
npm run build
npm run check:homepage-insights
```

Run any additional `check:*` script from [`package.json`](../../../content-site/package.json) that covers the changed surface. Use [`AI_HANDOFF.md`](../../../content-site/AI_HANDOFF.md) for base-path and deployment details.

## Analytics Worker And Infrastructure

For Worker changes:

```powershell
Set-Location infra/analytics/worker
npm ci
npm run typecheck
npm run build
npm test
git diff --exit-code dist/index.js
```

For analytics OpenTofu changes:

```powershell
tofu fmt -check -recursive infra/analytics/opentofu
tofu -chdir=infra/analytics/opentofu init -input=false
tofu -chdir=infra/analytics/opentofu validate
```

The live checks in [`infra/analytics/README.md`](../../../infra/analytics/README.md) are externally observable verification and must be run only when the task calls for live validation. Their expected boundary is a `200` site response, a same-origin script with `data-api=/_analytics/api/event`, and a `202` synthetic event response.

## n8n Infrastructure

```powershell
tofu fmt -check -recursive infra/n8n/opentofu
tofu -chdir=infra/n8n/opentofu init -input=false
tofu -chdir=infra/n8n/opentofu validate
```

Use [`infra/n8n/README.md`](../../../infra/n8n/README.md) for post-deploy checks. Validation does not authorize an apply, redeploy, credential read, or access change.

## Brand System

Validate changed JSON manifests by parsing them and verify that every referenced local asset exists. Review changes against [`README.md`](../../../creative-production/brand-systems/abpiv/README.md), [`prompt-contract.md`](../../../creative-production/brand-systems/abpiv/prompt-contract.md), and the package's existing lint or manifest contracts. Do not invent proof, metrics, or capabilities.

## Workflow And Live-State Changes

Inspect the exact trigger, branch condition, environment, confirmation input, permissions, and deployment effect in the changed workflow. A local syntax or diff check is not evidence that a production action ran. Remote checks, workflow dispatches, approvals, deploys, and applies require the authority stated in the Task or user request.

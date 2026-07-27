# Repository Map

This map identifies the narrowest live source for each repository concern. Load only the rows relevant to the current route.

## Discovery And Governance

| Concern | Source | Role |
| --- | --- | --- |
| Root agent discovery | [`AGENTS.md`](../../../AGENTS.md) | Thin pointer into canonical context. |
| Repository meaning and layers | [`context/CONTEXT.md`](../CONTEXT.md) | Canonical semantic context and safety boundaries. |
| Intent routing | [`context/ROUTING.md`](../ROUTING.md) | Selects the implementation domain or active Project surface. |
| Canonical terms | [`context/GLOSSARY.md`](../GLOSSARY.md) | Branch, environment, analytics, and agent-lifecycle language. |
| Active planned work | [`projects/ROUTING.md`](../projects/ROUTING.md) | Registry for active Projects only. |
| Verification | [`verification.md`](verification.md) | Local and live checks selected by affected domain. |
| Git and promotion | [`git-policy.md`](git-policy.md) | Branch, review, staging, publication, and deployment rules. |

## Implementation Domains

| Domain | Primary documentation | High-value implementation and automation |
| --- | --- | --- |
| Public content site | [`content-site/README.md`](../../../content-site/README.md) and [`content-site/AI_HANDOFF.md`](../../../content-site/AI_HANDOFF.md) | [`docusaurus.config.ts`](../../../content-site/docusaurus.config.ts), [`src/`](../../../content-site/src/), content collections under [`content-site/`](../../../content-site/), [`deploy.yml`](../../../.github/workflows/deploy.yml), and [`content-site-setup.yml`](../../../.github/workflows/content-site-setup.yml) |
| Shared analytics | [`infra/analytics/README.md`](../../../infra/analytics/README.md) | [`opentofu/`](../../../infra/analytics/opentofu/), [`worker/`](../../../infra/analytics/worker/), [`analytics-apply.yml`](../../../.github/workflows/analytics-apply.yml), and [`analytics-provision.yml`](../../../.github/workflows/analytics-provision.yml) |
| n8n forms infrastructure | [`infra/n8n/README.md`](../../../infra/n8n/README.md) | [`opentofu/`](../../../infra/n8n/opentofu/), [`n8n-validate.yml`](../../../.github/workflows/n8n-validate.yml), [`n8n-apply.yml`](../../../.github/workflows/n8n-apply.yml), and [`n8n-redeploy.yml`](../../../.github/workflows/n8n-redeploy.yml) |
| ABPIV brand system | [`brand-systems/abpiv/README.md`](../../../creative-production/brand-systems/abpiv/README.md) | [`CREATIVE_PRODUCTION.md`](../../../creative-production/brand-systems/abpiv/CREATIVE_PRODUCTION.md), [`creative-production.manifest.json`](../../../creative-production/brand-systems/abpiv/creative-production.manifest.json), and the assets and UI kits in that package |
| Repository promotion guard | [`main-source-guard.yml`](../../../.github/workflows/main-source-guard.yml) | Rejects pull requests into `main` unless their source branch is `preview`. |

## Agent Infrastructure

| Surface | Location | Current meaning |
| --- | --- | --- |
| Stable context | [`agents/context/`](../CONTEXT.md) | Repository meaning, routing, glossary, stable references, and Layer 4 registries. |
| Projects | [`agents/context/projects/`](../projects/CONTEXT.md) | Active Project control state and immutable archive boundary. |
| Agent Workflows | [`agents/context/workflows/`](../workflows/README.md) | Registry; no active reusable agent Workflow is currently defined. |
| Working material | [`agents/context/working/`](../working/README.md) | Cross-stage or exploratory Layer 4 artifacts. |
| Run history | [`agents/context/runs/`](../runs/README.md) | Retained evidence justified by auditability or reuse. |
| Legacy run history | [`agents/context/runs/legacy/`](../runs/legacy/README.md) | Provenance index for non-authoritative root, Kilo, and Superpowers artifacts. |
| Learning logs | [`agents/context/learnings/workspace/`](../learnings/workspace/LEARNINGS.md) | Raw workspace learning, errors, and feature requests awaiting review. |
| Context handoffs | [`agents/context/handoff/`](../handoff/README.md) | Non-Project continuity only. |
| Templates | [`templates/`](../../../templates/README.md) | Registry for reusable artifact templates. |
| Agent tools | [`tools/`](../../../tools/README.md) | Registry for executable agent capabilities. |
| External service access | [`access/`](../../../access/README.md) | Credential-free profiles for Google Cloud, Cloudflare, and n8n target selection, verification, and action gates. |
| MCP servers | [`mcp-servers/`](../../../mcp-servers/README.md) | Harness-agnostic server transport, dynamic-tool, credential-name, and safety contracts. |
| Harness adapters | [`adapters/`](../../../adapters/README.md) | Thin active Codex and historical Kilo mappings to canonical owners. |

## Legacy Run History

The [`legacy-history index`](../runs/legacy/README.md) accounts for the superseded root, Kilo, and Superpowers agent surfaces. The preserved artifacts are Layer 4 evidence, not default operating context, live routes, registered Workflows, or active Project control state.

## Local-Only State

`.codex-local/` is ignored and may contain credentials. Do not read, log, copy, link, or commit its contents during normal repository work. Canonical tracked documentation may describe the redacted contract, but secret values remain outside Git.

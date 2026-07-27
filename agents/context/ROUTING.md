# Agent Context Routing

## Domains

| User intent | Canonical starting point | Load next |
| --- | --- | --- |
| Start or resume nontrivial planned repository work | [`projects/ROUTING.md`](projects/ROUTING.md) | Classify the work before creating or selecting a Project. |
| Change content, navigation, presentation, or code on the public site | [`../../content-site/README.md`](../../content-site/README.md) | Use the content-site entries in the [`repository map`](references/repository-map.md) and [`verification reference`](references/verification.md). |
| Change Plausible analytics infrastructure or collection | [`../../infra/analytics/README.md`](../../infra/analytics/README.md) | Preserve same-origin collection through `/_analytics/*`. |
| Change n8n forms or editor infrastructure | [`../../infra/n8n/README.md`](../../infra/n8n/README.md) | Keep public forms, private editor, access, and secret boundaries distinct. |
| Use or change the ABPIV brand system | [`../../creative-production/brand-systems/abpiv/README.md`](../../creative-production/brand-systems/abpiv/README.md) | Treat the brand package and manifest as implementation sources of truth. |
| Select or verify a Google Cloud, Cloudflare, or n8n external target | [`agents/access/ROUTING.md`](../access/ROUTING.md) | Load one exact service profile and interface before using external access. |
| Configure or inspect an MCP server contract | [`agents/mcp-servers/README.md`](../mcp-servers/README.md) | Keep transport, dynamic tools, credential names, and server safety separate from target selection. |
| Understand Codex or historical Kilo harness mapping | [`agents/adapters/README.md`](../adapters/README.md) | Keep active mappings thin and canonical bodies under their owning domains. |
| Change repository automation, branch promotion, or deployment governance | [`references/git-policy.md`](references/git-policy.md) | Inspect the relevant live file under [`.github/workflows/`](../../.github/workflows/). |
| Change agent context or infrastructure | [`CONTEXT.md`](CONTEXT.md) | Route the asset by canonical owner; use the active Project registry when the work is planned. |
| Select checks or verify a change | [`references/verification.md`](references/verification.md) | Run the checks for every affected domain. |

## Agent Workflows

No reusable agent Workflow contract is currently registered. GitHub Actions files and n8n runtime workflows are implementation systems, not canonical agent Workflow contracts.

## Default Rule

If no route clearly owns the request, inspect the closest entries in the [`repository map`](references/repository-map.md) and stop rather than inventing a new owner or Workflow.

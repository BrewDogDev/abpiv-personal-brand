# Task 04: Establish Access, MCP, And Harness Adapter Contracts

## Status

Revisions

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-infrastructure-migration/PROJECT.md`
- Plan row: Task 04
- Planned from: `codex/migrate-agent-infrastructure` at coordinator checkpoint `44f2beb2aff94cfe0d3765e833f68dbf4121d6b9`
- Refreshed at: 2026-07-24 for isolated parallel dispatch
- Dependencies verified: Task 01 is `complete`; canonical context, routing, repository map, Git policy, ignored `.codex-local/` boundary, and live implementation/operator documentation exist; no credential value or local config read is required

## Outcome And Acceptance

- Outcome: future agents can select the ABPIV Google Cloud, Cloudflare, and Lobst3rs n8n targets, configure the existing n8n MCP client safely, and understand active Codex versus historical Kilo harness mappings without duplicating canonical instructions or exposing secrets.
- Acceptance criteria:
  - `agents/access/` has one credential-free routing/context surface with exact profiles for Google Cloud project `abpiv-personal-brand`, the Cloudflare account/site boundary used by this repository, and `workflows.lobst3rs.com`.
  - Access profiles separate stable target handles, approved interfaces, read-only verification, required credential names/binding keys, allowed actions, approval-gated actions, stop rules, and reporting.
  - `agents/mcp-servers/n8n-instance/MCP.md` documents upstream provenance, remote Streamable HTTP runtime, dynamic tool inventory, required header/binding names, safe redacted client shape, allowed reads, mutation/publication/test gates, ambiguity reconciliation, and troubleshooting without depending on an absent local tool.
  - `agents/adapters/codex/README.md` maps root `AGENTS.md`, canonical context, Projects, access, MCP, and the declared `agents/skills/agent-organization/` interface without copying their bodies; `agents/adapters/kilo/README.md` marks Kilo historical and points to preserved run history.
  - `agents/context/ROUTING.md` and `agents/context/references/repository-map.md` route external-target, MCP, and adapter work to the new owners.
  - `.codex-local/` remains ignored and unread; tracked examples contain placeholders and credential/header names only.
  - All owned Markdown links except the declared parallel Task 03 skill target resolve in this isolated Task head; combined integration must resolve that declared target before Project closure.
  - JSON/YAML/code examples parse where applicable, and safety scans find no token, key, private header value, personal cache path, or copied raw local config.

## Owned Scope

- Create: `agents/access/README.md`, `agents/access/CONTEXT.md`, `agents/access/ROUTING.md`, `agents/access/references/secret-boundary.md`, `agents/access/references/local-bindings.md`
- Create Google Cloud access files: `agents/access/services/google-cloud/CONTEXT.md`, `interfaces/gcloud-cli.md`, `profiles/abpiv-personal-brand.md`
- Create Cloudflare access files: `agents/access/services/cloudflare/CONTEXT.md`, `interfaces/wrangler-cli.md`, `profiles/abpiv-personal-brand.md`
- Create n8n access files: `agents/access/services/n8n/CONTEXT.md`, `interfaces/instance-mcp.md`, `profiles/workflows-lobst3rs.md`
- Create: `agents/mcp-servers/README.md`, `agents/mcp-servers/n8n-instance/MCP.md`
- Create: `agents/adapters/README.md`, `agents/adapters/codex/README.md`, `agents/adapters/kilo/README.md`
- Modify: `agents/context/ROUTING.md`, `agents/context/references/repository-map.md`
- Test: profile/interface/route consistency, local links and declared integration exception, redacted example syntax, ignored-local boundary, exact scope, whitespace, and secret/machine-path safety

## Do Not Touch

- `agents/skills/`, Project control files, other Task records, legacy raw history, root files, or implementation/operator files
- `.codex-local/`, `.git/info/exclude`, environment variables, credential stores, MCP runtime state, n8n, Cloudflare, Google Cloud, GitHub, or any external system
- Workflow, tool, skill, or implementation procedures beyond references needed to select the correct canonical owner
- Personal email identities when stable non-secret project/account/server handles are sufficient
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: Task 01 canonical context/Git/safety contracts; current `content-site/AI_HANDOFF.md`, `infra/n8n/README.md`, n8n OpenTofu, analytics/operator docs, `.gitignore`, and installed credential-free 0.1.30 templates/contracts as design sources
- Produces: stable access profiles, n8n MCP server contract, active Codex adapter, historical Kilo adapter, and canonical routes consumed by Task 05/final closure
- Declared parallel interface: `agents/skills/agent-organization/` is produced by Task 03; this Task may name it as code text but must record and defer only that target's resolution to combined integration

## Skills, Tools, And Authority

- Required implementation skills: `abpiv-agents:agent-access-organization`, `abpiv-agents:agent-mcp-organization`, `abpiv-agents:agent-adapter-organization`; return through `abpiv-agents:agent-organization`
- Required review and verification skills: `abpiv-agents:requesting-code-review`, `abpiv-agents:receiving-code-review`, profile/interface/link/example/safety inspection
- Allowed tools and actions: read tracked repository and installed credential-free template/contract sources; edit only owned paths with `apply_patch`; run local deterministic checks; commit exact owned implementation paths in the isolated Task worktree
- Approval-gated actions: none within the tracked credential-free contracts
- Prohibited actions: reading local credentials/config, probing MCP or external accounts, mutation, publication, deployment, permission expansion, broad staging, force operations, or Project control-state edits

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: validate route/profile/interface/server/adapter identifiers and links, parse every fenced JSON example after substituting no values, and assert secret-like fields contain only placeholders or binding names.
- Broader check: verify `.codex-local/` ignore behavior without reading it, exact owned diff scope, `git diff --check`, no external-state change, and secret/private-header/machine-cache scans.
- Diff or artifact review: isolated Task base-to-head diff must contain only owned `agents/access/`, `agents/mcp-servers/`, `agents/adapters/`, and two canonical routing files.
- Required evidence: profile matrix, route/link counts including the single declared parallel interface, example parse results, ignore result, safety scan, commit identity, and deferred combined check in `REPORT.md`.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

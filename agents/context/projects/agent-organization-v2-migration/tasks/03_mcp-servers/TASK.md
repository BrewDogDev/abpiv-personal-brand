# Task 03: Relocate MCP server contracts

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-organization-v2-migration/PROJECT.md`
- Plan row: 03
- Planned from: `codex/migrate-agent-organization-v2` at coordinator commit `0d12bf11b825eb579710742671d37bdd6940b456`
- Refreshed at: 2026-07-27 at coordinator commit `0d12bf11b825eb579710742671d37bdd6940b456`
- Dependencies verified: Task 02 is `complete`; its `REPORT.md` is `DONE`, its `REVIEW.md` is `COMPLIANT` / `APPROVED` / `READY`, and the required `agents/access/services/n8n/profiles/workflows-lobst3rs.md` and `agents/access/references/local-bindings.md` interfaces exist.

## Role, Outcome, And Acceptance

- Role: bounded MCP server documentation migration implementer
- Outcome: the complete two-file MCP registry lives under `agents/mcp-servers/` with access-profile, runtime, dynamic-tool, credential-name, and server safety relationships preserved.
- Acceptance criteria:
  - Move both tracked files from `mcp-servers/` to equivalent relative paths under `agents/mcp-servers/` with Git-visible history; require the former top-level `mcp-servers/` root to be absent.
  - Preserve both files byte-for-byte or normalized-content exact; no link or contract edit is expected.
  - Require all four local Markdown links to resolve after the move: one registry contract link and three references to the migrated Access owner.
  - Preserve the remote Streamable HTTP transport, dynamic `tools/list` authority, credential and header names, action gates, ambiguity handling, safety notes, example boundaries, and statement that no local server executable or secret-bearing client configuration is tracked.
  - Require zero runtime access, MCP connection, authentication, credential reads, external mutation, generated files, secret values, machine-local installed-cache paths, or new tool claims.

## Relevant Context And Source Paths

- `agents/skills/agent-organization/agent-mcp-organization/SKILL.md` owns server runtime, transport, dynamic-tool, credential-name, and server-level safety contracts.
- Task 02 moved the selected n8n Access profile and recovery contract to `agents/access/`; existing relative MCP links now resolve to those target paths without text changes.
- The live n8n tool inventory remains dynamically discovered; a copied inventory must not become stable documentation.
- `mcp-servers/README.md`
- `mcp-servers/n8n-instance/MCP.md`
- `agents/access/services/n8n/profiles/workflows-lobst3rs.md`
- `agents/access/references/local-bindings.md`
- `agents/context/projects/agent-organization-v2-migration/tasks/02_access/REPORT.md`
- `agents/context/projects/agent-organization-v2-migration/tasks/02_access/REVIEW.md`

## Owned Scope

- Create: `agents/mcp-servers/` and `agents/context/projects/agent-organization-v2-migration/tasks/03_mcp-servers/REPORT.md`
- Modify: tracked content moved from `mcp-servers/` to `agents/mcp-servers/`; no body edit is expected
- Test: two-file inventory and normalized content, four local links, exact safety and interface markers, generated and secret/path scans, Project and Workflow validators, `git diff --check`, and exact diff scope

## Do Not Touch

- Any file outside existing `mcp-servers/`, target `agents/mcp-servers/`, and this Task's `REPORT.md`
- Access, adapters, context routes, skills, tools, templates, applications, infrastructure, workflows, archives, legacy runs, ignored local bindings, credentials, MCP clients, or external systems
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: Task 02's migrated n8n Access profile and local-binding recovery contract, plus the current two-file MCP registry
- Produces: an equivalent two-file registry under `agents/mcp-servers/`, four resolving local links, preservation and safety evidence, and `REPORT.md`

## Skills, Tools, Authority, And Selection

- Required implementation skills: `agent-mcp-organization` and return through `agent-organization`
- Required review and verification skills: `requesting-code-review`, `receiving-code-review`, and `verification-before-completion`
- Allowed tools and actions: read tracked MCP and directly linked Access documentation; make the in-scope tracked move; run local deterministic checks; stage and commit exact owned paths
- Approval-gated actions: any edit to server provenance, runtime, transport, compatibility, exposed-tool semantics, credentials, scopes, permissions, targets, or safety gates
- Prohibited actions: delegation; connection to MCP; authentication; credential or `.codex-local/` access; external verification or mutation; push, PR, merge, deploy, publish, force push, destructive reset, or edits outside owned scope
- Implementer capability class: `balanced` because the file move is small but runtime, dynamic-tool, credential, and Access-owner boundaries must remain precise
- Implementer reasoning class: `medium` because the expected result is explicit and directly verifiable while safety drift would matter
- Review depth: `quick` because a two-file documentation-only move with exact content, link, interface-marker, and scope checks has strong direct verification
- Reviewer capability class: `balanced` because review must understand the MCP/Access boundary and inspect exact preservation evidence
- Reviewer reasoning class: `medium` because review risk is bounded to stale paths or unintended server/safety contract drift
- Isolation requirements: one implementer writes only the MCP surface and its report in this worktree; no other worker writes concurrently; Project control state remains coordinator-owned

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Use the repository's equivalent evidence cycle: record the absent target path before the move, then prove exact target inventory, content, links, and safety markers after the move.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: require two target files, no top-level `mcp-servers/`, normalized content equality for both files, four resolving local links, and unchanged runtime, tool-discovery, credential-name, gate, and secret-boundary markers
- Broader check: run the canonical Project and Workflow validators from `agents/skills/`; require zero errors or warnings and confirm no runtime or external state was touched
- Diff or artifact review: inspect exact Task base-to-head diff for only old and target MCP paths plus `REPORT.md`; both source documents should be 100% renames
- Required evidence: exact Task base/head and commit, inventory/content comparison, link results, safety-marker comparison, secret/cache-path scan, generated-file scan, validator output, `git diff --check`, and scope status

## Ambiguity And Escalation

- The implementer may resolve mechanical line endings, empty source directories, and Git rename detection without changing tracked body content.
- Escalate before continuing if file count differs from two, a body or link edit appears necessary, an Access target does not resolve, server/runtime/tool/safety semantics conflict, a secret or local value could be exposed, or any required check cannot run.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: one exact local commit containing the two-file MCP move, preservation evidence, and implementer report
- Independent review: `REVIEW.md`
- Review requirements: quickly inspect all acceptance criteria, actual move, exact content and link evidence, runtime/tool/credential/safety preservation, scope, and obvious regressions; return specification, quality, readiness, finding evidence, and re-review gate
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

# Task 01: Migrate Canonical Non-Skill Owners And Context Routes

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-documentation-mono-layout-migration/PROJECT.md`
- Plan row: 01
- Planned from: branch `codex/migrate-agent-docs-mono-layout` at coordinator checkpoint `a753c84`
- Refreshed at: 2026-07-27 at `a753c84`
- Dependencies verified: None; the worktree is clean, Project status is `ready`, and no other worker owns these paths

## Outcome And Acceptance

- Outcome: Live non-skill agent owners and active context routes use Mono 1.1.0's top-level canonical layout while preserving content, safety contracts, implementation behavior, and immutable history.
- Acceptance criteria:
  - Every tracked file under live `agents/access/`, `agents/adapters/`, `agents/mcp-servers/`, `agents/templates/`, and `agents/tools/` is moved with history to the equivalent top-level owner and no former live file remains.
  - Active context, repository-map, verification, access, MCP, and adapter links resolve at their new locations.
  - The Codex adapter maps root instructions, `agents/context/`, top-level access/MCP/skills owners, and recursive skill discovery without stale Project-task language.
  - The Kilo adapter remains historical and points to current canonical owners without reactivating Kilo.
  - No active tracked text outside immutable Project archives, legacy runs, and Task 02's still-unmigrated skill scope claims `agents/access/`, `agents/adapters/`, `agents/mcp-servers/`, `agents/templates/`, or `agents/tools/` is canonical.
  - Access handles, approval gates, ignored local-binding guidance, n8n recovery metadata, MCP behavior, and secret boundaries are semantically unchanged.
  - `agents/context/projects/archive/`, `agents/context/runs/legacy/`, `content-site/`, `creative-production/`, and `infra/` are unchanged from the Task base.

## Owned Scope

- Create: top-level `access/`, `adapters/`, `mcp-servers/`, `templates/`, and `tools/` only through history-preserving moves from their `agents/` predecessors; this `REPORT.md`
- Modify: moved files as required for relative links and live path language; `agents/context/CONTEXT.md`, `agents/context/ROUTING.md`, `agents/context/references/repository-map.md`, and `agents/context/references/verification.md`; root `AGENTS.md` or `README.md` only if live evidence requires a narrow discovery correction
- Test: changed and neighboring Markdown links; active old-path search; exact move/blob accounting; Project validator from its pre-Task path; Git scope, safety, and whitespace checks

## Do Not Touch

- `agents/skills/` or future `skills/`; Task 02 owns that migration.
- `agents/context/projects/agent-documentation-mono-layout-migration/PROJECT.md`, `PLAN.md`, Project routing, or any other coordinator control state.
- `agents/context/projects/archive/`, `agents/context/runs/legacy/`, any prior handoff or learning history, implementation code and docs under `content-site/`, `creative-production/`, and `infra/`, `.github/workflows/`, `.gitignore`, ignored `.codex-local/`, external services, branches, remotes, or pull requests.

## Interfaces

- Consumes: Mono 1.1.0 canonical owner layout; current live context and owner contracts; Git policy; Task base `a753c84`
- Produces: top-level canonical non-skill owner surfaces, corrected active route/link interfaces, `REPORT.md`, and one exact implementation commit for independent review

## Skills, Tools, And Authority

- Required implementation skills: `mono:agent-context-organization`, `mono:agent-access-organization`, `mono:agent-mcp-organization`, `mono:agent-adapter-organization`, `mono:agent-tool-organization`
- Required review and verification skills: `mono:verification-before-completion`, `mono:requesting-code-review`, `mono:receiving-code-review`
- Allowed tools and actions: read tracked files and Git metadata; use `apply_patch` for moves and edits; run local read-only searches and validators; stage exact owned files; commit one coherent Task result
- Approval-gated actions: None inside the owned tracked-documentation scope; stop before any external mutation, publication, permission, secret, production, deletion-without-preservation, or scope-expanding action
- Prohibited actions: delegate; edit Project control state; read ignored secret values; use destructive reset/clean/checkout or force push; deploy; mutate external systems; alter implementation behavior or immutable history

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: enumerate the five old and new owner trees, review `git diff --summary` for moves, and verify active old-path searches return no Task-01-owned canonical references
- Broader check: run a programmatic local-inline-link resolver across all changed Markdown plus `agents/context/CONTEXT.md`, `ROUTING.md`, repository map, access registry, MCP registry, and both adapter contracts; run `python agents/skills/agent-organization/agent-project-organization/scripts/validate_projects.py .` before Task 02 moves the validator
- Diff or artifact review: compare `a753c84..HEAD`; require only owned paths plus `REPORT.md`; require no diff in immutable history, implementation domains, workflows, or Task 02 scope
- Required evidence: old-to-new inventory and blob accounting, link count and zero failures, search commands and zero unexpected matches, validator result, secret/machine-local-path scan, `git diff --check`, exact commit identity, and unchanged prohibited paths

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

# Task 06: Relocate and remap harness adapters

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-organization-v2-migration/PROJECT.md`
- Plan row: 06
- Planned from: `codex/migrate-agent-organization-v2` at coordinator commit `17dfb71a039e1542d6c598cd6040fdd1b59fdba4`
- Refreshed at: 2026-07-27 at coordinator commit `17dfb71a039e1542d6c598cd6040fdd1b59fdba4`
- Dependencies verified: Tasks 01 through 05 are `complete`, each has `DONE` implementation evidence and `COMPLIANT` / `APPROVED` / `READY` independent review, and the target canonical owners exist at `agents/skills/`, `agents/access/`, `agents/mcp-servers/`, `agents/tools/`, and `agents/templates/`.

## Role, Outcome, And Acceptance

- Role: bounded harness-adapter migration implementer
- Outcome: the three-file adapter registry lives under `agents/adapters/`, with active Codex discovery mapped to every relevant canonical `agents/*` owner and Kilo preserved as historical evidence.
- Acceptance criteria:
  - Move all three tracked adapter files to equivalent relative paths under `agents/adapters/` with Git-visible history; require the former top-level `adapters/` root to be absent.
  - Update Codex root-entrypoint links for the extra path segment and update context links from former `../../agents/context/` routes to the new sibling `../../context/` routes.
  - Preserve the relative sibling paths for Access, MCP, and Skills so they resolve under `agents/`.
  - Replace obsolete “top-level owner” wording with the 0.1.36 canonical-owner language under `agents/`.
  - Add thin Codex mapping rows for `agents/tools/README.md` and `agents/templates/README.md`, explicitly retaining their currently empty registry status without inventing a tool or template.
  - Update Kilo's root and context-relative links for the moved adapter path while preserving maintenance status `historical`, no active discovery entrypoint, no synchronization, and no reactivation.
  - Require every local adapter link to resolve; recursively verify 14 unique folder-matched skills and 14 matching `agents/openai.yaml` prompts from the Codex mapping target.
  - Keep adapters mapping-only: no canonical instruction body duplication, generated manifest, installed-cache path, user-specific path, local configuration, secret, permission expansion, or external/runtime mutation.

## Relevant Context And Source Paths

- `agents/skills/agent-organization/agent-adapter-organization/SKILL.md` owns harness-specific mapping and requires active/historical status, canonical references, recursive discovery, and secret/local-state separation.
- Root `AGENTS.md` remains the supported Codex repository entrypoint at repository root.
- `agents/context/` remains canonical context; other migrated owners are siblings beneath `agents/`.
- The current Codex adapter is active; Kilo is historical and must not be modernized or reactivated.
- `adapters/README.md`
- `adapters/codex/README.md`
- `adapters/kilo/README.md`
- `AGENTS.md`
- `agents/context/`
- `agents/skills/`
- `agents/access/`
- `agents/mcp-servers/`
- `agents/tools/`
- `agents/templates/`

## Owned Scope

- Create: `agents/adapters/` and `agents/context/projects/agent-organization-v2-migration/tasks/06_adapters/REPORT.md`
- Modify: the three files moved from `adapters/` to `agents/adapters/`, limited to path, canonical-owner wording, and two thin empty-registry mapping rows required by acceptance
- Test: three-file inventory, normalized content delta map, all local links, active/historical status, mapping-only assertions, recursive skill/metadata discovery, generated/secret/cache-path scans, Project and Workflow validators, `git diff --check`, and exact diff scope

## Do Not Touch

- Any file outside existing `adapters/`, target `agents/adapters/`, and this Task's `REPORT.md`
- Root `AGENTS.md`, canonical context, skills, access, MCP, tools, templates, applications, infrastructure, workflows, archives, legacy runs, installed consumers, ignored local state, or external systems
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: completed target owner paths from Tasks 01 through 05, root `AGENTS.md`, canonical context, current active Codex mapping, and historical Kilo mapping
- Produces: three adapter files under `agents/adapters/`, resolving mappings to root and canonical owners, recursive-discovery evidence, preserved maintenance statuses, and `REPORT.md`

## Skills, Tools, Authority, And Selection

- Required implementation skills: `agent-adapter-organization` and return through `agent-organization`
- Required review and verification skills: `requesting-code-review`, `receiving-code-review`, `verification-before-completion`, and `testing-agent-skills` for deterministic recursive-discovery evidence
- Allowed tools and actions: read tracked adapters and mapped canonical targets; make the in-scope tracked move and bounded mapping edits; run local deterministic checks; stage and commit exact owned paths
- Approval-gated actions: adding or reactivating a maintained harness, generating or publishing a manifest, installing a skill or adapter, changing a public install contract, or broadening runtime permissions
- Prohibited actions: delegation; Kilo reactivation; copying canonical bodies; installed-cache or local-config writes; secret or ignored-local-state access; external/runtime mutation; push, PR, merge, deploy, publish, force push, destructive reset, or edits outside owned scope
- Implementer capability class: `balanced` because the Task updates multiple harness mappings after structural owner moves
- Implementer reasoning class: `medium` because current and target paths are explicit but active versus historical behavior and mapping-only boundaries require care
- Review depth: `rigorous` because the named compatibility risk is silent failure of Codex entrypoint, canonical-path, nested-skill, or metadata discovery after the structural migration
- Reviewer capability class: `deep` because review must independently trace mappings, recursive discovery, status boundaries, and the exact adapter delta
- Reviewer reasoning class: `high` because stale or duplicated discovery contracts can appear valid while misrouting future agent runs
- Isolation requirements: one implementer writes only the adapter surface and its report in this worktree; no other worker writes concurrently; Project control state and canonical owners remain read-only

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Use the repository's equivalent evidence cycle: record absent target adapters or broken target-relative links before the move, then prove all target mappings and recursive discovery after the move.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: require three target files, no top-level `adapters/`, all local links resolving, Codex active and Kilo historical status, mappings to root/context/skills/access/MCP/tools/templates, 14 unique folder-matched skills, 14 matching metadata prompts, and no duplicated canonical body or generated manifest
- Broader check: run the canonical Project and Workflow validators from `agents/skills/`; require zero errors or warnings
- Diff or artifact review: inspect exact Task base-to-head diff for only old and target adapter paths plus `REPORT.md`; distinguish moves, required path edits, wording changes, and the two mapping rows
- Required evidence: exact Task base/head and commit, file/delta inventory, link-resolution table, mapping/status assertions, recursive-discovery and metadata results, generated/secret/cache-path scans, validator output, `git diff --check`, and scope status

## Ambiguity And Escalation

- The implementer may resolve exact relative-path syntax and concise mapping-row wording from live target paths without changing canonical ownership or harness status.
- Escalate before continuing if any canonical target is missing, recursive discovery or metadata matching fails, a harness would need activation or installation, mapping requires duplicated canonical instructions, a secret or machine-local path could be exposed, or any required check cannot run.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: one exact local commit containing the three-file adapter move, bounded mapping updates, recursive-discovery evidence, and implementer report
- Independent review: `REVIEW.md`
- Review requirements: rigorously trace the active Codex and historical Kilo mappings, every local link, canonical-owner and mapping-only boundaries, recursive skills and metadata discovery, actual diff and evidence, and return specification, quality, readiness, findings, and re-review gate
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

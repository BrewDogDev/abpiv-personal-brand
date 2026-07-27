# Task 02: Relocate external-service access contracts

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-organization-v2-migration/PROJECT.md`
- Plan row: 02
- Planned from: `codex/migrate-agent-organization-v2` at coordinator commit `60402a0b47c2fae1ffc7a1d52d6510dbc79c0010`
- Refreshed at: 2026-07-27 at coordinator commit `60402a0b47c2fae1ffc7a1d52d6510dbc79c0010`
- Dependencies verified: None; Task 01 is independently complete, the worktree is clean, all 14 current access files are present, and no other worker owns the shared worktree.

## Role, Outcome, And Acceptance

- Role: bounded external-service access documentation migration implementer
- Outcome: the credential-free access registry and all 14 of its files live under `agents/access/`, preserving service handles, profiles, interfaces, gates, and secret boundaries while correcting relative links for the additional `agents/` path segment.
- Acceptance criteria:
  - Move all 14 tracked files from `access/` to equivalent relative paths under `agents/access/` with Git-visible history; require the former top-level `access/` root to be absent.
  - Preserve all human-authored access behavior, stable handles, service and profile names, verification commands, allowed and approval-gated action classes, local binding names, and secret boundaries.
  - Correct only the repository-external relative links whose targets remain at repository root after the extra `agents/` path segment: one `.github/workflows/` link, one n8n `infra/` link, and two Google Cloud `infra/` links.
  - Require every access-internal link and every implementation link to `.github/` or `infra/` to resolve after the move.
  - Preserve and explicitly verify the five planned sibling-owner links that will resolve after Task 03 moves MCP and Task 06 moves adapters: four links into `agents/mcp-servers/` and one link into `agents/adapters/`.
  - Require zero credential values, private payloads, machine-local credential paths, installed-cache paths, generated files, or changes to target identity, permissions, or external state.

## Relevant Context And Source Paths

- `agents/skills/agent-organization/agent-access-organization/SKILL.md` owns credential-free service, profile, interface, scope, verification, approval, and secret-boundary contracts.
- Root `.codex-local/` remains ignored and prohibited from inspection; tracked access documentation may name binding keys but never their values.
- Existing sibling links use relative paths that naturally point to `agents/mcp-servers/` and `agents/adapters/` after the move, but those target owner moves are later Project Tasks.
- Existing repository-root implementation links need one additional parent segment after the move under `agents/`.
- `access/README.md`
- `access/CONTEXT.md`
- `access/ROUTING.md`
- `access/references/`
- `access/services/`
- `agents/context/projects/agent-organization-v2-migration/PLAN.md`

## Owned Scope

- Create: `agents/access/` and `agents/context/projects/agent-organization-v2-migration/tasks/02_access/REPORT.md`
- Modify: tracked content moved from `access/` to `agents/access/`, limited to the four required repository-root relative-link corrections
- Test: file and normalized-content inventory, internal and implementation links, exact five planned sibling links, service/profile/interface consistency, stable-handle preservation, secret and machine-path scans, `git diff --check`, and exact diff scope

## Do Not Touch

- Any file outside existing `access/`, target `agents/access/`, and this Task's `REPORT.md`
- `agents/mcp-servers/`, `mcp-servers/`, `agents/adapters/`, `adapters/`, context routes, skills, tools, templates, applications, infrastructure, workflows, archives, legacy runs, ignored local bindings, or external systems
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: the current 14-file credential-free access registry, root repository paths, the documented secret boundary, and planned sibling target paths from Tasks 03 and 06
- Produces: an equivalent 14-file registry under `agents/access/`, four corrected repository-root links, five verified planned sibling links, preservation and safety evidence, and `REPORT.md`

## Skills, Tools, Authority, And Selection

- Required implementation skills: `agent-access-organization` and return through `agent-organization`
- Required review and verification skills: `requesting-code-review`, `receiving-code-review`, and `verification-before-completion`
- Allowed tools and actions: read tracked access and directly linked public repository documentation; make the in-scope tracked move and four relative-link edits; run local deterministic checks; stage and commit exact owned paths
- Approval-gated actions: any addition or removal of a profile, target, interface, scope, allowed action, binding key, or secret-boundary rule
- Prohibited actions: delegation; reading `.codex-local/` or credentials; authenticating; external target verification; changing permissions or external state; push, PR, merge, deploy, publish, force push, destructive reset, or edits outside owned scope
- Implementer capability class: `balanced` because the move is bounded but spans routing, profiles, interfaces, relative paths, and safety contracts
- Implementer reasoning class: `medium` because evidence clearly identifies the four root-link corrections and five planned sibling dependencies
- Review depth: `quick` because this is a documentation-only move with direct inventory, normalized-content, link, stable-handle, and safety verification
- Reviewer capability class: `balanced` because review must understand the access/MCP/adapter boundary and inspect exact evidence without broader architecture work
- Reviewer reasoning class: `medium` because the risk is bounded stale-link or safety-text drift with strong deterministic checks
- Isolation requirements: one implementer writes only the access surface and its report in this worktree; no other worker writes concurrently; Project control state remains coordinator-owned

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Use the repository's equivalent evidence cycle: record the absent target path before the move, then prove target inventory, links, and preservation after the move.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: require 14 target files, no top-level `access/`, normalized content preservation except exactly four root-relative link corrections, resolving internal and repository implementation links, and exactly five known planned sibling targets
- Broader check: run the canonical Project and Workflow validators from `agents/skills/`; require zero errors or warnings and confirm the move does not change active Project, Workflow, implementation, or external state
- Diff or artifact review: inspect exact Task base-to-head diff for only old and target access paths plus `REPORT.md`; distinguish history-visible moves from the four intended path edits
- Required evidence: exact Task base/head and commit, file counts, normalized preservation/delta map, link-resolution results, planned sibling-link list, stable-handle and safety-contract comparison, secret/cache-path scan, `git diff --check`, and scope status

## Ambiguity And Escalation

- The implementer may resolve mechanical line endings and Git rename detection, and may add one parent segment only to the four evidenced repository-root links.
- Escalate before continuing if file count differs from 14, a change beyond the four root-relative links appears necessary, a profile or safety rule would change, the planned sibling-link set differs from five, a secret or local value could be exposed, or any required check cannot run.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: one exact local commit containing the access move, four link corrections, preservation evidence, and implementer report
- Independent review: `REVIEW.md`
- Review requirements: quickly inspect all acceptance criteria, actual move and four deltas, link and planned-dependency evidence, stable-handle and secret-boundary preservation, scope, and obvious regressions; return specification, quality, readiness, finding evidence, and re-review gate
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

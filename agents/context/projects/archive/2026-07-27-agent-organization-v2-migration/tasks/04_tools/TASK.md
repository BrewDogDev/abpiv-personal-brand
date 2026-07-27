# Task 04: Relocate the executable-tool registry

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-organization-v2-migration/PROJECT.md`
- Plan row: 04
- Planned from: `codex/migrate-agent-organization-v2` at coordinator commit `50f4450394ef41bc64402dafb8db130842c86234`
- Refreshed at: 2026-07-27 at coordinator commit `50f4450394ef41bc64402dafb8db130842c86234`
- Dependencies verified: None; Tasks 01 through 03 are complete, the worktree is clean, and `tools/README.md` is the only file under the current registry.

## Role, Outcome, And Acceptance

- Role: bounded executable-tool registry migration implementer
- Outcome: the unchanged empty agent-tool registry lives at `agents/tools/README.md`.
- Acceptance criteria:
  - Move `tools/README.md` to `agents/tools/README.md` as a 100% Git-visible rename and remove the former top-level `tools/` root.
  - Preserve the file blob exactly, including the statement that no repository-owned executable agent tool is registered.
  - Do not create a `TOOL.md`, executable, capability claim, input/output contract, safety rule, Workflow, MCP contract, or external side effect.
  - Require zero generated files, secrets, private payloads, machine-local paths, external mutation, or unrelated changes.

## Relevant Context And Source Paths

- `agents/skills/agent-organization/agent-tool-organization/SKILL.md` owns one executable-capability contract and explicitly distinguishes tools from skills, MCP servers, access profiles, and adapters.
- The current registry is intentionally empty and is not evidence that GitHub Actions, n8n workflows, scripts, or prose are agent tools.
- `tools/README.md`
- `agents/context/projects/agent-organization-v2-migration/PLAN.md`

## Owned Scope

- Create: `agents/tools/README.md` and `agents/context/projects/agent-organization-v2-migration/tasks/04_tools/REPORT.md`
- Modify: the tracked move from `tools/README.md`; no body edit is expected
- Test: one-file inventory, exact blob equality, old-root absence, empty-registry classification, generated and safety scans, Project and Workflow validators, `git diff --check`, and exact diff scope

## Do Not Touch

- Any file outside existing `tools/`, target `agents/tools/`, and this Task's `REPORT.md`
- Skills, access, MCP, templates, adapters, context routes, applications, infrastructure, workflows, archives, legacy runs, ignored local state, or external systems
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: the current one-file empty tool registry and the 0.1.36 `agents/tools/` placement contract
- Produces: an exact registry at `agents/tools/README.md`, preservation and scope evidence, and `REPORT.md`

## Skills, Tools, Authority, And Selection

- Required implementation skills: `agent-tool-organization` and return through `agent-organization`
- Required review and verification skills: `requesting-code-review`, `receiving-code-review`, and `verification-before-completion`
- Allowed tools and actions: read the tracked registry and owning skill; make the one-file tracked move; run local deterministic checks; stage and commit exact owned paths
- Approval-gated actions: any body change or creation, registration, deletion, renaming, publication, or permission change for an executable tool contract
- Prohibited actions: delegation; executable creation or invocation; external access or mutation; secret or ignored-local-state access; push, PR, merge, deploy, publish, force push, destructive reset, or edits outside owned scope
- Implementer capability class: `fast-repeatable` because the Task is one explicit low-consequence file move with exact blob verification
- Implementer reasoning class: `low` because ownership, expected output, side effects, and checks are mechanically defined
- Review depth: `quick` because exact rename, blob, classification, and scope evidence directly prove acceptance
- Reviewer capability class: `fast-repeatable` because review is a mechanical one-file comparison against an explicit contract
- Reviewer reasoning class: `low` because no interpretation beyond classification preservation and scope is required
- Isolation requirements: one implementer writes only the tool registry and its report in this worktree; no other worker writes concurrently; Project control state remains coordinator-owned

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Use the repository's equivalent evidence cycle: record the absent target path before the move, then prove the exact target blob and classification after the move.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: require one target file, no top-level `tools/`, exact base-to-target blob equality, and the unchanged empty-registry and owner-classification sentences
- Broader check: run the canonical Project and Workflow validators from `agents/skills/`; require zero errors or warnings
- Diff or artifact review: inspect exact Task base-to-head diff for only the old and target tool path plus `REPORT.md`; the registry must be a 100% rename
- Required evidence: exact Task base/head and commit, blob identities, inventory, classification assertions, generated and secret/cache-path scans, validator output, `git diff --check`, and scope status

## Ambiguity And Escalation

- The implementer may resolve mechanical empty-directory cleanup and Git rename detection without changing tracked content.
- Escalate before continuing if the registry contains more than one file, the blob would change, any executable tool appears, ownership becomes ambiguous, a secret or local path could be exposed, or any required check cannot run.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: one exact local commit containing the one-file registry move and implementer report
- Independent review: `REVIEW.md`
- Review requirements: quickly inspect the one-file rename, exact blob and empty-registry classification, actual evidence, scope, and obvious regressions; return specification, quality, readiness, finding evidence, and re-review gate
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

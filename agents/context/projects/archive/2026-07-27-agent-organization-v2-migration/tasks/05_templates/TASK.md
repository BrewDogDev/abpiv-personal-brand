# Task 05: Relocate the reusable-template registry

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-organization-v2-migration/PROJECT.md`
- Plan row: 05
- Planned from: `codex/migrate-agent-organization-v2` at coordinator commit `90f7a0da4a90d6bacd97aab78022f0cc67278ced`
- Refreshed at: 2026-07-27 at coordinator commit `90f7a0da4a90d6bacd97aab78022f0cc67278ced`
- Dependencies verified: None; Tasks 01 through 04 are complete, the worktree is clean, and `templates/README.md` is the only file under the current registry.

## Role, Outcome, And Acceptance

- Role: bounded reusable-template registry migration implementer
- Outcome: the unchanged empty agent-template registry lives at `agents/templates/README.md`.
- Acceptance criteria:
  - Move `templates/README.md` to `agents/templates/README.md` as a 100% Git-visible rename and remove the former top-level `templates/` root.
  - Preserve the file blob exactly, including the statement that no reusable agent artifact template is registered.
  - Do not create a template, Workflow, skill resource, run-specific artifact, credential-bearing file, or new capability claim.
  - Require zero generated files, secrets, private payloads, machine-local paths, external mutation, or unrelated changes.

## Relevant Context And Source Paths

- The parent `agent-organization` contract places reusable templates under `agents/templates/` and requires templates to be created lazily only when an active repeated need justifies them.
- The current registry explicitly prohibits run-specific state, credentials, private payloads, and machine-local paths.
- `templates/README.md`
- `agents/skills/agent-organization/SKILL.md`
- `agents/context/projects/agent-organization-v2-migration/PLAN.md`

## Owned Scope

- Create: `agents/templates/README.md` and `agents/context/projects/agent-organization-v2-migration/tasks/05_templates/REPORT.md`
- Modify: the tracked move from `templates/README.md`; no body edit is expected
- Test: one-file inventory, exact blob equality, old-root absence, empty-registry classification, generated and safety scans, Project and Workflow validators, `git diff --check`, and exact diff scope

## Do Not Touch

- Any file outside existing `templates/`, target `agents/templates/`, and this Task's `REPORT.md`
- Skills, access, MCP, tools, adapters, context routes, applications, infrastructure, workflows, archives, legacy runs, ignored local state, or external systems
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: the current one-file empty template registry and the 0.1.36 `agents/templates/` placement contract
- Produces: an exact registry at `agents/templates/README.md`, preservation and scope evidence, and `REPORT.md`

## Skills, Tools, Authority, And Selection

- Required implementation skills: `agent-organization`
- Required review and verification skills: `requesting-code-review`, `receiving-code-review`, and `verification-before-completion`
- Allowed tools and actions: read the tracked registry and parent organization skill; make the one-file tracked move; run local deterministic checks; stage and commit exact owned paths
- Approval-gated actions: any body change or creation, registration, deletion, renaming, or publication of a reusable template
- Prohibited actions: delegation; template or capability invention; external access or mutation; secret or ignored-local-state access; push, PR, merge, deploy, publish, force push, destructive reset, or edits outside owned scope
- Implementer capability class: `fast-repeatable` because the Task is one explicit low-consequence file move with exact blob verification
- Implementer reasoning class: `low` because ownership, expected output, side effects, and checks are mechanically defined
- Review depth: `quick` because exact rename, blob, classification, and scope evidence directly prove acceptance
- Reviewer capability class: `fast-repeatable` because review is a mechanical one-file comparison against an explicit registry contract
- Reviewer reasoning class: `low` because no interpretation beyond classification preservation and scope is required
- Isolation requirements: one implementer writes only the template registry and its report in this worktree; no other worker writes concurrently; Project control state remains coordinator-owned

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Use the repository's equivalent evidence cycle: record the absent target path before the move, then prove the exact target blob and classification after the move.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: require one target file, no top-level `templates/`, exact base-to-target blob equality, and unchanged empty-registry, lazy-creation, and prohibited-content statements
- Broader check: run the canonical Project and Workflow validators from `agents/skills/`; require zero errors or warnings
- Diff or artifact review: inspect exact Task base-to-head diff for only the old and target template path plus `REPORT.md`; the registry must be a 100% rename
- Required evidence: exact Task base/head and commit, blob identities, inventory, classification assertions, generated and secret/cache-path scans, validator output, `git diff --check`, and scope status

## Ambiguity And Escalation

- The implementer may resolve mechanical empty-directory cleanup and Git rename detection without changing tracked content.
- Escalate before continuing if the registry contains more than one file, the blob would change, a reusable template appears, ownership becomes ambiguous, a secret or local path could be exposed, or any required check cannot run.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: one exact local commit containing the one-file registry move and implementer report
- Independent review: `REVIEW.md`
- Review requirements: quickly inspect the one-file rename, exact blob and empty-registry classification, actual evidence, scope, and obvious regressions; return specification, quality, readiness, finding evidence, and re-review gate
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

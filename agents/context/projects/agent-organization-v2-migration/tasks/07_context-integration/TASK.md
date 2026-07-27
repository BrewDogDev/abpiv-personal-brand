# Task 07: Integrate canonical context and repository governance

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-organization-v2-migration/PROJECT.md`
- Plan row: 07
- Planned from: `codex/migrate-agent-organization-v2` at coordinator commit `bb942fcde1f726b8e6329ab4ba1ab7810059602f`
- Refreshed at: 2026-07-27 at coordinator commit `bb942fcde1f726b8e6329ab4ba1ab7810059602f`
- Dependencies verified: Tasks 01 through 06 are `complete`, each has `DONE` implementation evidence and `COMPLIANT` / `APPROVED` / `READY` independent review. The six canonical owner targets now exist beneath `agents/`.

## Role, Outcome, And Acceptance

- Role: bounded canonical-context integration implementer
- Outcome: live repository context and verification route future agents to the migrated `agents/*` owner layout without rewriting immutable history or unrelated implementation paths.
- Acceptance criteria:
  - Update `agents/context/CONTEXT.md` to describe canonical sibling owner surfaces beneath `agents/`, replacing the obsolete top-level-owner statement without changing implementation-domain or safety boundaries.
  - Update the Access, MCP, and adapter rows in `agents/context/ROUTING.md` so their labels name the canonical `agents/*` paths and their links resolve as sibling owners from `agents/context/`.
  - Update all six moved owner rows in `agents/context/references/repository-map.md` so labels and links resolve to `agents/skills/`, `agents/templates/`, `agents/tools/`, `agents/access/`, `agents/mcp-servers/`, and `agents/adapters/`.
  - Update the three canonical validator commands in `agents/context/references/verification.md` to run from `agents/skills/` and update the documented Project-validator count from 31 to the verified 32.
  - Require every local Markdown link in the four changed files and their neighboring live context routes to resolve.
  - Require an active-reference scan outside immutable archives, legacy runs, and this migration's Project-local historical evidence to find no live route or command to a former top-level agent owner.
  - Preserve root `AGENTS.md` and `README.md` unless inspection proves a broken live reference; current preflight found both already route through `agents/context/`, so no edit is expected.
  - Preserve `agents/context/projects/archive/` and `agents/context/runs/legacy/` byte-for-byte from Project base `088ac31aeea018131a7bf4d11fff8943266cfba1`.
  - Do not invent a Workflow, tool, template, access profile, MCP server, adapter, runtime behavior, or external action.

## Relevant Context And Source Paths

- `agents/skills/agent-organization/agent-context-organization/SKILL.md` owns canonical context layering, routing, repository maps, and working-context boundaries.
- `agents/context/CONTEXT.md`
- `agents/context/ROUTING.md`
- `agents/context/GLOSSARY.md`
- `agents/context/references/repository-map.md`
- `agents/context/references/verification.md`
- `agents/context/references/git-policy.md`
- Root `AGENTS.md` and `README.md`
- Completed targets: `agents/skills/`, `agents/access/`, `agents/mcp-servers/`, `agents/tools/`, `agents/templates/`, and `agents/adapters/`
- Immutable evidence: `agents/context/projects/archive/` and `agents/context/runs/legacy/`

## Owned Scope

- Create: `agents/context/projects/agent-organization-v2-migration/tasks/07_context-integration/REPORT.md`
- Modify: only `agents/context/CONTEXT.md`, `agents/context/ROUTING.md`, `agents/context/references/repository-map.md`, and `agents/context/references/verification.md`
- Test: changed and neighboring live Markdown links, active former-owner references, canonical target inventory, archive and legacy preservation, Project and Workflow validators, `git diff --check`, and exact diff scope

## Do Not Touch

- Root `AGENTS.md` and `README.md` unless the stated stop gate is triggered and the coordinator explicitly replans the scope
- `agents/context/GLOSSARY.md`, `agents/context/references/git-policy.md`, or any other live context file not named in Owned Scope
- `agents/context/projects/agent-organization-v2-migration/PROJECT.md`, `PLAN.md`, Project routing, or any other coordinator control state
- Any completed owner body under `agents/skills/`, `agents/access/`, `agents/mcp-servers/`, `agents/tools/`, `agents/templates/`, or `agents/adapters/`
- `agents/context/projects/archive/`, `agents/context/runs/legacy/`, applications, infrastructure, automation, workflows, installed consumers, ignored local state, credentials, or external systems

## Interfaces

- Consumes: completed owner paths and reviewed owner contracts from Tasks 01 through 06, root discovery, canonical context, repository map, verification contract, Git policy, and immutable-history boundary
- Produces: four coherent live context documents with resolving canonical-owner routes and validator commands plus `REPORT.md`

## Skills, Tools, Authority, And Selection

- Required implementation skills: `agent-context-organization` and return through `agent-organization`
- Required review and verification skills: `requesting-code-review`, `receiving-code-review`, and `verification-before-completion`
- Allowed tools and actions: read tracked live context and completed owner targets; make the four bounded documentation edits; run local deterministic checks; stage and commit exact owned paths
- Approval-gated actions: changing root discovery, creating or promoting stable context beyond the four specified corrections, changing a branch or deployment contract, or expanding the active owner inventory
- Prohibited actions: delegation; archive or legacy-history edits; Project-control edits; application, infrastructure, Workflow, runtime, external-state, permission, or secret changes; ignored-local-state access; push, PR, merge, deploy, publish, force push, or destructive reset
- Implementer capability class: `deep` because the Task integrates multiple canonical owners while distinguishing current routes from immutable evidence and unrelated implementation strings
- Implementer reasoning class: `high` because relative-link depth, live-versus-historical scope, repository layering, and validation claims must remain mutually consistent
- Review depth: `rigorous` because stale routing or verification paths could silently misdirect every future repository agent
- Reviewer capability class: `deep` because review must independently trace context layering, owner routes, link targets, immutable history, and exact scope
- Reviewer reasoning class: `high` because superficially similar former paths remain valid historical evidence and must not be confused with live drift
- Isolation requirements: one implementer writes only the four canonical context files and its report in this worktree; no other worker writes concurrently; Project control, completed owners, root entrypoints, and historical evidence remain read-only

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient Task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Record the preflight former-owner routes and validator commands, then prove the target routes and commands after the bounded edits.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: require the four expected changed context files plus `REPORT.md`; resolve all local links in the changed files and neighboring live context registry files; verify all six canonical target owners exist; require exactly three canonical validator commands rooted at `agents/skills/` and the documented 32-test count
- Active-reference check: scan tracked live documentation outside `agents/context/projects/archive/`, `agents/context/runs/legacy/`, this Project's Task/control evidence, completed owner bodies, and unrelated implementation use of generic directory names; no live canonical route or command may target former repository-root `skills/`, `access/`, `mcp-servers/`, `tools/`, `templates/`, or `adapters/`
- Preservation check: `git diff --exit-code 088ac31aeea018131a7bf4d11fff8943266cfba1 -- agents/context/projects/archive agents/context/runs/legacy`
- Broader check: run the canonical 32-test Project-validator suite plus live Project and Workflow validators from `agents/skills/`; require `OK` and zero errors or warnings
- Diff or artifact review: inspect exact Task base-to-head diff for only the four owned context files plus `REPORT.md`; require no root, Project-control, owner-body, archive, legacy, application, infrastructure, or automation change
- Required evidence: exact Task base/head and commit, four-file semantic delta, local-link counts, active-reference scan exclusions and result, six-owner inventory, archive/legacy preservation, validator results, generated/secret/cache-path scans, `git diff --check`, and scope status

## Ambiguity And Escalation

- The implementer may resolve exact relative-link syntax and concise canonical-owner wording from live target paths without changing repository meaning or adding a new route.
- Escalate before continuing if any target owner is missing, root discovery is broken, a fifth live context file must change, live and historical references cannot be distinguished, immutable evidence differs from the Project base, a current governance claim conflicts with Git workflows, a secret or machine-local path could be exposed, or any required check cannot run.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: one exact local commit containing the four bounded context corrections and implementer report
- Independent review: `REVIEW.md`
- Review requirements: rigorously trace all live owner routes, relative links, verification commands and counts, active-reference exclusions, layering and no-invention boundaries, immutable-history preservation, actual diff and evidence, and return specification, quality, readiness, findings, and re-review gate
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

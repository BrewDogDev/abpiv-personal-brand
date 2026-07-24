# Task 01: Establish Canonical Context And Governance

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-infrastructure-migration/PROJECT.md`
- Plan row: Task 01
- Planned from: `codex/migrate-agent-infrastructure`, commit `0b669d0482db62878faf15aadead227672615d48`, with coordinator-owned Project scaffold changes pending
- Refreshed at: 2026-07-24 and the same base commit
- Dependencies verified: none; root instructions, repository files, implementation READMEs, workflow YAML, branch graph, remote state, and original user authorization were inspected

## Outcome And Acceptance

- Outcome: a fresh agent can enter through a thin root file, understand the repository, select the right domain, follow the correct Git promotion path, and find verification and learning surfaces without loading stale run history.
- Acceptance criteria:
  - `AGENTS.md` points to canonical context, routing, glossary, repository map, verification, and Git policy without duplicating their bodies.
  - `agents/context/{CONTEXT.md,GLOSSARY.md,ROUTING.md}` accurately distinguish stable and working context and route every live implementation domain.
  - `agents/context/references/{repository-map.md,verification.md,git-policy.md}` reflect live repository files and GitHub workflows, including `preview` to `main`, manual production deployment, and same-origin analytics.
  - Root `README.md` directs future agents to canonical context while retaining the content-site operator link.
  - Minimal workflow, run, working, handoff, learning, template, and tool registries exist only where useful and contain no invented active capability.
  - Local Markdown links in owned Markdown resolve, and a targeted scan finds no credential values.

## Owned Scope

- Create: `agents/context/references/repository-map.md`, `agents/context/references/verification.md`, `agents/context/references/git-policy.md`, `agents/context/learnings/workspace/LEARNINGS.md`, `agents/context/learnings/workspace/ERRORS.md`, `agents/context/learnings/workspace/FEATURE_REQUESTS.md`, `agents/context/workflows/README.md`, `agents/context/runs/README.md`, `agents/context/working/README.md`, `agents/context/handoff/README.md`, `agents/templates/README.md`, `agents/tools/README.md`
- Modify: `AGENTS.md`, `README.md`, `agents/context/CONTEXT.md`, `agents/context/GLOSSARY.md`, `agents/context/ROUTING.md`, `agents/context/projects/CONTEXT.md`
- Test: owned Markdown links, tracked secret patterns, Git diff boundaries, live workflow and branch-role correspondence

## Do Not Touch

- Root `CONTEXT.md`, `HANDOFF.md`, `DEPLOYMENT_PLAN.md`, `.kilo/`, `docs/superpowers/`, or `agents/context/runs/legacy/`
- `agents/access/`, `agents/mcp-servers/`, `agents/adapters/`, `agents/skills/`
- Implementation files under `content-site/`, `infra/`, or `creative-production/`
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: inspected repository map, root guidance, implementation documentation, `.github/workflows/*.yml`, and the Project's layer/ownership decisions
- Produces: stable context and governance interfaces consumed by Tasks 02-05

## Skills, Tools, And Authority

- Required implementation skills: `abpiv-agents:agent-context-organization`; return through `abpiv-agents:agent-organization` for Git governance
- Required review and verification skills: `abpiv-agents:requesting-code-review`, `abpiv-agents:receiving-code-review`, and link/secret/diff inspection
- Allowed tools and actions: read tracked repository files and Git/GitHub metadata; edit only owned paths with `apply_patch`; run local read-only checks; commit exact owned paths
- Approval-gated actions: none within owned tracked files
- Prohibited actions: external writes, deploys, secret/config reads, broad staging, force operations, implementation behavior changes, or Project control-state edits

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: programmatically enumerate local Markdown links in owned files and require every target to exist.
- Broader check: `git diff --check` plus a targeted tracked-text scan for common token/private-key patterns and machine-local plugin cache paths.
- Diff or artifact review: base-to-head diff limited to owned files, with coordinator-owned Project records explicitly excluded.
- Required evidence: exact commands, concise outputs, commit identity, and owned-file list in `REPORT.md`.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

# Task 02: Preserve And Reclassify Legacy Agent History

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-infrastructure-migration/PROJECT.md`
- Plan row: Task 02
- Planned from: `codex/migrate-agent-infrastructure` at `b9075b542a6664d7e083140ca0f838eecf7eeb46`
- Refreshed at: 2026-07-24 and the same head
- Dependencies verified: Task 01 is `complete`; its `REPORT.md` and amended `REVIEW.md` are present; canonical context, layer rules, repository map, and Git policy exist; the 12 tracked legacy artifacts remain unchanged at their original paths

## Outcome And Acceptance

- Outcome: legacy root, Kilo, and Superpowers agent artifacts remain inspectable as explicitly non-authoritative run history, while reusable brand terminology is promoted to the canonical glossary and no legacy surface can be mistaken for active control state.
- Acceptance criteria:
  - All 12 tracked source artifacts are moved into `agents/context/runs/legacy/{root,kilo,superpowers}/` without losing their original content.
  - `agents/context/runs/legacy/README.md` records each original path, new path, first tracked commit/date, lifecycle classification, preservation rule, and current canonical replacement.
  - The seven terms in legacy root `CONTEXT.md` are integrated into `agents/context/GLOSSARY.md` with their original meaning and avoided aliases.
  - Canonical context, run registry, and repository map point to the legacy-history index and no longer link the removed root, `.kilo/plans/`, or `docs/superpowers/` paths as live inputs.
  - Root `CONTEXT.md`, `HANDOFF.md`, `DEPLOYMENT_PLAN.md`, `.kilo/plans/`, and `docs/superpowers/` are absent from the committed head; `content-site/AI_HANDOFF.md` remains unchanged and canonical for content-site operations.
  - For every moved historical artifact, the committed target blob content matches the base source blob content exactly.
  - Active tracked guidance has no stale route to a removed legacy path; preserved raw history and this Project's migration records are explicit search exclusions.

## Owned Scope

- Create: `agents/context/runs/legacy/README.md`
- Move without editing content:
  - `CONTEXT.md` to `agents/context/runs/legacy/root/CONTEXT.md`
  - `HANDOFF.md` to `agents/context/runs/legacy/root/HANDOFF.md`
  - `DEPLOYMENT_PLAN.md` to `agents/context/runs/legacy/root/DEPLOYMENT_PLAN.md`
  - `.kilo/plans/1777572573826-mighty-cactus.md` to `agents/context/runs/legacy/kilo/plans/1777572573826-mighty-cactus.md`
  - `.kilo/plans/1777583916506-jolly-cabin.md` to `agents/context/runs/legacy/kilo/plans/1777583916506-jolly-cabin.md`
  - `docs/superpowers/plans/*.md` to `agents/context/runs/legacy/superpowers/plans/`
  - `docs/superpowers/specs/*` to `agents/context/runs/legacy/superpowers/specs/`
- Modify: `agents/context/CONTEXT.md`, `agents/context/GLOSSARY.md`, `agents/context/references/repository-map.md`, `agents/context/runs/README.md`
- Test: source-to-target blob equality, active-reference search, committed path inventory, relevant local links, whitespace, scope, and secret/path safety

## Do Not Touch

- `content-site/AI_HANDOFF.md` or any implementation file under `content-site/`, `infra/`, `creative-production/`, or `.github/`
- `AGENTS.md`, root `README.md`, `agents/skills/`, `agents/access/`, `agents/mcp-servers/`, `agents/adapters/`, `agents/templates/`, or `agents/tools/`
- The contents of moved legacy artifacts; preserve historical references and machine-local observations as evidence rather than rewriting them
- `.codex-local/` or any credential-bearing local configuration
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: Task 01's canonical layer model, glossary contract, repository map, run registry, and live Git history for the legacy source paths
- Produces: stable glossary promotion, non-authoritative legacy history index, exact preserved artifacts, and reconciled canonical routing consumed by Task 05

## Skills, Tools, And Authority

- Required implementation skills: `abpiv-agents:agent-context-organization`; use `abpiv-agents:agent-adapter-organization` only to classify and retire the legacy Kilo surface, then return through `abpiv-agents:agent-organization`
- Required review and verification skills: `abpiv-agents:requesting-code-review`, `abpiv-agents:receiving-code-review`, commit-tree/link/blob/diff inspection
- Allowed tools and actions: read tracked Git history and files; move and edit only owned paths with `apply_patch`; run local read-only checks; commit exact owned implementation paths
- Approval-gated actions: none; the original request explicitly authorizes legacy migration, moves, and removal of superseded surfaces while preserving useful history
- Prohibited actions: changing historical artifact contents, external writes, deploys, secret/config reads, broad staging, force operations, or Project control-state edits

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: compare `git show b9075b5:<old-path>` with `git show <task-head>:<new-path>` for all 12 moves and require identical SHA-256 content.
- Broader check: verify the exact committed path inventory, run local-link checks over changed canonical Markdown, search active tracked guidance for removed paths while excluding `agents/context/runs/legacy/` and this Project, then run `git diff --check`.
- Diff or artifact review: base-to-head diff must contain only the 12 renames, the legacy index, and four owned canonical context updates; historical target contents must be unchanged.
- Required evidence: mapping count, exact old/new paths, content-equality result, canonical-term assertions, stale-route search result, commit identity, and scope inventory in `REPORT.md`.

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

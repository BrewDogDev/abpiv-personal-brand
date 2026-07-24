# Task 05: Verify, Close, And Publish The Integrated Migration

## Status

Executing

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-infrastructure-migration/PROJECT.md`
- Plan row: Task 05
- Planned from: `codex/migrate-agent-infrastructure` after Task 02 completion checkpoint `484e3a6`
- Refreshed at: 2026-07-24 while Tasks 03 and 04 execute in isolated worktrees
- Dependencies verified: Tasks 01-04 are complete; Tasks 03 and 04 each have an implementation commit, implementer report, independent `READY` review, and coordinator integration

## Outcome And Acceptance

- Outcome: the integrated agent-infrastructure migration is independently verified, closed with durable continuity evidence, published to `preview`, and exposed as a non-draft pull request from `preview` to `main` for the repository owner to review.
- Acceptance criteria:
  - Tasks 01-04 are `complete`, their exact implementation commits and review verdicts are recorded, and every blocking review finding is resolved.
  - Reviewed Task 03 and Task 04 commits and evidence records are integrated without broad conflict resolution or unrelated changes.
  - Repository-local Project and Workflow validators, recursive skill checks, all tracked Markdown-link checks, JSON/example checks, exact legacy-preservation checks, `git diff --check`, scope inspection, and secret/machine-path scans pass from the integrated head.
  - Stable routing, the repository map, skill discovery, access profiles, MCP contract, adapters, historical run index, and root entrypoint agree on canonical ownership.
  - No content-site, analytics, n8n infrastructure, cloud resource, permission, secret, automation, or production-deployment behavior changes.
  - A fresh whole-Project reviewer returns `READY` against an exact base-to-head range.
  - A dated Project-local handoff records outcomes, decisions, verification, residual risks, commit identities, and the exact fresh-session continuation prompt.
  - The active Project route is removed and the intact Project is moved to `agents/context/projects/archive/2026-07-24-agent-infrastructure-migration/` with status `archived-complete`; archive validation passes.
  - The final intended diff is committed with exact staging, `origin/preview` is confirmed not to have diverged, the reviewed head is pushed without force, and an open non-draft PR exists with head `preview` and base `main`.

## Owned Scope

- Integrate: already reviewed Task 03 and Task 04 commits and their Task-local `REPORT.md`/`REVIEW.md` evidence
- Create and update: this Task's `REPORT.md` and `REVIEW.md`, Project-wide verification evidence, dated handoff, `handoff/latest.md`, Project status/ledger/completion evidence, and active/archive routing
- Move at closure: the intact Project directory to `agents/context/projects/archive/2026-07-24-agent-infrastructure-migration/`
- Git publication: exact local commits, non-force update of remote `preview`, and ready pull request from `preview` to `main`
- Test: the entire intended migration range and final committed/archive tree

## Do Not Touch

- `content-site/`, `infra/`, `creative-production/`, `.github/workflows/`, or runtime and deployment configuration
- `.codex-local/`, credential stores, environment secrets, Cloudflare, Google Cloud, n8n, analytics, or any other external runtime
- `main`, production environments, or pull-request merge state
- Unrelated user work, the primary checkout, or history outside this migration branch
- Task-owned implementation semantics unless a concrete review or integration failure is routed back through `receiving-code-review`

## Interfaces

- Consumes: Tasks 01-04 outputs, reports, independent reviews, repository-owned validators from Task 03, canonical verification/Git policy, live branch state, and GitHub repository metadata
- Produces: integrated verified head, final Project evidence and immutable archive, updated `preview`, and ready PR to `main`
- Promotion boundary: `preview` is the required PR head because `.github/workflows/main-source-guard.yml` rejects other sources into `main`; production deployment remains a separate manual action outside this Task

## Skills, Tools, And Authority

- Required coordination skills: `abpiv-agents:agent-organization`, `abpiv-agents:agent-project-organization`, `abpiv-agents:executing-projects`, `abpiv-agents:receiving-code-review`
- Required review and completion skills: `abpiv-agents:requesting-code-review`, `abpiv-agents:verification-before-completion`, `abpiv-agents:handoff`, `github:yeet`
- Allowed tools and actions: inspect and integrate reviewed local commits; run deterministic local checks; commit exact intended files; fetch Git metadata; push the final head to `preview`; create a non-draft PR to `main`
- Approval-gated actions: none for the explicitly requested ready PR and non-force `preview` update when the remote has not diverged
- Prohibited actions: force push, bypassing `preview`, merging, production deployment, external runtime mutation, permission expansion, secret access, broad staging, or destructive cleanup

## Implementation Contract

- One coordinator/implementer session for integration and closure preparation; do not delegate implementation.
- Do not begin until Tasks 03 and 04 have passed independent review.
- Ask before guessing at a material ambiguity or if `origin/preview` diverged.
- Integrate only exact reviewed commits, run every required check, inspect the full intended range, and commit exact paths.
- Write `REPORT.md`; do not self-approve the whole-Project review.
- Commission one fresh independent whole-Project reviewer with read-only authority except `REVIEW.md`.
- If a blocking finding appears, route it to the owning Task or coordinator through `receiving-code-review`, amend the head, and require re-review.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: verify all Task rows, reports, reviews, commit identities, produced interfaces, declared cross-Task links, and the Task 04-to-Task 03 parallel interface after integration.
- Broader check: run repository-local validator tests and live validators; recursively inspect skills/frontmatter/links; validate access/MCP/adapter examples and secret boundaries; verify legacy blobs/provenance; check every tracked Markdown link; run `git diff --check`; inspect exact path scope; scan for secrets, credential values, and machine-local cache paths.
- Publication check: fetch `origin`; prove the expected old `origin/preview` is an ancestor of the final head; inspect `origin/main...HEAD`; verify authenticated repository/branch identity; push `HEAD:preview` without force; create and re-read the PR; assert `draft=false`, `state=open`, base `main`, head `preview`, and the final commit is present.
- Required evidence: command/result matrix, exact base/head and Task commits, review verdicts, link/validator/safety counts, scope summary, final handoff paths, archive validation, push result, PR URL/number/state/base/head/draft state, and residual risks.

## Reuse Assessment

Record which verified outputs are durable repository capabilities and which suggested candidates remain deferred. Do not expand final integration to create unrelated tools, Workflows, or skills.

## Return

- Implementer report: `REPORT.md`
- Independent whole-Project review: `REVIEW.md`
- Final handoff: `handoff/2026-07-24-migrate-agent-infrastructure-handoff.md` and `handoff/latest.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

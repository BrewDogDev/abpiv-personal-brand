# Handoff: Migrate Agent Organization V2

## Metadata

- Date: 2026-07-27
- Goal: migrate live agent infrastructure to the reviewed 0.1.36 `agents/*` owner layout while preserving discovery, metadata, safety boundaries, and immutable history
- Status: ready-for-review
- Workspace: `C:\Users\allan\.codex\worktrees\1411\abpiv-personal-brand`
- Source of truth: `agents/context/projects/agent-organization-v2-migration/`

## Goal

Complete the user-requested local migration using `abpiv-agents:agent-organization`.
Move the six live owner surfaces beneath `agents/`, integrate live context and
verification, preserve retained metadata and historical evidence, and close the
Project without pushing, publishing, deploying, or mutating external state.

## Current State

- Branch: `codex/migrate-agent-organization-v2`.
- Project base and local upstream snapshot: `origin/preview` at
  `088ac31aeea018131a7bf4d11fff8943266cfba1`.
- Verified closing head:
  `66ddeadd14b0fdaa707401331dfe1f0005706e10`.
- All eight Tasks are complete. Every independent review is `COMPLIANT`,
  `APPROVED`, and `READY`, with no Critical, Important, or unresolved Minor
  finding.
- The active Project status is `closing`; its only remaining action is intact
  archival and active-route removal.
- No fetch, push, pull request, merge, publication, deployment, permission
  change, credential access, runtime action, or external mutation occurred.

## Decisions And Rationale

- Use `Migrate` mode and the `agents/*` owner layout because the user named the
  0.1.36 organization contract.
- Preserve 14 existing `agents/openai.yaml` records because this repository
  requires them and the selected 24-file source subset does not supply them.
- Keep archived Projects and legacy runs byte-for-byte unchanged even when
  they contain former live paths.
- Treat the Skills update policy and canonical verification procedure as the
  durable reusable integrations. Keep migration-specific checkers as Project
  evidence until repeated use justifies a separately reviewed artifact.
- Keep the branch local because publication and external actions were not
  authorized.

## Changes And Artifacts

- Canonical owners: `agents/skills/`, `agents/access/`,
  `agents/mcp-servers/`, `agents/tools/`, `agents/templates/`, and
  `agents/adapters/`.
- Live integration: `agents/context/CONTEXT.md`,
  `agents/context/ROUTING.md`,
  `agents/context/references/repository-map.md`, and
  `agents/context/references/verification.md`.
- Project evidence: `PROJECT.md`, `PLAN.md`, and all eight Task
  `TASK.md`/`REPORT.md`/`REVIEW.md` records.
- Integrated verification report:
  `tasks/08_integrated-verification/REPORT.md`.
- Integrated review:
  `tasks/08_integrated-verification/REVIEW.md`.

## Verification

- Canonical owner counts: `39/14/2/1/1/3`; all six former roots absent.
- Skill family: 38 files split 24 supplied and 14 retained; 14 recursively
  discovered folder-matched skills; 14 matching metadata prompts; 15 resolving
  family links; exactly two documented portability corrections; no generated
  bytecode.
- Active agent documentation: 85 Markdown artifacts and 198 local links, zero
  missing; historically aware stale-route scan found zero former-root routes.
- Preservation: root `AGENTS.md`, root `README.md`, archived Projects, and
  legacy runs match Project-base blobs and trees.
- Project validator suite: 32 tests, `OK`.
- Live Project and Workflow validators: zero warnings.
- Whole-Project review: 93 records and 149 path endpoints classified, with zero
  protected-domain path, safety, or mode finding.
- Git: clean at closing head; local comparison was 0 behind and 45 ahead of the
  available `origin/preview` snapshot after the closing commit. Remote state was
  not refreshed.

## What Worked

- Specialist-owned Tasks with exact bases, one non-delegating implementer, and
  independent review kept each move auditable.
- Normalized source/delta checks, recursive metadata pairing, link resolution,
  and Project-base object comparison caught structural drift without touching
  runtime or secret-bearing state.
- The migrated validators enforced bounded Task contracts and exposed
  coordinator-control mistakes before dispatch.

## What Did Not Work

- A temporary coordinator status `reviewing` was invalid under the migrated
  Project schema; it was corrected to `executing` before Task 06 completion.
- Initial Task 07 and Task 08 briefs omitted exact validator-required contract
  phrases; both briefs were corrected and revalidated before dispatch.
- Two repository-local review-skill paths named in a dispatch prompt were not
  vendored; available runtime-provided review skills were used without
  persisting an installed path.
- An initial safety classifier overmatched documentation that names excluded
  bytecode and normal Git mode lines; the corrected changed-path and mode
  classifier returned zero findings.

## Remaining Work

1. Verify the approved archive target
   `agents/context/projects/archive/2026-07-27-agent-organization-v2-migration/`
   does not exist and the active Project source resolves inside
   `agents/context/projects/`.
2. Change the Project status to `archived-complete`, update this handoff and
   `latest.md` to `complete`, remove the active routing row, and move the intact
   Project to the approved dated archive path.
3. Run the 32-test suite, live Project and Workflow validators, local-link
   resolution, archive/legacy preservation, exact closure diff, safety scan,
   and clean-worktree check.
4. Commit the exact archival closure paths locally and report the final commit.

## Open Decisions Or Blockers

None. The remaining archival action is explicitly planned, local, reversible
through Git, and within the original migration authority.

## Do Not Assume

- Do not assume the available remote-tracking snapshot is current; no fetch was
  performed.
- Do not push, publish, open or merge a pull request, deploy, access secrets,
  change permissions, or mutate runtime or external state without explicit new
  authorization.
- Do not rewrite immutable prior archives or legacy runs.
- Preserve the reviewed owner bodies, Task evidence, and unrelated repository
  domains exactly.

## Fresh-Session Continuation Prompt

```text
Continue the goal "archive the completed agent organization v2 migration" in C:\Users\allan\.codex\worktrees\1411\abpiv-personal-brand.

First, read agents/context/projects/agent-organization-v2-migration/handoff/2026-07-27-migrate-agent-organization-v2-handoff.md completely. Then load root AGENTS.md, agents/context/projects/agent-organization-v2-migration/PROJECT.md, PLAN.md, and the closure rules they reference. Treat the handoff as working context, not unquestionable truth: verify the current files, Git state, checks, approvals, and external state before acting.

Resume from the ordered Remaining Work section, beginning with verifying that agents/context/projects/archive/2026-07-27-agent-organization-v2-migration/ does not exist and that the active Project source is the intended in-repository directory. Preserve unrelated user changes and stay within every scope, safety, review, and stop boundary recorded in the handoff. Do not redo completed work unless live evidence contradicts it. If state has changed, reconcile it, document the difference, and continue toward the goal.
```

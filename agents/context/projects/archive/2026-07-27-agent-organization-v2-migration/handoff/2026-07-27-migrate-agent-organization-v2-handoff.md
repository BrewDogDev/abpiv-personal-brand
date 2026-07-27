# Handoff: Migrate Agent Organization V2

## Metadata

- Date: 2026-07-27
- Goal: migrate live agent infrastructure to the reviewed 0.1.36 `agents/*` owner layout while preserving discovery, metadata, safety boundaries, and immutable history
- Status: complete
- Workspace: `C:\Users\allan\.codex\worktrees\1411\abpiv-personal-brand`
- Source of truth: `agents/context/projects/archive/2026-07-27-agent-organization-v2-migration/`

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
  `66ddeadd14b0fdaa707401331dfe1f0005706e10`; handoff-pointer head:
  `8daa41a6617e5068d573e9d23eefb8e244a1e1d4`.
- All eight Tasks are complete. Every independent review is `COMPLIANT`,
  `APPROVED`, and `READY`, with no Critical, Important, or unresolved Minor
  finding.
- The Project is `archived-complete` at
  `agents/context/projects/archive/2026-07-27-agent-organization-v2-migration/`;
  it is absent from active Project routing.
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
- Git: clean at the closing and handoff commits. The final archive commit is the
  commit containing this completed record; the branch is 0 behind and 47 ahead
  of the available `origin/preview` snapshot. Remote state was not refreshed.

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

None is required to satisfy the user-requested migration. The local topic
branch may be integrated or published only after explicit new authorization.
If that is later requested, first confirm the exact requested action, refresh
the relevant remote refs, reconcile any new `origin/preview` commits without
rewriting unrelated work, and rerun the canonical checks before publication.

## Open Decisions Or Blockers

None. Publication is intentionally unperformed and is not an implicit
continuation requirement.

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
Continue the goal "integrate or publish the completed agent organization v2 migration only if explicitly authorized" in C:\Users\allan\.codex\worktrees\1411\abpiv-personal-brand.

First, read agents/context/projects/archive/2026-07-27-agent-organization-v2-migration/handoff/2026-07-27-migrate-agent-organization-v2-handoff.md completely. Then load root AGENTS.md, the archived Project instructions referenced by the handoff, and the current Git policy. Treat the handoff as working context, not unquestionable truth: verify the current files, Git state, checks, approvals, and external state before acting.

Resume from the ordered Remaining Work section, beginning with confirming that the user has explicitly authorized the exact integration or publication action; if no such authorization exists, make no external change. Preserve unrelated user changes and stay within every scope, safety, review, and stop boundary recorded in the handoff. Do not redo completed work unless live evidence contradicts it. If state has changed, reconcile it, document the difference, and continue toward the goal.
```

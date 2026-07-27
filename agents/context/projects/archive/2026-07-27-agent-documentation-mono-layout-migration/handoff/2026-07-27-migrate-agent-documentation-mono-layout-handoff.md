# Handoff: Migrate Agent Documentation To The Mono Layout

## Metadata
- Date: 2026-07-27
- Goal: Record the completed Mono agent-documentation migration and its verified merge before immutable Project archival.
- Status: complete
- Workspace: `BrewDogDev/abpiv-personal-brand`
- Source of truth: this repository, its canonical `agents/context/`, and the observed GitHub pull-request and ref state below

## Goal
Migrate the live agent documentation to Mono 1.1.0's canonical top-level
owner layout, preserve repository history and safety boundaries, reconcile
`main`, and merge the independently reviewed result through `preview`.

The Project does not authorize a production deployment, runtime or
infrastructure change, permission change, credential access, force push, or
rewrite of immutable Project and legacy-run history.

## Current State
- All three Project Tasks are complete.
- Task 01 and Task 02 returned amended independent verdicts of `READY`.
- Task 03 returned `READY` at its second amended head after the published
  checker passed verbatim from a later coordinator checkpoint.
- The reviewed migration was published from `preview` and merged to `main`
  through [PR #18](https://github.com/BrewDogDev/abpiv-personal-brand/pull/18).
- PR #18 merged at `2026-07-27T13:09:54Z` as
  `a58a366c9c7927368204b2e4a9f183f0fb07b3b4`.
- The required `Main Source Guard` check passed for PR #18.
- A fresh fetch observes `origin/main` at `a58a366c9c7927368204b2e4a9f183f0fb07b3b4`
  and `origin/preview` at `3519b0f7246a1e98f2ddbdab676af428cf341952`;
  both resolve to tree `ec0e4a67b1540a5a67f3fd6d523f52213c21ca4c`.
- The separate local `main` worktree was clean and fast-forwarded to the
  observed `origin/main`.
- The Project remains active with status `closing` only long enough to persist
  this observed merge evidence before immutable archival.

## Decisions And Rationale
- `agents/context/` remains canonical repository context; portable agent
  owners live at top-level `skills/`, `tools/`, `mcp-servers/`, `access/`,
  `adapters/`, and `templates/`.
- The vendored family follows Mono 1.1.0 with exactly three documented
  portability corrections in two files.
- Publication follows topic branch to `preview`, then a pull request from
  `preview` to `main`. A merge does not authorize production deployment.
- The prior `main` squash topology was reconciled into `preview` with merge
  commit `3519b0f7246a1e98f2ddbdab676af428cf341952`. Its tree is byte-identical
  to the reviewed migration tree.
- Project archival occurs only after the first merge is observed. The archive
  is then published through a second closure-only pull request so the
  `archived-complete` state never claims an unobserved migration merge.

## Changes And Artifacts
- Topic branch: `codex/migrate-agent-docs-mono-layout`
- First published `preview` head:
  `3519b0f7246a1e98f2ddbdab676af428cf341952`
- Migration pull request:
  [#18 — Migrate agent documentation to Mono layout](https://github.com/BrewDogDev/abpiv-personal-brand/pull/18)
- Migration merge commit:
  `a58a366c9c7927368204b2e4a9f183f0fb07b3b4`
- Task 01 implementation and revision:
  `92fdb1afa28614a48f4e2c4aeca5524dd7404c0b` and
  `bff58ef041b525d58f57f08a65a9ddcf296e58c3`
- Task 02 implementation and revision:
  `ccb422569e4f17c6eb05e037f0d217d1110b01ff` and
  `8db18c153b99a027a598e59a692d6f1ee11336b3`
- Task 03 original implementation and report revisions:
  `d6b5dbe17b1d439bbd1903fb0c20e7e77ca6a743`,
  `25be935b50151c6cda9d3d872864dc39e063a2a0`, and
  `f444b64b7f15aee786a1b063879137197e264b98`
- Project evidence remains under this Project until the whole directory moves
  intact to
  `agents/context/projects/archive/2026-07-27-agent-documentation-mono-layout-migration/`.

## Verification
- Mono source comparison: 37/37 files, 35 exact, three documented
  corrections in two files.
- Recursive discovery and interface metadata: 14/14 skills and 14/14
  `agents/openai.yaml` records.
- Project-validator suite: 31 tests, `OK`.
- Live Project validator before archival: one active Project, one archived
  Project, three Task directories, zero warnings.
- Live Workflow validator: zero routes, Workflows, stages, or warnings.
- Deterministic contract scenarios: 8/8.
- Active Markdown links at final Task review: 190 resolved with zero failures.
- History accounting: 21 non-skill owner moves and 24 skill-family moves.
- Generated-output, former-owner, safety, prohibited-domain, immutable-history,
  and scope scans passed with zero findings.
- PR #18's `Main Source Guard` completed successfully; no content-site
  deployment workflow was triggered by the agent-documentation-only range.

## What Worked
- Exact owner-specific Tasks plus fresh independent review kept structural
  moves, vendored-family changes, and integrated evidence separable.
- Stable report-head derivation made the published checker reproducible after
  coordinator control-state commits.
- Comparing conflicting Git stages to the recorded base proved that retaining
  the reviewed `preview` tree was the safe history-reconciliation result.
- Keeping the Project `closing` through the first observed merge preserved a
  truthful handoff before archive immutability.

## What Did Not Work
- The first publication attempt exposed an add/add conflict between the prior
  squash commit on `main` and equivalent unsquashed `preview` history. It was
  resolved without content change by joining the histories and retaining the
  reviewed tree.
- The first Task 03 report revision used moving `HEAD` in a report-only scope
  assertion. A second revision derived the report's own last commit and passed
  verbatim from the coordinator checkpoint.

## Remaining Work
1. Set the Project to `archived-complete`, remove its active route, and move
   this intact Project to
   `agents/context/projects/archive/2026-07-27-agent-documentation-mono-layout-migration/`.
2. Run the Project and Workflow validators plus archive, link, safety, scope,
   history, and generated-output checks; commit only the closure state.
3. Fetch and reconcile `origin/main` and `origin/preview` again, then
   fast-forward `preview` with the closure commit without force.
4. Open a second ready pull request from `preview` to `main`, require the
   `Main Source Guard`, merge under the user's existing authorization, and
   fetch once more.
5. Prove `origin/main` contains the top-level owners and intact archived
   Project while active Project routing is empty. Do not modify the immutable
   archive to record second-PR evidence.

## Open Decisions Or Blockers
None. The user authorized the resulting merge to `main`; production deployment
remains outside scope.

## Do Not Assume
- Remote refs, pull-request checks, and merge state are volatile; fetch and
  inspect them again before the closure push and merge.
- The second closure pull request does not exist at the time of this handoff.
- The archived Project must not be edited after its closure commit.
- `skills/README.md` still has a non-blocking consistency Minor: its neighboring
  validator examples omit `-B`, while the canonical verification reference
  includes it. Do not silently change the reviewed migration to address it.
- No production deployment, credential access, external runtime mutation, or
  permission change has been performed or authorized.
- Preserve unrelated user work and stop if a remote update overlaps the
  closure paths.

## Fresh-Session Continuation Prompt
```text
Continue the goal "Publish the immutable closure for the completed Mono agent-documentation migration" in BrewDogDev/abpiv-personal-brand.

First, read agents/context/projects/archive/2026-07-27-agent-documentation-mono-layout-migration/handoff/2026-07-27-migrate-agent-documentation-mono-layout-handoff.md completely. Then load root AGENTS.md, agents/context/CONTEXT.md, agents/context/projects/ROUTING.md, the archived PROJECT.md and PLAN.md, and agents/context/references/git-policy.md. Treat the handoff as working context, not unquestionable truth: verify the current files, Git state, checks, approvals, external state, and protected changes before acting.

Resume from the ordered Remaining Work section, beginning with a fresh fetch of origin/main and origin/preview and verification of the archive and closure pull-request state. Preserve unrelated user changes and stay within every scope, safety, review, and stop boundary recorded in the handoff. Do not redo completed migration work unless live evidence contradicts it. Do not deploy production. If state has changed, reconcile it, document the difference, and continue toward the goal.
```

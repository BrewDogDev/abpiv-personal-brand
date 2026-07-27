# Task 02 Independent Review

## Review Boundary

- Task brief: `agents/context/projects/agent-documentation-mono-layout-migration/tasks/02_agent-organization-skill-family/TASK.md`
- Report: `agents/context/projects/agent-documentation-mono-layout-migration/tasks/02_agent-organization-skill-family/REPORT.md`
- Base: `55248f674332234e3d9002d273ab571587aa4984`
- Head: `ccb422569e4f17c6eb05e037f0d217d1110b01ff`
- Diff or artifacts inspected: `git diff --find-renames 55248f674332234e3d9002d273ab571587aa4984..ccb422569e4f17c6eb05e037f0d217d1110b01ff`; the 39 changed paths; the selected Mono 1.1.0 `agent-organization` family and package manifest; and coordinator review package `126b61a33e71d15763d9e610af74f4b231f3c766`
- Authority: read-only except this review record

## Findings

### Critical

- None.

### Important

- `skills/README.md:9` attributes the vendored family to `BrewDogDev/mono`, but the selected Mono 1.1.0 package manifest declares both its homepage and repository as `https://github.com/CipherPlayLabs/mono` at `.codex-plugin/plugin.json:9-10`. Fresh read-only remote checks corroborate the manifest: `git ls-remote --symref https://github.com/BrewDogDev/mono.git HEAD` exits 128 with `Repository not found`, while the equivalent `CipherPlayLabs/mono` command exits 0 and resolves `refs/heads/main`. This fails the explicit acceptance criterion that `skills/README.md` record correct Mono 1.1.0 provenance and would send a future update to the wrong source. Replace the label and URL with `CipherPlayLabs/mono`.

### Minor

- The pinned head contains no tracked generated files, but the review worktree currently has untracked, unignored `skills/agent-organization/agent-project-organization/scripts/__pycache__/validate_projects.cpython-313.pyc`. `git status --short --untracked-files=all` reports it and `git check-ignore` exits 1. This does not alter the reviewed commit, but it weakens the clean merge gate and conflicts with the Task's no-generated-cache end state. Remove it before integration and prefer `python -B` or an explicit cleanup when rerunning the importing test.

## Specification Compliance

The implementation is compliant except for the Important provenance error above. The exact base-to-head scope contains 24 history-detected renames and 15 additions with no other change class or out-of-scope path; all 24 base `agents/skills/` paths are absent at the head and top-level `skills/` contains `README.md` plus the 37-file family. Normalized comparison against the selected Mono 1.1.0 source proves identical 37-path inventories, 35 exact files, and exactly the three approved corrections in two files. All 14 skills and 14 interface metadata records satisfy their required contracts. The coordinator package at `126b61a33e71d15763d9e610af74f4b231f3c766` preserves the Task artifacts and supplies the control-state normalization required by the refreshed live Project validator without expanding the implementation commit.

## Task Quality

Needs fixes. The migration, source-drift control, report evidence, scope isolation, and documented behavioral limitation are otherwise precise and reproducible, but incorrect source provenance blocks approval under the stated acceptance criteria. The untracked cache is non-blocking commit-external hygiene that should be cleared at the same gate.

## Verification Assessment

- Source identity and parity: the selected package manifest reports version `1.1.0`; a fresh normalized inventory/hash comparison reports 37 source files, 37 repository files, equal path sets, 35 exact matches, two allowed-deviation files containing exactly three one-occurrence transforms, and zero unexpected differences. The 37 hashes printed in `REPORT.md` also match the current reviewed files.
- Discovery and schema: recursive discovery reports 14 `SKILL.md` files, 14 globally unique folder-matched names, 14 colocated `agents/openai.yaml` files, zero frontmatter or metadata errors, and 14/14 passes from the canonical quick validator.
- Links: the same 28-file changed-and-neighboring Markdown set described in the report contains 90 rendered local links, all of which resolve after fenced examples, remote URLs, and anchors are excluded.
- Validators: `python -B skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py` passes 31 tests; the live Project validator at review package `126b61a33e71d15763d9e610af74f4b231f3c766` reports 1 active Project, 1 archived Project, 2 Task directories, and 0 warnings; the live Workflow validator reports 0 routes, 0 Workflows, 0 stages, and 0 warnings.
- Deterministic scenarios: fresh checks pass 8/8 direct-trigger, paraphrased-trigger, near-neighbor, non-trigger, missing-information, approval-boundary, stop-rule, and cross-skill-route assertions. The Task prohibits delegation, and `REPORT.md` correctly states that these textual checks are not equivalent to fresh-context forward-agent samples. This is an accepted, explicit residual behavioral limitation rather than evidence of independent runtime behavior.
- Scope and safety: the pinned head is a direct child of the stated base; all 39 changed paths are Task-owned; the coordinator package does not alter Task artifacts; `git diff --check` passes; the head has zero tracked cache/bytecode, active `agents/skills/` references, private-key blocks, credential-shaped assignments, user-specific paths, installed-cache paths, or unexpected non-UTF-8 files.
- Provenance: the source content is verified, but the README repository identity is disproved by the selected package manifest and live read-only Git resolution. The Task cannot be declared ready until the source link is corrected and the amended head is re-reviewed.

## Reuse Assessment

Validated as a candidate, not yet as a recurring capability. The normalized vendored-family comparison with an explicit transform allowlist, metadata/frontmatter checks, local-link resolution, and deterministic scenario assertions independently reproduced the report and detected the provenance gap. If repeated demand emerges, the canonical owner should be `agent-skill-organization` with a skill-scoped deterministic script or a narrowly owned repository tool; one successful migration does not justify promotion in this Task.

## Verdict

NEEDS_FIXES

## Re-Review

Pending an amended implementation head that corrects `skills/README.md:9`. Re-run provenance resolution, source inventory/hash/deviation, frontmatter, metadata, local-link, 31-test, live-validator, deterministic-scenario, scope, safety, and whitespace checks against the exact amended range; clear the untracked generated cache before the coordinator's clean integration gate.

# Task 02: Migrate And Refresh The Agent-Organization Skill Family

## Status

Ready

## Parent Project And Live Basis

- Project: `agents/context/projects/agent-documentation-mono-layout-migration/PROJECT.md`
- Plan row: 02
- Planned from: branch `codex/migrate-agent-docs-mono-layout` at coordinator head `e957cd4`
- Refreshed at: 2026-07-27 at `e957cd4`
- Dependencies verified: None; Task 01 is complete and independently `READY`, the worktree is clean, and no other worker owns the skill paths

## Outcome And Acceptance

- Outcome: The repository-owned `agent-organization` family lives under top-level `skills/`, reflects the complete non-generated Mono 1.1.0 family plus documented standalone portability corrections, and passes static, behavioral-equivalent, recursive-discovery, and workspace validation.
- Acceptance criteria:
  - Every tracked file under `agents/skills/` is moved with history to the equivalent top-level `skills/` path and no former live skill file remains.
  - `skills/agent-organization/` contains the complete 37-file Mono 1.1.0 source inventory excluding only generated `__pycache__` or bytecode: 14 `SKILL.md` files, 14 `agents/openai.yaml` interface metadata files, three Python scripts, and six Markdown references/templates.
  - Every source file matches Mono 1.1.0 except three reviewed standalone portability corrections: two validator command paths use top-level `skills/`, and the Project-family provenance link targets the vendored family-local upstream license.
  - `skills/README.md` records Mono 1.1.0 provenance, the 37-file family inventory, interface-metadata decision, external skill dependencies, the three portability corrections, validation commands, behavioral-testing limitation, and update policy without a machine-local source path.
  - All 14 skill frontmatter names are globally unique and match their containing folders; all 14 interface metadata files parse, declare the required interface fields, and invoke the matching `$skill-name`.
  - Recursive discovery finds all 14 `SKILL.md` files; directly linked local resources resolve; no generated cache, secret, private payload, absolute user path, installed-cache path, or former `agents/skills/` command/reference remains in active skill content.
  - Bundled Project-validator tests, live Project validation, empty Workflow validation, metadata checks, inventory/hash comparison with the allowed deviations, and deterministic trigger/routing/stop-rule scenario checks pass.

## Owned Scope

- Create: top-level `skills/` only through history-preserving moves from `agents/skills/` plus the 14 Mono 1.1.0 `agents/openai.yaml` source files; this Task's `REPORT.md`
- Modify: moved `skills/README.md`; moved family files only where Mono 1.1.0 differs or a documented standalone portability correction is required
- Test: Mono source inventory and normalized hash comparison; recursive discovery; frontmatter/name uniqueness; interface metadata schema and prompt mapping; local links; bundled Project-validator tests; live Project and Workflow validators; deterministic scenario matrix; active old-path, cache, secret, machine-path, scope, and whitespace checks

## Do Not Touch

- `access/`, `adapters/`, `mcp-servers/`, `templates/`, `tools/`, `agents/context/` outside this Task's `REPORT.md`, root `AGENTS.md` and `README.md`, `.github/workflows/`, `.gitignore`, implementation domains, immutable Project archives, legacy runs, ignored `.codex-local/`, external services, branches, remotes, or pull requests.
- `agents/context/projects/agent-documentation-mono-layout-migration/PROJECT.md`, `PLAN.md`, Project routing, Task 01 records, or any other coordinator control state.

## Interfaces

- Consumes: the current repository copy sourced from `abpiv-agents` 0.1.30; the installed Mono 1.1.0 package as read-only source evidence; Task 01's top-level owner convention and Codex recursive-discovery contract
- Produces: canonical top-level `skills/`, a documented 37-file Mono 1.1.0 family plus three portability corrections, reproducible validation evidence, `REPORT.md`, and one exact implementation commit

## Skills, Tools, And Authority

- Required implementation skills: `mono:agent-skill-organization`, `mono:testing-agent-skills`
- Required review and verification skills: `mono:verification-before-completion`, `mono:requesting-code-review`, `mono:receiving-code-review`
- Allowed tools and actions: read tracked files, Git metadata, and the selected installed Mono 1.1.0 package without persisting its absolute path; use `apply_patch` for moves and edits; run local read-only comparisons, parsers, tests, validators, and searches; stage exact owned files; commit one coherent Task result
- Approval-gated actions: None inside the owned tracked skill-migration scope; stop before publication, external mutation, installing into a runtime, changing another canonical owner, or broadening the selected source/version/deviation set
- Prohibited actions: delegate; edit Project control state; copy generated bytecode; persist an installed-cache or user-specific absolute path; read ignored secrets; use destructive reset/clean/checkout or force push; deploy; mutate external systems; alter immutable history or implementation behavior

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: derive and compare the 37-file normalized Mono source inventory, require exact content except the three allowed portability corrections, and require no generated bytecode
- Broader check: run `python skills/agent-organization/agent-project-organization/scripts/test_validate_projects.py`, `python skills/agent-organization/agent-project-organization/scripts/validate_projects.py .`, and `python skills/agent-organization/agent-workflow-organization/scripts/validate_workflows.py .`; validate all frontmatter, interface metadata, prompts, recursive discovery, and local links
- Diff or artifact review: compare the dispatch base to the Task head; require only history-preserving `agents/skills/` to `skills/` moves, 14 new interface metadata files, moved-file source updates, `skills/README.md`, and this `REPORT.md`; require no change in Task 01 outputs, context control state, immutable history, implementation domains, workflows, or external state
- Required evidence: exact old/new/source inventories and hash comparison; allowed-deviation diff; 14-skill discovery/frontmatter/name results; 14 metadata parse/prompt results; local-link count; validator test count and exit; live validator results; deterministic scenario coverage and fresh-agent limitation; active old-path/cache/safety searches; exact staged scope; `git diff --cached --check`; exact commit identity

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`

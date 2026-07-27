# Agent Documentation Mono Layout Migration Plan

## Planning Basis

- Goal: move live agent documentation to Mono 1.1.0's canonical top-level owner layout, migrate the repository-owned skill family coherently, verify the integrated result, and merge it to `main`
- Base state: clean topic branch `codex/migrate-agent-docs-mono-layout` from `origin/preview` commit `c58a221201057c3fb67ec31db198575fb0ff9970`; `origin/main` is `7b6267d23dc092dad007f04756325be0861002bc`
- Approval basis: the original request explicitly authorizes the agent-documentation migration and resulting merge to `main`
- Execution: one bounded implementer and one independent reviewer per Task
- Control state: this file is the authoritative Task ledger
- Replanning: material changes return through DDD and grill-me

## Shared Constraints

- Preserve root `AGENTS.md` discovery, `agents/context/`, implementation-domain behavior, same-origin analytics guidance, and all secret boundaries.
- Move live owner surfaces with Git history; do not recreate content from memory.
- Treat `agents/context/projects/archive/` and `agents/context/runs/legacy/` as immutable historical evidence even when they contain former live paths.
- Never read, copy, log, link, or commit `.codex-local/` values or installed-cache paths.
- Keep canonical owner bodies portable; keep harness-specific mapping thin and explicit.
- Update active paths, relative links, commands, repository maps, adapters, and validation contracts atomically within their owners.
- Use exact staging, inspect staged diffs, scan for secrets and machine-local paths, never force push, and follow topic branch -> `preview` -> pull request from `preview` to `main`.
- Do not deploy production or change external runtime, access, permissions, infrastructure, or application behavior.

## Task Ledger

| Task | Outcome | Dependencies | Status | Implementer | Review |
| --- | --- | --- | --- | --- | --- |
| 01 | Live non-skill agent owners and context routes use the top-level Mono layout with history and safety contracts preserved. | None | complete | task01-implementer | READY amended head |
| 02 | The repository-owned `agent-organization` family lives under `skills/`, reflects Mono 1.1.0 plus documented portability corrections, and passes skill validation. | None | complete | task02-implementer | READY amended head |
| 03 | The integrated migration passes whole-Project review and supplies verified evidence for coordinator archival, promotion, and merge through `preview` to `main`. | 01, 02 | revisions | task03-implementer | NEEDS_FIXES at first amended head |

## Task Outcomes And Interfaces

### Task 01: Migrate Canonical Non-Skill Owners And Context Routes

- Owns: active `agents/{access,adapters,mcp-servers,templates,tools}/` sources and their top-level destinations; root `AGENTS.md` and `README.md` if needed; active files under `agents/context/` except Project control state, archives, run history, and the skill-owned Project validator
- Consumes: Mono 1.1.0 canonical scaffold; existing access, MCP, adapter, template, tool, context, routing, repository-map, verification, Git-policy, and ignore contracts
- Produces: history-preserving moves to `access/`, `adapters/`, `mcp-servers/`, `templates/`, and `tools/`; corrected active links and routes; removal of stale task-era adapter text; evidence that historical and implementation domains are unchanged
- Required capabilities: `agent-context-organization`, `agent-access-organization`, `agent-mcp-organization`, `agent-adapter-organization`, `agent-tool-organization`
- Acceptance: exact old-to-new blob accounting; no active reference to former canonical paths outside immutable history; every changed and neighboring Markdown link resolves; profile, MCP, adapter, secret, and promotion semantics remain equivalent; prohibited domains and history are unchanged
- Approval or stop gate: the original request authorizes the moves; stop if a path is still consumed as a live interface or a safety contract would be weakened
- Completion evidence: implementation commit `92fdb1afa28614a48f4e2c4aeca5524dd7404c0b`, revision commit `bff58ef041b525d58f57f08a65a9ddcf296e58c3`, and amended independent verdict `READY`; 21/21 history-detected moves, 14 byte-identical and seven path-edited blobs, exact 24-entry implementation scope, 156/156 local links, 27/27 contract assertions, zero active former-owner or stale Task-language matches, zero prohibited-path or safety findings, and Project validation with zero warnings
- Deviations and residual findings: one non-blocking Minor notes that the report's revision-scope example uses moving `HEAD`; reruns must use the explicit amended head `bff58ef041b525d58f57f08a65a9ddcf296e58c3`. The one-use migration-verifier candidate was not promoted because recurring demand is unproven.

### Task 02: Migrate And Refresh The Agent-Organization Skill Family

- Owns: active `agents/skills/` source and top-level `skills/` destination, including README, skill bodies, references, scripts, tests, and selected interface metadata
- Consumes: Mono 1.1.0 cached package as read-only source evidence; current repository vendored family; current adapter and recursive-discovery contracts; upstream license text
- Produces: history-preserving move to `skills/`; semantically reviewed Mono 1.1.0 family; documented source version, inventory, dependencies, portability corrections, interface-metadata decision, and update policy; updated commands and local links
- Required capabilities: `agent-skill-organization`, `testing-agent-skills`
- Acceptance: inventory and content comparison against Mono 1.1.0 excluding generated cache files; canonical names and folders agree; frontmatter names are globally unique; recursive `SKILL.md` discovery works; bundled validator tests, live Project validation, empty Workflow validation, local links, safety scan, and deterministic scenario coverage pass
- Approval or stop gate: the original request authorizes the move and scoped contract refresh; stop if the source package cannot be made portable without an undocumented semantic fork or if a supported harness cannot discover the family
- Completion evidence: implementation commit `ccb422569e4f17c6eb05e037f0d217d1110b01ff`, provenance revision `8db18c153b99a027a598e59a692d6f1ee11336b3`, and amended independent verdict `READY`; exact 37-file family, 35 normalized exact matches plus three allowed corrections in two files, 14/14 skills, 14/14 metadata mappings, 90/90 relevant rendered links, 31 validator tests, live Project and Workflow validation with zero warnings, 8/8 deterministic scenarios, and zero scope or safety findings
- Deviations and residual findings: fresh-context agent samples were unavailable under the non-delegating Task contract and are not claimed; generated cache was removed and will be prevented through Task 03 integration; the vendored-family comparison candidate remains unpromoted because recurring demand is unproven.

### Task 03: Integrate, Verify, And Prepare Coordinator Publication

- Owns: cross-domain discovery, verification, adapter, and cache-hygiene findings; whole-Project verification evidence; final Task return records; a stable package consumed by coordinator handoff, archival, exact Git publication, pull request, and authorized merge
- Consumes: reviewed Task 01 and 02 commit ranges; live Git graph and workflows; repository verification and Git policy
- Produces: a clean integrated tree and zero-blocking whole-Project review; the coordinator then produces the immutable archive, removed active route, pushed `preview`, merged `preview` pull request in `main`, and post-merge ref/tree evidence
- Required capabilities: `agent-organization`, `agent-project-organization`, `verification-before-completion`, `handoff`, GitHub publication capability
- Acceptance: Project and Workflow validators pass from canonical paths; active Markdown links resolve; legacy history and prohibited implementation domains match the base; no credential, generated cache, or machine-local path enters tracked changes; staged and committed scope is exact; fresh remote/local-main reconciliation is recorded; the independent verdict is `READY`; coordinator closure then requires GitHub checks and `origin/main` to contain the migrated layout and archived Project
- Approval or stop gate: merge is authorized by the original request; do not force push, bypass `preview`, deploy production, merge with blocking review or CI findings, or overwrite unrelated remote work
- Revision evidence: the first independent review returned `NEEDS_FIXES` against implementation head `d6b5dbe17b1d439bbd1903fb0c20e7e77ca6a743`. Report revision `25be935b50151c6cda9d3d872864dc39e063a2a0` resolved the premature-archive finding and added the complete checker, but amended re-review found its report-only range still used moving `HEAD` and failed after the required coordinator checkpoint. The next report-only revision must derive a stable report head for every review-sensitive range. The four stable implementation edits continue to pass. A non-blocking Minor notes that neighboring `skills/README.md` validator examples omit `-B`; that file remains outside Task 03 revision scope.

## Integration And Reuse Obligations

- Canonical context, glossary, routing, Workflow, and repository docs: Tasks 01 and 03
- Validated reusable procedures or operational knowledge: Task 02, with Task 03 assessing any upstream inconsistency through the correct owner
- Project-wide review and integrated verification: Task 03

## Checkpoints And Replanning

- Record completed Task commit ranges, review verdicts, deviations, and unresolved Minor findings in the ledger or corresponding Task section.
- Add dated amendments to `PROJECT.md` and revise this graph before dispatch when live evidence changes scope, architecture, domain boundaries, acceptance, or dependencies.
- Tasks 01 and 02 may execute in parallel only from the same coordinator checkpoint in isolated worktrees because their owned paths and mutable state do not overlap.
- Task 03 begins only after both implementation ranges pass fresh independent review and are integrated into the coordinator branch.
- Immediately before Task 03 publication, fetch remote refs and inspect the separate local `main` worktree; reconcile all commits and touched paths since the Project base, and return through controlled replanning if an update overlaps migrated agent documentation.

## Project Closure

- All ledger Tasks are `complete`.
- All independent reviews and blocking fixes pass.
- Integrated verification proves the Project completion criteria.
- Project-local handoff and routing reflect final state.
- The coordinator removes the active route and moves the intact Project to `archive/2026-07-27-agent-documentation-mono-layout-migration/`.
- The archived Project and migrated canonical layout are present in `origin/main` after the authorized merge.

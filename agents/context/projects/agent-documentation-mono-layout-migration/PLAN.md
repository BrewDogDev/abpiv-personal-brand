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
| 01 | Live non-skill agent owners and context routes use the top-level Mono layout with history and safety contracts preserved. | None | review | task01-implementer | task01-reviewer |
| 02 | The repository-owned `agent-organization` family lives under `skills/`, reflects Mono 1.1.0 plus documented portability corrections, and passes skill validation. | None | planned | unassigned | pending |
| 03 | The integrated migration passes whole-Project review, is archived with handoff evidence, and is promoted and merged through `preview` to `main`. | 01, 02 | planned | unassigned | pending |

## Task Outcomes And Interfaces

### Task 01: Migrate Canonical Non-Skill Owners And Context Routes

- Owns: active `agents/{access,adapters,mcp-servers,templates,tools}/` sources and their top-level destinations; root `AGENTS.md` and `README.md` if needed; active files under `agents/context/` except Project control state, archives, run history, and the skill-owned Project validator
- Consumes: Mono 1.1.0 canonical scaffold; existing access, MCP, adapter, template, tool, context, routing, repository-map, verification, Git-policy, and ignore contracts
- Produces: history-preserving moves to `access/`, `adapters/`, `mcp-servers/`, `templates/`, and `tools/`; corrected active links and routes; removal of stale task-era adapter text; evidence that historical and implementation domains are unchanged
- Required capabilities: `agent-context-organization`, `agent-access-organization`, `agent-mcp-organization`, `agent-adapter-organization`, `agent-tool-organization`
- Acceptance: exact old-to-new blob accounting; no active reference to former canonical paths outside immutable history; every changed and neighboring Markdown link resolves; profile, MCP, adapter, secret, and promotion semantics remain equivalent; prohibited domains and history are unchanged
- Approval or stop gate: the original request authorizes the moves; stop if a path is still consumed as a live interface or a safety contract would be weakened

### Task 02: Migrate And Refresh The Agent-Organization Skill Family

- Owns: active `agents/skills/` source and top-level `skills/` destination, including README, skill bodies, references, scripts, tests, and selected interface metadata
- Consumes: Mono 1.1.0 cached package as read-only source evidence; current repository vendored family; current adapter and recursive-discovery contracts; upstream license text
- Produces: history-preserving move to `skills/`; semantically reviewed Mono 1.1.0 family; documented source version, inventory, dependencies, portability corrections, interface-metadata decision, and update policy; updated commands and local links
- Required capabilities: `agent-skill-organization`, `testing-agent-skills`
- Acceptance: inventory and content comparison against Mono 1.1.0 excluding generated cache files; canonical names and folders agree; frontmatter names are globally unique; recursive `SKILL.md` discovery works; bundled validator tests, live Project validation, empty Workflow validation, local links, safety scan, and deterministic scenario coverage pass
- Approval or stop gate: the original request authorizes the move and scoped contract refresh; stop if the source package cannot be made portable without an undocumented semantic fork or if a supported harness cannot discover the family

### Task 03: Integrate, Close, Publish, And Merge

- Owns: cross-domain findings routed to Tasks 01 or 02; integrated verification evidence; Project Task return records; Project-local handoff; coordinator control-state closure and archival; exact Git commits; topic-to-`preview` integration; the `preview` to `main` pull request and authorized merge
- Consumes: reviewed Task 01 and 02 commit ranges; live Git graph and workflows; repository verification and Git policy
- Produces: a clean integrated tree; zero blocking findings; immutable archived Project; removed active route; pushed `preview`; merged `preview` pull request in `main`; post-merge ref and tree verification
- Required capabilities: `agent-organization`, `agent-project-organization`, `verification-before-completion`, `handoff`, GitHub publication capability
- Acceptance: Project and Workflow validators pass from canonical paths; active Markdown links resolve; legacy history and prohibited implementation domains match the base; no credential or machine-local path enters tracked changes; staged and committed scope is exact; GitHub checks permit merge; `origin/main` contains the archived migration and canonical layout
- Approval or stop gate: merge is authorized by the original request; do not force push, bypass `preview`, deploy production, merge with blocking review or CI findings, or overwrite unrelated remote work

## Integration And Reuse Obligations

- Canonical context, glossary, routing, Workflow, and repository docs: Tasks 01 and 03
- Validated reusable procedures or operational knowledge: Task 02, with Task 03 assessing any upstream inconsistency through the correct owner
- Project-wide review and integrated verification: Task 03

## Checkpoints And Replanning

- Record completed Task commit ranges, review verdicts, deviations, and unresolved Minor findings in the ledger or corresponding Task section.
- Add dated amendments to `PROJECT.md` and revise this graph before dispatch when live evidence changes scope, architecture, domain boundaries, acceptance, or dependencies.
- Tasks 01 and 02 may execute in parallel only from the same coordinator checkpoint in isolated worktrees because their owned paths and mutable state do not overlap.
- Task 03 begins only after both implementation ranges pass fresh independent review and are integrated into the coordinator branch.

## Project Closure

- All ledger Tasks are `complete`.
- All independent reviews and blocking fixes pass.
- Integrated verification proves the Project completion criteria.
- Project-local handoff and routing reflect final state.
- The coordinator removes the active route and moves the intact Project to `archive/2026-07-27-agent-documentation-mono-layout-migration/`.
- The archived Project and migrated canonical layout are present in `origin/main` after the authorized merge.

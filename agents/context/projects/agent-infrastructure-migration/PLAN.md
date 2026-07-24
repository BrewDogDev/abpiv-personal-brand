# Agent Infrastructure Migration Plan

## Planning Basis

- Goal: establish the canonical agent scaffold, preserve and reclassify useful legacy material, and publish the verified migration as a ready PR from `preview` to `main`
- Base state: clean dedicated worktree on `codex/migrate-agent-infrastructure`, based on `origin/preview` commit `0b669d0482db62878faf15aadead227672615d48`; `origin/main` and `origin/preview` have identical trees
- Approval basis: the original user request authorizes the full migration, legacy moves, Git publication, and a non-draft PR to `main`
- Execution: one bounded implementer and one independent reviewer per Task
- Control state: this file is the authoritative Task ledger
- Replanning: material changes return through DDD and `grill-me`

## Shared Constraints

- Preserve useful human-authored guidance and history; do not rewrite historical artifacts as current truth.
- Keep `content-site/`, `infra/analytics/`, `infra/n8n/`, and `creative-production/` implementation behavior unchanged.
- Leave `.codex-local/` ignored and never read, copy, log, or commit its credential values.
- Keep public analytics same-origin through `/_analytics/*`.
- Keep root and harness entrypoints thin and point them to canonical assets.
- Follow the documented `preview` to `main` promotion path; do not merge or deploy production.
- Use exact staging, inspect the staged diff, scan for secrets, and never force push.

## Task Ledger

| Task | Outcome | Dependencies | Status | Implementer | Review |
| --- | --- | --- | --- | --- | --- |
| 01 | Canonical context, root entrypoint, repository map, Git policy, learning surfaces, and scaffold registries are complete. | None | complete | context-implementer | READY |
| 02 | Legacy root, Kilo, and Superpowers agent artifacts are preserved in the correct Layer 3 or Layer 4 locations with all references reconciled. | 01 | complete | legacy-implementer | READY |
| 03 | The repository-owned `agent-organization` skill family and Project validator are recursively discoverable, documented, and tested. | 01 | complete | skills-implementer | READY |
| 04 | n8n MCP/access guidance and harness adapter contracts are split into their canonical owners without exposing local secrets. | 01 | complete | access-implementer | READY |
| 05 | The integrated migration passes whole-Project review, validation, handoff, archival, exact staging, and GitHub publication as a ready PR to `main`. | 02, 03, 04 | executing | final-integrator | pending |

## Task Outcomes And Interfaces

### Task 01: Establish Canonical Context And Governance

- Owns: `AGENTS.md`, `README.md`, `agents/context/` stable context except legacy run history and Project control state, `agents/{templates,tools}/` registries
- Consumes: current root instructions, live repository map, current workflows, implementation READMEs, and root glossary
- Produces: thin root entrypoint; completed context, glossary, routing, repository map, verification reference, Git policy, learning logs, and minimal scaffold registries
- Required capabilities: `agent-context-organization`, parent `agent-organization` Git governance
- Acceptance: every root route and local Markdown link resolves; branch/environment roles match live workflows; content and infrastructure boundaries remain explicit; no run-specific history is promoted into stable context
- Approval or stop gate: stop if live implementation docs contradict safety-critical root instructions
- Completion evidence: implementation commit `00b3ad439f21da0b1805059f6a4d89d58e797b7f`; coordinator scaffold checkpoint `58fe84465477d65dc165ec67e94c6baba458ed55`; amended-head review `READY`; 103/103 Task links and 104/104 combined-range links resolved from Git objects; Project validator passed with no warnings
- Produced interfaces: thin root entrypoint, canonical context/routing/glossary, repository map, verification reference, Git policy, Layer 4 registries, and learning logs
- Deviations and residual findings: the first review found five links that depended on untracked Project scaffold; the coordinator checkpoint resolved the finding without changing the 18 Task-owned implementation files; no Minor findings remain

### Task 02: Preserve And Reclassify Legacy Agent History

- Owns: root `CONTEXT.md`, `HANDOFF.md`, `DEPLOYMENT_PLAN.md`, `.kilo/plans/`, `docs/superpowers/`, `agents/context/runs/legacy/`, and affected references outside implementation code
- Consumes: Task 01 layer model, glossary, routing, and repository map
- Produces: preserved legacy artifacts with a provenance/index record; canonical glossary integration; removal of superseded root/Kilo/Superpowers control surfaces; no false active Project state
- Required capabilities: `agent-context-organization`, `agent-adapter-organization`
- Acceptance: all tracked legacy source content is accounted for by exact moves or documented continued ownership; searches find no live routing to removed paths; historical artifacts are clearly non-authoritative
- Approval or stop gate: the original migration request authorizes moves and removal of superseded paths; stop if an artifact is still active
- Completion evidence: implementation commit `6439d1e7a138022d1a8b7712f52588b5b04097d3`; independent review `READY` with no findings; 12/12 exact blob and SHA-256 moves, 12/12 provenance records, exact 29-path implementation scope, 7/7 glossary blocks, 100/100 committed links, zero stale active routes or safety matches, and unchanged excluded implementation/adapter domains
- Deviations and residual findings: the implementation preserved one source blob without a final newline through a documented one-file Git index method after `apply_patch` could not retain the exact bytes; independent review reproduced the committed and worktree blob equality; no review findings remain

### Task 03: Vendor And Validate Agent-Organization Skills

- Owns: `agents/skills/`, including the `agent-organization` family and its bundled resources/scripts
- Consumes: installed `abpiv-agents` version `0.1.30` as the migration source and Task 01 scaffold contracts
- Produces: repository-owned recursive skill family, provenance/dependency notes, working Project validator, and validator test evidence
- Required capabilities: `agent-skill-organization`, `testing-agent-skills`
- Acceptance: every `SKILL.md` is recursively discoverable; relative links resolve or external dependencies are explicit; validator unit tests and live workspace validation pass
- Approval or stop gate: stop rather than persist machine-specific cache paths or silently alter procedural semantics
- Completion evidence: isolated implementation commit `556a1181eebe10479a5eb124961fde647f03ff30`, integrated as `a2960a0`; independent review `READY`; 23/23 source inventory, 22 exact normalized files plus one documented license-link portability correction, 14 unique recursively discovered skills, 9/9 local links, 22 validator tests, live Project and empty-Workflow validation with zero warnings, and clean scope/safety checks
- Deviations and residual findings: one non-blocking Minor records nonstandard report section headings despite complete evidence; deterministic scenarios verify rule presence and routing behavior but do not sample selection reliability across every harness

### Task 04: Split Access, MCP, And Adapter Contracts

- Owns: `agents/access/`, `agents/mcp-servers/`, `agents/adapters/`, and related stable routing links
- Consumes: the redacted local n8n guidance in current root instructions, existing `infra/n8n` documentation, ignore rules, and Task 01 context
- Produces: least-privilege local-client access profile, n8n MCP server contract, Codex/root and legacy Kilo adapter records, registries, and safe verification guidance
- Required capabilities: `agent-access-organization`, `agent-mcp-organization`, `agent-adapter-organization`
- Acceptance: access selection, server runtime, harness mapping, and secret boundaries are unambiguous; no secret values or private config content enter tracked files; routing links resolve
- Approval or stop gate: no credential reads, permission expansion, remote MCP mutation, or workflow deployment is authorized
- Completion evidence: isolated implementation commit `cbdb47ff741a619e9c7188c4beadea153119de63`, integrated as `4d5d6a2`; independent review `READY` with no findings; exact 21-file scope, 3/3 profile contracts, 13/13 MCP sections, 2/2 adapters, 2/2 JSON examples, ignored-local verification without reading, and zero safety matches
- Deviations and residual findings: the isolated review deferred one declared Codex-adapter link to Task 03; combined integration now supplies `agents/skills/agent-organization/`; live credentials, MCP runtime, and external accounts were intentionally not probed

### Task 05: Integrated Review, Closure, And Publication

- Owns: cross-domain findings and fixes routed to their owners, Project review/verification evidence, Project handoff and archive transition, exact Git staging/commit/push, and the GitHub PR
- Consumes: Tasks 01-04 outputs and independent reviews
- Produces: complete reviewed Task records; integrated structure/link/secret/Git validation; immutable archived Project; updated active routing; commit on `preview`; ready PR to `main`
- Required capabilities: `agent-organization`, `agent-project-organization`, `verification-before-completion`, `handoff`, `github:yeet`
- Acceptance: no blocking review findings; all Task records complete; Project validator and specialist checks pass from repository paths; Git diff contains only intended files; PR is non-draft, targets `main`, and uses `preview` as head
- Approval or stop gate: do not merge, deploy production, force push, or publish if `origin/preview` has diverged

## Integration And Reuse Obligations

- Canonical context, glossary, routing, Workflow, and repository docs: Tasks 01, 02, and 04
- Validated reusable procedures or operational knowledge: Task 03, with Task 05 cross-domain review
- Project-wide review and integrated verification: Task 05

## Checkpoints And Replanning

- Record completed Task commit ranges, review verdicts, deviations, and unresolved Minor findings in the ledger or corresponding Task section.
- Add dated amendments to `PROJECT.md` and revise this graph before dispatch when live evidence changes scope, architecture, domain boundaries, acceptance, or dependencies.
- Tasks 02, 03, and 04 may run in parallel only after Task 01 is complete because they own disjoint files and create no external side effects.
- Parallel execution decision: at the user's request, Tasks 03 and 04 use separate sibling Git worktrees and branches from one coordinator checkpoint; Task 03 owns only `agents/skills/`, Task 04 owns access/MCP/adapters plus two routing files, and Task 02 review writes only its `REVIEW.md`.
- Task 01 review amendment: the implementation commit's five Project routing/archive links require the coordinator-owned Project scaffold to be checkpointed in the amended review head; the same reviewer must verify links against that commit tree before completion.

## Project Closure

- All ledger Tasks are `complete`.
- All independent reviews and blocking fixes pass.
- Integrated verification proves the Project completion criteria.
- Project-local handoff and routing reflect final state.
- The coordinator removes the active route and moves the intact Project to `archive/<closure-date>-<project-slug>/`.

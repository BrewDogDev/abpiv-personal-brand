# Agent Documentation Mono Layout Migration

## Status

- Status: executing
- Owning context: `agents/context/`
- Branch or working state: `codex/migrate-agent-docs-mono-layout`
- Base: `origin/preview` at `c58a221201057c3fb67ec31db198575fb0ff9970`
- Authorization: The user requested use of `mono:agent-organization` to migrate this repository's agent documentation and complete the result through a merge to `main`.

## Outcome

The repository's live agent documentation uses the Mono 1.1.0 canonical owner layout, preserves historical evidence, passes specialist and integrated verification, and is merged to `main` through the documented `preview` promotion path.

## Non-Goals

- Change public-site content, runtime code, analytics behavior, n8n infrastructure, cloud resources, permissions, or secrets.
- Rewrite immutable archived Project or legacy run-history records to use current paths.
- Deploy the content site or any production infrastructure.
- Add a new external access target, MCP runtime, executable tool, recurring Workflow, or active harness.

## Domain-Driven Frame

### Decision

Decide how the repository should migrate canonical agent owners from the former `agents/<owner>/` layout to Mono 1.1.0's top-level owner layout without losing history, breaking discovery, or confusing live routes with archived evidence.

### Domain Area And Outcome

- Domain area: repository agent documentation, discovery, and delivery governance
- Economic, user, or risk driver: reduce stale-path failures, source-of-truth ambiguity, harness coupling, and unsafe publication while preserving auditable history
- Experts or decision owners: the repository owner for approval; Mono 1.1.0 skills for target contracts; live repository files and workflows for operational truth

### Ubiquitous Language

| Term | Meaning here | Other meaning or avoided alias |
| --- | --- | --- |
| Canonical context | Repository meaning, routing, stable references, and Layer 4 registries retained under `agents/context/`. | Not every agent-owned asset. |
| Canonical owner surface | A top-level portable owner such as `skills/`, `tools/`, `mcp-servers/`, `access/`, `adapters/`, or `templates/`. | Not an installed plugin cache or archived path. |
| Historical path | A path written inside immutable Project archives or run-history evidence that describes the state at that time. | Not a live route that should be rewritten. |
| Promotion | Topic branch to `preview`, then a `preview` pull request to `main`. | Not production deployment. |

### Bounded Contexts And Ownership

| Context or owner | Responsibility | Owned data or decisions | Dependencies |
| --- | --- | --- | --- |
| Repository context | Meaning, routing, glossary, repository map, verification, Projects, and history | Which paths are live and which evidence remains historical | Canonical owner surfaces and Git governance |
| Skills | Reusable procedures, nested routing, bundled validators, and interface metadata | Mono-family source, portability deviations, discovery, and tests | Context, adapters, and external dependency availability |
| Access | Credential-free service and target selection | Profiles, interfaces, secret boundaries, and action gates | MCP and adapter references |
| MCP servers | Server transport, dynamic tools, runtime, and safety contracts | n8n instance MCP documentation | Access target and adapter mapping |
| Adapters | Harness-specific discovery mappings | Active Codex and historical Kilo mappings | Context, skills, access, and MCP owners |
| Git governance | Topic, `preview`, pull request, and `main` promotion | Required checks, exact staging, and merge sequence | Live Git graph and GitHub workflows |

### Behaviors, Events, Policies, And Integrations

- A fresh agent reads root `AGENTS.md`, loads `agents/context/`, and follows links to top-level canonical owners.
- A move preserves Git history while active Markdown routes and relative links are updated atomically.
- Archived Projects and legacy runs remain immutable evidence even when they contain former live paths.
- The repository-owned skill family is compared with Mono 1.1.0, adapted only where portability requires it, and recursively validated.
- A push to `preview` is publication, while a merge to `main` is production-source promotion and still does not authorize production deployment.

### Validation

- Evidence that could change this frame: a supported harness cannot discover top-level nested skills; a live implementation or workflow contradicts the promotion contract; or a moved surface still has an undiscovered active consumer
- Next expert or artifact validation: task-scoped independent reviews, Project and Workflow validators, recursive skill discovery, active-link resolution, secret/path scans, GitHub checks, and post-merge ref verification

## Targets And Interfaces

- Affected repositories, services, or systems: tracked agent documentation and Project control state in `BrewDogDev/abpiv-personal-brand`, plus Git refs and the `preview` to `main` pull request
- Existing interfaces to preserve: root `AGENTS.md`, `agents/context/`, implementation READMEs, ignored `.codex-local/`, same-origin analytics guidance, profile and MCP safety contracts, active Codex discovery, historical Kilo classification, immutable Project archives, and the documented promotion sequence

## Approval And Safety Boundaries

- Authorized actions: history-preserving tracked moves; active path and contract updates; vendored skill-family migration; validation; branch creation; exact commits; push to `preview`; creation and merge of the `preview` to `main` pull request
- Approval-gated actions: any production deployment, external permission or secret change, runtime mutation, new public surface, force push, or scope expansion beyond agent documentation and Git promotion
- Prohibited or out-of-scope actions: reading or persisting `.codex-local/` values, rewriting immutable archives, changing application or infrastructure behavior, bypassing `preview`, or deleting useful history

## Completion Criteria

- Live canonical owner surfaces are top-level and `agents/` retains only canonical context.
- Every active path, route, adapter mapping, command, and local Markdown link resolves after the moves.
- The repository-owned `agent-organization` family reflects the selected Mono 1.1.0 source plus documented portability corrections, passes bundled tests, and is recursively discoverable.
- Legacy run history and the July 24 archived Project remain byte-for-byte unchanged.
- All Tasks and independent reviews pass.
- Durable results and validated reuse opportunities are integrated into their canonical owners.
- Integrated review, verification, routing removal, archival, publication, and the authorized merge to `main` pass.
- No production deployment, secret access, or runtime mutation occurs.

## Decisions And Amendments

| Date | Evidence or trigger | Decision | Plan impact | Approval basis |
| --- | --- | --- | --- | --- |
| 2026-07-27 | Mono 1.1.0's `agent-organization` scaffold, repository live layout, immutable July 24 archive, current Git graph, and the user's request were inspected. | Use Migrate mode; keep `agents/context/`, move the sibling canonical owners to top level, preserve immutable history, and promote through `preview` to an authorized `main` merge. | Create specialist-owned documentation, skill-family, and integrated-publication Tasks. | Original user request and `agent-organization` classification. |
| 2026-07-27 | The affected owners, active references, vendored-family delta, promotion workflow, and preservation boundaries were inventoried with no material unresolved decision. | Move to planning and define three bounded Tasks with independent reviews; Tasks 01 and 02 are parallel-eligible only in isolated worktrees because their owned files do not overlap. | Write the complete Task graph and validate it before execution. | Original user request plus the inspected Mono and repository contracts. |
| 2026-07-27 | The complete three-Task graph traces every requested outcome and non-goal, resolves cross-domain ownership, preserves immutable history, records the merge authority, and passes Project validation with zero warnings. | Approve the Project for coordinated execution; Tasks 01 and 02 may be briefed and dispatched from the same checkpoint in isolated worktrees. | Move the Project and active route to `ready`. | Original request plus successful planning self-review and validator evidence. |

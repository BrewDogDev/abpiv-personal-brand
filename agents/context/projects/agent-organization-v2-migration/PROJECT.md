# Agent Organization V2 Migration

## Status

- Status: ready
- Owning context: `agents/context/`
- Branch or working state: `codex/migrate-agent-organization-v2`
- Base: `origin/preview` at `088ac31aeea018131a7bf4d11fff8943266cfba1`
- Authorization: The user explicitly requested migration of the repository's agent organization using `abpiv-agents:agent-organization` from package version 0.1.36.

## Outcome

The repository's live agent infrastructure uses the 0.1.36 `agents/*` canonical-owner layout and procedures, preserves useful guidance and history, and passes specialist and integrated validation on a local topic branch.

## Non-Goals

- Change public-site content, runtime code, analytics behavior, n8n infrastructure, cloud resources, permissions, or secrets.
- Rewrite immutable archived Projects or preserved legacy run history to use current paths.
- Delete useful human-authored agent documentation or the 14 retained Codex skill metadata files.
- Push, open or merge a pull request, deploy, publish, or mutate external state.
- Create a new executable tool, recurring Workflow, access target, MCP runtime, or active harness.

## Domain-Driven Frame

### Decision

Decide how to migrate the repository from top-level canonical agent-owner surfaces to the 0.1.36 `agents/*` layout without losing history, weakening discovery, or conflating machine-local plugin installation with the tracked source of truth.

### Domain Area And Outcome

- Domain area: repository agent infrastructure, discovery, and delivery governance
- Economic, user, or risk driver: reduce stale-path failures, contract drift, source-of-truth ambiguity, and unsafe execution while preserving auditable history and harness discovery
- Experts or decision owners: the repository owner for authorization; `BrewDogDev/abpiv-agents` 0.1.36 for the requested target contract; live repository files and workflows for operational truth

### Ubiquitous Language

| Term | Meaning here | Other meaning or avoided alias |
| --- | --- | --- |
| Canonical context | Repository meaning, routing, stable references, and Layer 4 state under `agents/context/`. | Not every file owned by an agent-infrastructure domain. |
| Canonical owner surface | A portable owner under `agents/`, including `skills/`, `access/`, `mcp-servers/`, `tools/`, `templates/`, and `adapters/`. | Not an installed plugin cache or immutable historical path. |
| Source package | The versioned, repository-addressable `BrewDogDev/abpiv-agents` 0.1.36 package named by the user. | Not a machine-local cache path persisted in Git. |
| Retained metadata | The 14 existing `agents/openai.yaml` skill interface files preserved because the 0.1.36 skill subset omits them while this repository requires them. | Not duplicated skill bodies or adapter ownership. |
| Historical path | A path inside an immutable archived Project or preserved legacy run that describes its original state. | Not a live route that should be rewritten. |

### Bounded Contexts And Ownership

| Context or owner | Responsibility | Owned data or decisions | Dependencies |
| --- | --- | --- | --- |
| Agent organization | Cross-domain classification, owner layout, Git governance, sequencing, and integrated verification | Migration boundary and canonical placement | Every specialist owner |
| Projects | Active migration control state, Task ledger, review, handoff, and closure | Project status and Task contracts | Context and validator behavior |
| Skills | Reusable procedures, nested routing, scripts, references, and interface metadata | 0.1.36 overlay, retained metadata, discovery, and tests | Context, adapters, and source provenance |
| Access | Credential-free service and target selection | Profiles, interfaces, secret boundaries, and action gates | MCP and adapter references |
| MCP servers | Server transport, dynamic tools, runtime, and safety contracts | n8n instance MCP documentation | Access target and adapter mapping |
| Tools and templates | Empty registries and future placement contracts | Canonical registry paths | Agent-organization scaffold |
| Adapters | Harness-specific discovery mappings | Active Codex and historical Kilo mappings | Context, skills, access, and MCP owners |
| Repository context | Meaning, routing, glossary, repository map, verification, Projects, and history | Which paths are live and which records remain historical | Canonical owner surfaces and Git governance |

### Behaviors, Events, Policies, And Integrations

- A fresh agent reads root `AGENTS.md`, loads `agents/context/`, and follows live routes to sibling owners under `agents/`.
- A tracked move preserves useful content and history while live Markdown routes, commands, and relative links update atomically.
- Archived Projects and legacy runs remain immutable evidence even when they contain former live paths.
- The repository-owned skill family receives the 0.1.36 non-generated skill subset while retaining repository-required Codex metadata.
- The skill family and live Project state satisfy the updated validator and bounded Task-contract behavior.
- Local implementation authority does not imply publication, deployment, access, permission, or secret authority.

### Validation

- Evidence that could change this frame: a supported harness cannot recursively discover `agents/skills/`; a 0.1.36 source file conflicts with a repository-required metadata or safety contract; or a live consumer of a moved path is not covered by the inventory
- Next expert or artifact validation: specialist-owned Task reviews, Project and Workflow validators, recursive discovery, metadata checks, active-link resolution, secret and cache-path scans, archive preservation checks, and final Git scope review

## Targets And Interfaces

- Affected repositories, services, or systems: tracked agent infrastructure and local Git state in `BrewDogDev/abpiv-personal-brand`
- Existing interfaces to preserve: root `AGENTS.md`, `agents/context/`, implementation READMEs, ignored `.codex-local/`, same-origin analytics guidance, access and MCP safety contracts, active Codex discovery, historical Kilo classification, immutable Project archives, and the documented branch-promotion policy

## Approval And Safety Boundaries

- Authorized actions: in-scope tracked moves and updates under agent infrastructure; 0.1.36 skill-family migration; Project control records; validation; local topic-branch commits
- Approval-gated actions: any push, pull request, merge, deployment, publication, external permission or secret change, runtime mutation, deletion of useful guidance, or scope expansion beyond tracked agent infrastructure
- Prohibited or out-of-scope actions: reading or persisting `.codex-local/` values, rewriting immutable archives or legacy history, changing application or infrastructure behavior, force pushing, or storing machine-local plugin cache paths

## Completion Criteria

- Live canonical owner surfaces are under `agents/`, with `agents/context/` retaining its Layer 1, Layer 3, and Layer 4 contracts.
- Every active path, route, adapter mapping, command, and changed Markdown link resolves after the moves.
- The repository-owned `agent-organization` family reflects the non-generated `abpiv-agents` 0.1.36 subset plus documented retained metadata and passes its bundled tests.
- Recursive discovery finds the expected globally unique skills and matching retained metadata under `agents/skills/`.
- Archived Projects and legacy run history remain unchanged.
- All Tasks and independent reviews pass.
- Durable results and validated reuse opportunities are integrated into their canonical owners.
- Integrated review, verification, routing removal, and archival pass locally.
- No external publication, deployment, secret access, permission change, or runtime mutation occurs.

## Decisions And Amendments

| Date | Evidence or trigger | Decision | Plan impact | Approval basis |
| --- | --- | --- | --- | --- |
| 2026-07-27 | The 0.1.36 skill contract, current repository layout, prior completed migration, plugin metadata, current Git graph, and the user's request were inspected. | Use Migrate mode; move the six top-level owner surfaces beneath `agents/`, preserve immutable history and retained metadata, and keep all work local. | Scaffold a new Project and inventory specialist-owned Tasks. | Original user request and `agent-organization` classification. |
| 2026-07-27 | The ownership inventory found 59 files across six live top-level owner surfaces, active path references in canonical context and owner documentation, a complete 37-file vendored family, a 23-file non-generated 0.1.36 source subset, and 14 repository-required metadata files absent from that subset. | Move to planning and decompose the migration by canonical specialist owner, keeping cross-domain integration and whole-Project verification explicit. | Write the complete Task graph and validate it before execution. | Original request plus inspected repository and package evidence. |
| 2026-07-27 | The eight-Task graph traces the requested layout, source migration, preserved metadata and history, canonical-owner integrations, and whole-Project verification; Project validation passed with zero warnings. | Approve the Project for coordinated local execution in dependency order. | Move the Project and active route to `ready`; brief Task 01 just in time. | Original request plus planning self-review and validator evidence. |
| 2026-07-27 | The legacy repository validator rejected `ready` with all Tasks still `planned`, while the requested 0.1.36 validator passed the same Project with zero warnings and intentionally removes premature current-Task routing. | Treat the legacy failure as target-contract drift, retain the 0.1.36-ready control state, and make validator migration the first execution Task. | Task 01 is the mandatory first dispatch; later Project checks use the migrated repository validator. | Original request for the 0.1.36 organization contract plus direct validator evidence. |

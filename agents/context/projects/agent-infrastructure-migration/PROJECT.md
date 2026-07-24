# Agent Infrastructure Migration

## Status

- Status: executing
- Owning context: `agents/context/`
- Branch or working state: `codex/migrate-agent-infrastructure`
- Base: `origin/preview` at `0b669d0482db62878faf15aadead227672615d48`
- Authorization: User requested use of `abpiv-agents:agent-organization` to scaffold and migrate the repository's legacy agent infrastructure and open a non-draft PR to `main`.

## Outcome

The repository has a portable, discoverable, validated `agents/` infrastructure; useful legacy agent material is preserved in the correct lifecycle layer; root instructions are thin; and the reviewed migration is published from `preview` as a ready PR to `main`.

## Non-Goals

- Change public site content, runtime behavior, analytics collection, n8n resources, cloud infrastructure, permissions, or secrets.
- Deploy the content site or production infrastructure.
- Convert unimplemented historical ideas into active Workflow contracts.
- Merge the final pull request.

## Domain-Driven Frame

### Decision

Define which agent artifacts are current sources of truth, which are historical evidence, and how future agents discover the correct owner without relying on Kilo or Superpowers conventions.

### Domain Area And Outcome

- Domain area: repository agent operations and delivery governance
- Economic, user, or risk driver: reduce stale-context errors, unsafe promotion, duplicated guidance, and harness lock-in
- Experts or decision owners: repository owner for intent and approval; live repository files and workflows for operational truth

### Ubiquitous Language

| Term | Meaning here | Other meaning or avoided alias |
| --- | --- | --- |
| Project | Active multi-Task or multi-session delivery state under `agents/context/projects/`. | Not every historical plan. |
| Workflow | A reusable agent outcome contract. | Not a GitHub Actions YAML file or n8n runtime object. |
| Handoff | A dated continuity record for current work. | Not durable deployment documentation. |
| Stable reference | Durable guidance valid across runs. | Not a run log or stale plan. |
| Adapter | A thin harness mapping to canonical assets. | Not a duplicate source of context. |

### Bounded Contexts And Ownership

| Context or owner | Responsibility | Owned data or decisions | Dependencies |
| --- | --- | --- | --- |
| Repository context | Meaning, routing, glossary, references, run history, and handoffs | Canonical discovery and lifecycle placement | Implementation documentation |
| Project lifecycle | Active delivery control state and closure | Project and Task status | Repository context and validators |
| Skills | Reusable procedures and recursive discovery | Skill bodies, resources, and behavioral validation | Repository context |
| Access and MCP | External-handle selection and MCP runtime contracts | Secret boundaries and safe local setup | Existing n8n infrastructure |
| Adapters and entrypoints | Harness discovery of canonical assets | Thin mappings only | All canonical owners |
| Git governance | Branch, promotion, review, and deployment boundaries | Repository-wide Git contract | Live GitHub workflows |

### Behaviors, Events, Policies, And Integrations

- A fresh agent reads the root entrypoint, then routes through canonical context.
- Nontrivial planned work is classified before a Project is created or resumed.
- Legacy Kilo and Superpowers artifacts remain inspectable but cannot masquerade as active control state.
- Public changes into `main` originate from `preview`; production deployment remains a separate manual action.
- Local n8n credentials remain ignored and are referenced only through redacted contracts.

### Validation

- Evidence that could change this frame: live files or GitHub workflow behavior contradicting the documented source, an active legacy plan still governing work, or an agent harness requiring a different discovery surface
- Next expert or artifact validation: independent Task reviews, repository validators, link/reference checks, secret scan, and GitHub PR checks

## Targets And Interfaces

- Affected repositories, services, or systems: `BrewDogDev/abpiv-personal-brand` tracked documentation and agent infrastructure only
- Existing interfaces to preserve: root `AGENTS.md` discovery, implementation READMEs, same-origin analytics boundary, preview-to-main promotion, ignored `.codex-local/` config, and Git history

## Approval And Safety Boundaries

- Authorized actions: scaffold and migrate tracked agent infrastructure; move or remove superseded legacy agent artifacts while preserving useful history; create a branch, commit, push `preview`, and open a ready PR to `main`
- Approval-gated actions: merging the PR, production deployment, permissions or secret changes, destructive deletion of useful history, or scope expansion into implementation behavior
- Prohibited or out-of-scope actions: exposing secrets, force pushing, bypassing `preview`, changing cloud/runtime resources, or rewriting unrelated content

## Completion Criteria

- The canonical scaffold and each populated domain pass their specialist and cross-domain checks.
- Legacy instructions, context, handoffs, Kilo plans, and Superpowers artifacts are either migrated, preserved as history, or explicitly classified as still-canonical implementation documentation.
- Root and harness entrypoints point to canonical context without duplicating it.
- Branch and environment roles are documented from live workflow evidence.
- All Tasks and independent reviews pass.
- Durable results and validated reuse opportunities are integrated into their canonical owners.
- Integrated review, verification, routing removal, and archival pass.
- A non-draft PR from `preview` to `main` exists for user review.

## Decisions And Amendments

| Date | Evidence or trigger | Decision | Plan impact | Approval basis |
| --- | --- | --- | --- | --- |
| 2026-07-24 | Root files, legacy Kilo/Superpowers artifacts, workflows, branch state, and user request were inspected. | Use Migrate mode; preserve legacy working material as Layer 4 history, keep implementation docs beside their systems when still canonical, and make `agents/` the portable source of agent context. | Create sequential domain Tasks plus independent reviews and integrated verification. | Original user request. |
| 2026-07-24 | The migration crosses canonical context, Project history, Skills, Access, MCP, adapters, and Git governance. | Treat the work as one Project with independently reviewable domain Tasks; permit parallel implementation only where file ownership and dependencies do not overlap. | Move to planning and write the complete Task graph. | `agent-project-organization` classification. |
| 2026-07-24 | The complete five-Task graph was traced to every requested outcome, self-reviewed, and validated with no unresolved material decision. | Approve the Project for coordinated execution; Tasks 02-04 become parallel-eligible only after Task 01 passes independent review. | Move Project and active route to `ready`. | Original request plus planning validation. |
| 2026-07-24 | Task 01 passed independent amended-head review, and the user explicitly requested parallel agent execution. | Dispatch Tasks 03 and 04 concurrently from one coordinator checkpoint in isolated sibling worktrees while Task 02 remains under independent review. | Assign the two disjoint implementation tracks and move them to `executing`; preserve Task 02's review gate before integration. | Project plan plus explicit user direction. |

# Handoff: Single-VM Personal Brand Runtime Consolidation

## Metadata
- Date: 2026-08-06
- Goal: Consolidate the ABPIV personal-brand n8n and Plausible runtimes onto one private Compute Engine VM with isolated Docker containers, then retire redundant n8n managed infrastructure only after a verified rollback-safe cutover.
- Status: in-progress
- Workspace: `C:\Users\allan\Documents\agent-git-projects\abpiv-personal-brand`
- Source of truth: this repository's canonical context and the active Project under `agents/context/projects/single-vm-runtime-consolidation/`

## Goal

Plan and later deliver a reversible cost-reduction migration from the current personal-brand runtime footprint to one right-sized private Compute Engine VM. The target host keeps n8n, n8n PostgreSQL, Plausible, Plausible PostgreSQL, ClickHouse, and Cloudflare Tunnel in separately owned Docker containers, networks, and persistent volumes. Public forms, webhook behavior, private n8n editor/MCP access, Cloudflare controls, recoverability, and same-origin `/_analytics/*` collection must remain intact.

This Project does not authorize implementation, production mutation, data movement, traffic cutover, workflow dispatch, resource destruction, or a production deployment. It also does not replace either application, combine their databases, introduce Kubernetes or multi-VM high availability, or purchase a committed-use discount before the consolidated workload is stable.

## Current State

- The Project is `ready` and awaiting explicit execution approval. No `TASK.md` exists; Task 01 must be planned just in time with `planning-tasks` only after that approval.
- `PROJECT.md` defines the outcome, non-goals, completion criteria, approval boundaries, cost target, worker/reviewer budgets, and Project ledger.
- `PLAN.md` defines nine Tasks in seven waves. Task 01 is read-only baseline and capacity evidence; Tasks 02-06 prepare repository changes; Task 07 is the separately approved cutover; Task 08 requires seven stable days plus separate destructive approval; Task 09 reconciles final repository state.
- The chosen architecture evolves the existing `plausible-analytics-vm` into one shared private host. Application boundaries remain explicit even though the VM is shared.
- At the time this record was written, the Project artifacts were uncommitted in the isolated worktree `C:\Users\allan\.codex\worktrees\cloud-cost\abpiv-personal-brand` on `codex/consolidate-n8n-compute-engine`, based on `origin/preview` commit `e002dbfa71c493528bd1e6be384e36b4005dce62`.
- At that same observation, `origin/main` was `2c7f46d43ac41bee6c7a4ca56ce957f1b9416d28`, `origin/preview` was `e002dbfa71c493528bd1e6be384e36b4005dce62`, and their trees were identical. `main` was one promotion merge commit ahead of `preview`.
- The current session has explicit user authorization to integrate this planning change into `main`, but the repository requires topic branch -> `preview` -> pull request from `preview` to `main`. A merge is not a production deployment.
- No live Google Cloud, Cloudflare, n8n, database, traffic, capacity, or billing state was mutated by planning. Task 01 owns fresh inventory, workload, recovery, utilization, and cost evidence.
- The primary `main` worktree contains an unrelated untracked file, `Codex Image Aug 4, 2026, 08_43_20 AM.gif`. It is outside this Project and must remain untouched.

## Decisions And Rationale

- Use one Compute Engine VM for maximum fixed-cost reduction while preserving separate container, network, volume, health, backup, and ownership boundaries for n8n and Plausible.
- Evolve `plausible-analytics-vm` in place instead of creating a second permanent VM. This avoids overlapping steady-state compute while retaining a stable infrastructure handle.
- Keep Cloudflare Tunnel as the private ingress boundary and preserve existing forms/editor/MCP/Access/WAF behavior. This avoids exposing new Google load-balancer or public-VM ingress cost and attack surface.
- Require Task 01 evidence before selecting the final machine type, disk size, RPO/RTO, downtime plan, or monthly savings claim. Those values are live-state decisions, not planning assumptions.
- Require seven consecutive stable days after cutover before legacy n8n resources can be considered for retirement. Task 08 also requires separate explicit destructive approval and a final restore check.
- Target at least 50% reduction in measured fixed Google Cloud run rate and no more than USD 60 per month before variable traffic. Do not claim the target until Task 08 produces observed or exact-SKU evidence.
- Keep Project execution serial where production state overlaps. Parallelism is limited to the repository-only, file-disjoint waves recorded in `PLAN.md`.

## Changes And Artifacts

- Topic branch: `codex/consolidate-n8n-compute-engine`
- Isolated worktree: `C:\Users\allan\.codex\worktrees\cloud-cost\abpiv-personal-brand`
- Exact planning base: `e002dbfa71c493528bd1e6be384e36b4005dce62` (`origin/preview` when planning began)
- Active Project route: `agents/context/projects/ROUTING.md`
- Project contract: `agents/context/projects/single-vm-runtime-consolidation/PROJECT.md`
- Task graph: `agents/context/projects/single-vm-runtime-consolidation/PLAN.md`
- Stable handoff pointer: `agents/context/projects/single-vm-runtime-consolidation/handoff/latest.md`
- This dated handoff: `agents/context/projects/single-vm-runtime-consolidation/handoff/2026-08-06-single-vm-runtime-consolidation-handoff.md`
- Empty future Task surface: `agents/context/projects/single-vm-runtime-consolidation/tasks/.gitkeep`
- Commit, push, pull-request, merge, release, deployment, and infrastructure-operation identities were not yet created when this record was written. Verify them live before resuming.

## Verification

Planning validation observed before this handoff was added:

- The externally supplied `agent-project-organization/scripts/test_validate_projects.py` was run with Python bytecode generation disabled: 50 tests, `OK`.
- The externally supplied `agent-project-organization/scripts/validate_projects.py` was run against the repository root with Python bytecode generation disabled: one active Project, three archives, zero warnings.
- The agent Workflow validator reported zero warnings.
- A local Markdown-link check over the three changed Markdown files reported zero missing targets.
- Trailing-whitespace and credential/machine-local-path safety scans reported zero findings.
- `git diff --check` passed; Git emitted only the existing LF-to-CRLF working-copy warning for `agents/context/projects/ROUTING.md`.

These checks must be rerun against the exact handoff-inclusive staged state before commit and against the final integrated state before claiming source integration. No application build, OpenTofu plan, container test, endpoint check, restore test, billing check, or production workflow was run because this change is planning-only.

## What Worked

- Treating the effort as an active Project made approval, destructive-action, stabilization, cost-evidence, and recovery boundaries explicit before implementation.
- Domain framing separated the physical shared host from application ownership and prevented "one VM" from becoming "one undifferentiated stack."
- The independent-rigorous Task policy and bounded parallel waves keep production writers serial while allowing safe repository-only preparation.

## What Did Not Work

None observed during planning.

## Remaining Work

1. Verify whether the current publishing session committed the exact Project artifacts, integrated the topic branch into `preview`, opened the required `preview` -> `main` pull request, merged it, and left production workflows undispatched. Reconcile any difference before doing anything else.
2. Obtain Allan's explicit Project execution approval. Do not infer it from approval to publish this plan.
3. After approval, invoke `planning-tasks` to create only Task 01's execution-ready `TASK.md`, using the live Project and Plan. Do not pre-create downstream Tasks.
4. Execute Task 01 as a read-only baseline and capacity investigation. Record exact live resource, cost, workload, data-size, recovery, and utilization evidence without exposing secrets.
5. Replan before implementation if Task 01 disproves single-host capacity, the savings threshold, the intended ownership boundaries, or the recovery/cutover assumptions.

## Open Decisions Or Blockers

- Project execution is not approved.
- Final VM type, disk sizing, headroom thresholds, maintenance window, RPO/RTO, and exact savings remain intentionally unset until Task 01 produces live evidence and Allan approves the consequential choices.
- Production data movement, VM stop/start or resize, Cloudflare cutover, workflow dispatch, and legacy-resource decommission each remain behind the Project's recorded approval and stop gates.

## Do Not Assume

- Do not assume the Git publication steps described above completed; verify topic, `preview`, `main`, pull requests, checks, and workflow runs live.
- Do not assume repository `main` reflects live Google Cloud or Cloudflare state.
- Do not assume current resource inventory, billing, utilization, database size, binary-data size, backup validity, or machine sizing from historical names or repository definitions.
- Do not read, print, persist, rotate, or stage secrets, credentials, private payloads, service-account keys, or ignored `.codex-local/` values.
- Do not weaken same-origin analytics, Cloudflare Access/WAF, private editor/MCP boundaries, backups, or rollback merely to hit a cost target.
- Do not equate a merge with deployment, a healthy endpoint with data integrity, or seven elapsed days with seven verified stable days.
- Preserve the unrelated GIF in the primary `main` worktree and all other user-owned changes.
- Do not clean up the isolated topic worktree until the Project artifacts are safely integrated and no review or continuation depends on it.

## Fresh-Session Continuation Prompt

```text
Continue the goal "Consolidate the ABPIV personal-brand n8n and Plausible runtimes onto one private Compute Engine VM with isolated Docker containers, then retire redundant n8n managed infrastructure only after a verified rollback-safe cutover" in C:\Users\allan\Documents\agent-git-projects\abpiv-personal-brand.

First, read C:\Users\allan\Documents\agent-git-projects\abpiv-personal-brand\agents\context\projects\single-vm-runtime-consolidation\handoff\2026-08-06-single-vm-runtime-consolidation-handoff.md completely. Then load AGENTS.md, agents/context/CONTEXT.md, agents/context/ROUTING.md, agents/context/GLOSSARY.md, agents/context/projects/ROUTING.md, the Project's PROJECT.md and PLAN.md, and the repository-map, verification, Git-policy, and access-routing references cited there. Treat the handoff as working context, not unquestionable truth: verify the current files, Git branches/worktrees/remotes, checks, approvals, live Google Cloud and Cloudflare state, and protected changes before acting.

Resume from the ordered Remaining Work section, beginning with verifying that the Project plan and handoff reached main through topic -> preview -> main and reconciling any publication difference. Do not execute, mutate production, move data, change edge routing, dispatch workflows, or decommission anything without the explicit approvals recorded by the Project. Once Allan explicitly approves Project execution, invoke planning-tasks just in time for Task 01; do not create downstream TASK.md files early. Preserve the unrelated "Codex Image Aug 4, 2026, 08_43_20 AM.gif" file in the primary main worktree and any other user changes, and stay within every scope, safety, review, and stop boundary recorded in the handoff. Do not redo completed work unless live evidence contradicts it. If state has changed, reconcile it, document the difference, and continue toward the goal.
```

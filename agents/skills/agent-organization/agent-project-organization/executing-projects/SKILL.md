---
name: executing-projects
description: Use when an approved Project and PLAN.md are ready to coordinate through just-in-time Task planning, sequential-by-default subagent execution, checkpoints, controlled replanning, reuse promotion, integrated review and verification, project-local handoff, cancellation, closure, and immutable archival.
---

# Executing Projects

Coordinate the active Project from its durable records. The coordinator alone writes `PROJECT.md`, `PLAN.md`, and `projects/ROUTING.md`; workers return evidence through their Task artifacts.

Read [capability-and-reasoning-classes.md](../references/capability-and-reasoning-classes.md) before accepting a Task selection, dispatch, review, or completion recommendation. Use the portable classes without naming a runtime or treating selection as authority.

## Review Before Execution

1. Read the entire `PROJECT.md`, `PLAN.md`, Project route, latest project-local handoff, applicable instructions, Git policy, and current repository state.
2. Compare the plan with live paths, interfaces, tests, dependencies, external targets, and approval state. Resolve contradictions before dispatch.
3. Run the Project validator. Record the Project base and current head or equivalent state.
4. Confirm the approval basis still covers execution. Do not treat a stale plan or conversational memory as authority.
5. Confirm planned Task size, isolation, verification strength, and implementer/reviewer selection assumptions still match live evidence. Return mismatches to `planning-tasks` or controlled replanning; never let a worker silently change its selection.
6. Leave the Project `ready` through this review. Do not pre-set execution state; `executing-tasks` owns the dispatch boundary and asks this coordinator to persist it only after the Task preflight passes.

## Coordinate Tasks

For each incomplete Task:

1. Confirm ledger dependencies and approval gates.
2. Use `planning-tasks` to create or refresh its just-in-time brief.
3. As coordinator, persist that Task as `ready`.
4. Use `executing-tasks` for the preflight, dispatch-boundary transition, one bounded implementer, and one fresh independent reviewer. When its preflight passes, it asks this coordinator to persist the Task, Project, and route as `executing` immediately before implementer dispatch.
5. After the implementer result passes inspection, persist `review` before dispatching the reviewer.
6. If review returns a Critical or Important finding, persist `revisions`; return every blocking fix to the same bounded implementer, require fresh covering verification, then return the amended result to an independent reviewer selected from current review risk.
7. Inspect the actual `TASK.md`, `REPORT.md`, `REVIEW.md`, artifacts, base-to-head diff, commands and full results, external records, scope, and unresolved findings. Reject conversation-only or report-only completion claims.
8. Persist `complete` only when direct acceptance evidence passes, the specification-compliance verdict is `COMPLIANT`, the task-quality verdict is `APPROVED`, and the review verdict is `READY`. Record its commit range, produced interfaces, deviations, and Minor findings.
9. Re-read affected downstream Task assumptions before planning the next brief.

Schedule sequentially by default. Use `dispatching-parallel-agents` only when Tasks have no dependency, file, mutable-state, approval, or side-effect overlap and genuine isolation such as separate worktrees exists. The coordinator keeps integration state outside every worker's ownership.

Create or refresh a project-local handoff on pauses, transfers, blockers, session boundaries, or context pressure. Store it under `<project>/handoff/` and update the Project route; never use the context-level handoff for Project work.

When a blocker prevents safe progress, persist affected Tasks as `blocked` and the Project as `blocked` in both its record and route. After the blocker is resolved, recheck the plan and approval basis. Persist each blocked Task as `planned` before `planning-tasks` refreshes it; only when its brief is unchanged may the coordinator revalidate its dependencies, scope, authority, and evidence and persist it directly as `ready`. Persist the Project and route as `ready`; `executing-tasks` requests the coordinated transition to `executing` only after its dispatch preflight passes.

For an access, authentication, approval, or external-target impediment, record the unavailable interface or target, the exact action and decision owner needed to unblock it, why it blocks the Task, billing/production/credential/data safety implications, and the precise resume point. Verify credential presence only through safe read-only checks and never persist secret values.

## Controlled Replanning

Harmless stale details may be corrected from evidence without changing intent. For a material change to scope, architecture, domain boundaries, dependencies, acceptance, or authority:

1. Stop affected dispatch and record the evidence and blocked dependencies.
2. Set the Project to `replanning` and affected Tasks to `blocked`.
3. Reapply proportional DDD and `grill-me`.
4. Add a dated decision amendment to `PROJECT.md`; revise `PLAN.md` and affected future briefs.
5. Mark every changed or invalidated Task `planned` and mark any existing brief stale and non-executable; preserve its prior content in Git history.
6. Obtain renewed approval only when scope or authority expands.
7. Revalidate, persist the Project and route as `ready`, and refresh the next Task through `planning-tasks`; let `executing-tasks` request the coordinated transition to `executing` only after its dispatch preflight passes.

Treat `BLOCKED: OVERSIZED` as a planning defect: replace the unit with smaller Project-owned Tasks. An implementer never subdivides or delegates it.

## Promote Reuse And Integrate

Review every Task's reuse assessment. A validated opportunity blocks closure until an explicit reviewed Task promotes it through `agent-organization` into the correct skill, Workflow, tool, MCP server, access profile, adapter, context/reference, or repository documentation. Do not duplicate ownership or hide a reusable rule only in Project history.

Keep context, Workflow, glossary, routing, and repository-documentation integration as explicit Tasks. Refresh the complete graph through controlled replanning when execution discovers one.

## Close Or Cancel

For completion:

1. Confirm every Task is `complete`, every blocking finding is resolved, and all reuse and documentation integration Tasks passed.
2. Inspect and consume the explicit final whole-Project review and integrated-verification Task's actual artifacts, diffs, commands, external records, independent verdicts, and fresh evidence against the Project completion criteria. Do not commission a duplicate closure review; reject evidence-free claims and return that Task to `revisions` if its evidence is stale or insufficient.
3. Record `closing`, final evidence, publication states, risks, and the final project-local handoff.
4. Set status to `archived-complete`, remove the active route, and move the intact Project to `projects/archive/<closure-date>-<project-slug>/`.

For cancellation, record the reason, unfinished obligations, disposition of partial work, and verification; set `archived-cancelled`, remove the active route, and archive intact. Never imply completion.

Run Project and affected Workflow validators after integration and archival. Never reopen or rewrite an archive; create a new Project referencing it.

## Stop Rules

Stop when control-state ownership conflicts, the plan is stale in a material way, dependencies or authority are unresolved, worker state overlaps, independent review is unavailable, blocking findings remain, required integration is missing, verification is inadequate, or the archive destination exists.

## Output

Report Project status, ledger transitions, Task selection and review-risk evidence, Task evidence and commit ranges, scheduling and isolation, deviations and amendments, reuse promotions, integrated review and verification, handoff path, archive state, Git/publication states, and blockers.

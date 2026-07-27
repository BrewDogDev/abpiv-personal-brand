# Project Plan Template

Use this template for `<project>/PLAN.md`. The Project coordinator is the sole writer of this control state.

```markdown
# <Project Name> Plan

## Planning Basis

- Goal: <observable outcome>
- Base state: <branch, commit, working state, and relevant current behavior>
- Approval basis: <original authorization or explicit approval>
- Execution: one bounded implementer and one independent reviewer per Task
- Control state: this file is the authoritative Task ledger
- Replanning: material changes return through DDD and grill-me

## Shared Constraints

- <Repository, safety, compatibility, ownership, and non-goal constraints>

## Task Ledger

| Task | Outcome | Dependencies | Status | Implementer | Review |
| --- | --- | --- | --- | --- | --- |
| 01 | <One independently reviewable outcome> | None | planned | unassigned | pending |

## Task Outcomes And Interfaces

### Task 01: <Outcome>

- Owns: <files, records, or state>
- Consumes: <existing or predecessor interface>
- Produces: <exact interface, behavior, or evidence>
- Required capabilities: <specialist skills>
- Acceptance: <direct test, check, or observation>
- Approval or stop gate: <gate or None>

## Integration And Reuse Obligations

- Canonical context, glossary, routing, Workflow, and repository docs: <planned Task ids>
- Validated reusable procedures or operational knowledge: <planned Task ids or assessment Task>
- Project-wide review and integrated verification: <planned Task ids>

## Checkpoints And Replanning

- Record completed Task commit ranges, review verdicts, deviations, and unresolved Minor findings in the ledger or corresponding Task section.
- Add dated amendments to `PROJECT.md` and revise this graph before dispatch when live evidence changes scope, architecture, domain boundaries, acceptance, or dependencies.

## Project Closure

- All ledger Tasks are `complete`.
- All independent reviews and blocking fixes pass.
- Integrated verification proves the Project completion criteria.
- Project-local handoff and routing reflect final state.
- The coordinator removes the active route and moves the intact Project to `archive/<closure-date>-<project-slug>/`.
```

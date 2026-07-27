# Task Brief Template

Use this template for `<project>/tasks/<task-id>_<task-slug>/TASK.md`. Resolve all fields just before dispatch.

```markdown
# Task <id>: <Outcome>

## Status

Ready

## Parent Project And Live Basis

- Project: <project-relative PROJECT.md path>
- Plan row: <Task id>
- Planned from: <branch, base, or state identity>
- Refreshed at: <date and current commit or state>
- Dependencies verified: <Task ids, reports, reviews, and produced interfaces>

## Outcome And Acceptance

- Outcome: <one observable result>
- Acceptance criteria:
  - <criterion with direct evidence>

## Owned Scope

- Create: <exact paths or None>
- Modify: <exact paths or state>
- Test: <exact paths or checks>

## Do Not Touch

- <excluded files, state, behavior, or decisions>
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: <verified predecessor or existing interface>
- Produces: <exact symbol, schema, behavior, artifact, or evidence>

## Skills, Tools, And Authority

- Required implementation skills: <skills>
- Required review and verification skills: <skills>
- Allowed tools and actions: <bounds>
- Approval-gated actions: <gates or None>
- Prohibited actions: <bounds>

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: <command or observation and expected result>
- Broader check: <command or observation and expected result>
- Diff or artifact review: <boundary>
- Required evidence: <logs, IDs, screenshots, commit range, or None>

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return

- Implementer report: `REPORT.md`
- Independent review: `REVIEW.md`
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`
```

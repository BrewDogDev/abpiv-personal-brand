# Task Brief Template

Use this template for `<project>/tasks/<task-id>_<task-slug>/TASK.md`. Resolve all fields just before dispatch. Select portable capability and reasoning classes with [capability-and-reasoning-classes.md](../../references/capability-and-reasoning-classes.md).

```markdown
# Task <id>: <Outcome>

## Status

Ready

## Parent Project And Live Basis

- Project: <project-relative PROJECT.md path>
- Plan row: <Task id>
- Planned from: <branch and exact base commit, or exact stable state identity>
- Refreshed at: <date and current commit or state>
- Dependencies verified: <Task ids, reports, reviews, and produced interfaces>

## Role, Outcome, And Acceptance

- Role: <one task-local implementer role>
- Outcome: <one observable result>
- Acceptance criteria:
  - <criterion with direct evidence>

## Relevant Context And Source Paths

- <task-local fact needed without the coordinator conversation>
- `<exact source path>`

## Owned Scope

- Create: <exact owned files or resources, or None>
- Modify: <exact owned files, mutable resources, or state>
- Test: <exact paths or checks>

## Do Not Touch

- <explicit exclusions: files, resources, state, behavior, or decisions>
- `PROJECT.md`, `PLAN.md`, and Project routing

## Interfaces

- Consumes: <verified predecessor or existing interface>
- Produces: <exact symbol, schema, behavior, artifact, or evidence>

## Skills, Tools, Authority, And Selection

- Required implementation skills: <skills>
- Required review and verification skills: <skills>
- Allowed tools and actions: <bounds>
- Approval-gated actions: <gates or None>
- Prohibited actions: <bounds>
- Implementer capability class: <deep | balanced | fast-repeatable | rapid-explorer>
- Implementer reasoning class: <low | medium | high | exceptional>
- Review depth: <quick | rigorous; quick is the default, rigorous requires a named risk trigger>
- Reviewer capability class: <deep | balanced | fast-repeatable | rapid-explorer>
- Reviewer reasoning class: <low | medium | high | exceptional>
- Isolation requirements: <one writer, worktree or resource boundary, and shared-state constraint>

## Implementation Contract

- One implementer session; do not delegate or subdivide.
- The brief contains sufficient task-local context; do not depend on the full coordinator conversation.
- Ask before guessing at a material ambiguity.
- Use test-driven development or the repository's equivalent evidence cycle when behavior changes.
- Implement only this Task, run focused and required checks, inspect scope, and commit exact owned files when Git policy requires it.
- Write `REPORT.md`; do not update Project control state.
- If the Task cannot fit this contract, return `BLOCKED: OVERSIZED`.

## Verification And Evidence

- Focused check: <command or observation and expected result>
- Broader check: <command or observation and expected result>
- Diff or artifact review: <boundary>
- Required evidence: <direct command results, logs, IDs, screenshots, commit range, or None>

## Ambiguity And Escalation

- <what the implementer may resolve from evidence>
- <what must return to the coordinator before work continues>

## Reuse Assessment

Determine whether the work reveals a verified reusable procedure, recurring outcome, capability contract, runtime rule, access boundary, harness mapping, or stable context. Record the candidate and evidence in `REPORT.md`; do not silently expand this Task to promote it.

## Return And Review

- Implementer report: `REPORT.md`
- Expected return artifact: <exact commit, changed resource, evidence package, or stable state>
- Independent review: `REVIEW.md`
- Review requirements: <for quick, the exact acceptance evidence and obvious risk/scope checks; for rigorous, the named risk surfaces and deeper checks; include specification, quality, readiness, finding evidence, and re-review gate>
- Allowed implementer statuses: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`, `BLOCKED: OVERSIZED`
```

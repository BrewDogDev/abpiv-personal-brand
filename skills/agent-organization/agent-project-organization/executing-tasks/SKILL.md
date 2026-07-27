---
name: executing-tasks
description: Use when one ready Project-owned TASK.md must be implemented by a bounded non-delegating subagent, inspected against actual artifacts and commits, independently reviewed by a fresh reviewer, fixed and re-reviewed until blocking findings clear, and returned as evidence to the Project coordinator.
---

# Executing Tasks

Run one ready Task without taking ownership of Project control state. Read [return-contracts.md](references/return-contracts.md) before dispatching the implementer or reviewer.

## Verify The Dispatch

1. Read the full `TASK.md`, binding Project constraints, relevant dependency reports and reviews, Git policy, and current repository state.
2. Confirm the Task is `ready` in `PLAN.md`, belongs to exactly one Project, dependencies and approvals still hold, owned state is exclusive, and the recorded base is current.
3. Record an exact task base commit or stable pre-task state.
4. Only after every preflight check passes, ask the Project coordinator to atomically persist the Task as `executing` in `PLAN.md` and the Project as `executing` in both `PROJECT.md` and Project routing. Re-read all three records and stop unless they agree. Do not edit control state here.

## Run The Implementer

Only after the dispatch-boundary transition is confirmed, dispatch one implementer with the Task path, workspace and branch, exact ownership and exclusions, allowed authority, required skills, acceptance checks, report path, and task base. Require it to:

- work in one session without further delegation;
- ask before guessing at a material ambiguity;
- implement only the Task and follow the named coding or operating skills;
- run focused and repository-required checks, inspect its diff, and commit exact owned files when required;
- write `REPORT.md` using the return contract.

Inspect the actual report, files, external records, commit range, diff, commands, and evidence. Do not accept a completion claim from the report alone.

Handle statuses as follows:

- `DONE`: proceed to review after inspection.
- `DONE_WITH_CONCERNS`: resolve correctness or scope concerns before review; carry non-blocking concerns into the review package.
- `NEEDS_CONTEXT`: supply only the missing evidence or decision and resume the same Task.
- `BLOCKED`: return the demonstrated impediment to the coordinator.
- `BLOCKED: OVERSIZED`: stop; the coordinator must replan into smaller Tasks.

## Run Independent Review

Prepare a stable package containing the same `TASK.md`, binding constraints, `REPORT.md`, exact base and head, actual diff or artifact paths, checks, risks, and exclusions. Dispatch a fresh reviewer independent of the implementer.

Use `requesting-code-review` to commission the evidence-based review and `receiving-code-review` to evaluate findings and govern fixes. These skills supply review technique; this skill retains the Task return contract and mandatory fresh-review gate.

The reviewer is read-only for implementation, branch, index, control state, and external systems; its only write is `REVIEW.md`. Require:

1. a specification-compliance verdict;
2. a task-quality verdict;
3. Critical, Important, and Minor findings with tight file, line, symbol, or artifact evidence;
4. a clear ready or needs-fixes conclusion.

Verify findings against live evidence. Return all Critical and Important findings to the same bounded implementer, require covering checks and an appended report, then re-review the amended base-to-head result while preserving reviewer independence. Do not mark blocking feedback resolved without evidence. Carry unresolved Minor findings to the Project coordinator.

## Return To The Coordinator

Run the focused Task checks again when fixes changed the result. Confirm scope, required artifacts, commit identities, and both review verdicts. Return evidence to `executing-projects`; only that coordinator may update the ledger or mark the Task complete.

## Stop Rules

Stop when the Task is not ready at preflight, the coordinator does not persist an agreeing Task/Project/route transition to `executing`, authority or state changed, ownership overlaps, the implementer delegates or broadens scope, actual artifacts cannot be inspected, the reviewer is not independent, a blocking finding remains, or required verification cannot prove acceptance.

## Output

Report implementer and reviewer identities, task base and head, status, files and external state changed, commands and results, report and review paths, findings and fixes, reuse candidates, residual Minor findings, and the readiness recommendation to the coordinator.

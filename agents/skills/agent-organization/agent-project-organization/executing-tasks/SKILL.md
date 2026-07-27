---
name: executing-tasks
description: Use when one ready Project-owned TASK.md must be implemented by a bounded non-delegating subagent, inspected against actual artifacts and commits, independently reviewed by a fresh reviewer, fixed and re-reviewed until blocking findings clear, and returned as evidence to the Project coordinator.
---

# Executing Tasks

Run one ready Task without taking ownership of Project control state. Read [return-contracts.md](references/return-contracts.md) and [capability-and-reasoning-classes.md](../references/capability-and-reasoning-classes.md) before dispatching the implementer or reviewer. Use the portable classes without naming a runtime or treating selection as authority.

## Verify The Dispatch

1. Read the full `TASK.md`, binding Project constraints, relevant dependency reports and reviews, Git policy, and current repository state.
2. Confirm the Task is `ready` in `PLAN.md`, belongs to exactly one Project, dependencies and approvals still hold, owned state is exclusive, and the recorded base is current.
3. Confirm the brief records implementer and reviewer capability/reasoning selections, `quick` or `rigorous` review depth, current rationale, and isolation. Recheck observable complexity, consequence, clarity, isolation, verification strength, and review risk; return any mismatch to the coordinator rather than changing a class or review depth silently.
4. Record an exact task base commit or stable pre-task state.
5. Only after every preflight check passes, ask the Project coordinator to atomically persist the Task as `executing` in `PLAN.md` and the Project as `executing` in both `PROJECT.md` and Project routing. Re-read all three records and stop unless they agree. Do not edit control state here.

## Run The Implementer

Only after the dispatch-boundary transition is confirmed, dispatch one implementer with the Task path, workspace and branch, exact ownership and exclusions, allowed authority, required skills, acceptance checks, report path, and task base. Require it to:

- work in one session without further delegation;
- ask before guessing at a material ambiguity;
- implement only the Task and follow the named coding or operating skills;
- preserve the brief's outcome, ownership, authority, side effects, and selected capability/reasoning classes; stop and report a mismatch instead of broadening or changing them;
- leave `PROJECT.md`, `PLAN.md`, and Project routing unchanged;
- run focused and repository-required checks, inspect its diff, and commit exact owned files when required;
- write `REPORT.md` using the return contract.

Inspect the actual report, files, external records, commit range, base-to-head diff, commands and full results, and direct acceptance evidence. Do not accept a completion claim from conversation or the report alone.

Handle statuses as follows:

- `DONE`: proceed to review after inspection.
- `DONE_WITH_CONCERNS`: resolve correctness or scope concerns before review; carry non-blocking concerns into the review package.
- `NEEDS_CONTEXT`: supply only the missing evidence or decision and resume the same Task.
- `BLOCKED`: return the demonstrated impediment to the coordinator.
- `BLOCKED: OVERSIZED`: stop; the coordinator must replan into smaller Tasks.

## Run Independent Review

Prepare a stable package containing the same `TASK.md`, binding constraints, `REPORT.md`, exact base and head, actual diff or artifact paths, checks, risks, exclusions, the shared `software-delivery/references/review-scope.md` contract from the external `software-delivery` dependency, and recorded review depth. Select reviewer capability and the lowest reliable reasoning class independently from current review risk, then dispatch a fresh reviewer independent of the implementer.

Use `requesting-code-review` to commission the evidence-based review and `receiving-code-review` to evaluate findings and govern fixes. These skills supply review technique; this skill retains the Task return contract and mandatory fresh-review gate.

For `quick` review, ask for an informed sanity check: inspect the acceptance criteria, actual change, focused evidence, obvious regressions, and scope. Stop when that bounded evidence gives reasonable confidence the result likely works. Do not ask the reviewer to reconstruct the implementation, exhaustively prove correctness, explore adjacent architecture, invent edge cases without a plausible failure path, or fill the record with stylistic and optional improvements.

For `rigorous` review, name the escalation trigger and ask the reviewer to trace the material business logic or control flow, challenge relevant edge cases and assumptions, inspect affected interfaces, and assess whether verification covers the named risk. Keep this review within Task scope; rigorous does not mean unlimited.

Exclude package ecosystem health unless the user or accepted Task requirements explicitly name a package concern. Do not ask the reviewer to run package audit, advisory, or freshness tooling or to report incidental package vulnerability, deprecation, licensing, provenance, supply-chain, or similar warnings.

The reviewer is read-only for implementation, branch, index, control state, and external systems; its only write is `REVIEW.md`. Require:

1. a specification-compliance verdict;
2. a task-quality verdict;
3. only concrete, actionable Critical, Important, or directly useful Minor findings, each with tight file, line, symbol, or artifact evidence;
4. a clear ready or needs-fixes conclusion.

An empty finding class is `None`, not an invitation to manufacture feedback. For a clean `quick` review, a short verdict plus the evidence checked is the correct result. Do not require a narrative replay of the Task, diff, report, or command transcript.

Verify findings against live evidence. Return all Critical and Important findings to the same bounded implementer, require fresh covering checks and an appended report, then re-review the amended base-to-head result with an independent reviewer selected from the amended review risk. Do not mark blocking feedback resolved without evidence. Carry unresolved Minor findings to the Project coordinator.

## Return To The Coordinator

Run the focused Task checks again when fixes changed the result. Confirm scope, required artifacts, commit identities, direct evidence, a `COMPLIANT` specification-compliance verdict, an `APPROVED` task-quality verdict, and a `READY` review verdict. Return evidence to `executing-projects`; only that coordinator may update the ledger or mark the Task complete.

## Stop Rules

Stop when the Task is not ready at preflight, the coordinator does not persist an agreeing Task/Project/route transition to `executing`, authority or state changed, ownership overlaps, the implementer delegates or broadens scope, actual artifacts cannot be inspected, the reviewer is not independent, a blocking finding remains, or required verification cannot prove acceptance.

## Output

Report implementer and reviewer identities and selections, review depth, task base and head, status, files and external state changed, commands and results, report and review paths, findings and fixes, reuse candidates, residual Minor findings, and the evidence-backed readiness recommendation to the coordinator.

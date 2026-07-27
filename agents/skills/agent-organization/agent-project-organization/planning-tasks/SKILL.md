---
name: planning-tasks
description: Use when the next planned Task in an active Project must be written or refreshed just in time as one execution-ready TASK.md from completed dependencies, current monorepo state, exact ownership, specialist skills, approval limits, interfaces, and verification evidence.
---

# Planning Tasks

Turn one `planned` Project-plan unit into a bounded, current execution contract. Invoke this as the Project coordinator; do not let a Task implementer define or approve its own scope.

Read [task-brief-template.md](references/task-brief-template.md) and [capability-and-reasoning-classes.md](../references/capability-and-reasoning-classes.md) before writing or refreshing `TASK.md`. Use the portable classes without naming a runtime or treating selection as authority.

## Readiness Workflow

1. Read the complete `PROJECT.md`, `PLAN.md`, Project route, applicable instructions, Git policy, latest project-local handoff, and every dependency report and review.
2. Inspect current repository and external state. Confirm dependencies are `complete`, interfaces exist as recorded, approval gates are satisfied, and no overlapping worker owns the same mutable state.
3. For external systems, resolve the canonical access profile, exact account/project/tenant/environment, approved interface, scopes, and side-effect gates. Verify access read-only without printing secret values; a missing or ambiguous target blocks readiness.
4. Reconcile harmless stale details such as paths or commit identities. Treat any existing brief for a `planned` Task as stale and non-executable until this workflow rewrites it. Return material changes to `executing-projects` for controlled replanning before editing the brief.
5. Define one observable outcome sized for one implementer session. The separate reviewer session does not count against that size limit. Return oversized work to `executing-projects` for decomposition before selecting a worker.
6. Inspect work type, requirement and interface clarity, consequence, complexity, isolation, verification strength, and review risk. Select the implementer capability and lowest reliable reasoning class from implementation evidence. Default review depth to `quick`; select `rigorous` only when the brief names an observable escalation trigger from the capability reference. Select reviewer capability and reasoning independently from that scoped review risk.
7. Bind exact owned files or state, exclusions, consumed and produced interfaces, implementation skills, review and verification skills, review depth, selected classes and rationale, allowed tools, authority, approval gates, checks, and expected evidence.
8. Make the ready brief self-contained: include every task-local requirement, decision, interface, path, authority basis, stop rule, and verification expectation the implementer or reviewer needs without access to the coordinator conversation.
9. Use inspected paths, symbols, commands, and observable results. Do not leave `TODO`, `TBD`, unresolved placeholders, vague cleanup, generic test instructions, or invented line numbers in a ready brief.
10. Require a non-delegating implementer, focused verification, exact diff and commit evidence when Git applies, self-review, and a reuse assessment.
11. Write or refresh only `<project>/tasks/<task-id>_<task-slug>/TASK.md`. The coordinator then marks the Task `ready` in `PLAN.md`.

Skill and class selection in the brief is binding. An implementer may invoke an additional procedural skill required by live evidence only when it does not broaden outcome, ownership, authority, or side effects and must record the reason. If live evidence no longer supports the selected capability or reasoning class, the implementer stops and returns the mismatch to the coordinator rather than changing selection silently.

## Readiness Gate

Do not mark the Task ready unless:

- it belongs to exactly one Project and one ledger row;
- every dependency and interface is verified from current evidence;
- scope fits one implementer session without delegation;
- owned state and exclusions prevent overlap;
- acceptance criteria are observable and mapped to exact checks;
- selection rationale cites current complexity, risk, clarity, isolation, verification strength, and review risk, with `quick` review by default and the lowest reliable reviewer class;
- any `rigorous` review names the concrete security, consequence, business-logic, integration, verification, or user-required trigger that justifies escalation;
- authority, approval, destructive, production, billing, identity, data, and publication boundaries are explicit;
- every required external target and access profile is verified without exposing credentials;
- the brief is executable without the complete coordinator conversation;
- the implementer and reviewer return paths are known.

If the Task is oversized, leave it non-ready and return `BLOCKED: OVERSIZED` to the coordinator for decomposition. Do not split or dispatch it from this skill.

Run the Project validator after the coordinator records readiness.

## Output

Report the Task path, live basis, dependency evidence, outcome and scope, review depth plus implementer and reviewer selection with rationale, bound skills, authority and gates, verification plan, self-contained-context check, reuse-assessment requirement, readiness decision, and validator result.

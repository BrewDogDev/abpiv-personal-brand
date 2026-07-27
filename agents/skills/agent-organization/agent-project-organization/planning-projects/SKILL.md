---
name: planning-projects
description: Use when monorepo work requires multiple bounded subagent Tasks or multiple AI sessions and must be classified, scaffolded, framed with proportional Domain-Driven Design, challenged with grill-me, decomposed into a complete dependency graph, approved, and made ready for coordinated execution.
---

# Planning Projects

Create one durable, decision-ready Project under its owning `agents/context/projects/`. Plan the complete Task graph now; leave each detailed Task brief for just-in-time `planning-tasks`.

Read [project-template.md](references/project-template.md), [project-plan-template.md](references/project-plan-template.md), and [capability-and-reasoning-classes.md](../references/capability-and-reasoning-classes.md) before creating the Project contracts. Use the portable classes without naming a runtime or treating selection as authority.

## Establish The Project

1. Confirm the work needs multiple bounded Tasks or multiple sessions. Route smaller work directly to its specialist.
2. Resolve the one owning `agents/context/`, closest instructions, glossary, routing, Project contract, Git policy, live repository state, prior decisions, and relevant handoff.
3. Choose a unique lowercase kebab-case slug. Scaffold:

   ```text
   agents/context/projects/<project-slug>/
     PROJECT.md
     PLAN.md
     tasks/
     handoff/
   ```

4. Register the active Project exactly once in `projects/ROUTING.md` with status `discovery`. Do not create `handoff/latest.md` until a dated project-local handoff exists.

## Discover And Grill

Apply `domain-driven-consulting` proportionally to every Project. Record the decision, domain area, business outcome, important language and overloaded terms, affected bounded contexts or ownership boundaries, key behaviors/events/policies/integrations, experts or decision owners, and evidence that could change the model. Expand into EventStorming, context mapping, or tactical design only when the domain complexity warrants it.

Then use `grill-me` against live evidence. Resolve outcome, non-goals, terminology, ownership, interfaces, risks, rollout or recovery, approval boundaries, acceptance criteria, and verification. Ask one focused question at a time only for material unresolved decisions. Stop grilling when the safe plan is settled.

Persist each Project transition in both `PROJECT.md` and `projects/ROUTING.md`: scaffold as `discovery`, move to `planning` before writing the Task graph, and move to `ready` only after the graph, approval basis, self-review, and validation pass. Never leave the route and Project record at different statuses.

## Build The Complete Task Graph

1. Trace every requirement to a Task or explicit non-goal.
2. Size each Task for one non-delegating implementer session and one independent reviewer. Split oversized work before selecting capability or reasoning; never use a stronger class to compensate for an oversized unit.
3. Define each Task's outcome, dependencies, owned state, produced and consumed interfaces, acceptance evidence, approval gates, specialist skills, and authority.
4. Record the observable work type, requirement and interface clarity, consequence, complexity, isolation, verification strength, and review risk that `planning-tasks` must refresh before dispatch. Choose the lowest reliable reasoning class, and select implementer and reviewer classes independently from implementation evidence and review risk.
5. Keep dependent Tasks sequential. Mark parallel eligibility only when dependencies, files, mutable state, approval gates, and side effects are demonstrably independent.
6. Include explicit reviewed Tasks for:
   - durable context, Workflow, glossary, routing, and repository-documentation integration;
   - every validated reuse opportunity, promoted through the correct skill, Workflow, tool, MCP, access, adapter, context, or documentation owner;
   - one final whole-Project review and integrated-verification Task whose evidence is consumed at closure.
7. Record all Tasks as `planned` in `PLAN.md`. Task folders may be scaffolded, but no `TASK.md` is execution-ready until `planning-tasks` refreshes it from live state.

## Set The Approval Basis

Record whether the original request already authorizes the resolved Project. Proceed without another approval round only when it clearly authorizes full implementation and the grill leaves no material unresolved decision. Otherwise obtain explicit approval before execution. Any later scope or authority expansion requires renewed approval.

Self-review paths, dependency order, interfaces, acceptance evidence, Task size and selection basis, integration obligations, and closure gates. Run the Project validator while `planning`; after it passes, persist `ready` in the Project and route, rerun the validator, and hand the ready Project to `executing-projects`. Do not dispatch Tasks from this skill.

## Stop Rules

Stop if the context root or Project owner is ambiguous, the work does not meet the Project threshold, material domain or acceptance decisions remain open, a Task is oversized, the graph hides shared state, approval is missing, or validation fails.

## Output

Report the Project path and route, DDD frame, grill decisions, complete Task graph, Task-sizing and selection evidence, parallel exceptions, approval basis, integration and reuse Tasks, validation evidence, and first planned Task.

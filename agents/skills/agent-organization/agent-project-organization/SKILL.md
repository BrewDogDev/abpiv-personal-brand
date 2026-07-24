---
name: agent-project-organization
description: Use as the default classifier for nontrivial planned work in a monorepo and when creating, planning, coordinating, resuming, reviewing, closing, cancelling, or archiving a multi-task or multi-session Project and its Project-owned Tasks under agents/context/projects/.
---

# Agent Project Organization

Own the universal Project and Task lifecycle for a monorepo. A Project is active planned work that needs multiple bounded subagent Tasks or multiple AI sessions. A Task is one Project-owned implementation unit sized for one implementer session plus independent review.

Read `agents/context/projects/CONTEXT.md` and `ROUTING.md` before acting. Use the validator already bundled with this family after changing Project records:

```bash
python agents/skills/agent-organization/agent-project-organization/scripts/validate_projects.py .
```

## Classify The Work

| Evidence | Route |
| --- | --- |
| One bounded session and no durable coordination need | Use the owning specialist directly; do not create a canonical Project or Task. |
| Multiple bounded Tasks or multiple AI sessions | Use `planning-projects`. |
| One Task in an existing Project needs an execution-ready brief | Use `planning-tasks`. |
| An approved Project needs coordination, replanning, closure, or archival | Use `executing-projects`. |
| One ready Task needs implementation and independent review | Use `executing-tasks`. |
| A recurring outcome needs a stable operating contract | Use `agent-workflow-organization`; create a Project only when the work to create or change that Workflow is itself project-sized. |

If only the legacy `agent-context/` root exists, route its authorized migration through `agent-context-organization` before creating a Project. Never create both context roots.

## Invariants

- Every Project belongs to exactly one `agents/context/`; every canonical Task belongs to exactly one Project.
- `PROJECT.md`, `PLAN.md`, and `projects/ROUTING.md` are coordinator-owned control state. `PLAN.md` is the sole Task ledger.
- Task implementers cannot delegate, alter control state, or silently broaden authority.
- Every Task receives fresh independent review; Project completion also requires integrated review and verification.
- Project handoffs stay in `<project>/handoff/`. Context-level handoffs are for non-project work.
- Validated reuse opportunities and durable context, Workflow, and repository-documentation integration are explicit reviewed Tasks.
- Archived Projects are immutable. Follow-up work creates a new active Project that references the archive.
- Skills, Workflows, tools, MCP servers, access profiles, adapters, context, and repository docs retain their canonical owners. Route promotion through `agent-organization`.

## Shared Stop Rules

Stop rather than infer when context ownership is unclear, a Task could belong to multiple Projects, authority or scope would expand, mutable ownership overlaps, an implementer would need to delegate, independent review is unavailable, a blocking finding remains, required validation cannot run, or archival would overwrite history.

## Output

Report the classification, owning context and Project when applicable, selected child skill, control-state path, authority basis, next gate, validation state, and blockers.

## Provenance

This family incorporates harness-neutral planning, checkpoint, plan-deviation, delegated implementation, and independent-review patterns adapted from the former ABPIV `writing-plans`, `executing-plans`, and `subagent-driven-development` skills, which were based on [`obra/superpowers`](https://github.com/obra/superpowers/tree/d884ae04edebef577e82ff7c4e143debd0bbec99/skills), copyright 2025 Jesse Vincent. See the [upstream MIT license](../references/upstream-license.md).

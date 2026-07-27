# Project Contract Template

Use this template for `<project>/PROJECT.md`. Resolve every field from evidence or an explicit decision.

```markdown
# <Project Name>

## Status

- Status: discovery
- Owning context: `agents/context/`
- Branch or working state: <branch, worktree, or non-Git state>
- Base: <commit or observed starting identity>
- Authorization: <original request or approval record>

## Outcome

<One observable Project outcome.>

## Non-Goals

- <Explicit exclusion>

## Domain-Driven Frame

### Decision

<Decision this Project must improve.>

### Domain Area And Outcome

- Domain area: <business or operational domain>
- Economic, user, or risk driver: <driver>
- Experts or decision owners: <owners>

### Ubiquitous Language

| Term | Meaning here | Other meaning or avoided alias |
| --- | --- | --- |
| <term> | <contextual meaning> | <difference or None> |

### Bounded Contexts And Ownership

| Context or owner | Responsibility | Owned data or decisions | Dependencies |
| --- | --- | --- | --- |
| <context> | <responsibility> | <ownership> | <relationship> |

### Behaviors, Events, Policies, And Integrations

- <Important behavior, past-tense event, policy, consistency rule, or integration>

### Validation

- Evidence that could change this frame: <evidence>
- Next expert or artifact validation: <validation>

## Targets And Interfaces

- Affected repositories, services, or systems: <targets>
- Existing interfaces to preserve: <interfaces>

## Approval And Safety Boundaries

- Authorized actions: <authority>
- Approval-gated actions: <gates>
- Prohibited or out-of-scope actions: <boundaries>

## Completion Criteria

- <Project-level acceptance criterion and direct evidence>
- All Tasks and independent reviews pass.
- Durable results and validated reuse opportunities are integrated into their canonical owners.
- Integrated review, verification, routing removal, and archival pass.

## Decisions And Amendments

| Date | Evidence or trigger | Decision | Plan impact | Approval basis |
| --- | --- | --- | --- | --- |
| <YYYY-MM-DD> | Initial planning | <decision> | <impact> | <basis> |
```

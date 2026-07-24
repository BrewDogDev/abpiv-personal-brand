---
name: agent-workflow-organization
description: Use when designing, auditing, creating, updating, decomposing, validating, or retiring harness-agnostic workflow and stage contracts, including repeatable outcome boundaries, ordered or branching stages, capability dependencies, inputs and outputs, review and approval gates, verify gates, stop rules, run expectations, and automation bindings.
---

# Agent Workflow Organization

Own repeatable outcome contracts as a first-class coordination layer. Make each workflow explicit about what it produces, which stages and canonical capabilities it composes, which gates constrain side effects, and how one run is verified without turning the workflow into a skill, tool, automation, or run log.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain sequencing, and handoff triggers. Return through that router before changing context routing, skills, tools, MCP servers, access profiles, or adapters.

## Ownership

Own:

- workflow boundaries, declared outcomes, start and terminal conditions;
- ordered stages, explicit branches, transitions, and stage responsibilities;
- declared capability dependencies on skills, tools, MCP servers, access profiles, and stable references;
- workflow and stage inputs, outputs, side effects, review or approval gates, verify gates, and stop rules;
- run-retention expectations and portable automation-binding requirements;
- workflow templates, structural validation, safe retirement, and contract history.

Do not own active Project or Task state, semantic context, glossary terms, user-intent routing, stable reference content, reusable procedural skills, executable tool behavior, MCP runtime setup, external target selection, harness schedules, or live run artifacts. Link to those canonical owners.

## Concept Boundaries

Keep these terms distinct:

| Concept | Responsibility |
| --- | --- |
| Project | One context-owned body of active planned work requiring multiple bounded Tasks or multiple AI sessions; coordinated by `agent-project-organization`. |
| Task | One Project-owned, independently reviewed implementation unit; never a standalone workflow stage or run record. |
| Skill | Portable knowledge about how to perform a kind of work. |
| Workflow | Repeatable outcome contract that composes bounded stages and canonical capabilities in a workspace or domain. |
| Stage | One bounded transformation or decision inside exactly one workflow. |
| Tool | One executable capability a stage may invoke. |
| Access profile | The authorized external target and permission boundary a stage may use. |
| Automation | Harness-owned trigger, schedule, and workspace binding that points to a workflow. |
| Loop | Control policy that decides whether, when, or how workflow runs repeat or adapt. |
| Run | One execution instance and its Layer 4 evidence. |

Do not create a workflow for a one-off checklist or for procedure that should be a reusable skill. A workflow is justified when the outcome recurs, coordination or gates matter, and its execution state benefits from an inspectable contract.

A Project may create or change a Workflow when that delivery work is project-sized, and a Project Task may invoke an existing Workflow when its recurring outcome is required. Keep the Project's temporary plan, ledger, reports, reviews, and handoffs under `agents/context/projects/`; keep the reusable outcome contract here. Project closure promotes the settled Workflow through an explicit reviewed integration Task.

## Definition Of Ready

Resolve from existing context before drafting:

1. What recurring outcome and explicit non-goals define the workflow boundary?
2. Which user intent should route here, and which context specialist owns that route?
3. What starts and terminates a run?
4. Which stages, transitions, inputs, outputs, and side effects are required?
5. Which canonical skills, tools, MCP servers, access profiles, and references does each stage depend on?
6. Where are human review, serious approval, verification, and stop gates required?
7. Which artifacts are current outputs, retained run history, or stable references?
8. Which automation or loop may trigger the workflow without owning its behavior?

Use `grill-me` only when these choices remain materially unresolved after inspecting documented answers. Structural retirement, contract-breaking changes, and ambiguous ownership require explicit approval.

## Canonical Shape

Keep workflow contracts within the portable context surface unless the workspace documents another canonical location:

```text
agents/context/
  ROUTING.md
  workflows/
    <workflow-name>/
      CONTEXT.md
      references/
      stages/
        01_<stage-name>/
          CONTEXT.md
          references/
          output/
```

Context owns `ROUTING.md`, glossary terms, stable reference contents, and Layer 4 artifacts. Workflow organization owns the Layer 2 contracts under `workflows/`. Physical co-location does not collapse those ownership boundaries.

## Workflow Contract

Keep each workflow `CONTEXT.md` concise and include:

- `Boundary`: recurring outcome, start condition, terminal condition, and non-goals;
- `Stages`: canonical order and explicit next-stage or branch behavior;
- `Capability Dependencies`: canonical owners composed by the workflow;
- `Review Points`: every gate before consequential judgment or side effect;
- `Shared References`: stable inputs declared by path;
- `Run And Retention`: current outputs versus retained history when retention matters;
- `Stop Rules`: ambiguity, unavailable capabilities, unsafe targets, failed gates, and missing evidence.

Use `agents/templates/WORKFLOW.md` when the workspace provides it. Simple linear workflows may use table order as the transition contract. Branching or retrying workflows must declare transitions explicitly rather than relying on prose inference.

## Stage Contract

Give each stage exactly one bounded job. Include:

- purpose;
- Layer 3 and Layer 4 inputs;
- required capabilities and their canonical paths;
- a short orchestration process that does not duplicate a skill or tool body;
- declared outputs and destinations;
- observable side effects;
- human review or approval gate;
- verify gate;
- next stage or branch rule when it is not implied by linear order;
- stop rules.

Use `agents/templates/STAGE.md` when available. Route detailed reusable procedure into a skill, executable semantics into a tool, server setup into MCP ownership, and target or scope selection into access ownership.

## Workflow Lifecycle

1. Inspect context, glossary, routes, existing workflows, capabilities, automation bindings, outputs, run history, learning, handoff, and Git state.
2. Classify the request as create, audit, maintain, decompose, validate, or retire. Route project-sized delivery through `agent-project-organization` while retaining Workflow ownership here.
3. Define concrete success and pressure scenarios before editing.
4. Draft or patch the smallest coherent workflow and stage contracts while preserving output and run history.
5. Return through `agent-organization` for context routing or sibling-domain changes; do not silently edit their owners.
6. Validate structure, routes, stages, dependency paths, gates, side effects, automation pointers, and artifact boundaries.
7. Record durable learning and continuity according to the shared lifecycle.

## Deterministic Validation

When the canonical shape is present, run:

```powershell
python agents/skills/agent-organization/agent-workflow-organization/scripts/validate_workflows.py <workspace-root>
```

The script checks routing targets, start stages, declared stage membership, required contract headings, stable reference paths, and duplicate or undeclared stages. It does not replace semantic review of capability fit, approval sufficiency, side effects, or human judgment.

## Validation

Verify that:

- every routed intent resolves to an existing workflow and start stage;
- every workflow has a bounded recurring outcome and at least one reachable terminal path;
- declared stages and stage directories agree, with explicit branches where linear order is insufficient;
- dependency paths resolve to the correct canonical owners without copied instruction bodies;
- every side effect has an appropriate approval gate and observable verify gate;
- inputs and outputs distinguish stable context from run-specific artifacts;
- automations point to workflow contracts instead of embedding their logic;
- loops govern repetition without duplicating workflow behavior;
- retirement preserves history and updates routes, automations, and consumers only with approval;
- no secret, private payload, machine-local binding, or run-specific evidence entered a stable contract.

## Approval And Stop Rules

Require approval before moving, renaming, deleting, retiring, or breaking a workflow or stage contract; changing a consequential approval gate; expanding permissions; or publishing an automation or adapter change. Stop if the outcome boundary, route owner, stage transitions, canonical dependency, side-effect authority, or preservation requirement remains ambiguous.

## Output

Report the workflow boundary, lifecycle mode, stages and transitions, capability dependencies, gates, artifacts and retention, route or automation work returned through `agent-organization`, deterministic and semantic validation evidence, approvals, Git state, learning action, and handoff location.

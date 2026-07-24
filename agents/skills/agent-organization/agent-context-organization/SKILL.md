---
name: agent-context-organization
description: Use when designing, auditing, creating, updating, or migrating harness-agnostic agent context, including semantic context, glossaries, user-intent routing, Project placement, workflow selection, stable references, scoped learning logs, working artifacts, run history, and handoffs.
---

# Agent Context Organization

Organize workspace- and domain-specific meaning as inspectable files. Make future agent runs know what context to load, what terms mean, which workflow and stage applies, which artifacts are stable or run-specific, what to verify, and how to resume safely.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain boundaries, and handoff triggers. Return through that router before changing another domain.

## Ownership

Own:

- `CONTEXT.md` semantic context and scope;
- `GLOSSARY.md` canonical terms and avoided aliases;
- `ROUTING.md` user-intent to workflow or domain selection;
- stable references at workspace, workflow, and stage scope;
- the `projects/` Layer 4 placement, active-Project registry, archive boundary, and Project/context handoff locality;
- other Layer 4 working artifacts, run history, scoped learning logs, and continuity handoffs;
- context templates, links, preservation, and layer-boundary validation.

Do not own Project planning, Task planning, execution coordination, Project control-state updates, workflow or stage contracts, reusable procedural skills, executable tool contracts, MCP runtime setup, external access profiles, harness mappings, or workspace-wide Git policy. Route Project lifecycle work to `agent-project-organization`, route workflow contract work to `agent-workflow-organization`, and link to other canonical owners.

## Definition Of Ready

Inspect existing files before asking. Resolve only the decisions needed for the requested change:

1. Which workspace, domain, active Project, or recurring workflow does this context serve?
2. What terminology is canonical, and where is it already defined?
3. Which user intents require routing, and which nontrivial planned work must first be classified by `agent-project-organization`?
4. Which existing workflow and start stage should each recurring intent select, and does workflow contract work need the workflow specialist?
5. Which rules are stable references, and at what narrowest durable scope?
6. Which artifacts vary by run and whether history must be retained?
7. Which learning and handoff scopes are required now?
8. Which existing entrypoints point into this context?

Use `grill-me` only for unresolved greenfield design, migration, structural reorganization, ambiguous ownership, or breaking changes. Ask one focused question at a time with a recommended answer. Record resolved terminology in `GLOSSARY.md`, not in a glossary-only `CONTEXT.md`.

If the user authorizes partial progress before all required decisions are clear, create only the safe parts and record unresolved items in the current handoff.

## Layer Model

Use five layers:

| Layer | Practical name | Purpose |
| --- | --- | --- |
| 0 | Harness entrypoint | Thin file, prompt, manifest, or instruction surface that points to canonical context. |
| 1 | Context map and routing | Select the relevant workflow, stage, or domain. |
| 2 | Workflow and stage contract | Owned by `agent-workflow-organization`; define stages, dependencies, outputs, gates, and stop rules. |
| 3 | Stable context | Semantic context, glossary, policies, schemas, examples, preferences, and other durable references. |
| 4 | Working context | Active Projects, Project Tasks, run inputs, drafts, outputs, logs, scoped learning, history, and handoffs. |

Keep Layer 3 and Layer 4 separate. Never promote a run-specific draft or uncertain learning into stable context merely to make it discoverable.

## Canonical Folder Shape

Use `agents/context/` as the portable source of truth:

```text
agents/context/
  CONTEXT.md
  GLOSSARY.md
  ROUTING.md
  references/
  learnings/
    workspace/
      LEARNINGS.md
      ERRORS.md
      FEATURE_REQUESTS.md
    skills/
    contexts/
    workflows/
    tools/
    mcp-servers/
    access/
    adapters/
  workflows/
    <workflow-name>/
      CONTEXT.md
      references/
      stages/
        01_<stage-name>/
          CONTEXT.md
          references/
          output/
  projects/
    CONTEXT.md
    ROUTING.md
    archive/
  working/
  runs/
  handoff/
    latest.md
    YYYY-MM-DD-<goal-slug>-handoff.md
```

`projects/CONTEXT.md`, `projects/ROUTING.md`, and `projects/archive/` are required scaffolding even when no Project is active. Create other surfaces only when useful. `GLOSSARY.md` is required when canonical terminology exists. Root `ROUTING.md` is required when more than one workflow or domain can be selected. Create narrow learning scopes lazily when the first relevant learning appears.

## Context And Glossary Contracts

Use `CONTEXT.md` for purpose, scope, operating meaning, layer rules, constraints, and navigation. Do not reduce it to a term list or turn it into a run log.

Use `GLOSSARY.md` for canonical language:

```markdown
# Glossary

**Canonical Term**:
Concise domain meaning.
_Avoid_: ambiguous alias, overloaded term
```

When resolving terminology, inspect the current glossary and code or artifacts first. Record the term as soon as it is settled and validate affected context, workflows, schemas, and references.

## Reference Scope

Place stable references at the narrowest durable scope:

| Scope | Location |
| --- | --- |
| Workspace | `agents/context/references/` |
| Workflow | `agents/context/workflows/<workflow>/references/` |
| Stage | `agents/context/workflows/<workflow>/stages/<stage>/references/` |

Promote a reference to a wider scope only when multiple consumers need the same stable rule. Keep narrow rules out of globally loaded context.

## Routing Contract

Route multiple workflows explicitly without copying their stage contracts:

```markdown
# Routing

## Workflows
| User intent | Workflow | Start stage | Notes |
| --- | --- | --- | --- |
| Create a recurring brief | workflows/recurring-brief | 01_ingest | Load shared references first. |

## Default Rule
If no workflow clearly applies, stop and ask which workflow to use.
```

A route selects an existing workflow and start stage. Creating, decomposing, or changing the selected workflow belongs to `agent-workflow-organization`; return through the parent router before changing that domain.

Root context routing selects stable domains and recurring Workflows. Active Project discovery belongs in `projects/ROUTING.md`; do not copy its Task ledger into root routing. Route nontrivial planned work through `agent-project-organization` before deciding whether it needs a Project.

## Working Artifacts And Run History

Use stage `output/` as the current handoff surface. Use `working/` for cross-stage or exploratory run material. Use `runs/` only when auditability, reproducibility, comparison, or recurring production use justifies retained history.

- Use `projects/<project-slug>/` for active multi-task or multi-session delivery state, never as stable context or a substitute for a recurring Workflow.
- Promote durable results to their canonical owners through explicit reviewed Project Tasks before moving a completed or cancelled Project intact to `projects/archive/`.
- Stable rules never belong in `runs/`.
- Run-specific drafts never belong in `references/`.
- Handoffs and raw learning are Layer 4 artifacts, not stable policy.
- Preserve existing outputs and run history unless deletion is explicitly approved.

## Scoped Learning Integration

Use `self-improving-skill` to capture corrections, failures, missing capabilities, and better reusable patterns under `agents/context/learnings/`:

- `workspace/` for cross-domain learning;
- `skills/<skill-name>/` for one skill or family;
- `contexts/<context-name>/` for one semantic context;
- `workflows/<workflow-name>/` for one workflow and its stages;
- `tools/<tool-name>/`, `mcp-servers/<server-name>/`, `access/<profile-name>/`, or `adapters/<adapter-name>/` for the owning asset.

Keep uncertain or one-off learning at the narrowest Layer 4 scope. Promote only explicit, verified, reusable learning into the correct canonical owner and validate neighboring assets after promotion. Preserve legacy learning history during migration; moves or deletions require approval.

## Handoff Integration

Use `handoff` after nontrivial context creation, routing changes, migration, or multi-asset maintenance and whenever work pauses, transfers, reaches a session boundary, becomes blocked, or leaves an unfinished milestone.

For work inside an active Project, store the dated record and `latest.md` under that Project's `handoff/` and update its row in `projects/ROUTING.md`; never use the context-level pointer for Project continuity. For non-Project work, store the dated record at `agents/context/handoff/YYYY-MM-DD-<goal-slug>-handoff.md` and keep `agents/context/handoff/latest.md` as a short pointer. Include a fully resolved fresh-session continuation prompt and return that exact prompt in chat.

Do not create a generic root `HANDOFF.md` unless an active workflow separately declares it as an output. Preserve prior dated handoffs.

## Updating Existing Context

1. Read the existing tree, routing, glossary, workflow inventory, references, working artifacts, learning history, run history, and handoff first.
2. Identify missing, stale, duplicated, overly broad, hidden, or layer-mixed context.
3. Preserve human-authored material and existing history unless it conflicts with an approved decision.
4. Patch contracts in place and add only justified files or directories.
5. Require approval before moves, renames, deletions, or breaking routing contracts; return stage-contract changes through `agent-organization` to the workflow specialist.
6. Validate every changed and neighboring path before handoff.

## Harness Entrypoints

Update a harness entrypoint only when one exists or the user asks to create it. Keep the pointer thin and route harness-specific work through adapter ownership. Never copy the complete context model into an entrypoint.

## Validation

Verify that:

- semantic context, glossary, routing, references, working artifacts, learning logs, and handoffs occupy the correct layer;
- every routed intent resolves to an existing workflow and start stage;
- workflow and stage contract validation is routed to `agent-workflow-organization`;
- references live at the narrowest durable scope;
- raw learning is scoped and promotions point to the correct canonical owner;
- current and historical run artifacts remain preserved;
- active Project placement, registry, handoff locality, and archive exclusion pass the Project validator;
- Project-local and context-level handoff paths and `latest.md` pointers resolve without crossing scopes;
- no secret, credential, private payload, or machine-local value entered tracked context;
- harness entrypoints point to canonical context rather than duplicating it.

## Stop Rules

Stop rather than guess when the canonical context source is ambiguous, unrelated changes overlap the requested edit, a secret could be persisted, a structural or breaking change lacks approval, routing or workflow ownership is unresolved, a required context review cannot be satisfied, or a move would lose history.

## Output

Report the context boundary, files created or updated, layer and scope decisions, terminology recorded, routing changes, workflow work returned through `agent-organization`, learning and handoff action, preservation evidence, validation performed, and Git state.

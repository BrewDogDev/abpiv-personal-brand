---
name: agent-organization
description: Use when bootstrapping, auditing, maintaining, or migrating a harness-agnostic agent infrastructure workspace, especially when work crosses Projects, skills, context, workflows, tools, MCP servers, access profiles, adapters, root instructions, Git governance, or lifecycle boundaries.
---

# Agent Organization

Organize an agent infrastructure workspace without making a repository, model, or harness the center of the design. Own the workspace entrypoint, top-level structure, Git governance, cross-domain classification, specialist sequencing, and multi-domain verification.

Do not duplicate specialist procedures. Route domain work to the owning child skill and require a specialist to return here before changing another domain.

## Operating Modes

Choose one mode before planning:

| Mode | Use |
| --- | --- |
| Bootstrap | Create a minimally functional agent infrastructure workspace. |
| Audit | Inventory live assets, find boundary or discovery gaps, and recommend the smallest safe corrections. |
| Maintain | Make bounded additive or corrective changes without reorganizing unrelated assets. |
| Migrate | Move from another structure or contract while preserving useful content, history, and references. |

## Canonical Boundaries

Classify every affected asset before editing:

| Domain | Canonical responsibility | Specialist |
| --- | --- | --- |
| Projects | Active multi-task or multi-session delivery state, Project-owned Tasks, coordination, closure, and immutable archive | `agent-project-organization` |
| Skills | Reusable procedural knowledge, routers, families, metadata, and bundled resources | `agent-skill-organization` |
| Context | Workspace meaning, glossary, intent routing, stable references, working artifacts, learning logs, and handoffs | `agent-context-organization` |
| Workflows | Repeatable outcome contracts, stages, capability dependencies, gates, outputs, and run expectations | `agent-workflow-organization` |
| Tools | One executable capability and its usage and safety contract | `agent-tool-organization` |
| MCP servers | A server or runtime that exposes one or more tools | `agent-mcp-organization` |
| Access | Service/account/project/tenant/environment selection, verification, scopes, gates, and secret boundaries | `agent-access-organization` |
| Adapters | Harness-specific mappings to canonical assets | `agent-adapter-organization` |

Within the Skills domain, use `testing-agent-skills` for behavioral validation. It supports `agent-skill-organization` and does not become a separate canonical owner.

Keep these distinctions explicit:

- A Project is active planned work owned by one repository context; it coordinates multiple bounded Tasks or multiple AI sessions and remains Layer 4 state until closure.
- A Task is a Project-owned unit sized for one non-delegating implementer session plus independent review.
- A skill explains when and how to perform a kind of work.
- Context explains what a workspace or domain means and where current work belongs.
- A workflow composes bounded stages and canonical capabilities into a repeatable outcome contract.
- A tool is one executable capability.
- An MCP server is the runtime exposing one or more tools.
- An access profile selects the authorized external handle and its boundaries.
- An adapter maps canonical assets into a harness without becoming their owner.

## Shared Lifecycle

Apply this lifecycle to every mode and specialist:

1. Resolve the exact target workspace and source of truth, then inspect its live structure, instructions, semantic context, relevant learning history, current handoff, and Git state.
2. Use `agent-project-organization` as the default classifier for nontrivial planned monorepo work. Create a Project only for multiple bounded Tasks or multiple AI sessions; route bounded one-session work directly to its specialist without creating a canonical Project or Task.
3. Classify the requested assets and domain boundaries.
4. For a Project, let `planning-projects` own proportional DDD, `grill-me`, the complete Task graph, and the approval basis. For smaller work, use `grill-me` only when a material decision remains unresolved after inspection.
5. Apply changes only within the active specialist's ownership and approval boundary. Project implementers follow their ready Task briefs and never update Project control state.
6. Validate structure, links, metadata, safety, discovery, and neighboring contracts.
7. Use `self-improving-skill` when the run yields a correction, failure, missing capability, or reusable improvement. In a Project, validated reuse must become an explicit reviewed Task before closure.
8. Follow the workspace's documented Git policy.
9. Use `handoff` for nontrivial creation, migration, multi-asset maintenance, pauses, blockers, transfers, session boundaries, or unfinished milestones. Store Project continuity inside the Project and non-Project continuity at the context handoff surface.

Skip a handoff only for a read-only question or a trivial edit that is fully completed and verified in the same run.

## Workflow

### 1. Inspect before proposing structure

Resolve the target workspace before inspecting Git. Never treat the repository that stores this skill as the task target merely because it is the current process directory. For a hypothetical design with no live target, say that Git and external state are not applicable rather than inspecting ambient state.

Read the target's closest applicable instruction files, repository map, context and routing files, glossary, learning history, current handoff, asset templates, adapters, manifests, validation scripts, Git state, branches, worktrees, and remotes. Search all path and name references affected by a proposed change.

Treat installed caches, generated output, and stale mirrors as non-canonical unless the workspace explicitly says otherwise.

### 2. Build an ownership inventory

List every affected source, adapter, document, template, manifest, generated surface, and external publication target. Mark unrelated dirty files and user-owned assets as preservation boundaries.

If a request spans domains, select and order the specialists before editing. A specialist that discovers sibling-domain work must return through this router instead of silently expanding scope.

### 3. Resolve decisions and approvals

Use existing documentation to answer settled questions. Grill only unresolved choices, one focused question at a time, with a recommended answer.

Require explicit approval before:

- moving, renaming, or deleting assets;
- breaking a public or internal contract;
- broadening permissions, scopes, or secret access;
- changing a documented environment-promotion path;
- publishing, deploying, merging, or otherwise creating an external side effect not already authorized.

### 4. Apply the smallest coherent change

Preserve human-authored guidance and useful existing behavior. Prefer references to duplication. Keep Markdown as the human- and agent-readable contract while allowing scripts, schemas, manifests, and executable configuration when required.

Never store secret values in skills, context, tools, MCP definitions, access profiles, adapters, learning logs, or handoffs.

### 5. Verify dependencies and lifecycle closure

Run every relevant specialist check, then perform a cross-domain review:

- Every canonical owner is unambiguous.
- Workflow routes, stages, dependencies, gates, outputs, and automation pointers agree.
- Paths, links, routing, metadata, and manifests resolve.
- Recursive skill discovery works in each supported harness.
- Adapters point to canonical bodies without copying them.
- Access and secret boundaries remain least-privilege.
- Git changes contain only intended files.
- Durable learning and handoff triggers were evaluated.

## Minimal Bootstrap Scaffold

Create only the minimal functional surfaces needed now:

```text
AGENTS.md
skills/
agents/context/
  CONTEXT.md
  GLOSSARY.md
  ROUTING.md
  references/
    git-policy.md
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
  projects/
    CONTEXT.md
    ROUTING.md
    archive/
  working/
  runs/
  handoff/
tools/
mcp-servers/
access/
adapters/
```

Create narrow learning scopes lazily when the first relevant learning appears. Add `docs/`, `templates/`, deeper skill families, or other support folders only when justified by an active need.

Keep `AGENTS.md` thin: point to semantic context, routing, glossary, and the detailed Git policy rather than duplicating them. Keep harness entrypoints thin through adapters.

## Git Governance

Own the workspace-wide Git contract. Store detailed rules in `agents/context/references/git-policy.md` and keep a thin pointer in `AGENTS.md`.

At minimum, require agents to inspect branch, worktree, remotes, instructions, and unrelated changes; use dedicated branches for structural or multi-domain work; stage exact files; review staged diffs; scan for secrets; avoid destructive resets and force pushes; and record branch, commit, push, and dirty state in handoffs.

Document branch and environment roles instead of inferring them from names. Record each role's source, promotion target, required checks, approval gate, and deployment effect, then follow the documented promotion sequence.

## Stop Rules

Stop rather than guess when:

- the canonical source or owner is ambiguous;
- unrelated changes overlap the intended edit;
- a secret could be persisted or exposed;
- a move, deletion, breaking change, permission expansion, or publication lacks approval;
- recursive discovery cannot be verified in a supported harness;
- branch, environment, deployment, or promotion roles are unclear;
- required validation cannot be run and no safe equivalent provides evidence.

## Output

Report the selected mode, ownership inventory, specialists used, approvals relied on, files changed, validation evidence, Git state, durable learning action, and handoff location or reason it was safely skipped.

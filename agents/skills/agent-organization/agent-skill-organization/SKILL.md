---
name: agent-skill-organization
description: Use when designing, auditing, creating, updating, nesting, moving, or validating harness-agnostic agent skills and skill families, including routers, frontmatter, interface metadata, references, scripts, assets, templates, and recursive discoverability.
---

# Agent Skill Organization

Own reusable procedural knowledge under the workspace's canonical skills surface. Organize individual skills and meaningful skill families so each skill is concise, independently discoverable, testable, and clearly separated from context, tools, MCP servers, access profiles, and adapters.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain boundaries, and handoff triggers. Return through that router before changing another domain.

## Ownership

Own:

- skill names, directories, and `SKILL.md` bodies;
- family routers and meaningful intermediate routing levels;
- frontmatter and portable skill interfaces;
- skill-scoped references, scripts, assets, and reusable templates;
- platform interface metadata placement through the workspace's adapter convention;
- validation, realistic behavioral scenarios, and recursive discovery.

Do not own workspace semantic context, executable tool contracts, MCP runtime documentation, external access profiles, harness mappings, or workspace-wide Git policy.

## Family Rules

Use these shapes:

```text
agents/skills/
  <skill-name>/
    SKILL.md

agents/skills/
  <family-name>/
    SKILL.md
    <child-skill-name>/
      SKILL.md
```

Support deeper nesting only when every level represents a stable domain boundary, ownership boundary, or meaningful routing decision. Give every meaningful intermediate level a router `SKILL.md` or a lightweight `ROUTING.md`. Flatten levels that add no routing value.

Keep every discoverable skill name globally unique even when its folder is nested. Match the folder name to the skill name. Use lowercase letters, digits, and hyphens.

Keep a family router focused on selection, shared lifecycle, cross-child boundaries, and aggregate validation. Keep specialist procedures in child skills.

## Workflow

1. Inspect the closest instructions, current skill-authoring guidance, existing skills and families, templates, adapters, manifests, references, tests, and Git state.
2. Search all references to the skill name and path before renaming, moving, or changing discovery metadata.
3. Define concrete trigger examples and pressure scenarios before authoring. Identify reusable references, scripts, and assets without creating speculative folders.
4. For a new skill, use the workspace's canonical initializer when one exists. For an existing skill, preserve useful behavior and edit in place.
5. Write frontmatter accepted by the current canonical validator. Put complete trigger conditions in `description`; keep the body imperative, concise, and focused on non-obvious procedure.
6. Keep detailed variants or large reference material in directly linked `references/`. Add scripts only for repeated or fragile deterministic work and run them before handoff. Keep output assets under `assets/`.
7. Generate or update human-facing interface metadata from the finished skill. Store harness-specific metadata in the adapter-owned location selected by the workspace; do not maintain duplicate metadata bodies.
8. Validate the skill before starting another untested skill. Use `testing-agent-skills` for realistic forward scenarios, pressure tests, and trigger or routing evaluation, then verify recursive discovery across every supported harness.
9. Update all canonical path references, routers, repository maps, templates, adapters, manifests, and plugin or package metadata atomically.
10. Return to `agent-organization` for cross-domain validation, durable learning, Git closure, and handoff.

## Frontmatter And Progressive Disclosure

Treat current canonical authoring instructions and validators as authoritative for allowed frontmatter keys. Do not copy legacy fields into a new or materially revised skill merely because older skills still contain them. Preserve untouched legacy skills unless a scoped migration is approved.

Keep `SKILL.md` limited to essential workflow and routing. Link every required resource directly from the skill and state when to read or run it. Avoid nested reference chains and auxiliary skill-level README or changelog files unless a canonical contract explicitly requires them.

## Validation

For each skill independently, verify:

- the canonical validator passes;
- the name, folder, and frontmatter agree;
- the description distinguishes the trigger from sibling skills;
- no placeholders, secrets, machine-local values, or repository-specific branding leaked into reusable content;
- referenced files and scripts exist and scripts run as documented;
- interface metadata matches the finished skill and invokes the correct skill name;
- realistic scenarios exercise success, ambiguity, cross-domain routing, approvals, and stop behavior.

For each family, recursively enumerate every `SKILL.md` and verify:

- every intended router and child is found in every supported harness;
- no globally duplicate skill names exist;
- every intermediate level has a meaningful router or routing file;
- moved paths have no stale references;
- adapter mappings point to canonical bodies rather than duplicating them.

## Approval And Stop Rules

Require approval before moving, renaming, deleting, publishing, or breaking a skill contract. Stop if recursive discovery cannot be demonstrated, the canonical authoring schema is ambiguous, a family level has no meaningful routing purpose, unrelated changes overlap the target, or a secret could enter a skill or bundled resource.

## Output

Report the skill or family boundary, concrete scenarios, resources created, metadata location, independent validation results, recursive-discovery evidence, updated references, approvals, Git state, and any unresolved compatibility limitation.

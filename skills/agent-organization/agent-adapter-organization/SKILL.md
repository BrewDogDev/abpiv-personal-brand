---
name: agent-adapter-organization
description: Use when designing, auditing, creating, updating, generating, or retiring harness-specific agent adapters that map canonical skills, context, workflows, tools, MCP servers, access profiles, manifests, and interface metadata without duplicating their instruction bodies.
---

# Agent Adapter Organization

Own harness- or runtime-specific mappings from canonical agent infrastructure into platform expectations. Keep canonical assets portable and keep adapters thin, explicit, replaceable, and safe to regenerate.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain boundaries, and handoff triggers. Return through that router before changing another domain.

## Boundary

Use the workspace's canonical adapter surface, commonly:

```text
adapters/
  <harness-name>/
    README.md
    skills/
    manifests/
    templates/
```

Create only the files the target harness actually consumes or the mapping notes needed to produce them.

Own:

- canonical-to-harness mapping tables;
- harness entrypoints, install locations, discovery rules, and unsupported features;
- platform interface metadata, manifests, prompts, and generated-file conventions;
- generation, synchronization, validation, reload, and drift-detection guidance;
- maintenance status for active, inactive, historical, or unsupported harness targets.

Do not own canonical skill bodies, semantic context, workflow contracts, tool or MCP behavior, access profiles, or secret values. An adapter points to those owners and translates only what the harness requires.

## Workflow

1. Inspect canonical assets, existing adapter files, target-harness documentation and schemas, manifests, generators, installed or generated output, validation commands, maintenance-status docs, and Git state.
2. Confirm that the requested content is harness-specific. Route reusable procedure, semantic meaning, executable capability, server setup, or target-account selection back to the owning canonical domain.
3. Inventory every canonical source and every adapter or generated consumer affected by the change. Identify which files are authoritative, generated, historical, or machine-local.
4. Map canonical assets by reference. Copy only the minimal fields or wrappers required by the target harness and include a source pointer when the output can drift.
5. Keep interface metadata, manifests, entrypoint prompts, install notes, and reload behavior consistent with current harness schemas. Use the finished canonical asset to derive human-facing metadata.
6. Keep user-specific paths, local bindings, credentials, tokens, private headers, and secret values in ignored or platform-native configuration, never in tracked adapters.
7. Update only actively maintained harnesses unless an explicit request reactivates another target. Preserve historical adapters as history rather than silently modernizing them.
8. Run adapter, manifest, plugin, package, link, and recursive-discovery validation for every supported active harness. Compare generated output to canonical sources when generation exists.
9. Return to `agent-organization` before changing canonical owners, adding another maintained harness, publishing, or changing cross-domain structure.

## Adapter Contract

Include these sections when a human-readable mapping is needed:

```markdown
# <Harness> Adapter

## Status And Scope
## Mapping
## Discovery And Entrypoints
## Interface Metadata And Manifests
## Unsupported Features
## Generation Or Synchronization
## Validation And Reload
## Secret And Local-State Boundary
```

Keep generated files clearly labeled and reproducible. Do not allow generated or installed cache content to become the silent source of truth.

## Validation

Verify that:

- every adapter file has one canonical owner or an explicit generated source;
- links and relative paths resolve after moves or nesting;
- interface metadata, manifests, prompts, names, and discovery roots agree;
- nested skills are recursively discovered where the harness claims support;
- adapter text does not duplicate full canonical instruction bodies;
- active and inactive maintenance targets are explicit;
- install, update, validation, and reload instructions are current;
- no secret, private payload, user-specific absolute path, or copied local configuration is tracked.

## Approval And Stop Rules

Require approval before adding or reactivating a maintained harness, removing an adapter, changing a published manifest or install contract, broadening runtime permissions, or publishing adapter output. Stop if the target schema or discovery behavior cannot be verified, canonical ownership is ambiguous, generated output would overwrite user edits, or safe mapping would require persisting a secret.

## Output

Report the harness and maintenance status, canonical-to-adapter mappings, generated or installed consumers, metadata and manifest changes, validation and recursive-discovery evidence, unsupported features, cross-domain work routed to `agent-organization`, and Git state.

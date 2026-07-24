---
name: agent-tool-organization
description: Use when designing, auditing, documenting, creating, or updating harness-agnostic agent tool contracts for individual executable capabilities, including requirements, inputs and outputs, allowed and denied actions, side effects, approval gates, and tool-level safety.
---

# Agent Tool Organization

Own contracts for individual executable capabilities. Make each tool understandable and safe to invoke without turning its documentation into a workflow skill, MCP server setup guide, access profile, or harness adapter.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain boundaries, and handoff triggers. Return through that router before changing another domain.

## Boundary

A tool performs one executable capability through a command, API operation, connector action, function, script, or equivalent interface. Document the reusable usage and safety contract under the workspace's canonical tool surface, commonly:

```text
agents/tools/
  <tool-name>/
    TOOL.md
```

Own:

- capability and intended use;
- runtime and dependency requirements specific to that capability;
- inputs, outputs, failure modes, and observable side effects;
- credential or scope requirements by name, never value;
- allowed, denied, destructive, costly, privileged, and approval-gated actions;
- safe examples, verification, and reporting requirements.

Do not own the broader procedure for completing a kind of work, the server/runtime that exposes multiple tools, the selected account or environment, or harness-specific configuration. Route those to skill, MCP, access, or adapter organization.

## Workflow

1. Inspect the actual executable interface, existing tool documentation, calling skills and workflows, MCP surface if present, access profiles, adapters, templates, tests, and Git state.
2. Confirm that the asset is one executable capability. If the proposed document primarily teaches a reusable workflow, describes a multi-tool runtime, selects an external handle, or maps a harness, route it to the owning domain.
3. Identify supported inputs, outputs, preconditions, failure modes, network or filesystem effects, cost, privilege, interactivity, and reversibility from live evidence or authoritative documentation.
4. Write or update the smallest canonical contract. Link to the owning access profile and MCP server where relevant instead of copying account, credential, server, or client configuration.
5. Separate routine read-only or draft actions from mutating, destructive, identity-affecting, billing-impacting, or production actions. State the approval gate before the action, not after it.
6. Name required credentials, roles, scopes, environment variables, or secret references without including values, token fragments, private headers, or local credential files.
7. Provide one safe example and a verification or reporting contract that lets a later agent prove which interface and side-effect class were used.
8. Validate links, commands, examples, safety language, secret boundaries, and affected callers. Return to `agent-organization` for cross-domain changes and closure.

## Minimum Contract

Include these sections when applicable:

```markdown
# <Tool Name>

## Capability
## Requirements
## Inputs And Outputs
## Allowed Actions
## Denied Or Approval-Gated Actions
## Side Effects And Failure Modes
## Verification And Reporting
## Example Usage
```

Adapt the shape when the workspace provides a stricter template, but keep every safety-relevant fact inspectable.

## Validation

Verify that:

- the document describes one capability rather than an entire workflow or server;
- required runtime, credential names, scopes, inputs, outputs, and errors are explicit;
- allowed and approval-gated actions are mutually understandable;
- destructive, costly, privileged, production, network, and data effects are surfaced;
- examples default to read-only, dry-run, draft, or least-privilege behavior when available;
- commands and links resolve or are clearly marked as illustrative;
- no secret value, private payload, machine-local path, or raw credential material is present;
- skills, MCP docs, access profiles, and adapters reference this contract without duplicating it.

## Approval And Stop Rules

Require approval before deleting or renaming a tool contract, breaking callers, broadening allowed actions, expanding permissions, or publishing executable changes. Stop if the actual interface cannot be verified, the requested capability spans multiple ownership domains, side effects are unclear, or safe documentation would require exposing a secret.

## Output

Report the classified capability, canonical contract path, evidence inspected, safety and approval boundaries, linked access/MCP owners, validation performed, cross-domain work routed back to `agent-organization`, and Git state.

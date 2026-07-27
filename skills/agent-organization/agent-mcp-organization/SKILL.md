---
name: agent-mcp-organization
description: Use when designing, auditing, documenting, creating, or updating harness-agnostic Model Context Protocol server integrations, including upstream provenance, runtime requirements, setup, client configuration, exposed tool inventory, credential names, server-level risks, and approval-gated actions.
---

# Agent MCP Organization

Own the canonical contract for an MCP server or runtime that exposes one or more tools. Make setup, client integration, tool inventory, credential requirements, and server-level safety inspectable without absorbing workflow, tool, access-profile, or adapter ownership.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain boundaries, and handoff triggers. Return through that router before changing another domain.

## Boundary

Use the workspace's canonical MCP surface, commonly:

```text
mcp-servers/
  <server-name>/
    MCP.md
    setup.md
    safety.md
    examples.md
```

Create support files only when they keep the primary contract concise or executable source is part of the maintained server.

Own:

- upstream repository, package, documentation, status, version, and license provenance;
- runtime, package-manager, host, transport, and local dependency requirements;
- installation, launch, and client configuration patterns;
- exposed MCP tool inventory and server-wide behavior;
- required credential, role, scope, header, or environment-variable names, never values;
- allowed, denied, approval-gated, costly, destructive, production, and data-handling behavior;
- smoke tests, troubleshooting, safe examples, and server-level reporting.

Do not own the detailed contract for each executable capability, the account/project/environment to use, the reusable task procedure, or harness-specific mapping. Route those to tool, access, skill, or adapter organization.

## Workflow

1. Inspect existing MCP documentation and source, authoritative upstream material, package manifests, runtime files, exposed tools, access profiles, callers, adapters, templates, tests, and Git state.
2. Confirm that the asset is a server or runtime exposing tools. Route one standalone executable capability to tool organization and external handle selection to access organization.
3. Record provenance and observed compatibility precisely. Distinguish verified facts from examples, assumptions, preview status, or untested clients.
4. Document runtime and install requirements without embedding a user-specific absolute path. Keep executable configuration in the format required by the server, using safe placeholders.
5. Inventory every exposed tool by stable name and purpose. Link to separate tool contracts when a capability needs detailed safety or usage guidance.
6. Name required credentials and scopes, then point to the owning access profile or secret store. Never include tokens, private headers, passwords, key files, or copied local client configuration.
7. Classify server-level actions and risks. Require approval before mutations, deletion, permission changes, public access, billing effects, production effects, arbitrary code execution, or sensitive data movement unless an existing stricter policy already governs them.
8. Add read-only smoke tests, troubleshooting, and example prompts that prove server availability and active identity or target without leaking secrets.
9. Validate configuration syntax, links, tool inventory, runtime commands, secret safety, and caller references. Return to `agent-organization` before changing sibling domains.

## Minimum Contract

Include these sections when applicable:

```markdown
# <MCP Server Name>

## Capability
## Upstream
## Runtime
## Required Local Tools
## Required Credentials
## Install And Run
## Client Configuration
## Available MCP Tools
## Allowed Actions
## Denied Or Approval-Gated Actions
## Safety Notes
## Verification And Troubleshooting
## Example Prompts
```

## Validation

Verify that:

- upstream, package, runtime, transport, and compatibility claims have evidence;
- launch and client snippets parse and contain placeholders rather than live secrets;
- every exposed tool is inventoried or explicitly marked dynamically discovered;
- server-level permissions and side effects are clear;
- credential requirements are named and delegated to access ownership;
- read-only verification identifies the active server, account, project, tenant, or environment when relevant;
- source, docs, examples, setup, safety, manifests, and adapters agree;
- no secret, private payload, machine-local credential path, or raw local config is persisted.

## Approval And Stop Rules

Require approval before renaming or deleting a server contract, changing runtime or client compatibility, publishing a server, broadening tools or permissions, or executing external mutations. Stop if upstream provenance, exposed tools, runtime behavior, active target, or secret boundary cannot be verified safely.

## Output

Report the server boundary, provenance, runtime and transport, tool inventory, credential names and owning access surface, safety gates, verification evidence, cross-domain work routed to `agent-organization`, and Git state.

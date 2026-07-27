---
name: agent-access-organization
description: Use when designing, auditing, creating, or updating harness-agnostic external-service access context, including services, accounts, projects, tenants, environments, profiles, non-secret handles, verification checks, scopes, approval gates, and secret boundaries.
---

# Agent Access Organization

Own credential-free context that tells an agent which external service handle may be used, how to verify it, which interfaces and scopes are approved, what side effects require approval, and where secrets must remain.

Read the parent `agent-organization` skill for the shared lifecycle, approvals, Git rules, cross-domain boundaries, and handoff triggers. Return through that router before changing another domain.

## Boundary

Use the workspace's canonical access surface, commonly:

```text
agents/access/
  CONTEXT.md
  ROUTING.md
  references/
  services/
    <service>/
      CONTEXT.md
      profiles/
        <profile>.md
      interfaces/
      references/
```

Own:

- service, account, project, tenant, workspace, subscription, region, and environment selection;
- stable non-secret handles and profile identifiers;
- approved MCP, CLI, API, SDK, connector, or local access methods;
- read-only identity and target verification;
- required credential names, roles, scopes, environment variables, binding keys, and secret-location references;
- allowed, denied, approval-gated, production, billing, identity, and destructive action classes;
- stop rules and evidence to report after access is used.

Do not own secret values, workflow procedures, tool behavior, MCP server setup, or harness mappings. Route those to secret stores outside tracked assets or to skill, tool, MCP, or adapter organization.

## Workflow

1. Inspect access routing, service contexts, profiles, interfaces, secret-boundary references, calling workflows and tools, adapters, templates, ignored local bindings, and Git state.
2. Identify the exact service and profile dimensions needed to prevent target ambiguity. Prefer stable profile identifiers and non-secret handles over prose labels alone.
3. Separate service-wide rules, profile-specific target facts, and interface-specific instructions. Keep each fact at the narrowest durable scope and link shared rules instead of copying them.
4. Document approved access methods and read-only checks that reveal the active identity, account, project, tenant, workspace, server, region, or environment without printing secret values.
5. Name required roles, scopes, credential references, environment variables, or local binding keys. State where values must live and which values must never be tracked.
6. Classify allowed, approval-gated, and denied actions. Require explicit approval for production mutation, permission expansion, public access, billing effects, identity changes, data movement, and destructive operations unless a stricter policy already applies.
7. Add stop rules for target mismatch, stale authentication, insufficient scope, ambiguous ownership, unsafe secret handling, or missing approval.
8. Validate every profile against the referenced interface, tool, MCP server, workflow, secret boundary, and routing entry. Return to `agent-organization` before changing those domains.

## Profile Contract

Include these sections when applicable:

```markdown
# <Profile Name>

## Service Handle
## Approved Means Of Access
## Credential Boundary
## Verification
## Allowed Actions
## Approval-Gated Or Denied Actions
## Stop Rules
## Reporting Requirements
```

Tracked access files may contain stable handles, public hostnames, project identifiers, login identity hints, credential names, scopes, verification commands, and approval rules. They must not contain tokens, passwords, private headers, key material, recovery codes, decrypted credentials, or copied local config.

## Validation

Verify that:

- routing resolves each recurring intent or handle to one unambiguous profile;
- service, profile, interface, and environment names agree;
- verification is read-only and reports the active target without exposing secrets;
- required roles, scopes, and credential references are explicit;
- allowed and approval-gated action classes match tool and MCP safety contracts;
- production, billing, identity, public-access, permission, and destructive effects are gated;
- ignored local bindings and secret stores remain outside tracked content;
- no secret value, private payload, machine-local credential file, or raw config is present.

## Approval And Stop Rules

Require approval before adding or removing a profile that changes authorized targets, broadening scopes or allowed actions, changing environment or promotion semantics, publishing access context, or deleting access history. Stop if the active target cannot be verified, required access is ambiguous, a secret would need to be exposed, or the requested permission exceeds the documented boundary.

## Output

Report the service and profile, non-secret handle, approved interfaces, verification evidence, scope and secret boundaries, allowed and gated action classes, linked owners, cross-domain work routed to `agent-organization`, and Git state.

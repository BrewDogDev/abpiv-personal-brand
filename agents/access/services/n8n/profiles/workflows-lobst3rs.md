# n8n Profile: workflows.lobst3rs

## Service Handle

| Field | Value |
| --- | --- |
| Profile id | `workflows-lobst3rs` |
| Service | n8n |
| Environment | Production instance |
| Editor hostname | `workflows.lobst3rs.com` |
| MCP endpoint | `https://workflows.lobst3rs.com/mcp-server/http` |
| Public forms hostname | `forms.allanbpediniv.com` |

Project and folder ids must be discovered through read-only instance calls for
each task; this profile does not guess or persist a personal-project identity.

## Approved Means Of Access

- [`instance-mcp`](../interfaces/instance-mcp.md)
- Interactive editor access only when the task requires it and the active
  identity is authorized
- Repository infrastructure workflows only when explicitly authorized for that
  operation

## Credential Boundary

Required runtime names:

- `Authorization` with a bearer value sourced from
  `N8N_LOBST3RS_MCP_TOKEN`
- `CF-Access-Client-Id` sourced from `CF_ACCESS_CLIENT_ID`
- `CF-Access-Client-Secret` sourced from `CF_ACCESS_CLIENT_SECRET`
- `User-Agent`, using the non-secret client label `Codex-n8n-MCP/1.0`
- Local binding `n8n.workflows-lobst3rs`

All values except the public user-agent label live in n8n, Cloudflare, a
platform-native secret store, or ignored local config governed by the
[`secret boundary`](../../../references/secret-boundary.md).

## Verification

Before workflow work:

1. Confirm MCP initialization at the exact endpoint.
2. Record the dynamic `tools/list` count without persisting schemas that may
   drift.
3. Resolve the exact accessible project or folder and workflow target through
   read-only calls.
4. Confirm required credential metadata by display name or id only.

## Allowed Actions

- Search and inspect projects, folders, workflows, executions, tags, credential
  metadata, and other read-only metadata exposed by the current server.
- Validate workflow source or node configuration when the dynamic tool inventory
  supports it.
- Draft a proposed mutation without executing it.

## Approval-Gated Or Denied Actions

The exact task must separately authorize draft creation/update, executable tests,
publication or activation changes, production execution, credentials, data
mutation, third-party effects, transfers, archival, or deletion. Secret
exposure, bypassing Cloudflare Access, and treating the public forms host as an
admin endpoint are denied.

## Stop Rules

Stop if the host differs, Cloudflare Access or bearer auth fails, tools are
unavailable, project/folder/workflow identity is ambiguous, visibility or
credential metadata is insufficient, a mutation is unreconciled, or authority is
missing.

## Reporting Requirements

Report profile id, endpoint hostname, tool count, project/folder/workflow ids,
action class, validation/test/execution evidence, publication state,
reconciliation status, required credential names, and skipped gates.

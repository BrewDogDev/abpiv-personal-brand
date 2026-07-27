# n8n Access

Use this context before inspecting, building, testing, publishing, or operating
workflows on the repository's n8n instance.

## Boundary

This context owns instance selection, access verification, credential references,
and action gates. The canonical remote server contract is
[`mcp-servers/n8n-instance/MCP.md`](../../../mcp-servers/n8n-instance/MCP.md). Infrastructure
operation remains owned by [`infra/n8n/`](../../../../infra/n8n/README.md).

## Profile

| Target | Profile | Default interface |
| --- | --- | --- |
| Lobst3rs n8n editor and instance MCP | [`workflows-lobst3rs`](profiles/workflows-lobst3rs.md) | [`instance-mcp`](interfaces/instance-mcp.md) |

The public forms host `forms.allanbpediniv.com` is not an administrative or MCP
interface.

## Credential Boundary

MCP bearer tokens, Cloudflare Access service-token values, n8n credentials,
browser sessions, execution payloads, and credential exports remain outside Git
under the shared [`secret boundary`](../../references/secret-boundary.md).

## Default Gates

- MCP initialization, dynamic tool discovery, workflow/project/folder search,
  sanitized workflow reads, execution metadata reads, and credential metadata by
  name are read-only.
- Draft create/update, tests, publication state, production execution,
  credentials, data mutation, archiving, deletion, or third-party side effects
  each require the authority defined by the exact task.
- A missing terminal response after mutation is ambiguous, never proof of
  failure. Reconcile exact live state before any retry.

Stop if the gateway or MCP authentication fails, target visibility is
insufficient, a project/folder is ambiguous, required credentials are absent, or
safe progress would reveal a secret.

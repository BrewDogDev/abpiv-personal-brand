# n8n Instance MCP Interface

## Purpose

Use the remote instance MCP server for authenticated n8n discovery and
task-authorized workflow operations.

Canonical server contract:
[`agents/mcp-servers/n8n-instance/MCP.md`](../../../../mcp-servers/n8n-instance/MCP.md).

## Inputs

| Layer | Source | Use |
| --- | --- | --- |
| Stable service context | [`../CONTEXT.md`](../CONTEXT.md) | Service-wide gates |
| Stable profile | [`../profiles/workflows-lobst3rs.md`](../profiles/workflows-lobst3rs.md) | Exact host and credential names |
| Stable secret rules | [`../../../references/secret-boundary.md`](../../../references/secret-boundary.md) | Values that remain outside Git |
| Runtime binding | Ignored local config or platform secret store | Endpoint, bearer token, and gateway header values |

## Process

1. Read the selected profile and server contract.
2. Resolve `Authorization`, `CF-Access-Client-Id`,
   `CF-Access-Client-Secret`, and `User-Agent` through the approved runtime
   binding.
3. Initialize MCP and request `tools/list`; accept the response transport
   documented by the server contract.
4. Resolve the exact project/folder and workflow with read-only calls.
5. Classify the requested operation as read, draft mutation, test, publication,
   production execution, credential/data mutation, or destructive action and
   verify the applicable authority.
6. Re-read exact state after mutation. If the terminal result is missing, stop
   and reconcile before any retry.

## Stop Rules

Stop on gateway or bearer authentication failure, target ambiguity, insufficient
visibility, missing authority, unreconciled mutation, or any need to print token,
header, credential, payload, or session values.

## Reporting

Report the selected profile, endpoint hostname, transport status, dynamic tool
count, exact project/folder and workflow ids, action class, validation or
execution ids where applicable, publish state, reconciliation result, and
credential prerequisites by name only.

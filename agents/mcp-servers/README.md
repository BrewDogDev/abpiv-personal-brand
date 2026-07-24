# MCP Server Registry

This folder owns harness-agnostic contracts for remote or local Model Context
Protocol servers used by this repository. A server contract documents transport,
provenance, dynamic tools, credential names, safety gates, and verification; it
does not select the external target or store credentials.

## Registered Servers

| Server | Contract | Target owner | Status |
| --- | --- | --- | --- |
| n8n instance MCP | [`n8n-instance/MCP.md`](n8n-instance/MCP.md) | [`workflows-lobst3rs` access profile](../access/services/n8n/profiles/workflows-lobst3rs.md) | Remote instance server; tool inventory is discovered at runtime |

No MCP server executable or secret-bearing client configuration is maintained in
this repository. Harness clients resolve runtime bindings outside Git.

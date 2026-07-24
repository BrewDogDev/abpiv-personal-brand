# n8n Instance MCP

## Capability

The instance-level n8n MCP server exposes authenticated workflow and execution
operations for one n8n instance. Select the exact target through the
[`workflows-lobst3rs` access profile](../../access/services/n8n/profiles/workflows-lobst3rs.md)
before connecting.

## Upstream

- Repository: https://github.com/n8n-io/n8n
- Access documentation:
  https://docs.n8n.io/advanced-ai/mcp/accessing-n8n-mcp-server/
- Tool reference:
  https://docs.n8n.io/advanced-ai/mcp/mcp_tools_reference/
- Status: remotely hosted instance feature; availability, names, schemas, and
  behavior depend on the deployed n8n version, settings, license, and caller
  permissions.
- License: upstream n8n licensing applies; this repository does not redistribute
  the server.

## Runtime

- Host: the selected n8n instance.
- Transport: remote Streamable HTTP at
  `https://workflows.lobst3rs.com/mcp-server/http`.
- Protocol: MCP JSON-RPC; clients must accept supported JSON or server-sent-event
  responses and honor any session behavior returned by the server.
- Gateway: Cloudflare Access protects the host before n8n authentication.

No MCP server is installed or launched locally by this repository.

## Required Local Tools

- An MCP client supporting remote Streamable HTTP and custom request headers.
- A JSON parser for configuration validation.
- Browser access only for separately authorized interactive administration;
  browser login is not a substitute for the service-token MCP binding.

## Required Credentials

The selected profile names all bindings. A compatible client sends:

- `Authorization: Bearer <bound value>` from the separately managed n8n binding
  `N8N_LOBST3RS_MCP_TOKEN`;
- `CF-Access-Client-Id: <bound value>` and
  `CF-Access-Client-Secret: <bound value>` from Google Cloud Secret Manager
  handle `abpiv-n8n-mcp-cloudflare-access`; and
- `User-Agent: Codex-n8n-MCP/1.0`, also recorded in that managed payload as a
  non-secret client label.

Header names and the user-agent label are non-secret. Bearer and Cloudflare
Access header values are secret and remain in ignored local config or a
platform-native secret store. The
[`local-binding recovery contract`](../../access/references/local-bindings.md)
identifies the owning workflow and required authority. The workflow-owned secret
does not contain the n8n bearer token. Never log complete request headers or
substitute one credential source for the other.

## Install And Run

There is no local server install. The supported repo-root Codex client binding is
`.codex-local/n8n-mcp.json`. Protect `.codex-local/` with mode `0700` and the
config with mode `0600` on POSIX-compatible filesystems; elsewhere, use an
equivalent least-privilege ACL restricted to the approved client account and
required trusted system principals.

Creating or replacing that binding, reading the Secret Manager payload, or
obtaining the n8n bearer token requires explicit authority for the exact
secret-bearing action. Repository work and read-only external inspection do not
grant that authority. Once an authorized binding exists, initialize MCP and
request `tools/list`.

## Client Configuration

This credential-free example shows the required shape for
`.codex-local/n8n-mcp.json`. Replace placeholders only inside ignored local or
platform-managed configuration and only through the
[`recovery contract`](../../access/references/local-bindings.md):

```json
{
  "mcpServers": {
    "n8n-mcp": {
      "type": "http",
      "url": "https://workflows.lobst3rs.com/mcp-server/http",
      "headers": {
        "Authorization": "Bearer <n8n-mcp-token>",
        "CF-Access-Client-Id": "<cloudflare-access-client-id>",
        "CF-Access-Client-Secret": "<cloudflare-access-client-secret>",
        "User-Agent": "Codex-n8n-MCP/1.0"
      }
    }
  }
}
```

A client must use bounded deadlines, accept the negotiated response type, match
responses to request ids, retain any returned session id only in memory, and
treat a non-terminal mutation outcome as ambiguous.

## Available MCP Tools

`tools/list` is authoritative for every connection. Do not treat a copied list as
stable. Record the returned tool count and inspect schemas before use.

Depending on the live server, the dynamic inventory may include:

- workflow, project, folder, tag, credential-metadata, data-table, and execution
  search or detail reads;
- SDK, node-type, node-resource, and best-practice guidance;
- workflow and node validation;
- draft create or update operations;
- pin-data preparation and workflow testing; and
- publication, unpublication, production execution, archive, or delete
  operations.

The presence of a tool does not authorize its use.

## Allowed Actions

- Initialize the server and inspect server metadata and `tools/list`.
- Search and read accessible project, folder, workflow, execution, tag, and
  credential metadata when the task permits read-only inspection.
- Validate workflow or node source without mutation when an exposed tool supports
  it.
- Draft a proposed call without sending it.

## Denied Or Approval-Gated Actions

Require exact task authority for inactive-draft creation or update. Require a
separate explicit gate after graph and side-effect review for executable tests.
Require explicit approval for publishing, unpublishing, activating, production
execution, provider effects, credential or data-table mutation, transfer,
archival, deletion, public-access changes, or permission expansion.

Secret exposure, Cloudflare Access bypass, raw credential export, duplicate retry
after an ambiguous mutation, and treating read visibility as mutation authority
are denied.

## Safety Notes

- A successful read proves authentication and visibility only.
- Resolve exact project/folder and workflow ids before mutation; do not persist a
  personal-project identity when an id is sufficient.
- Re-read exact live state after every mutation.
- If a terminal mutation response is absent, search the exact target and classify
  reconciliation as `none`, `single`, or `multiple`. Do not retry on `single` or
  `multiple`; stop for review.
- Credential metadata is limited to display names, ids, and types. Stop if a
  response unexpectedly contains secret material.
- Keep the public forms hostname separate from the Access-protected editor and
  MCP host.
- Keep the workflow-managed Cloudflare Access headers separate from the n8n
  bearer token. Retrieval or local binding repair is a secret-bearing operation,
  not a routine connectivity check.

## Verification And Troubleshooting

Before work, report:

- selected profile and endpoint hostname;
- initialization result, response content type, elapsed time, and session
  presence without a session value;
- dynamic tool count and the exact schema of any tool proposed for use;
- resolved project/folder and workflow ids; and
- the intended action class and authority boundary.

Troubleshooting:

- Cloudflare login HTML instead of MCP: gateway service-token bindings are absent
  or rejected. Under separately approved recovery authority, use Secret Manager
  handle `abpiv-n8n-mcp-cloudflare-access` as described by the local-binding
  contract; otherwise stop. Do not substitute an interactive email challenge.
- HTTP 401: verify the bearer binding name and current n8n MCP access without
  printing the token. The Cloudflare Access Secret Manager payload cannot repair
  a missing n8n bearer token.
- HTTP 403: verify the Cloudflare Access binding and policy through an approved
  read-only path.
- Unexpected content type or timeout: inspect negotiated transport, bounded
  response handling, request-id matching, and session behavior.
- Ambiguous mutation: reconcile exact live state before considering any retry.

## Example Prompts

- Use the `workflows-lobst3rs` profile to initialize n8n MCP, list dynamic tools,
  and report accessible project/folder handles. Read-only only.
- Inspect the exact workflow by id and report its publish state and credential
  prerequisites by name. Do not mutate.
- Reconcile whether an exact draft exists in an exact project after an ambiguous
  create. Do not retry.

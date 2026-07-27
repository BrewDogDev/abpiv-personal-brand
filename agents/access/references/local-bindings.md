# Local Bindings

Local bindings connect tracked profile ids to machine-local credentials. They are
Layer 4 state and must stay ignored.

## Repository Boundary

The supported repo-root Codex binding for the Lobst3rs n8n MCP client is
`.codex-local/n8n-mcp.json`. The whole `.codex-local/` directory is ignored and
must remain Layer 4 machine-local state. Do not read, copy, or reconstruct that
file during normal repository work.

Protect the directory and config before writing any value:

- On POSIX-compatible filesystems, keep `.codex-local/` at mode `0700` and
  `.codex-local/n8n-mcp.json` at mode `0600`.
- On filesystems without POSIX modes, apply an equivalent least-privilege ACL:
  restrict read and write access to the account running the approved client and
  required trusted system principals, and remove broad inherited access.
- Never weaken permissions merely to make a client or diagnostic command work.

Platform-native authentication and shell-scoped variables remain valid
alternatives when they satisfy the selected profile and the same secret boundary.

## Credential-Free Shape

The following example contains binding names and placeholders only:

```json
{
  "google-cloud": {
    "abpiv-personal-brand": {
      "project_id": "abpiv-personal-brand",
      "gcloud_config": "abpiv-personal-brand",
      "impersonate_service_account_env": "ABPIV_GCP_IMPERSONATE_SERVICE_ACCOUNT"
    }
  },
  "cloudflare": {
    "abpiv-personal-brand": {
      "account_id": "c4641560f98108d80fe5dd892cd2ef14",
      "api_token_env": "CLOUDFLARE_API_TOKEN",
      "allanbpediniv_zone_id_env": "CLOUDFLARE_ZONE_ID_ALLANBPEDINIV",
      "lobst3rs_zone_id_env": "CLOUDFLARE_ZONE_ID_LOBST3RS"
    }
  },
  "n8n": {
    "workflows-lobst3rs": {
      "url": "https://workflows.lobst3rs.com/mcp-server/http",
      "authorization_env": "N8N_LOBST3RS_MCP_TOKEN",
      "cloudflare_access_client_id_env": "CF_ACCESS_CLIENT_ID",
      "cloudflare_access_client_secret_env": "CF_ACCESS_CLIENT_SECRET",
      "user_agent": "Codex-n8n-MCP/1.0"
    }
  }
}
```

For a tool that expects a fixed environment-variable or header name, map the
profile-specific binding into that name only in the active process or secret
store. Do not write a tracked generated environment file.

## n8n MCP Recovery Contract

The non-secret Google Cloud Secret Manager handle
`abpiv-n8n-mcp-cloudflare-access` is the supported recovery source for the
Cloudflare Access client headers used by the local n8n MCP client. It belongs to
Google Cloud project `abpiv-personal-brand` and is written by
[`.github/workflows/n8n-apply.yml`](../../../.github/workflows/n8n-apply.yml).

That managed secret contains only:

- `CF-Access-Client-Id`;
- `CF-Access-Client-Secret`; and
- the non-secret `User-Agent` label.

It does **not** contain the separate n8n MCP bearer token used by the
`Authorization` header. The bearer token must come from the separately authorized
n8n credential owner or binding represented by `N8N_LOBST3RS_MCP_TOKEN`. Never
infer, derive, or substitute it from the Cloudflare Access secret.

Recreate or repair the local client binding only under explicit authority for
each secret-bearing action:

1. Verify the path is ignored without reading it:
   `git check-ignore -v --no-index .codex-local/n8n-mcp.json`.
2. Create `.codex-local/` and apply the restrictive directory permission or ACL
   before retrieving or entering any value.
3. Obtain separate approval to read the production Secret Manager payload and
   use an approved identity scoped to project `abpiv-personal-brand`. Keep the
   returned Cloudflare Access values out of terminal logs, transcripts,
   clipboard history, tracked files, and reports.
4. Obtain the n8n bearer token through its separately authorized owner or secret
   process. If that source is unavailable or ambiguous, stop; the workflow-owned
   Secret Manager payload is not a fallback.
5. Assemble the redacted client shape documented in
   [`mcp-servers/n8n-instance/MCP.md`](../../mcp-servers/n8n-instance/MCP.md)
   only at `.codex-local/n8n-mcp.json`, then apply the restrictive file
   permission or ACL before client use.
6. Validate JSON and effective permissions locally without printing the config,
   full headers, token prefixes, or session material.

Repository-edit authority, read-only cloud inspection authority, or permission
to use an already configured MCP client does not authorize reading Secret Manager
payloads, revealing an existing local config, retrieving the n8n bearer token, or
creating/replacing the binding file.

## Stop Rules

Stop if a binding is missing, selects a different profile, has insufficient
scope, is stale, has unsafe permissions, lacks explicit secret-read or local-write
authority, or would require printing a secret to diagnose. Stop if the Cloudflare
Access values and n8n bearer token cannot be sourced independently through their
authorized owners. Report only the binding name, non-secret secret handle, owning
workflow, permission state, and failure class.

# Local Bindings

Local bindings connect tracked profile ids to machine-local credentials. They are
Layer 4 state and must stay ignored.

## Repository Boundary

This repository may use harness-specific ignored configuration under
`.codex-local/`. Do not read or copy that directory during normal repository
work. Platform-native authentication and shell-scoped variables are equally valid
when they satisfy the selected profile.

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

## Stop Rules

Stop if a binding is missing, selects a different profile, has insufficient
scope, is stale, or would require printing a secret to diagnose. Report only the
binding name and failure class.

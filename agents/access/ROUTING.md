# Access Routing

## Profiles

| User intent or handle | Service profile | Default interface | Required first check |
| --- | --- | --- | --- |
| ABPIV Google Cloud or project `abpiv-personal-brand` | [`services/google-cloud/profiles/abpiv-personal-brand.md`](services/google-cloud/profiles/abpiv-personal-brand.md) | [`gcloud-cli`](services/google-cloud/interfaces/gcloud-cli.md) | Confirm active auth and describe project `abpiv-personal-brand`. |
| ABPIV Cloudflare, account `c4641560f98108d80fe5dd892cd2ef14`, Pages project `abpiv-personal-brand`, `allanbpediniv.com`, or `lobst3rs.com` resources used by this repository | [`services/cloudflare/profiles/abpiv-personal-brand.md`](services/cloudflare/profiles/abpiv-personal-brand.md) | [`wrangler-cli`](services/cloudflare/interfaces/wrangler-cli.md) | Confirm the account is visible and the selected account id matches. |
| n8n editor, `workflows.lobst3rs.com`, or its instance MCP endpoint | [`services/n8n/profiles/workflows-lobst3rs.md`](services/n8n/profiles/workflows-lobst3rs.md) | [`instance-mcp`](services/n8n/interfaces/instance-mcp.md) | Confirm MCP initialization, dynamic tool inventory, and exact project/folder visibility. |

## Default Rule

Stop and ask for the exact target if a request could select more than one service,
account, project, server, folder, or environment. Do not create an undocumented
profile or infer a target from ambient credentials.

## Secret Rule

If progress would require reading, printing, pasting, logging, or committing a
secret value or raw local configuration, stop and use the
[`local-binding contract`](references/local-bindings.md).

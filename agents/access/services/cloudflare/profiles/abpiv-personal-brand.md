# Cloudflare Profile: ABPIV Personal Brand

## Service Handle

| Field | Value |
| --- | --- |
| Profile id | `abpiv-personal-brand` |
| Service | Cloudflare |
| Environment | Production and preview resources in one account |
| Account id | `c4641560f98108d80fe5dd892cd2ef14` |
| Pages project | `abpiv-personal-brand` |
| Public site | `allanbpediniv.com` |
| Preview site | `content-site.lobst3rs.com` |
| n8n editor | `workflows.lobst3rs.com` |
| Public n8n forms | `forms.allanbpediniv.com` |

## Approved Means Of Access

- [`wrangler-cli`](../interfaces/wrangler-cli.md)
- Scoped Cloudflare API access when the selected operation is not supported by
  Wrangler and the task explicitly authorizes that interface
- Repository GitHub Actions when an authorized workflow owns the operation

## Credential Boundary

Required references may include:

- Local binding `cloudflare.abpiv-personal-brand`
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ANALYTICS_API_TOKEN` where an existing analytics workflow maps it
- `CLOUDFLARE_ZONE_ID_ALLANBPEDINIV`
- `CLOUDFLARE_ZONE_ID_LOBST3RS`

Values live in Cloudflare, GitHub encrypted configuration, Wrangler auth,
platform secret stores, or ignored local bindings under the
[`secret boundary`](../../../references/secret-boundary.md).

## Verification

Run before meaningful work:

```powershell
wrangler whoami --json
```

Confirm the returned account list contains account id
`c4641560f98108d80fe5dd892cd2ef14`. Then use a read-only list or describe command
for the exact product and resource handle.

## Allowed Actions

- List or describe accessible Pages projects, Workers, routes, zones, DNS
  records, Access applications, tunnels, storage resources, and analytics
  metadata.
- Run local builds, validation, and dry runs that cannot modify Cloudflare.
- Draft commands, API requests, or infrastructure changes without applying them.

## Approval-Gated Or Denied Actions

Require explicit authority for deploys; DNS, route, WAF, Access, SSL/TLS, tunnel,
secret, token, certificate, storage, permission, billing, or public-exposure
changes; and destructive operations. Printing or exporting secret values and
using a different account are denied.

## Stop Rules

Stop on account mismatch, stale auth, insufficient scope, ambiguous zone or
environment, missing authority, or unsafe secret handling.

## Reporting Requirements

Report profile id, account id, resource handle, interface, verification evidence,
action class, product area, scope failures, and skipped gates.

# Cloudflare Access

Use this service context before inspecting or operating Cloudflare resources for
the public site, preview site, analytics proxy, or n8n edge.

## Boundary

This context owns Cloudflare account selection, approved interfaces,
verification, credential references, and action gates. Pages deployment,
analytics, and n8n implementation procedures remain with their respective
repository domains.

## Profile

| Target | Profile | Default interface |
| --- | --- | --- |
| ABPIV public, preview, analytics, and Lobst3rs resources | [`abpiv-personal-brand`](profiles/abpiv-personal-brand.md) | [`wrangler-cli`](interfaces/wrangler-cli.md) |

No profile is selected by a personal login identity. The stable account id and
repository resource handles are authoritative.

## Credential Boundary

Use Wrangler authentication or a scoped API token held outside Git. Cloudflare
Access service-token values, API tokens, tunnel credentials, private keys, and
session material follow the shared
[`secret boundary`](../../references/secret-boundary.md).

## Default Gates

- Account visibility, resource listing and description, local validation, and dry
  runs are allowed when in task scope.
- DNS, routing, WAF, Access, Pages or Worker deployment, secrets, tunnel,
  storage, permission, billing, and public-exposure changes require explicit
  authority for the exact effect.

Stop if the account is not visible, the selected account id differs, scope is
insufficient, or diagnosis would expose a credential value.

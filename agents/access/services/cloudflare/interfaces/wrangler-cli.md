# Wrangler CLI Interface

## Purpose

Use Wrangler for read-only account verification, local validation, and
task-authorized Cloudflare developer-platform operations.

## Inputs

| Layer | Source | Use |
| --- | --- | --- |
| Stable service context | [`../CONTEXT.md`](../CONTEXT.md) | Service-wide gates |
| Stable profile | [`../profiles/abpiv-personal-brand.md`](../profiles/abpiv-personal-brand.md) | Exact account and repository resources |
| Runtime binding | Wrangler auth or shell-scoped `CLOUDFLARE_API_TOKEN` | Credential value outside Git |

## Process

1. Confirm `wrangler` is available.
2. Run `wrangler whoami --json`.
3. Confirm the returned account list contains
   `c4641560f98108d80fe5dd892cd2ef14`.
4. Select that account explicitly through supported command options, config, or
   shell-scoped `CLOUDFLARE_ACCOUNT_ID`.
5. Prefer local validation, dry runs, lists, and descriptions.
6. Confirm explicit authority before deploys or any DNS, routing, WAF, Access,
   secret, storage, permission, public-exposure, or billing change.

## Stop Rules

Stop if Wrangler is unavailable, auth is stale, the account id does not match,
token scope is insufficient, or diagnosis would expose auth files, tokens, or
private headers.

## Reporting

Report the selected profile and account id, visible account label when returned,
Wrangler version, commands, action class, product area, scope failures, and
skipped gated actions.

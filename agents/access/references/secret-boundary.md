# Secret Boundary

## Tracked Files May Contain

- Service names, profile ids, public hostnames, account ids, project ids, regions,
  and public site handles.
- Required credential names, environment-variable names, header names, local
  binding keys, and role or scope names.
- Read-only verification commands that do not print secret values.
- Allowed actions, approval gates, stop rules, and reporting requirements.

## Tracked Files Must Not Contain

- API keys, bearer tokens, passwords, private header values, refresh tokens,
  OAuth client secrets, recovery codes, private keys, or service-account key JSON.
- Google ADC files, Cloudflare API token values, Access service-token values,
  tunnel credentials, decrypted n8n credentials, browser cookies, or session ids.
- Raw `.codex-local/` files, copied client configuration, secret-bearing command
  output, execution payloads, or private logs.

## Runtime Locations

Use Google Cloud SDK authentication, Wrangler authentication, platform-native
secret stores, OS credential storage, shell-scoped variables, or ignored local
bindings described in [`local-bindings.md`](local-bindings.md).

`.codex-local/` is machine-local Layer 4 state. Normal repository work may verify
that it is ignored, but must not read, link, stage, log, or copy its contents.

## Reporting Rule

Report whether a named credential or binding is present, missing, expired, or
insufficient. Never report its value, prefix, full request headers, session id, or
the contents of a local binding file.

# External Service Access

This folder is the credential-free source of truth for selecting external service
targets used by this repository.

Access context answers:

- Which service profile is the intended target?
- Which interface is approved?
- How must the target be verified before work?
- Which actions are read-only, approval-gated, or denied?
- Which credential names or local binding keys are required?
- What evidence must be reported after access is used?

## Current Profiles

| Service | Profile | Stable handle |
| --- | --- | --- |
| Google Cloud | [`abpiv-personal-brand`](services/google-cloud/profiles/abpiv-personal-brand.md) | Project `abpiv-personal-brand` |
| Cloudflare | [`abpiv-personal-brand`](services/cloudflare/profiles/abpiv-personal-brand.md) | Account `c4641560f98108d80fe5dd892cd2ef14` and Pages project `abpiv-personal-brand` |
| n8n | [`workflows-lobst3rs`](services/n8n/profiles/workflows-lobst3rs.md) | `workflows.lobst3rs.com` |

## Use Pattern

1. Resolve the exact profile through [`ROUTING.md`](ROUTING.md).
2. Read the service context, selected profile, and interface contract.
3. Resolve credentials through ignored local bindings or a platform-native secret
   store.
4. Run the profile's read-only identity and target checks.
5. Confirm the requested action class is authorized.
6. Report the target, interface, checks, side-effect class, and any stopped or
   skipped action without exposing secrets.

## Boundaries

- Stable handles, public hostnames, credential names, binding keys, scopes, and
  verification commands belong here.
- Runtime procedures belong with their implementation or reusable skill.
- MCP transport and exposed-tool behavior belongs under
  [`mcp-servers/`](../mcp-servers/README.md).
- Harness-specific mapping belongs under
  [`adapters/`](../adapters/README.md).
- Tokens, passwords, private header values, key material, raw local config, and
  decrypted credentials never belong in tracked files. See the
  [`secret boundary`](references/secret-boundary.md).

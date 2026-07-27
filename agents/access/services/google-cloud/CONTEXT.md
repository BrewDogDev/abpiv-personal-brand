# Google Cloud Access

Use this service context before inspecting or operating Google Cloud resources
owned by this repository.

## Boundary

This context owns target-project selection, approved interfaces, verification,
credential references, and action gates. Infrastructure procedures remain in
[`infra/analytics/`](../../../../infra/analytics/README.md) and
[`infra/n8n/`](../../../../infra/n8n/README.md).

## Profile

| Target | Profile | Default interface |
| --- | --- | --- |
| ABPIV personal brand production resources | [`abpiv-personal-brand`](profiles/abpiv-personal-brand.md) | [`gcloud-cli`](interfaces/gcloud-cli.md) |

No other Google Cloud profile is authorized by this repository access context.

## Credential Boundary

Use Google Cloud SDK authentication, Application Default Credentials, or approved
service-account impersonation. Store values outside Git under the shared
[`secret boundary`](../../references/secret-boundary.md).

Never commit service-account keys, ADC files, refresh tokens, OAuth client
secrets, private keys, or secret payloads.

## Default Gates

- Read-only account, project, service, resource, IAM-metadata, and log-metadata
  inspection is allowed when it is within the active task.
- Drafting commands and plans is allowed.
- Resource mutation, IAM, API enablement, billing, data movement, deployment,
  public access, interactive sessions, and secret access require explicit
  authority for the exact effect.

Stop if authentication is stale, the active or explicit project differs from the
selected profile, scope is insufficient, or a secret would need to be exposed.

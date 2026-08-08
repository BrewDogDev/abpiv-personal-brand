# ABPIV n8n OpenTofu

This root manages the current Cloud Run/Cloud SQL stack, the additive private Compute runtime, Cloudflare security, and the staged transition between them. State remains in the private `abpiv-personal-brand-opentofu-state` bucket under `infra/n8n`.

## State model

| Phase | Inputs | Permitted effect |
| --- | --- | --- |
| IAM bootstrap | `runtime_origin=cloud_run`, `legacy_stack_enabled=true`, exact target list | Create only the Compute runtime service account, the exact missing deployer project roles, and the deployer's service-account-user bindings on the Compute and Plausible runtime identities. No VM, data, Tunnel, routing, or DNS resource is targeted. |
| Preparation | `runtime_origin=cloud_run`, `legacy_stack_enabled=true` | Create only the shared VM, independent n8n and Plausible data disks, NAT, n8n backup bucket and Tunnel, VM identity/IAM, Plausible secret metadata, and required APIs. |
| Cutover | `runtime_origin=compute`, `legacy_stack_enabled=true` | Update only the forms and editor DNS records from the load-balancer IP to the Tunnel CNAME. |
| Decommission arm | `runtime_origin=compute`, `legacy_stack_enabled=true`, `legacy_cloud_run_min_instances=0`, `legacy_destruction_armed=true` | Update only Cloud SQL's Terraform deletion-protection flag; this must be written to state before removal without restarting Cloud Run. |
| Decommission delete | `runtime_origin=compute`, `legacy_stack_enabled=false`, `legacy_destruction_armed=false` after arming was applied | Delete only the exact reviewed legacy allowlist while retaining the Compute path and Cloudflare security. |

The defaults select preparation. `migrations.tf` moves existing singleton state addresses to their conditional `[0]` addresses so the first preparation plan does not recreate the old stack. Apply those moves while `legacy_stack_enabled=true`.

`../tools/assert-plan-allowlist.py` must inspect the JSON form of every saved plan before apply. It rejects replacements, unexpected updates, unexpected creates, and unexpected destroys. For DNS, Cloud Run rollback, and Cloud SQL arming/protection, it also inspects before/after values and permits only the exact attributes and directions required by that phase. The IAM bootstrap, additive preparation, and decommission each use separate plan/apply dispatches. Bootstrap is target-only and binds apply to the reviewed commit, sorted action-manifest hash, and the deterministic `../tools/canonical-plan-values.py` digest of resolved non-sensitive values plus unknown-value structure. Preparation then proves the deployer already has every effective apply permission—including on the newly bootstrapped Compute identity—and uses the same three bindings. The decommission manifest binds the reviewed commit and action list plus the round-trip-verified migration prefix and checksum-manifest digest and deletion of objects from the exact old binary bucket.

## Retained target resources

- Existing VPC and subnet
- Private `abpiv-runtime-vm`, Cloud Router/NAT, IAP-only SSH firewall, and independent non-auto-delete n8n and Plausible data disks
- VM runtime service account with only Secret Manager, backup/legacy-object, logging, and monitoring access
- Private versioned backup bucket with seven-day retention and lifecycle
- Existing n8n secrets plus Plausible secret containers for the unchanged key, database password, existing Tunnel token, and backup age identity
- Cloudflare Tunnel, WAF, rate limiting, Access application, and MCP service token
- GitHub OIDC deployer and narrowed Compute-era roles

## Conditional legacy resources

- Cloud Run runtime and its obsolete runtime service account/IAM
- Cloud SQL database and private-service connection/range
- Serverless VPC connector and serverless NEG
- HTTPS load balancer, forwarding rule/IP, Certificate Manager resources, and Cloudflare certificate-authorization records
- Old GCS binary-data bucket

The VPC/subnet, Secret Manager values, new backup bucket, Cloudflare security controls, and GitHub OIDC identity are never part of the legacy destruction allowlist.

## Authentication and secrets

Google uses Application Default Credentials locally or Workload Identity Federation in Actions. Cloudflare reads `CLOUDFLARE_API_TOKEN` from the environment. Never use service-account key files.

OpenTofu creates secret containers and IAM only. It does not contain runtime secret versions, output the Tunnel token, or persist secret values in plans or repository files. The Cloudflare Access client-secret output remains sensitive and is handled by the existing approved workflow path.

The deployer receives `roles/iam.serviceAccountUser` on both the new shared VM identity and the existing `plausible-analytics-vm` identity so the reviewed cutover can use OS Login through IAP on the two exact hosts. This does not grant either runtime identity access to the other runtime's data.

## Commands

For offline structure and safety tests:

```bash
tofu fmt -check -recursive infra/n8n/opentofu
tofu -chdir=infra/n8n/opentofu init -backend=false -input=false
tofu -chdir=infra/n8n/opentofu validate
tofu -chdir=infra/n8n/opentofu test
```

Live full-root plans and applies use the gated workflows because they bind all production variables, authenticate through OIDC, and enforce phase-specific action allowlists. Do not apply this root from a local shell.

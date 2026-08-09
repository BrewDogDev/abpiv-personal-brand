# ABPIV n8n infrastructure

This directory owns ABPIV's n8n runtime and the shared private Compute Engine host used by the target n8n and Plausible stacks. n8n and Plausible remain isolated Docker projects with independent data disks, networks, loopback listeners, Tunnel connectors, secrets, backups, and runtime modes. OpenTofu state remains at `infra/n8n`; the existing analytics root continues to own the old Plausible VM and Cloudflare analytics edge during rollback.

The detailed host, migration, backup, acceptance, and rollback runbook is [`compute/README.md`](compute/README.md). The independent production review checklist is [`compute/CUTOVER-REVIEW.md`](compute/CUTOVER-REVIEW.md).

## Staged architecture

Before cutover, the live path remains:

```text
Cloudflare security -> Google HTTPS load balancer -> Cloud Run -> private Cloud SQL
```

The additive preparation creates this stopped path without changing production DNS:

```text
Cloudflare Tunnel -> 127.0.0.1 Nginx
                            |
                     internal n8n network
                       |              |
                      n8n      PostgreSQL 16

Existing Plausible Tunnel -> 127.0.0.1:8000 Nginx
                                    |
                           internal analytics network
                         Plausible / PostgreSQL / ClickHouse
                            same private VM
```

The target VM is `abpiv-runtime-vm` in `us-east1-c`, initially `e2-custom-medium-6144` (1 sustained shared-core vCPU, 6 GiB), with `e2-standard-2` as the only automated fallback. It has a 20 GiB boot disk, a 30 GiB non-auto-delete n8n data disk, and an independent 80 GiB non-auto-delete Plausible data disk. It has no public IP. Cloud NAT is outbound-only; IAP with OS Login is the sole SSH path, and Cloudflare Tunnel is the sole application ingress path.

The production hostnames remain:

- `forms.allanbpediniv.com`, restricted to public form and production webhook paths by Cloudflare and Nginx
- `workflows.lobst3rs.com`, protected by Cloudflare Access and n8n login

Cloudflare WAF, rate limits, Access, MCP service token, hostnames, webhook/editor URLs, timezone, and the existing n8n encryption key are retained.

## Safety defaults

OpenTofu defaults to:

```hcl
runtime_origin       = "cloud_run"
legacy_stack_enabled = true
compute_machine_type = "e2-custom-medium-6144"
```

That combination is additive. `runtime_origin=compute` changes only the two Cloudflare DNS records when the prepared infrastructure is otherwise current. `legacy_stack_enabled=false` is reserved for the separately reviewed destructive dispatch. A configuration check prevents selecting the removed Cloud Run origin.

## Workflows

- `n8n-validate.yml`: both runtime contracts, shell/static validation, Compose validation, OpenTofu tests, plan-allowlist tests, and the pinned Plausible restore rehearsal.
- `n8n-iam-bootstrap.yml`: two-dispatch, target-only bootstrap for four required Google APIs, the new Compute runtime identity, the exact missing deployer project roles, two service-account-user bindings, the two repository-scoped Workload Identity bindings on the dedicated n8n deployer, and the 19 declared legacy singleton state-address moves that OpenTofu requires in every targeted plan until they are recorded. Plan evidence and apply are bound to the exact commit, action manifest, state-move manifest, and canonical non-sensitive plan values; the move targets may not change the live legacy resources.
- `n8n-apply.yml`: two-dispatch additive preparation. `plan` first proves the deployer already has the required effective permissions, then publishes redacted evidence plus action and non-sensitive plan-value hashes; a later `apply` must use the same reviewed commit and match both regenerated hashes.
- `n8n-redeploy.yml`: separately gated Tunnel-token storage and stopped-host provisioning, or an in-place release deployment that preserves runtime mode.
- `n8n-fresh-cutover.yml`: approval-gated fresh-start production cutover for cases where the legacy n8n database and binary data are intentionally abandoned. It installs the exact reviewed runtime release, requires the target to be stopped and match the pinned clean-start database/filesystem baseline, starts and verifies the private runtime, and changes only the two production DNS records to the managed Tunnel. An Access-authenticated target-only health probe must cross Cloudflare before commit; any precommit failure restores the Cloud Run origin before attempting to stop the target.
- `plausible-redeploy.yml`: additive stopped-host Plausible provisioning or an in-place mode-preserving release deployment.
- `plausible-cutover.yml`: imports the unchanged old runtime secrets without printing them, moves the existing Tunnel connector, encrypts and transfers the complete old dataset, compares PostgreSQL and ClickHouse counts plus application-state checksums, observes the shared host, and stops—but never deletes—the intact old VM only after acceptance.
- `n8n-cutover.yml`: independently reviewed 60-minute maintenance-window migration that first requires the sole traffic-serving Cloud Run revision and prepared target to use the same immutable n8n digest, with minute-45 rollback, combined-host observation, and `e2-standard-2` fallback.
- `n8n-decommission.yml`: two-dispatch review/apply flow that round-trip verifies the complete retained migration package and binds its prefix/digest, the reviewed commit, exact legacy destruction allowlist, and legacy binary-object removal into one reviewed manifest.
- `n8n-fresh-decommission.yml`: separate two-dispatch review/apply flow for an explicitly accepted fresh-start cutover. It proves Cloud Run is manually disabled at zero or already absent during a partial-decommission retry, never reads or preserves the intentionally abandoned Cloud SQL or legacy bucket data, and binds the reviewed commit plus exact legacy destruction allowlist. Apply retains the six deletion roles through external resource-absence checks, then removes only those obsolete grants and proves full convergence. A failed or cancelled permission phase strictly restores only missing members of those six grants so a reviewed retry remains possible.

GitHub Actions authenticates to Google through OIDC. No service-account key belongs in GitHub or this repository.

## Required repository configuration

| Name | Type | Expected purpose |
| --- | --- | --- |
| `N8N_GCP_PROJECT_ID` | variable | `abpiv-personal-brand` |
| `N8N_GCP_REGION` | variable | `us-east1` |
| `N8N_GCP_ZONE` | optional variable | `us-east1-c`; workflows use this exact fallback when absent |
| `N8N_GCP_SERVICE_ACCOUNT` | variable | Dedicated GitHub OIDC deployer: `n8n-github-deployer@abpiv-personal-brand.iam.gserviceaccount.com` after its reviewed Workload Identity bootstrap |
| `N8N_GCP_WORKLOAD_IDENTITY_PROVIDER` | variable | Workload Identity provider resource name |
| `N8N_GITHUB_OIDC_PRINCIPAL_SET` | variable | Exact repository-scoped principalSet derived from the provider and `BrewDogDev/abpiv-personal-brand` |
| `CLOUDFLARE_ACCOUNT_ID` | variable | Account that owns Tunnel and Access |
| `CLOUDFLARE_ZONE_ID_ALLANBPEDINIV` | variable | Forms-hostname zone |
| `CLOUDFLARE_ZONE_ID_LOBST3RS` | variable | Editor-hostname zone |
| `N8N_EDITOR_HOSTNAME` | variable | `workflows.lobst3rs.com` |
| `N8N_EDITOR_ZONE_ID` | optional variable | Lobst3rs zone ID; falls back to `CLOUDFLARE_ZONE_ID_LOBST3RS` |
| `N8N_EDITOR_ACCESS_ALLOWED_EMAILS` | variable | Reviewed JSON allowlist |
| `CLOUDFLARE_API_TOKEN` | secret | Cloudflare resource-management credential |

Optional Access organization, group, and hostname-zone-name variables remain documented in `opentofu/variables.tf`. The GitHub OIDC principal set is required by the bootstrap workflow so it cannot prepare an unusable dedicated deployer.

The live workflows also require these pre-created GitHub environments. Every environment must allow deployments only from `main` and require Allan's explicit approval; the workflows independently refuse non-`main` dispatches.

| Environment | Workflows |
| --- | --- |
| `production` | Reviewed IAM bootstrap, additive apply, and n8n/Plausible provisioning or release deployment |
| `production-plan` | IAM-bootstrap and additive-plan evidence plus legacy-decommission planning |
| `production-cutover` | Plausible and n8n maintenance-window cutovers |
| `production-destruction` | Exact hash-matched legacy n8n destruction only |

Runtime secret values remain only in Secret Manager:

- `abpiv-n8n-encryption-key`
- `abpiv-n8n-postgres-password`
- `abpiv-n8n-cloudflare-tunnel-token`
- `abpiv-plausible-secret-key-base`
- `abpiv-plausible-postgres-password`
- `abpiv-plausible-tunnel-token`
- `abpiv-plausible-backup-age-key`

The provisioning workflow obtains the Tunnel token directly from Cloudflare, writes it to a mode-0600 temporary file, adds it to Secret Manager, and deletes the file through a trap. It never asks an operator to copy, reveal, or retain the value.

## Fresh-start n8n cutover

Use `n8n-fresh-cutover.yml` only when the owner has explicitly accepted an empty target and does not require legacy users, workflows, credentials, executions, projects, settings, or binary data. Before DNS can move, the target must have no persisted application, binary, backup, or migration files and its database must be either virgin or exactly match the generated rows from the pinned n8n image with an unclaimed owner. The workflow does not read, back up, export, compare, or restore the Cloud SQL database or legacy binary-data bucket.

The cutover preserves the old Cloud Run, Cloud SQL, load-balancer, and storage resources. After the workflow succeeds, the owner must sign in through `workflows.lobst3rs.com`, complete first-user setup, recreate or import workflows and credentials, activate the intended workflows, and test the exact production form and webhook URLs. Generated URLs, internal ids, API tokens, and the n8n MCP bearer token may differ on the fresh instance.

Only after that manual acceptance should Cloud Run be manually disabled with zero instances. If Allan then explicitly authorizes destruction of the intentionally abandoned data and the complete legacy stack, use `n8n-fresh-decommission.yml` in `plan` mode, obtain `COMPLIANT / APPROVED / READY` for its exact commit and manifest digest, and use a later hash-bound `apply` dispatch. Do not use migration-oriented `n8n-decommission.yml` for a fresh start because it would inspect and require a retained migration package that intentionally does not exist.

## Local verification

Use an external OpenTofu data directory so provider artifacts never enter the repository:

```bash
pwsh -File infra/n8n/tests/compute-runtime-contract.ps1
pwsh -File infra/analytics/tests/shared-runtime-contract.ps1
tofu fmt -check -recursive infra/n8n/opentofu
export TF_DATA_DIR="$(mktemp -d)"
tofu -chdir=infra/n8n/opentofu init -backend=false -input=false
tofu -chdir=infra/n8n/opentofu validate
tofu -chdir=infra/n8n/opentofu test
find infra/n8n/compute/scripts infra/n8n/tools infra/analytics/compute/scripts -name '*.sh' -print0 | xargs -0 -n1 bash -n
shellcheck infra/n8n/compute/scripts/*.sh infra/n8n/tools/*.sh infra/analytics/compute/scripts/*.sh
docker compose --project-directory infra/n8n/compute --file infra/n8n/compute/docker-compose.yml config --quiet
docker compose --project-directory infra/analytics/compute --file infra/analytics/compute/docker-compose.yml config --quiet
bash infra/analytics/tests/restore-rehearsal.sh
```

Do not run a live plan, apply, secret operation, data movement, DNS change, workflow dispatch, form submission, or destruction without its recorded approval.

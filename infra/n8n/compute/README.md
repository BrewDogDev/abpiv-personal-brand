# Private Compute runtime

This directory defines the host-managed n8n runtime used after the approved cutover. It runs PostgreSQL 16, n8n, and Nginx in Docker on `abpiv-runtime-vm`; Cloudflare Tunnel is the only application ingress path. The VM has no public IP, Nginx binds only to `127.0.0.1:8080`, and neither n8n nor PostgreSQL publishes a host port.

## Safety states

The OpenTofu defaults are deliberately rollback-safe:

| State | `runtime_origin` | `legacy_stack_enabled` | legacy Cloud Run minimum | Effect |
| --- | --- | --- | --- | --- |
| Additive preparation | `cloud_run` | `true` | `1` | Creates the private VM path while production DNS and all rollback resources remain unchanged. |
| Cutover | `compute` | `true` | `1`, then quiesced out of band to `0` | Changes only the two proxied hostname records to the Tunnel. The old stack remains available for rollback. |
| Decommission | `compute` | `false` | `0` while arming | Deletes only the reviewed legacy allowlist after verified migration and explicit destructive approval. |

OpenTofu rejects `runtime_origin=cloud_run` when the legacy stack is disabled. The plan allowlist in `../tools/assert-plan-allowlist.py` rejects unlisted creates, changes, replacements, and deletes for every phase.

## Approval sequence

Never collapse these gates:

1. Publish the reviewed topic branch through the repository's preview flow.
2. After separate live-planning approval, dispatch `n8n-iam-bootstrap.yml` in `plan` mode with `plan-preparation-iam-bootstrap`. Preserve its permission evidence, redacted plan, exact commit SHA, sorted action manifest and SHA-256, and canonical non-sensitive plan-values file and SHA-256; this dispatch cannot apply infrastructure.
3. Give the IAM-bootstrap evidence to the independent rigorous reviewer. Require `COMPLIANT / APPROVED / READY` for the exact commit plus both manifest digests before requesting bootstrap apply approval.
4. Only after explicit IAM-bootstrap approval, dispatch `n8n-iam-bootstrap.yml` in `apply` mode with `apply-preparation-iam-bootstrap`, the review decision and identity, reviewed commit SHA, reviewed action-manifest SHA-256, and reviewed non-sensitive plan-values SHA-256. It regenerates and matches the target-only plan before creating only the reviewed identity and IAM resources.
5. Dispatch `n8n-apply.yml` in `plan` mode with `plan-private-shared-vm`. The workflow must prove the deployer now has every required GCP permission, including act-as and IAM-policy access on the new Compute runtime identity. Preserve the redacted plan evidence, permission-preflight evidence, exact commit SHA, sorted action manifest and SHA-256, and canonical non-sensitive plan-values file and SHA-256; this dispatch cannot apply infrastructure.
6. Give the additive-preparation evidence to the independent rigorous reviewer. Require `COMPLIANT / APPROVED / READY` for the exact commit plus both manifest digests before requesting additive-preparation approval.
7. Only after explicit additive-preparation approval, dispatch `n8n-apply.yml` in `apply` mode with `prepare-private-shared-vm`, the review decision and identity, reviewed commit SHA, reviewed action-manifest SHA-256, and reviewed non-sensitive plan-values SHA-256. The workflow repeats the permission preflight, regenerates the live plan, rejects any non-create drift, matches the commit and both manifests, and applies only that saved plan.
8. Separately approve the purpose-limited Tunnel-token lifecycle and host provisioning. Dispatch `n8n-redeploy.yml` with `provision`, `provision-private-n8n-vm`, and `store-tunnel-token`. The workflow reads the non-secret Tunnel ID from OpenTofu state; the token moves directly from Cloudflare API memory to Secret Manager through a mode-0600 temporary file, which is deleted by a trap.
9. Complete the independent rigorous review in `CUTOVER-REVIEW.md`. Continue only with `COMPLIANT / APPROVED / READY` and explicit cutover approval.
10. Provision the Plausible release in stopped mode, then run its separately gated cutover only after review. Its workflow proves the old PostgreSQL counts, ClickHouse counts, and application-state checksums match the target and leaves the intact old VM stopped for rollback.
11. Dispatch `n8n-cutover.yml` during the approved maintenance window with separate typed confirmations for runtime-secret access, data movement, and the two DNS changes, plus an existing `/form/...` path for a read-only public check. Before source backup or quiescence, it requires exactly one Cloud Run revision to serve all traffic, proves that revision's resolved digest matches the pinned n8n target image, and confirms that image is present on the private VM. It then creates an on-demand Cloud SQL backup, serves maintenance through the Tunnel, quiesces Cloud Run, exports and checksums the source, restores locally, compares every public-table count, proves stored-credential decryption without retaining plaintext, activates n8n, verifies public path controls and Access redirection, and observes the complete shared VM for at least 15 minutes.
12. Allan must then complete n8n login and read-only MCP initialization/tool-inventory checks without submitting a form or running a workflow. Only after those checks pass may `n8n-decommission.yml` run in `plan` mode. The workflow downloads every required object from the newest exact migration prefix, verifies that the checksum manifest names only the required package, and round-trip checks the complete PostgreSQL/binary package before planning. Give the exact commit, retained migration prefix and manifest digest, destruction action manifest, and SHA-256 to the same reviewer.
13. Only after that reviewer reconfirms the exact commit and manifest and explicit destruction approval is recorded, dispatch `n8n-decommission.yml` in `apply` mode with the reviewed commit SHA, reviewed manifest SHA-256, and `destroy-reviewed-legacy-n8n`. The workflow repeats the complete retained-package verification, matches the reviewed commit and regenerated manifest, writes Cloud SQL's deletion-protection flag to false in state, regenerates the full destruction plan, proves its action list is identical to the reviewed deletion list, and only then removes the old bucket objects and applies deletion.

Repository publication, IAM bootstrap, preparation, runtime secret access, source data movement, DNS cutover, and destruction remain separate approvals.

## Runtime operations

The data disk mounts by UUID at `/srv/n8n` and holds:

- `postgres/`: PostgreSQL data directory
- `state/`: n8n state
- `binary/`: n8n filesystem binary data
- `backups/`: temporary daily backup staging
- `migration/`: cutover packages and the pre-restore local rollback archive

The expected UUID is persisted in `/etc/abpiv-n8n/data-disk.uuid`. Runtime startup, backup, restore, migration, and observation fail closed unless that exact filesystem is mounted; they never fall back to similarly named directories on the boot disk.

The deployed release is under `/opt/abpiv-n8n`. Runtime secrets exist only in the VM's `/run` tmpfs:

- `/run/n8n/runtime.env`: the unchanged n8n encryption key and PostgreSQL password, retained only in host tmpfs and never passed to Docker as an `env_file`
- `/run/n8n/postgres.env`: a compatibility copy retained only in host tmpfs and never passed to Docker
- `/run/n8n/postgres-password`: a root-only transient copy bind-mounted read-only for PostgreSQL `_FILE` loading and source export
- `/run/n8n/encryption-key`: a root-only transient copy used by n8n's `_FILE` loader
- `/run/cloudflared/token`: the Tunnel token

These files are root-owned mode `0600`, regenerated from Secret Manager, removed in stopped mode, and never written into Git, OpenTofu inputs, command output, Docker container metadata, or durable host configuration. The n8n wrapper copies only process-readable values into container tmpfs. Its generated `/home/node/.n8n/config` is redirected through a symlink to that tmpfs, so the encryption key is not stored on the data disk or included in backups.

Docker startup installs a persistent `DOCKER-USER` drop rule for `169.254.169.254`, and every active or maintenance transition verifies it. Containers therefore cannot use the shared VM metadata endpoint to obtain the host service-account token or cross the n8n/Plausible secret and backup boundaries.

Host mode commands are:

```bash
sudo /opt/abpiv-n8n/scripts/runtime-mode.sh maintenance
sudo /opt/abpiv-n8n/scripts/runtime-mode.sh active
sudo /opt/abpiv-n8n/scripts/runtime-mode.sh stopped
```

Preparation always ends in `stopped`. Active mode enables restart-at-boot and the daily backup timer. On reboot, systemd reads `/etc/abpiv-n8n/mode` and restores that exact state, so a restore left in maintenance cannot become active implicitly. A normal release deployment preserves the current mode.

The Google Cloud Ops Agent publishes host memory and swap metrics. OpenTofu alert policies cover sustained CPU, memory, and swap thresholds. A one-minute host timer fails and emits a log-based alert event for any missing or unhealthy runtime container, and also reports kernel OOM or increased Docker restart counts; it never resizes automatically because resize remains approval-gated.

## Backup and recovery

`backup.sh` acquires the shared data-operation lock, serves maintenance, stops n8n, creates a PostgreSQL custom-format dump plus n8n state and binary-data archives, and then resumes n8n before uploading. It verifies the SHA-256 manifest both locally and after a round-trip download. Restore and migration use the same lock. The private GCS bucket has public-access prevention, uniform access, object versioning, a seven-day retention policy, and a seven-day deletion lifecycle.

Before any Cloud SQL deletion:

- the final migration package must be present in the backup bucket;
- its checksum manifest must have passed locally;
- the source and target public-table counts must match;
- the exact migration dump must have completed a disposable restore; and
- stored credentials must have been exercised through approved n8n login/read-only MCP acceptance using the unchanged encryption key.

The daily target is RPO 24 hours and RTO four hours. `restore-rehearsal.sh` proves the pinned PostgreSQL image can dump and restore fixture data without production secrets.

For disaster recovery, download one complete `daily/<timestamp>` prefix to a root-only directory, then run `restore-backup.sh` with `BACKUP_DIR` and the typed `restore-daily-abpiv-n8n` confirmation. The script verifies checksums and archive paths, creates a local pre-restore rollback package, restores PostgreSQL/state/binary data, and leaves n8n stopped behind maintenance mode for acceptance.

## Cutover and rollback

The migration must be green before minute 45 and the whole automated window must finish within 60 minutes. DNS is marked attempted before apply, so a zero-, one-, or two-record partial failure enters a fail-closed rollback. After restore, n8n is first booted and its credentials are decrypted behind maintenance. A read-only precommit Nginx state then allows form inspection while denying form submissions and every webhook write. The old origin remains the rollback target until these sealed checks pass; only then is the target marked canonical and write ingress opened. After that boundary, failures recover the target and never re-expose stale Cloud SQL. No legacy destruction is part of either recovery path.

Acceptance must confirm:

- source and target workflow, credential, execution, and all public-table counts match;
- binary archive checksums match;
- forms paths load while editor/API paths remain blocked on the forms hostname;
- automated editor Access redirection and stored-credential decryption pass, followed by Allan's manual n8n login and read-only MCP initialization/tool inventory;
- no workflow execution or form submission is performed without its own approval; and
- memory is below 75%, CPU below 70% of the live machine's sustained reserved-core entitlement (1 vCPU for `e2-custom-medium-6144`, 2 vCPU for `e2-standard-2`), sustained swap remains negligible (below 64 MiB), and both active Docker projects have no unhealthy container, OOM, or restart loop during the initial 15-minute observation.

If the initial VM misses a threshold, the approved cutover automation stops both projects safely, resizes the VM in place to `e2-standard-2`, restores their prior modes, and repeats acceptance and observation before destruction can be considered.

After cutover, request an approved in-place resize to `e2-standard-2` when any trigger occurs:

- memory above 80% for 15 minutes;
- any OOM termination or repeated container restart;
- swap above 256 MiB for five minutes; or
- CPU above 80% for 15 minutes or material request latency.

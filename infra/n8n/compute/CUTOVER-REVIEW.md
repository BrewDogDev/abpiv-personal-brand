# Independent rigorous cutover review

This is a review checklist, not an approval record. Complete it immediately before requesting the production maintenance window. The reviewer must be independent of the implementation and must inspect live plans and state rather than rely on this file.

## Evidence package

- [ ] Clean diff from the exact `origin/preview` base, with no Project-artifact or unrelated-file changes.
- [ ] OpenTofu format, initialization, validation, tests, and additive preparation plan all pass.
- [ ] Preparation plan contains only allowlisted creates; production DNS, Cloud Run, Cloud SQL, load balancer, and legacy bucket are unchanged.
- [ ] Exact Ubuntu image and all seven application/database/proxy container digests across the two isolated projects are recorded and resolvable for Linux amd64.
- [ ] The sole Cloud Run revision serving n8n source traffic resolves to the exact pinned target n8n digest, and that image is already present on the private VM before source backup or quiescence.
- [ ] VM has no external IP, no application firewall ingress, OS Login, IAP-only SSH, Shielded VM, and Cloud NAT.
- [ ] Both separate data disks are non-auto-delete, mount by UUID, and every data/runtime path fails closed when its expected UUID is absent.
- [ ] Compose proves isolated networks, loopback-only Nginx publication, health checks, restart policies, resource limits, and durable bind mounts.
- [ ] Secret-loading paths expose neither secret values nor durable secret files; Docker metadata contains only `_FILE` paths and n8n's generated config resolves to container tmpfs.
- [ ] Fixture backup/restore passes, and migration restore refuses a bad checksum or unsafe archive path.
- [ ] Plausible migration stops its writer, records stable source PostgreSQL and ClickHouse counts, archives application state, encrypts the complete package before transfer, restores all three data classes, and requires exact target count/checksum matches before activation.
- [ ] Plausible rollback restores the intact old VM and existing Tunnel connector on every partial transition failure; successful cutover stops but does not delete that VM.
- [ ] DNS cutover plan is exactly 0 add / 2 in-place changes / 0 destroy and touches only the two proxied hostname records.
- [ ] Source quiescence, database/binary counts, checksum, restore, and unchanged-encryption-key verification are executable.
- [ ] Minute-45 rollback runs after a partial DNS apply, fails closed on its exact-attribute allowlist, restores the load-balancer DNS path and Cloud Run minimum one, and ends with no OpenTofu drift.
- [ ] The 15-minute complete-host thresholds and approved `e2-standard-2` fallback are executable while preserving both runtime modes.
- [ ] Automated active checks prove a safe public form GET, forms-hostname API blocking, editor Access redirection, and in-memory credential decryption; Allan separately confirms n8n login and read-only MCP inventory before decommission planning.
- [ ] Decommission is a separate dispatch with Cloud Run retained at minimum zero, a complete retained migration-package round trip, a fresh full-root plan, exact-attribute Cloud SQL arming, strict destruction allowlist, exact reviewed commit and manifest-hash matches, and explicit destructive confirmation.
- [ ] Retained resources include VPC/subnet, VM/NAT/data disk, Secret Manager secrets, backup bucket, Cloudflare security resources, and GitHub OIDC identity.
- [ ] Deleted resources are limited to Cloud Run, Cloud SQL, serverless connector/NEG, HTTPS load balancer components, forwarding rule/IP, Google certificates/authorization records, obsolete runtime IAM/service account, private-service connection/range, and old binary bucket.

## Required decision

Proceed only when the reviewer records exactly:

`COMPLIANT / APPROVED / READY`

Anything else keeps cutover and destruction closed.

# Handoff: Live n8n And Plausible Single-VM Migration

## Metadata
- Date: 2026-08-07
- Goal: Complete the rollback-safe live migration of n8n and Plausible onto one private Compute Engine VM, prove all old data is present and usable on the target, and retire only the independently reviewed legacy n8n resources after explicit approval.
- Status: in-progress
- Workspace: `C:\Users\allan\.codex\worktrees\69f7\abpiv-personal-brand`
- Source of truth: the working tree on `codex/migrate-n8n-to-compute`, the runtime runbooks under `infra/n8n/compute/` and `infra/analytics/compute/`, the gated GitHub workflows, and this non-Project handoff

## Goal

Publish and execute the already implemented migration in separately approved stages. The target is one private `abpiv-runtime-vm` running isolated n8n and Plausible Docker projects, each with its own durable data disk, loopback Nginx ingress, Tunnel connector, secrets, runtime modes, backups, and recovery path.

The live cutovers must transfer and prove the complete source datasets before either target becomes the canonical writer. The legacy n8n stack may be destroyed only after target acceptance, a fresh full-root destruction plan, independent review of the exact allowlist, and Allan's explicit destructive approval. The old Plausible VM is retained intact and stopped after successful cutover; its deletion is not part of this implementation.

This effort uses Codex `/plan`, not repository Project control artifacts. Do not create, update, or resume `agents/context/projects/**` for this migration unless Allan explicitly reverses that instruction.

## Current State

- Branch: `codex/migrate-n8n-to-compute`.
- HEAD: `b4b6f34aa49fe875ab1eeed27452e01b49134630`.
- Local and remote `origin/preview` were both verified at that commit on 2026-08-07.
- The topic branch has no commits beyond its clean `origin/preview` base. All implementation remains in the working tree.
- Before adding this handoff, the implementation comprised 12 modified tracked paths and 83 untracked files represented by 13 untracked status entries. Nothing was staged.
- No implementation file has been committed, pushed, published, applied, provisioned, or deployed.
- No production secret was accessed, no production data was moved, no Tunnel or DNS route was changed, no VM was resized, and no legacy resource was destroyed during implementation or verification.
- An independent rigorous reviewer returned `COMPLIANT / APPROVED / READY` for the next separately approved additive-preparation gate, with no Critical, Important, or Minor findings.
- Public cloud and service state was not re-read for this handoff because no live-operation gate was opened. Treat all live service, IAM, GitHub environment, Cloudflare, and Google Cloud state as volatile and reverify it before acting.
- The protected file `C:\Users\allan\Documents\agent-git-projects\abpiv-personal-brand\Codex Image Aug 4, 2026, 08_43_20 AM.gif` still exists. The separate dirty worktree at `C:\Users\allan\.codex\worktrees\cloud-cost\abpiv-personal-brand` was not modified.

## Continuation Reverification

The continuation session reverified the following before any staging or publication:

- After a fresh fetch, local `HEAD` and current `origin/preview` still equal `b4b6f34aa49fe875ab1eeed27452e01b49134630`; the remote topic branch and topic pull request remain absent, and the real index remains unstaged.
- The complete tracked diff and all 84 untracked files were reread. The audit found and corrected six gate defects: Plausible started the target connector before stopping the old connector; additive preparation planned and applied inside one dispatch; five mutation workflows lacked an explicit main-branch guard if a referenced environment were absent; n8n cutover did not prove the live Cloud Run source used the same immutable n8n digest as the prepared target; destruction apply was not bound to the reviewed commit; and decommission checked only for a checksum-manifest object's existence rather than round-tripping the complete retained PostgreSQL/binary package. Contracts now assert connector ordering, two-dispatch commit/hash-bound preparation, main-only mutation, exact traffic-serving source/target digest equality before backup or quiescence, commit-bound destruction, and complete retained-package verification bound into the destruction manifest.
- The protected GIF remains present with SHA-256 `23ABC64A229292AC5EDA29EB25A853DDFCF1FC21795048CBBD03B273849440CB`. The separate `cloud-cost` worktree remains dirty and untouched.
- GitHub currently has only the `preview`, `production`, and `github-pages` environments. `production` requires reviewer `BrewDogDev`, permits self-review, and accepts only `main`. The workflow-referenced `production-cutover`, `production-plan`, and `production-destruction` environments do not exist and therefore must be created and protected before any corresponding dispatch.
- Core GitHub repository variables, OIDC/deployer variables, Cloudflare IDs, editor hostname/allowlist, and Cloudflare secret metadata are present. `N8N_GCP_ZONE`, `N8N_EDITOR_ZONE_ID`, `N8N_GITHUB_OIDC_PRINCIPAL_SET`, and `GCP_ZONE` are absent; current workflows default or fall back for the two zones and editor zone, while the OIDC principal-set input is optional. Reconcile the required-variable documentation and live settings before production use.
- Read-only public checks returned `200` for the n8n forms root, `302` for the Access-protected n8n editor and Plausible dashboard, and `200` for the same-origin Plausible script. No form, workflow, or analytics event was submitted.
- Google Cloud state could not be reverified because the configured `gcloud` account requires interactive reauthentication. Earlier suppressed-error probes were discarded and are not evidence that resources are absent. Allan must complete login/MFA before the live-state audit resumes.
- Fresh post-correction checks passed before the final gate audits: both PowerShell runtime contracts, six plan-allowlist unit tests, Bash syntax, ShellCheck 0.10.0, actionlint 1.7.7, both Compose configurations, every Nginx configuration, OpenTofu 1.10.6 formatting/initialization/validation/tests (four passed), Markdown local links, `git diff --check`, untracked whitespace/final-newline validation, and the targeted credential-shaped scan. The source-image gate and the commit/package-bound destruction gate each completed a witnessed four-violation red/green contract cycle. Final focused verification after every gate change passed both runtime contracts, all six allowlist tests, actionlint across all 12 workflows, local links across all eight changed Markdown files, `git diff --check`, all 84 untracked files' whitespace/final-newline checks, zero Project-path changes, and a high-confidence secret scan across all 97 changed/untracked paths. The disposable restore rehearsals were not repeated because no migration, backup, or restore implementation changed.
- Repository publication remains unauthorized. No file has been staged, committed, pushed, merged, deployed, applied, or dispatched in the continuation.

## Decisions And Rationale

- Use `e2-custom-medium-6144` initially, with `e2-standard-2` as the only automated fallback. The combined container limits are approximately 4.6 GiB before host overhead, so the proposed 3 GiB shared host cannot safely run n8n, two PostgreSQL databases, ClickHouse, Plausible, and both proxies.
- Keep the VM private: no public IP, IAP/OS Login for administration, Cloud NAT for outbound traffic, and Cloudflare Tunnel as the only application ingress.
- Keep n8n and Plausible isolated through separate Docker projects, internal networks, loopback ports, data disks, runtime secrets, Tunnel services, modes, backups, and evidence.
- Block containers from `169.254.169.254` through a durable `DOCKER-USER` rule so neither application can exchange a compromise for the shared VM service-account token.
- Keep secrets in root-only `/run` files and container tmpfs. Do not persist secret values in Git, OpenTofu plans, Docker environment metadata, durable application state, logs, or backups.
- Use two-phase cutover. Start and verify the restored application behind read-only precommit Nginx; deny n8n submissions/webhooks and Plausible event methods; mark the target canonical only immediately before opening writes. Precommit failures may restore the old source. Postcommit failures must recover the target and never expose stale source data.
- Serialize every shared-host mutation through `abpiv-shared-runtime-mutation` with cancellation disabled.
- Bound every container's local logs to 10 MiB times three files to protect the 20 GiB boot disk.
- Preserve complete data evidence: all PostgreSQL public-table counts, every ClickHouse table count, application-state manifests and checksums, n8n binary-object counts and checksums, and n8n stored-credential decryption with the unchanged key.
- Keep daily Plausible backups executable through the exact typed restore wrapper rather than treating archives as sufficient recovery evidence.
- Do not infer publication or production authority from Allan's approval to implement and safeguard the migration. Publication, preparation, secrets, data movement, routing, cutover, and destruction remain separate gates.

## Changes And Artifacts

- Added private shared-host OpenTofu resources and safety tests under `infra/n8n/opentofu/`, including `compute.tf`, `migrations.tf`, `monitoring.tf`, and `compute.tftest.hcl`.
- Added the n8n runtime, provisioning, migration, backup, restore, monitoring, precommit, and systemd package under `infra/n8n/compute/`.
- Added the Plausible runtime, PostgreSQL/ClickHouse/state migration, encrypted daily backup/restore, monitoring, precommit, and systemd package under `infra/analytics/compute/`.
- Added contract and migration-rehearsal tests under `infra/n8n/tests/` and `infra/analytics/tests/`.
- Added exact OpenTofu plan allowlists under `infra/n8n/tools/`.
- Added or revised gated automation in `.github/workflows/n8n-apply.yml`, `n8n-redeploy.yml`, `n8n-validate.yml`, `n8n-cutover.yml`, `n8n-decommission.yml`, `plausible-redeploy.yml`, and `plausible-cutover.yml`.
- Updated the n8n, analytics, OpenTofu, runtime, cutover, backup, and recovery documentation beside the implementations.
- Added this dated handoff and updated `agents/context/handoff/latest.md`. No Project artifact was changed.

## Verification

Fresh verification completed before handoff:

- n8n Compute runtime PowerShell contract: passed.
- shared Plausible runtime PowerShell contract: passed.
- Python OpenTofu plan-allowlist tests: 6 passed.
- Bash syntax over n8n, analytics, tool, and rehearsal scripts: passed.
- ShellCheck 0.10.0 over all runtime/tool scripts and the Plausible rehearsal: passed.
- actionlint 1.7.7 over GitHub workflows: passed.
- Docker Compose configuration for both projects: passed.
- `nginx -t` for every active, maintenance, precommit, and current config in both projects: passed.
- OpenTofu 1.10.6 format check, backend-disabled initialization, validation, and tests: passed; 4 tests passed and 0 failed.
- n8n pinned PostgreSQL disposable backup/restore rehearsal: passed.
- Plausible real-image encrypted migration and actual daily-package restore rehearsal: passed for PostgreSQL, every ClickHouse table, application state, and proxied readiness.
- Disposable Docker containers, networks, and exact rehearsal paths were removed.
- `git diff --check`: passed.
- Untracked-file whitespace/final-newline check: passed for 83 implementation files.
- Targeted credential-shaped scan found no secret value in the implementation diff. Matches were variable names, redacted loaders, or fixture-only values.
- No changed path existed under `agents/context/projects/` before this non-Project handoff was written.

Still missing because the corresponding gates remain closed:

- staged-diff review, commit, push, remote CI, or repository publication;
- a fresh live full-root OpenTofu plan against current remote state;
- GitHub environment-protection and repository-variable verification;
- live additive provisioning evidence;
- live Secret Manager, Cloudflare, Google Cloud, Tunnel, VM, DNS, Cloud Run, Cloud SQL, bucket, database, and workflow state verification;
- production data migration and source/target comparisons;
- active-runtime public acceptance, Allan's n8n login, and read-only MCP inventory;
- the independently reviewed post-cutover destruction plan and explicit destruction approval.

## What Worked

- Repeated fail-closed review found and corrected partial DNS, rollback, shared-VM resize, cross-runtime recovery, secret-persistence, metadata-access, backup, logging, and stale-writer failure paths before any live action.
- Running the pinned containers in a disposable Docker rehearsal exposed a ClickHouse table-enumeration bug that static review did not; the fixed rehearsal now proves every table rather than only the first.
- The two-phase read-only precommit state gives the old source a safe rollback window while preventing any post-write return to stale data.
- An actual encrypted daily backup was built, decrypted, and restored, so disaster recovery is executable rather than documentary.

## What Did Not Work

- `e2-custom-small-3072` is not a safe shared-host starting point for the combined runtime. The implementation uses the reviewed 6 GiB shared-core target instead.
- Treating a canonical-writer marker after active exposure allowed a stale-source rollback window; moving public read acceptance behind a write-blocking precommit Nginx state resolved it.
- Best-effort rollback and resize commands were insufficient on a shared VM because one runtime could leave the other stopped or create dual Tunnel connectors. Recovery now positively verifies isolation and restores captured modes.
- The linked handoff skill version was no longer installed; the current installed handoff procedure was used. No installed-cache path is persisted in repository artifacts.

## Remaining Work

1. Enter `/plan` in the continuation session and create a concise execution plan from this ordered list. Do not use Project planning or execution skills and do not change `agents/context/projects/**`.
2. Reverify the current worktree, branch, `origin/preview`, remotes, full diff, untracked file inventory, protected GIF, separate dirty consolidation worktree, and absence of staged or secret-bearing artifacts.
3. Obtain or confirm Allan's explicit repository-publication authorization. Only then stage the exact implementation and handoff paths, review the complete staged diff and safety scan, create one coherent commit, push `codex/migrate-n8n-to-compute`, and follow the repository's topic-to-`preview` policy. Do not merge or deploy implicitly.
4. Verify remote CI and the actual GitHub production environment protections, variables, OIDC identity, and service-account bindings. Stop on drift or missing protection.
5. Generate a fresh live full-root OpenTofu plan with current remote state and exact Cloudflare/Google Cloud access routing. The first accepted plan must be additive preparation only: shared VM, disks, NAT, identity/IAM, backup bucket, secrets metadata, monitoring, and Tunnel metadata while legacy origins and production routing remain unchanged. Stop on any unlisted update, replacement, deletion, Worker action, or production route change.
6. Return the exact additive plan and clean diff to an independent rigorous reviewer. The implementation reviewer was the Codex reviewer named Carver in the originating session. If that same reviewer cannot be resumed, stop and ask Allan whether a replacement independent reviewer is acceptable. Require `COMPLIANT / APPROVED / READY` before requesting preparation approval.
7. After explicit additive-preparation approval, apply only the reviewed plan. Provision n8n and Plausible releases in `stopped` mode, mount both disks by UUID, enforce metadata blocking and bounded logs, pre-pull exact images, validate Compose/Nginx/systemd, and run the disposable restore rehearsals. Record live evidence; keep production routing unchanged.
8. Obtain the separate approvals for purpose-limited runtime secret access, production data movement, Plausible Tunnel transition, n8n DNS transition, and the maintenance window. Never ask Allan to copy, paste, reveal, or retain a token; he handles only login/MFA when interactive access is required.
9. Run the Plausible cutover first through `.github/workflows/plausible-cutover.yml`. Quiesce the old writer, prove public maintenance, export and encrypt PostgreSQL, every ClickHouse table, and state, round-trip the package, restore and compare all evidence, perform read-only precommit acceptance, open event writes only after the canonical boundary, observe the shared host, create the first daily backup, and stop but do not delete the old VM. On any mismatch, keep writes closed or execute only the appropriate precommit/postcommit recovery path.
10. Run the n8n cutover through `.github/workflows/n8n-cutover.yml` only after Plausible is stable. First prove the sole traffic-serving Cloud Run revision has the same immutable n8n digest already present on the target VM; then create the on-demand Cloud SQL backup, quiesce Cloud Run, export/checksum/restore PostgreSQL and any binary objects, compare all required counts/checksums, prove credential decryption with the unchanged key behind precommit ingress, open writes only after the canonical boundary, verify public form/API/Access controls, observe the shared host, resize only through the reviewed fallback path if thresholds fail, and create the first verified backup.
11. Require Allan's manual n8n login and approved read-only MCP initialization/tool-inventory acceptance. Do not run a workflow or submit a form without its own approval.
12. Round-trip every required file in the exact retained n8n migration package, then generate a fresh full-root decommission plan and manifest binding that migration prefix/digest, the exact commit, and every destruction action. Return it to the same approved independent reviewer, obtain `COMPLIANT / APPROVED / READY`, then obtain Allan's explicit destructive approval tied to the reviewed commit and manifest hash. Only then run `.github/workflows/n8n-decommission.yml` to repeat the package proof and remove the allowlisted legacy n8n stack. Preserve the VM/NAT, both data disks, Secret Manager secrets, backup bucket, Cloudflare security, GitHub OIDC identity, and retained Plausible rollback VM.
13. Reverify backups, public behavior, old-resource absence, monitoring, Git state, and recovery commands. Record the final live outcome in a new dated non-Project handoff.

## Open Decisions Or Blockers

- Repository publication is not approved in the recorded state.
- No current live full-root plan or additive-preparation approval exists.
- GitHub environment protection was reverified and is incomplete: `production-plan`, `production-cutover`, and `production-destruction` do not exist. Current Google Cloud IAM/configuration remains unverified because the configured account requires interactive reauthentication.
- Secret access, data movement, Tunnel/DNS transition, maintenance-window cutover, and destruction approvals are not recorded.
- The originating independent reviewer may not be resumable from a fresh session. If unavailable, Allan must approve using a replacement reviewer before the relevant live gate.
- Production source data has not yet moved. The disposable rehearsals prove the mechanism, not the current production contents.

## Do Not Assume

- Do not treat the former Project records as active control state. This continuation uses `/plan` and this non-Project handoff.
- Do not assume the branch, remote, workflow, cloud, DNS, Tunnel, IAM, secret, VM, database, bucket, or service state is unchanged.
- Do not assume `COMPLIANT / APPROVED / READY` for implementation authorizes publication, a live plan, apply, provisioning, secret access, data movement, routing, cutover, destruction, merge, or deployment.
- Do not access or expose `.codex-local/`, secret values, tokens, database contents, credential plaintext, or private payloads.
- Do not ask Allan to copy, paste, reveal, or retain a Cloudflare token. Allan handles only login/MFA; the agent handles any explicitly approved temporary credential lifecycle in memory and revokes it immediately.
- Do not expose write paths until source/target evidence and sealed application readiness pass. After a target can receive writes, never roll back to stale source data.
- Do not delete old n8n infrastructure until the exact destruction plan is freshly generated, independently approved, explicitly authorized by Allan, and the target data/backup acceptance is complete.
- Do not delete the old Plausible VM as part of this plan.
- Do not use destructive Git commands, broad staging, force push, or a topic-branch pull request directly to `main`.
- Preserve every unrelated user/coordinator change, the dirty `cloud-cost` worktree, and the protected GIF.
- Do not redo completed implementation or disposable rehearsals unless live evidence or changed files make them stale.

## Fresh-Session Continuation Prompt

```text
Continue the goal "complete the rollback-safe live migration of n8n and Plausible onto one private Compute Engine VM, prove all old data is present and usable on the target, and retire only the independently reviewed legacy n8n resources after explicit approval" in C:\Users\allan\.codex\worktrees\69f7\abpiv-personal-brand.

First, enter /plan and use plan mode for a concise execution plan. Do not invoke Project planning or execution skills, and do not create, update, or resume agents/context/projects/**; this effort uses plans, not Projects.

Read C:\Users\allan\.codex\worktrees\69f7\abpiv-personal-brand\agents\context\handoff\2026-08-07-live-n8n-plausible-single-vm-migration-handoff.md completely. Then load AGENTS.md, agents/context/CONTEXT.md, agents/context/ROUTING.md, agents/context/GLOSSARY.md, agents/context/references/repository-map.md, agents/context/references/verification.md, agents/context/references/git-policy.md, infra/n8n/README.md, infra/n8n/compute/README.md, infra/analytics/README.md, infra/analytics/compute/README.md, and the exact gated workflows named in the handoff. Treat the handoff as working context, not unquestionable truth: verify current files, Git branches/worktrees/remotes, checks, approvals, external service state, GitHub environment protection, publication state, and protected changes before acting.

Resume from the ordered Remaining Work section, beginning with reverifying the branch and complete working-tree diff against current origin/preview and obtaining or confirming Allan's explicit repository-publication authorization before staging, committing, or pushing. Preserve every unrelated user change, the dirty cloud-cost worktree, and the protected GIF. Do not redo completed implementation or disposable restore rehearsals unless live evidence contradicts them. Keep publication, live planning, infrastructure preparation, secret access, data movement, Tunnel/DNS routing, cutover, workflow/form execution, destruction, merge, and deployment behind their separately recorded approvals. Ensure the complete old PostgreSQL, ClickHouse, binary, and application-state datasets are verified on the target before opening write paths, and never delete or re-expose a stale source outside the exact recovery and destruction gates. If state has changed, reconcile it, document the difference, and continue toward the goal.
```

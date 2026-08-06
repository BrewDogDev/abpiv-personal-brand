# Single-VM Personal Brand Runtime Consolidation Plan

## Planning Basis

- Goal: operate n8n and Plausible on one right-sized private Compute Engine VM with isolated Docker containers, preserve every public/private interface and recovery boundary, and retire the redundant n8n managed-service stack after a rollback-safe stabilization window
- Base state: clean isolated worktree on `codex/consolidate-n8n-compute-engine` from `origin/preview` commit `e002dbfa71c493528bd1e6be384e36b4005dce62`; the source checkout's unrelated untracked GIF remains outside this worktree and untouched
- Approval basis: the 2026-08-06 request authorizes creation and validation of this Project only; no Task execution, commit, publication, infrastructure mutation, secret access, data movement, cutover, or destruction is authorized until the owner explicitly approves the ready Project, and Tasks 07 and 08 retain additional action-time production and destructive gates
- Execution profile: controlled
- Profile rationale: the work changes a production/public runtime, databases, encryption-key binding, identity-protected ingress, money, DNS, data location, backup and restore, and destructive infrastructure state; recovery is possible but depends on ordered cutover and verified evidence
- Worker budget: 11 total implementers for nine planned Tasks plus one replacement each reserved for Tasks 01 and 07
- Concurrent worker limit: 2, restricted to the two repository-only waves whose owned paths and side-effect channels are explicitly disjoint
- Task refresh reserve: 2 replacement implementers included in the worker budget; no other replacement is authorized without replanning
- Reviewer budget: 10 total reviewers for nine independent-rigorous Task reviews plus one final integrated reviewer
- Full-suite run budget: 3 integrated runs, after repository implementation, after production cutover, and after decommission/final cleanup
- Wait-cycle budget: 12 total coordinator waits, allocated to authenticated inventory, production workflows, cutover observation, and post-decommission billing evidence
- Reasoning default: high
- Time or token target: no more than 13 active implementer-hours across initial attempts, measured from Task dispatch and return timestamps, plus an intentional seven-day stabilization interval and bounded external workflow waits
- Progress policy: review progress no later than each Task estimate; use twice the estimate as the hard fresh-agent threshold; permit at most one recorded bounded extension only for demonstrated acceptance-relevant progress or a safely uninterruptible operation; use coordinator timestamps, changed artifacts, check results, workflow states, and external operation identifiers as observable evidence
- Evidence reuse: allowed only when the claim, exact Git tree or external resource generation/revision, environment, relevant configuration, command, timestamp, and result are unchanged and complete; migration, restore, security-boundary, and destructive checks require fresh evidence at their named gate
- Execution: one bounded non-delegating implementer per Task; review follows each Task's recorded policy
- Control state: this file is the authoritative Task ledger and only the Project coordinator updates it
- Replanning: material changes to cost target, host count, data ownership, public interfaces, recovery targets, authority, or migration sequence return through proportional DDD and grill-me

## Shared Constraints

- End with exactly one permanent Compute Engine application VM; do not create a second permanent host or preserve Cloud Run as a steady-state fallback.
- Evolve the existing `plausible-analytics-vm` in place unless Task 01 proves in-place migration unsafe; preserve its resource identity even when documentation calls it the shared runtime host.
- Keep n8n, n8n PostgreSQL, Plausible, Plausible PostgreSQL, and ClickHouse in separate containers with explicit health checks, networks, volumes, ownership, and resource limits; do not merge the two application databases merely because both use PostgreSQL 16.
- Preserve same-origin analytics through `/_analytics/*`, n8n public form and production webhook paths, the private editor and dashboard Access gates, MCP service-token access, and Cloudflare WAF/rate limiting.
- Preserve the existing n8n encryption key unchanged and never expose secrets in Git, logs, Task records, diffs, command output, or temporary artifacts outside approved root-only or platform secret storage.
- Keep the VM private with IAP/OS Login administration and Cloudflare Tunnel application ingress; do not add a public application IP or broad inbound firewall rule.
- Treat the current analytics and n8n OpenTofu states as separate owners throughout migration; use explicit outputs/variables and origin-mode switches rather than cross-state ad hoc edits or manual state surgery.
- Preserve a tested rollback to the old n8n origin through the entire seven-day stabilization window; accept temporary dual-running cost during that bounded safety interval.
- Do not destroy Cloud Run, Cloud SQL, the load balancer, VPC connector, old n8n networking, or recovery data during cutover; Task 08 owns a later separate destructive gate.
- Retain final database and binary-data recovery artifacts after legacy compute removal, with documented lifecycle/retention instead of immediate deletion.
- Use test-first or evidence-first implementation for observable infrastructure, script, workflow, and configuration behavior; a successful parse alone does not prove migration or recovery behavior.
- Use exact staging and scope review; do not touch the unrelated source-worktree GIF, ignored local bindings, credential files, installed plugin caches, archived Projects, or legacy run history.
- No push, pull request, merge, production workflow dispatch, OpenTofu apply, service restart, DNS change, secret read, data movement, or deletion occurs without the authority recorded for that Task.

## Task Ledger

| Task | Outcome | Dependencies | Status | Wave | Attempt | Implementer | Review policy | Isolation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 01 | Establish authenticated cost, capacity, workload, data-size, recovery, and interface baselines and select the exact single-host capacity envelope. | None | planned | 1 | 0 | unassigned | independent-rigorous | Read-only external inventory plus Task-owned evidence; no repository implementation or mutation. |
| 02 | Implement reviewable shared-host Compute capacity and least-privilege IAM changes without applying them. | 01 | planned | 2 | 0 | unassigned | independent-rigorous | Owns host-facing GCP/IAM OpenTofu files; disjoint from Task 03's new runtime tree. |
| 03 | Create the shared Docker runtime with isolated n8n and Plausible application/data containers and deterministic local validation. | 01 | planned | 2 | 0 | unassigned | independent-rigorous | Owns new `infra/shared-host/` runtime files except Task 04's backup and migration subtrees. |
| 04 | Implement backup, restore, Cloud SQL export, binary-data transfer, and repeatable n8n recovery tooling with a disposable restore rehearsal. | 03 | planned | 3 | 0 | unassigned | independent-rigorous | Owns only `infra/shared-host/backup/` and `infra/shared-host/migration/`; no live data movement. |
| 05 | Implement a staged Cloudflare Tunnel origin switch that preserves n8n WAF, rate limits, Access, MCP, and the still-running legacy origin. | 02, 03 | planned | 3 | 0 | unassigned | independent-rigorous | Owns analytics/n8n origin and Cloudflare OpenTofu surfaces; disjoint from Task 04 tooling. |
| 06 | Replace provisioning and validation workflows and integrate migration-era operator documentation and canonical verification. | 02, 03, 04, 05 | planned | 4 | 0 | unassigned | independent-rigorous | Sequential workflow/documentation integration after all produced interfaces settle. |
| 07 | Execute an explicitly approved in-place VM preparation, n8n restore, reversible traffic cutover, and post-cutover verification without destroying the legacy origin. | 01, 02, 03, 04, 05, 06 | planned | 5 | 0 | unassigned | independent-rigorous | Sole writer to production runtime during cutover; all other Tasks and external mutations stop. |
| 08 | After seven stable days and separate destructive approval, retire redundant n8n managed resources and prove the reduced fixed run rate while retaining recovery artifacts. | 07 | planned | 6 | 0 | unassigned | independent-rigorous | Sole writer to legacy Google Cloud state; no concurrent infrastructure or DNS work. |
| 09 | Remove migration-only repository branches, finalize durable architecture/runbook context, and prove the final repository state matches the surviving single-VM runtime. | 08 | planned | 7 | 0 | unassigned | independent-rigorous | Repository-only cleanup after external state settles; no production mutations. |

## Task Outcomes And Interfaces

### Task 01: Establish the live baseline and capacity decision

- Owns: Task-local report/review evidence and a new non-secret architecture decision artifact under `infra/shared-host/` if the refreshed Task contract assigns it; no Project control state
- Consumes: Google Cloud profile `abpiv-personal-brand`, Cloud Run/Cloud SQL/Compute/Storage/Load Balancing/Billing metadata, Cloudflare route metadata, current Docker/VM metrics, n8n trigger inventory, repository configuration, and existing backup contracts
- Produces: exact pre-migration monthly and daily fixed-cost baseline by SKU; live resource inventory; VM CPU, memory, swap, disk, and container usage; n8n workflow-trigger classes; database and binary-data sizes; backup/restore gaps; selected VM machine type and disk envelope; downtime, RPO, RTO, and rollback assumptions ready for owner review
- Required capabilities: `cfo`, `agent-access-organization`, `domain-driven-consulting`, and `verification-before-completion`
- Work type: read-only investigation and consequential architecture decision
- Requirement and interface clarity: target architecture is fixed at one VM, while exact size, data volume, workflow triggers, and bill are intentionally evidence-dependent
- Consequence: under-sizing can cause public downtime or data loss; over-sizing can defeat the cost outcome
- Complexity: multiple billing SKUs, two application stacks, three databases, background-workflow behavior, and external ingress
- Isolation: all external access is read-only and explicitly targeted; only Task evidence or an assigned architecture artifact may change
- Verification strength: direct billing/resource/monitoring queries, database-size queries that do not expose records, Docker metrics, workflow-type inventory, and current endpoint checks
- Review risk: a missed workload or underestimated recovery requirement can invalidate every later Task
- Implementer selection: `deep` capability with `high` reasoning for cross-system evidence synthesis and a financially and operationally consequential sizing decision
- Reviewer selection: `deep` capability with `high` reasoning to rigorously challenge cost basis, missing workloads, capacity headroom, recovery assumptions, and source identity
- Acceptance: the baseline ties every material number to project, resource/SKU, period, source, and confidence; no secret or private payload is captured; the selected host envelope meets the Project cost target with at least 30% memory and 20% disk headroom under observed load; every n8n trigger is classified for continuous-runtime behavior; and blockers are explicit
- Evidence identity: repository commit, Google Cloud project, active account identifier, query period, resource names and generations/revisions, monitoring interval, Cloudflare account/zone handles, command/observation, timestamp, and producer
- Approval or stop gate: read-only inventory is allowed by the service profiles; stop on stale auth, project mismatch, permission failure, a need to inspect secret values or user payloads, or evidence that one VM cannot meet the target safely
- Coordination budget: up to 2 implementers including one replacement, 1 reviewer, 2 focused evidence passes, and 2 wait cycles
- Estimated implementer time: 45 minutes active
- Progress checkpoint and hard threshold: review at 45 minutes; transfer at 90 minutes unless one bounded authenticated query is safely completing
- Agent refreshes: one fresh attempt is reserved if authentication latency, context load, or external query visibility stalls the first attempt; handoff must record exact completed queries and omitted sensitive output

### Task 02: Implement shared-host Compute capacity and IAM

- Owns: host-facing GCP configuration under `infra/analytics/opentofu/` and n8n IAM bindings under `infra/n8n/opentofu/iam.tf`, plus focused tests/docs assigned by the refreshed Task
- Consumes: Task 01's selected machine type, disk envelope, host service-account handle, required Secret Manager and backup-bucket capabilities, existing VM identity, and current separate OpenTofu states
- Produces: variable-driven in-place VM capacity, least-privilege host access to approved n8n secrets and backup/object storage, monitoring metadata, and OpenTofu plans that do not replace the VM or mutate unrelated resources
- Required capabilities: `test-driven-development`, `agent-access-organization`, `software-delivery`, and `verification-before-completion`
- Work type: infrastructure-as-code implementation with no apply
- Requirement and interface clarity: exact inputs come from Task 01; state separation and existing VM identity are fixed
- Consequence: a replacement plan, excessive IAM, or disk error can create downtime, access escalation, or data loss
- Complexity: two OpenTofu states share one runtime identity while retaining separate application ownership
- Isolation: Wave 2 file ownership is disjoint from Task 03; no remote state or production mutation is allowed
- Verification strength: formatting/validation, focused structural tests, provider schema checks, and authenticated read-only plans when permitted
- Review risk: plan output can hide replacement, privilege expansion, or dependency-order defects
- Implementer selection: `deep` capability with `high` reasoning for state-aware infrastructure and IAM changes
- Reviewer selection: `deep` capability with `high` reasoning to rigorously trace resource identity, replacement risk, permissions, and plan evidence
- Acceptance: both OpenTofu roots format and validate; plans show only the selected in-place capacity/metadata/IAM changes and no unintended destroy/recreate; the VM remains private; no secret value enters configuration or output; and rollback to the original size/config is documented
- Evidence identity: exact Git tree, OpenTofu/provider lock identities, variable set with values redacted where sensitive, plan digest, targeted project/region/zone, timestamp, and producer
- Approval or stop gate: Project execution approval is required before edits; any apply, VM stop/start, IAM mutation, secret access, or state move remains prohibited in this Task
- Coordination budget: 1 implementer, 1 reviewer, 3 focused check passes, and 0 wait cycles
- Estimated implementer time: 75 minutes
- Progress checkpoint and hard threshold: review at 75 minutes; stop and replan at 150 minutes
- Agent refreshes: None; ambiguity in state ownership or replacement behavior returns to the coordinator instead of using another worker

### Task 03: Create the shared Docker runtime

- Owns: new `infra/shared-host/` runtime, Compose, host-service, configuration-template, and local-test files, excluding `backup/` and `migration/`
- Consumes: Task 01's capacity envelope and port/image decisions; existing Plausible Compose/Ansible behavior; existing n8n Cloud Run environment contract; and the fixed separate-database policy
- Produces: one deterministic runtime definition for n8n, n8n PostgreSQL, Plausible, Plausible PostgreSQL, ClickHouse, and Cloudflare Tunnel or its host-managed equivalent, with isolated networks/volumes, health checks, resource limits, root-only secret-file interfaces, and no public host bindings
- Required capabilities: `test-driven-development`, `software-delivery`, `systematic-debugging`, and `verification-before-completion`
- Work type: container runtime and provisioning implementation
- Requirement and interface clarity: container responsibilities and preserved endpoints are explicit; exact resource limits and image versions come from Task 01
- Consequence: network, volume, health-check, or secret-interface defects can cause public outage or corrupt data
- Complexity: six cooperating containers, two PostgreSQL services, ClickHouse, persistent volumes, startup ordering, and ingress isolation
- Isolation: Wave 2 changes only the new runtime tree; it neither changes OpenTofu nor touches production Docker
- Verification strength: `docker compose config`, schema/static checks, disposable-container health tests, network/port assertions, resource-limit assertions, and failure/restart scenarios
- Review risk: configuration can parse while silently sharing networks, exposing ports, using mutable images, or mishandling secrets
- Implementer selection: `balanced` capability with `high` reasoning for bounded but security- and data-sensitive multi-container work
- Reviewer selection: `deep` capability with `high` reasoning to rigorously trace network isolation, persistent data, images, startup, health, resources, and secret flow
- Acceptance: all containers validate and become healthy in a disposable environment; application databases and volumes are distinct; only intended local/tunnel paths reach application ports; secrets are referenced through root-only external files; images are versioned according to Task 01; and resource constraints fit the selected host envelope
- Evidence identity: exact Git tree, Compose config digest, container image digests, disposable environment identity, command results, health counts, timestamp, and producer
- Approval or stop gate: Project execution approval is required before edits; image pulls and disposable local containers are allowed only within the refreshed Task, while VM provisioning, secret reads, external traffic, and production changes are prohibited
- Coordination budget: 1 implementer, 1 reviewer, 3 focused check passes, and 0 wait cycles
- Estimated implementer time: 90 minutes
- Progress checkpoint and hard threshold: review at 90 minutes; stop and replan at 180 minutes
- Agent refreshes: None; an oversized runtime definition must be split by the coordinator rather than extended

### Task 04: Implement backup, restore, and migration tooling

- Owns: `infra/shared-host/backup/`, `infra/shared-host/migration/`, their tests/templates, and Task return artifacts
- Consumes: Task 03's container names, networks, volumes, secret-file interfaces, and health checks; existing Plausible backup template; Cloud SQL export and GCS binary-data interfaces; and Project RPO/RTO assumptions
- Produces: non-interactive, idempotent preparation and validation tools for final Cloud SQL export, n8n PostgreSQL restore, binary-data synchronization, daily backups for both stacks, integrity manifests, retention, and disposable restore rehearsal without embedding secrets
- Required capabilities: `test-driven-development`, `systematic-debugging`, `software-delivery`, and `verification-before-completion`
- Work type: data migration and recovery tooling implementation
- Requirement and interface clarity: data sources and destinations are known; live sizes and exact export method come from Task 01
- Consequence: defects can create unrecoverable credential, workflow, analytics, or binary-data loss
- Complexity: heterogeneous PostgreSQL/ClickHouse/GCS data, quiescence, ownership, integrity, encryption-key continuity, and restoration ordering
- Isolation: Wave 3 owns only backup/migration subtrees and uses disposable data; Task 05 owns all Cloudflare/OpenTofu origin changes
- Verification strength: fixture-driven test-first behavior, failure injection, idempotence checks, checksums/manifests, and complete restore into disposable containers followed by application-level queries/health checks
- Review risk: a backup can complete successfully yet be incomplete, secret-bearing, or unrestorable
- Implementer selection: `deep` capability with `high` reasoning for destructive-risk data semantics and recovery design
- Reviewer selection: `deep` capability with `high` reasoning to rigorously inspect data coverage, secret handling, quiescence, integrity, retention, failure modes, and restore evidence
- Acceptance: tooling produces integrity-checked artifacts for both application stacks; the n8n encryption key is consumed but never printed or archived insecurely; a disposable full restore passes; failures leave sources unchanged and return nonzero; retention preserves the final legacy recovery point; and documented steps support the RPO/RTO targets
- Evidence identity: exact Git tree, test fixture/artifact digests, tool versions, disposable container/image digests, check results, timestamp, and producer
- Approval or stop gate: Project execution approval is required before edits; no production database query, export, object copy, secret access, or retention mutation is allowed in this Task
- Coordination budget: 1 implementer, 1 reviewer, 4 focused check passes, and 0 wait cycles
- Estimated implementer time: 90 minutes
- Progress checkpoint and hard threshold: review at 90 minutes; stop and replan at 180 minutes
- Agent refreshes: None; any need for live data to prove tooling waits for Task 07 approval

### Task 05: Implement the staged Cloudflare origin switch

- Owns: Cloudflare Tunnel/origin configuration and migration-mode controls under `infra/analytics/opentofu/` and `infra/n8n/opentofu/`, including sequential edits to files previously stabilized by Task 02
- Consumes: Task 02's surviving resource/IAM interfaces, Task 03's local origin service names/ports, existing DNS/WAF/rate-limit/Access/service-token policies, and the current separate state boundaries
- Produces: default-compatible OpenTofu with explicit legacy and shared-host origin modes; Tunnel ingress for analytics, forms, and editor; CNAME/DNS behavior for the shared Tunnel; preserved n8n public/private policies; and a rollback mode that does not require reconstructing destroyed resources
- Required capabilities: `test-driven-development`, `agent-access-organization`, `software-delivery`, and `verification-before-completion`
- Work type: infrastructure-as-code ingress migration with no apply
- Requirement and interface clarity: hostnames, local origins, and policies are explicit; state-safe variable/output handoff must be implemented
- Consequence: a routing or Access error can expose the editor, bypass forms controls, break MCP, or interrupt all application ingress
- Complexity: one remotely managed Tunnel spans two zones and three hostnames while resources remain split across two states
- Isolation: Wave 3 owns only origin/OpenTofu surfaces and has no file or external-state overlap with Task 04
- Verification strength: structural tests for every ingress fallback and policy, default-mode no-op plan, target-mode plan, rollback-mode plan, link/output checks, and public/private path matrices without applying
- Review risk: generated plans can preserve DNS while subtly weakening Access or WAF expressions
- Implementer selection: `deep` capability with `high` reasoning for identity, public access, multi-state, and rollback-sensitive infrastructure
- Reviewer selection: `deep` capability with `high` reasoning to rigorously trace hostname, path, Access, service token, WAF, rate limit, Tunnel fallback, state ownership, and rollback
- Acceptance: default mode plans no unintended change; shared-host mode changes only intended Tunnel/DNS origin resources while preserving the legacy runtime; every public disallowed path remains blocked; private surfaces require the same identities/tokens; no secret is output; and rollback mode restores the former origin without resource recreation
- Evidence identity: exact Git tree, provider locks, non-secret input matrix, plan digests for default/target/rollback modes, policy assertions, target account/zones, timestamp, and producer
- Approval or stop gate: Project execution approval is required before edits; no Cloudflare, DNS, Access, Tunnel, OpenTofu state, or production origin mutation is allowed in this Task
- Coordination budget: 1 implementer, 1 reviewer, 3 focused check passes, and 0 wait cycles
- Estimated implementer time: 75 minutes
- Progress checkpoint and hard threshold: review at 75 minutes; stop and replan at 150 minutes
- Agent refreshes: None; a state conflict or inability to preserve controls returns to planning

### Task 06: Integrate workflows, validation, and migration-era documentation

- Owns: relevant `.github/workflows/`, `infra/analytics/README.md`, `infra/n8n/README.md`, shared-host operator documentation, and canonical repository-map/verification entries assigned by the refreshed Task
- Consumes: Tasks 02 through 05's exact configuration, runtime, migration, backup, origin-mode, and validation interfaces
- Produces: confirmation-gated shared-host provisioning/cutover/rollback/decommission workflow contracts; updated path-filter and validation coverage; minimal-permission OIDC/IAP/secret behavior; operator runbooks; and canonical routing/verification that distinguishes repository validation from production authorization
- Required capabilities: `test-driven-development`, `software-delivery`, `agent-context-organization`, and `verification-before-completion`
- Work type: deployment workflow, documentation, and cross-domain integration
- Requirement and interface clarity: predecessor Tasks publish exact commands and inputs; workflow actions remain manually dispatched and production-environment gated
- Consequence: workflow permission or quoting defects can leak secrets, run an unintended phase, or mutate production without the expected gate
- Complexity: multiple former workflows, inline legacy provisioning, new runtime artifacts, GitHub variables/secrets, and four operational phases
- Isolation: sequential integration after all predecessor repository interfaces settle; no live workflow dispatch
- Verification strength: workflow/YAML parsing, action and shell static checks, exact trigger/permission/confirmation assertions, dry-run command tests, OpenTofu/Compose/script suites, Markdown-link validation, and Git scope scans
- Review risk: a syntactically valid workflow can possess excessive authority or cross phase boundaries
- Implementer selection: `deep` capability with `high` reasoning for production workflow authority, secret flow, and cross-domain documentation
- Reviewer selection: `deep` capability with `high` reasoning to rigorously trace triggers, environments, permissions, inputs, secret handling, commands, rollback, docs, and verification claims
- Acceptance: repository validation covers every new artifact; production workflows require explicit typed confirmation and the `production` environment; phases cannot accidentally fall through; logs mask or avoid secret values; obsolete Cloud Run redeploy behavior is disabled or replaced without breaking rollback; all local links resolve; and the first full-suite run passes
- Evidence identity: exact Git tree, action/workflow versions, validation environment, command results, link counts, full-suite artifact identities, timestamp, and producer
- Approval or stop gate: Project execution approval is required before edits; workflow dispatch, environment approval, repository-setting mutation, commit, push, and publication are prohibited
- Coordination budget: 1 implementer, 1 reviewer, 4 focused check passes, 1 full-suite run, and 0 wait cycles
- Estimated implementer time: 90 minutes
- Progress checkpoint and hard threshold: review at 90 minutes; stop and replan at 180 minutes
- Agent refreshes: None; unresolved workflow authority or secret flow blocks execution

### Task 07: Execute the reversible production cutover

- Owns: approved production mutation sequence and Task-local evidence only; Project control state remains coordinator-owned
- Consumes: the reviewed repository head from Task 06, Task 01 baseline, approved OpenTofu plans, shared runtime/provisioning tools, verified recovery artifacts, owner-approved downtime/RPO/RTO, and exact rollback commands
- Produces: resized/prepared existing VM, healthy shared containers, restored n8n database and binary data, preserved encryption-key access, Cloudflare traffic on the shared Tunnel, passing analytics/n8n/MCP checks, a recorded rollback point, and the start timestamp for the seven-day stabilization window
- Required capabilities: `executing-tasks`, `agent-access-organization`, `systematic-debugging`, and `verification-before-completion`
- Work type: production infrastructure/data migration and traffic cutover
- Requirement and interface clarity: exact commands and expected plans come from reviewed predecessor artifacts; action-time live drift must be checked
- Consequence: production outage, data loss, credential decryption failure, access-control regression, or runaway cost
- Complexity: ordered VM stop/start, provisioning, data quiescence/export/import, binary delta sync, secrets, Tunnel/DNS, private/public checks, and rollback
- Isolation: exclusive production writer; no concurrent infrastructure, workflow, DNS, database, or container mutation is permitted
- Verification strength: fresh plan comparison, pre/post database and binary counts/checksums, container health, direct n8n/Plausible behavior, WAF/Access/MCP matrices, monitoring headroom, rollback drill, and exact external operation identifiers
- Review risk: success on a basic health endpoint can hide missing workflows, unreadable credentials, incomplete binaries, or bypassable access controls
- Implementer selection: `deep` capability with `high` reasoning for a consequential, weakly reversible, multi-system migration
- Reviewer selection: `deep` capability with `high` reasoning to rigorously challenge drift, data integrity, encryption continuity, ingress security, capacity, rollback readiness, and claimed acceptance
- Acceptance: every preflight passes; final artifacts are captured; n8n is restored with consistent row/object evidence and readable stored credentials; all containers and public/private interfaces pass; monitoring meets the initial envelope; rollback is demonstrably ready; legacy resources remain intact and recoverable; and no secret appears in evidence
- Evidence identity: exact approved Git commit, workflow run IDs/URLs, OpenTofu plan hashes, external resource generations/revisions, container image digests, backup manifest/checksums, cutover timestamp, endpoint matrix, monitoring interval, and producer
- Approval or stop gate: explicit Project execution approval plus immediate owner approval of the exact production plan, downtime, Secret Manager access, data movement, VM stop/start, provisioning, and Cloudflare cutover is mandatory; stop on drift, failed backup/restore evidence, insufficient headroom, access regression, or missing rollback
- Coordination budget: up to 2 implementers including one serial replacement, 1 reviewer, 3 focused evidence passes, 1 full-suite run, and 6 wait cycles
- Estimated implementer time: 120 minutes active plus bounded workflow/data-transfer waits
- Progress checkpoint and hard threshold: review at 120 minutes; transfer by 240 minutes only after any safely uninterruptible command completes and the prior writer records exact live state
- Agent refreshes: one replacement is reserved; the coordinator must stop the prior writer, prove no mutation remains in flight, write a dated Project-local handoff, and dispatch the unchanged Task serially

### Task 08: Decommission legacy n8n resources and verify savings

- Owns: approved legacy-resource retirement sequence, retained recovery-artifact lifecycle, budget/run-rate evidence, and Task-local report/review artifacts
- Consumes: seven complete stable days from Task 07, no unresolved Important/Critical findings, final legacy recovery artifacts, reviewed decommission plan, current billing/resource inventory, and explicit destructive approval
- Produces: removal of the n8n Cloud Run service, Cloud SQL instance, VPC connector, Google load balancer/certificates, superseded n8n VPC resources and unneeded runtime identity; intentionally retained secrets/backups/edge controls; post-decommission resource inventory; and measured/projected fixed run rate against the baseline
- Required capabilities: `executing-tasks`, `agent-access-organization`, `cfo`, `systematic-debugging`, and `verification-before-completion`
- Work type: destructive production infrastructure retirement and financial verification
- Requirement and interface clarity: exact resources derive from state and Task 07 evidence; retention and edge survivors are explicitly listed before apply
- Consequence: premature destruction can remove the only rollback or recovery path; incomplete destruction can miss the cost target
- Complexity: deletion protection, dependency ordering, split state, retained Cloudflare/secret/backup resources, billing delay, and final endpoint verification
- Isolation: exclusive legacy-state writer with all other external mutation stopped
- Verification strength: reviewed destroy plan, exact resource allowlist, final backup restore evidence, post-apply inventory, fresh endpoint and access checks, billing/SKU observations, and absence checks for every retired handle
- Review risk: broad destroy plans or delayed billing can conceal retained cost or unintended survivor deletion
- Implementer selection: `deep` capability with `high` reasoning for destructive state and cost evidence
- Reviewer selection: `deep` capability with `high` reasoning to rigorously trace the allowlist, retained recovery, deletion order, state, endpoint health, and savings calculation
- Acceptance: the stabilization window is clean; a final recovery artifact restores; the approved plan contains only allowlisted retirement actions; all named legacy compute/network/database resources are absent after apply; Cloudflare protections, runtime secrets, and retained backups survive; endpoints remain healthy; and the observed or exact-SKU projected run rate meets the Project threshold
- Evidence identity: exact approved Git commit, reviewed plan/destroy digest, state serials, workflow run and operation IDs, final resource inventory, retained artifact digests/retention, billing period/SKUs, endpoint matrix, timestamp, and producer
- Approval or stop gate: separate explicit destructive approval is mandatory after the seven-day evidence review; stop on any plan item outside the allowlist, failed restore, unresolved finding, missing retention, endpoint regression, or cost evidence that misses the target
- Coordination budget: 1 implementer, 1 reviewer, 3 focused evidence passes, and 4 wait cycles
- Estimated implementer time: 90 minutes active after the stabilization window
- Progress checkpoint and hard threshold: review at 90 minutes; stop and replan at 180 minutes
- Agent refreshes: None; a stalled or disputed destructive action blocks rather than transfers

### Task 09: Finalize repository state and durable operating context

- Owns: migration-only branches and toggles in affected infrastructure/workflow files, final shared-host and application READMEs/runbooks, canonical repository map/verification, and Task-local evidence; it does not own Project routing or archive state
- Consumes: Task 08's exact surviving resource inventory, final endpoints, retained recovery controls, billing result, and completed migration/decommission evidence
- Produces: a repository source of truth that describes only the surviving one-VM architecture, removes dead Cloud Run/Cloud SQL/load-balancer deployment paths without scheduling new external changes, preserves retained edge/secret/backup management, and documents operations, restore, upgrades, capacity, and cost checks
- Required capabilities: `test-driven-development`, `agent-context-organization`, `software-delivery`, and `verification-before-completion`
- Work type: post-migration infrastructure cleanup, documentation, and integrated verification preparation
- Requirement and interface clarity: the final external inventory from Task 08 is authoritative; no migration-era fallback remains live
- Consequence: stale definitions can recreate retired costs or mislead later operators; over-cleanup can orphan retained resources
- Complexity: two former infrastructure domains, workflows, state-aware removal, documentation, and canonical verification
- Isolation: repository-only and sequential after all external state settles; no production mutations or Task control edits
- Verification strength: no-op OpenTofu plans against final state, full validation suites, stale-resource/path scans, Markdown-link checks, secret/cache scans, exact Git scope, and final architecture-to-inventory comparison
- Review risk: a clean diff can still leave a deploy path that recreates expensive legacy resources
- Implementer selection: `deep` capability with `high` reasoning for final state reconciliation and durable operating safety
- Reviewer selection: `deep` capability with `high` reasoning to rigorously trace surviving ownership, no-op plans, workflows, recovery, docs, cost guardrails, and stale recreation paths
- Acceptance: no repository path can deploy or describe the retired managed stack as active; surviving Cloudflare/secret/backup resources remain managed; operator docs cover upgrade, backup, restore, monitoring, capacity, and cost review; all domain and agent validators pass; final no-op plans match live state; and the third full-suite run passes
- Evidence identity: exact final Git tree, live state serials/resource inventory from Task 08, no-op plan digests, validation environment and commands, link/stale-reference counts, full-suite artifacts, timestamp, and producer
- Approval or stop gate: Project execution approval covers local cleanup; commit, push, pull request, merge, publication, workflow dispatch, apply, or external mutation remains separately gated
- Coordination budget: 1 implementer, 1 reviewer, 3 focused check passes, 1 full-suite run, and 0 wait cycles
- Estimated implementer time: 90 minutes
- Progress checkpoint and hard threshold: review at 90 minutes; stop and replan at 180 minutes
- Agent refreshes: None; external-state mismatch returns the Project to replanning

## Integration And Reuse Obligations

- Canonical context, glossary, routing, Workflow, and repository docs: Tasks 06 and 09; add glossary terms only if execution proves they are durable beyond this Project
- Validated reusable procedures or operational knowledge: Tasks 04, 06, and 09 assess backup/restore, single-host provisioning, cutover, and cost-check procedures for promotion to the narrowest implementation owner; do not create a repository-wide agent Workflow unless repeated use is demonstrated
- Shared-host platform ownership: Tasks 02, 03, 06, and 09 must keep physical host state, runtime configuration, and application-specific contracts explicit without collapsing n8n and analytics domain ownership
- Cost evidence: Tasks 01 and 08 must preserve source, period, basis, confidence, and surviving-SKU assumptions without storing billing identifiers or private payloads unnecessarily
- Project-wide review and integrated verification: root `INTEGRATION_REVIEW.md`, created by the coordinator after every Task and review is complete; it is not a dedicated Task

## Checkpoints And Replanning

- Wave 1 is read-only and must settle exact cost, workload, data, recovery, and capacity inputs before implementation.
- Wave 2 is parallel-eligible: Task 02 owns existing host/IAM OpenTofu paths; Task 03 owns the new shared-runtime tree excluding backup/migration. They share no files, mutable external state, processes, credentials, locks, databases, or approval actions. Local dependency/image caches are read-mostly shared machine resources and Tasks must not run conflicting long-lived containers or package operations without unique project names.
- Wave 3 is parallel-eligible: Task 04 owns only backup/migration code and disposable data; Task 05 owns only OpenTofu origin/Cloudflare files. Both are repository-only, consume Task 03's frozen interfaces, and cannot access live data, secrets, state mutation, DNS, or production services.
- Waves 4 through 7 are sequential because they integrate shared files or mutate the same production runtime/state.
- Record completed Task identities, implementer attempts, progress and overrun observations, fresh-agent handoff paths, review-policy verdicts, evidence envelopes, budget actuals, deviations, and unresolved Minor findings in the ledger or corresponding Task section.
- At each progress review capture the current subgoal, exact changed state, checks/results, blocker or uncertainty, next action, and revised remaining estimate. Two observations without acceptance-relevant progress, a repeated failing approach without new evidence, no concrete next action, context pressure, or a hard-threshold breach triggers the recorded transfer or blocks the Task.
- Add dated amendments to `PROJECT.md` and revise this graph before dispatch when live evidence changes host count, sizing viability, cost target, domain ownership, interfaces, RPO/RTO, stabilization duration, rollback, acceptance, authority, dependencies, or destructive scope.
- Block, replan, or consolidate before exceeding the worker, refresh, reviewer, full-suite, or wait-cycle budget.

## Project Closure

- All ledger Tasks are `complete` and every independent-rigorous review and blocking revision passes.
- `INTEGRATION_REVIEW.md` traces the completion criteria to the final combined Git and external state and records coordination actuals within budget.
- Final fresh verification proves one surviving private Compute Engine application VM, healthy isolated containers, preserved public/private interfaces, recoverability, absence of retired cost-bearing resources, and the target fixed run rate.
- Durable documentation and validated reuse candidates are integrated into their canonical owners without inventing a recurring agent Workflow.
- A Project-local dated handoff records branch, commits, checks, external operation identities, retained backups, approval history, unpublished state, and any bounded monitoring follow-up.
- The coordinator removes the active route and moves the intact Project to `archive/<closure-date>-single-vm-runtime-consolidation/` only after closure evidence passes.

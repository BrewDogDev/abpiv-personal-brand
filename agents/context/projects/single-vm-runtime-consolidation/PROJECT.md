# Single-VM Personal Brand Runtime Consolidation

## Status

- Status: ready
- Owning context: `agents/context/`
- Branch or working state: isolated worktree on `codex/consolidate-n8n-compute-engine`
- Base: `origin/preview` at `e002dbfa71c493528bd1e6be384e36b4005dce62`
- Authorization: The user explicitly requested this Project on 2026-08-06 and selected one Compute Engine VM running multiple Docker containers as the target; this authorizes planning artifacts only, while implementation, production mutation, data movement, cutover, and decommissioning require later explicit approval.

## Outcome

The ABPIV personal-brand runtime operates on one right-sized private Compute Engine VM that runs isolated Docker containers for Plausible, n8n, their data services, and Cloudflare Tunnel ingress; the public analytics, forms, webhook, editor, and MCP interfaces continue to work; recoverability is demonstrated; and the redundant n8n Cloud Run, Cloud SQL, VPC connector, and Google load-balancer resources are retired only after a rollback-safe stabilization window, reducing the measured fixed Google Cloud run rate by at least 50% and to a target of no more than USD 60 per month before variable traffic.

## Non-Goals

- Replace n8n, Plausible, Cloudflare, or the public Docusaurus site.
- Change n8n workflow or form business behavior, Plausible event semantics, public hostname contracts, or the same-origin `/_analytics/*` collection boundary.
- Introduce multi-VM high availability, Kubernetes, a second permanent database host, or a second permanent application VM.
- Rename or recreate the existing `plausible-analytics-vm` merely to make its resource handle match the new logical role.
- Read, print, persist, or rotate secret values as part of planning.
- Apply infrastructure, resize or restart the VM, move production data, change DNS or Cloudflare Access, dispatch a production workflow, destroy resources, publish, merge, or push during Project planning.
- Purchase a committed-use discount before the consolidated architecture and measured utilization are stable.

## Domain-Driven Frame

### Decision

Decide and deliver the safest reversible path from separate always-on n8n managed services plus the existing Plausible VM to one cost-efficient personal-brand runtime host without weakening data ownership, ingress controls, recovery, or observable service behavior.

### Domain Area And Outcome

- Domain area: personal-brand runtime hosting, automation, analytics, edge ingress, data recovery, and cloud-cost governance
- Economic, user, or risk driver: remove redundant fixed Google Cloud charges while retaining reliable public forms, private workflow administration, same-origin analytics, and recoverable data
- Experts or decision owners: Allan Pedin for cost, downtime, retention, and production approvals; live Google Cloud and Cloudflare state for runtime truth; n8n and Plausible data contracts for migration correctness; repository infrastructure and workflows for intended state

### Ubiquitous Language

| Term | Meaning here | Other meaning or avoided alias |
| --- | --- | --- |
| Shared runtime host | The one private Compute Engine VM that supplies capacity, Docker, persistent disks, IAM identity, IAP administration, and outbound networking for both application stacks. | Not a shared application database or one combined container. |
| Application stack | One independently owned set of containers, networks, volumes, configuration, and health checks for n8n or Plausible. | Not a separate VM or Cloud Run service. |
| Cutover | The approved, reversible transition of authoritative n8n data and Cloudflare traffic from Cloud Run and Cloud SQL to the shared runtime host. | Not repository deployment or legacy-resource destruction. |
| Stabilization window | Seven consecutive days after cutover during which the former n8n origin remains recoverable and cost overlap is accepted to preserve rollback. | Not indefinite dual-running. |
| Decommission | Separately approved removal of the redundant n8n Cloud Run, Cloud SQL, VPC connector, load balancer, and associated network resources after stabilization evidence passes. | Not deletion of retained backups, recovery secrets, or Cloudflare protections. |
| Recovery artifact | A timestamped, integrity-checked database or binary-data backup that can be restored without relying on the retired service. | Not an untested snapshot or the live Docker volume. |
| Runtime secret | A secret value retrieved from its approved external owner into a root-readable runtime file without entering Git, logs, Task records, or command output. | Not a repository variable name or a plaintext `.env` template. |

### Bounded Contexts And Ownership

| Context or owner | Responsibility | Owned data or decisions | Dependencies |
| --- | --- | --- | --- |
| Shared host platform | VM sizing, boot disk, network, NAT, service account, IAP access, Docker lifecycle, and host monitoring | Capacity, OS/runtime posture, least-privilege host identity, local service ports, and resource headroom | Google Cloud profile and both application requirements |
| n8n automation | n8n container, PostgreSQL container, encryption key binding, workflow database, filesystem binary data, forms, webhooks, editor, and MCP behavior | n8n data schema, workflow execution, binary retention, and n8n-specific recovery | Shared host capacity, runtime secrets, and edge ingress |
| Plausible analytics | Plausible container, PostgreSQL container, ClickHouse container, analytics data, and same-origin collection | Analytics schemas, event ingestion, operator dashboard, and analytics recovery | Shared host capacity and edge ingress |
| Edge ingress and identity | One remotely managed Cloudflare Tunnel, DNS, WAF/rate limiting, Access, and service-token policy | Public-path filtering, private editor/dashboard identity, and hostname-to-container routing | Healthy local origins and Cloudflare account state |
| Migration and recovery | Baseline, export, restore, integrity checks, cutover, rollback, stabilization, and legacy retirement | Migration evidence, rollback point, recovery artifacts, and destructive approval gates | Every other context plus production authority |
| Cost governance | Billing baseline, target run rate, budget alerts, and post-cutover verification | Savings claim, fixed-cost threshold, and evidence period | Google Cloud billing data and final resource inventory |

### Behaviors, Events, Policies, And Integrations

- The existing `plausible-analytics-vm` evolves in place into the shared runtime host unless live capacity evidence proves replacement is safer; its legacy resource name does not define its new logical responsibility.
- Plausible and n8n run as separate application stacks with separate PostgreSQL containers, internal Docker networks, persistent volumes, health checks, backup identities, and restore procedures.
- Only Cloudflare Tunnel provides application ingress; application containers do not receive public VM addresses or public host-port bindings.
- `analytics.lobst3rs.com`, `forms.allanbpediniv.com`, and `workflows.lobst3rs.com` preserve their existing Access, WAF, rate-limit, and same-origin behaviors while their origin changes.
- The existing n8n encryption key is preserved unchanged through migration because losing or replacing it can make stored credentials unreadable.
- Cloud SQL export, binary-data synchronization, database restore, and final delta capture occur under an explicit cutover gate with the legacy service quiesced for a bounded interval.
- DNS or Tunnel cutover occurs only after local container health, restored-data integrity, and rollback readiness pass.
- The legacy n8n origin remains recoverable for the stabilization window and is not destroyed during cutover.
- Decommissioning requires a separate reviewed plan, final recovery artifacts, passing public/private interface checks, measured host headroom, and explicit destructive approval.
- The runtime target is a fixed Google Cloud run rate of no more than USD 60 per month before variable traffic and at least 50% below the measured pre-migration baseline; no savings claim relies only on list-price estimates once billing data is accessible.

### Validation

- Evidence that could change this frame: live VM memory or disk pressure makes safe consolidation impossible at the target cost; an n8n trigger requires an unsupported runtime behavior; database or binary-data volume exceeds the backup window; Cloudflare Tunnel cannot preserve the existing forms and editor controls; or the observed bill does not match the modeled fixed-cost drivers
- Next expert or artifact validation: authenticated Google Cloud billing and resource inventory, VM and database utilization, n8n trigger inventory, exact data sizes, current backup restoration evidence, Cloudflare Tunnel and Access plan, OpenTofu plans, Docker Compose validation, controlled restore rehearsal, and owner approval of downtime, RPO, RTO, stabilization, and destruction gates

## Targets And Interfaces

- Affected repositories, services, or systems: `infra/analytics/`, `infra/n8n/`, a new shared-host runtime surface under `infra/shared-host/`, relevant `.github/workflows/`, canonical repository context, Google Cloud project `abpiv-personal-brand`, and the repository-owned Cloudflare account and zones
- Existing interfaces to preserve: `https://allanbpediniv.com/_analytics/*`, `https://analytics.lobst3rs.com`, `https://forms.allanbpediniv.com` public form and production webhook paths, `https://workflows.lobst3rs.com`, Cloudflare Access for private surfaces and MCP, GitHub OIDC, IAP/OS Login administration, existing n8n workflow and credential decryption, and the documented topic-to-preview-to-main promotion path

## Approval And Safety Boundaries

- Authorized actions: create and validate this Project; later, after explicit execution approval, make bounded local repository changes and read approved live metadata without revealing secrets
- Approval-gated actions: any production workflow dispatch, OpenTofu apply, VM resize/restart, package or container deployment to the VM, Secret Manager access, database or object movement, DNS/Tunnel/Access mutation, traffic cutover, service quiescence, rollback, legacy-resource destruction, budget or billing mutation, commit, push, pull request, merge, or publication
- Prohibited or out-of-scope actions: expose or persist secret values, create service-account keys, weaken Cloudflare path or identity controls, give the VM a public application ingress path, destroy the old origin during cutover, remove the final recovery artifact, force-push, or absorb unrelated work

## Execution Strategy

- Planning owner: `PLAN.md` Planning Basis owns the execution profile, state identity, and coordination budgets
- Integrated review artifact: `INTEGRATION_REVIEW.md`

## Completion Criteria

- One right-sized private Compute Engine VM runs healthy, isolated Docker containers for n8n, n8n PostgreSQL, Plausible, Plausible PostgreSQL, ClickHouse, and Cloudflare Tunnel or an equivalently isolated host-managed Tunnel process.
- The VM has at least 30% sustained memory headroom, at least 20% disk headroom, no sustained swap thrashing, and observed CPU behavior within the Task 01 capacity envelope during the stabilization window.
- n8n workflows, credentials, binary data, forms, webhooks, editor, and MCP behavior pass direct post-restore and post-cutover checks with the original encryption key.
- Plausible dashboard access and same-origin script/event collection continue to pass their existing public checks.
- Automated encrypted or provider-encrypted daily recovery artifacts for both stacks meet an assumed recovery point objective of 24 hours and a restore rehearsal supports an assumed recovery time objective of four hours; the owner may tighten these targets before execution.
- Cloudflare Tunnel, DNS, WAF, rate limiting, Access, and service-token behavior preserve the existing public/private boundaries.
- Rollback to the legacy n8n origin is documented and demonstrated before cutover, and the legacy origin remains recoverable throughout the seven-day stabilization window.
- The redundant n8n Cloud Run, Cloud SQL, VPC connector, load balancer, and superseded network resources are removed only after a separate destructive approval and retained recovery artifacts.
- Post-cutover billing evidence or exact remaining-SKU run-rate evidence shows at least a 50% fixed-cost reduction and a projected fixed Google Cloud run rate no higher than USD 60 per month before variable traffic.
- All Tasks and their selected review policies pass.
- Durable results and validated reuse opportunities are integrated into their canonical owners.
- Final combined-state integrated review, verification, routing removal, and archival pass.

## Decisions And Amendments

| Date | Evidence or trigger | Decision | Plan impact | Approval basis |
| --- | --- | --- | --- | --- |
| 2026-08-06 | Repository infrastructure shows one existing private Plausible VM and a separate always-on n8n Cloud Run, Cloud SQL, VPC connector, load balancer, GCS mount, and Cloudflare edge contract; the user selected one Compute Engine VM with multiple Docker containers. | Establish a controlled migration Project whose target is the existing VM evolved into one shared runtime host, with separate application/data containers and staged rollback-safe decommissioning. | Enter discovery, preserve current interfaces, and gather live capacity and billing evidence before choosing the final VM size. | Original planning request and user-selected architecture. |
| 2026-08-06 | The proportional DDD frame separates shared-host capacity, n8n, Plausible, edge ingress, migration/recovery, and cost governance; the grill found no planning blocker because exact sizing and live values can be resolved by a read-only first Task without changing the selected architecture. | Move to planning with one reversible cutover, one stabilization window, and a separately approved destructive decommission stage. | Build the complete dependency graph, controlled execution profile, evidence contracts, and approval gates. | Original planning request plus inspected repository evidence. |
| 2026-08-06 | The nine-Task graph traces capacity, host/IAM, container runtime, recovery, Tunnel origin, workflows/docs, cutover, decommission, cost verification, and final cleanup; all Tasks are sized for one non-delegating session; budgets include two risk-based replacement reserves; the 50-test validator suite and live Project/Workflow validators passed with zero warnings while status was `planning`. | Approve the plan as decision-ready but not execution-authorized; keep the Project at `ready` pending explicit owner approval, with additional action-time gates for production cutover and destruction. | First executable wave is the read-only Task 01 after approval; no `TASK.md` is created until just-in-time refresh by `planning-tasks`. | Original planning request, planning self-review, and validator evidence; implementation authority remains ungranted. |

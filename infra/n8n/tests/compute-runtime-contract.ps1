$ErrorActionPreference = "Stop"

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..\..")).Path
$failures = [System.Collections.Generic.List[string]]::new()

function Read-RepositoryFile {
    param([Parameter(Mandatory)][string]$RelativePath)

    $path = Join-Path $repositoryRoot $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        $failures.Add("Missing required file: $RelativePath")
        return ""
    }

    return Get-Content -LiteralPath $path -Raw
}

function Assert-Match {
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Content,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter(Mandatory)][string]$Message
    )

    if ($Content -notmatch $Pattern) {
        $failures.Add($Message)
    }
}

function Assert-NotMatch {
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Content,
        [Parameter(Mandatory)][string]$Pattern,
        [Parameter(Mandatory)][string]$Message
    )

    if ($Content -match $Pattern) {
        $failures.Add($Message)
    }
}

$variables = Read-RepositoryFile "infra/n8n/opentofu/variables.tf"
$gcp = Read-RepositoryFile "infra/n8n/opentofu/gcp.tf"
$compute = Read-RepositoryFile "infra/n8n/opentofu/compute.tf"
$cloudflare = Read-RepositoryFile "infra/n8n/opentofu/cloudflare.tf"
$compose = Read-RepositoryFile "infra/n8n/compute/docker-compose.yml"
$provision = Read-RepositoryFile "infra/n8n/compute/scripts/provision-host.sh"
$backup = Read-RepositoryFile "infra/n8n/compute/scripts/backup.sh"
$restore = Read-RepositoryFile "infra/n8n/compute/scripts/restore-backup.sh"
$export = Read-RepositoryFile "infra/n8n/compute/scripts/export-cloud-sql.sh"
$migration = Read-RepositoryFile "infra/n8n/compute/scripts/migrate-from-cloud-sql.sh"
$secretLoader = Read-RepositoryFile "infra/n8n/compute/scripts/load-runtime-secrets.sh"
$runtimeBoot = Read-RepositoryFile "infra/n8n/compute/scripts/start-on-boot.sh"
$observation = Read-RepositoryFile "infra/n8n/compute/scripts/observe-runtime.sh"
$monitor = Read-RepositoryFile "infra/n8n/compute/scripts/monitor-runtime.sh"
$runtimeService = Read-RepositoryFile "infra/n8n/compute/systemd/abpiv-n8n.service"
$bootstrap = Read-RepositoryFile "infra/n8n/compute/scripts/bootstrap-host.sh"
$firewall = Read-RepositoryFile "infra/n8n/compute/scripts/configure-container-firewall.sh"
$runtimeMode = Read-RepositoryFile "infra/n8n/compute/scripts/runtime-mode.sh"
$prepareCutover = Read-RepositoryFile "infra/n8n/compute/scripts/prepare-cutover-runtime.sh"
$precommitNginx = Read-RepositoryFile "infra/n8n/compute/nginx/precommit.conf"
$backupTimer = Read-RepositoryFile "infra/n8n/compute/systemd/abpiv-n8n-backup.timer"
$prepareWorkflow = Read-RepositoryFile ".github/workflows/n8n-apply.yml"
$bootstrapWorkflow = Read-RepositoryFile ".github/workflows/n8n-iam-bootstrap.yml"
$migrations = Read-RepositoryFile "infra/n8n/opentofu/migrations.tf"
$canonicalPlanValues = Read-RepositoryFile "infra/n8n/tools/canonical-plan-values.py"
$decommission = Read-RepositoryFile ".github/workflows/n8n-decommission.yml"
$cutover = (Read-RepositoryFile ".github/workflows/n8n-cutover.yml") + $decommission

# OpenTofu defaults must remain additive and rollback-safe.
Assert-Match $variables 'variable\s+"runtime_origin"[\s\S]*?default\s*=\s*"cloud_run"' "runtime_origin must default to cloud_run."
Assert-Match $variables 'variable\s+"legacy_stack_enabled"[\s\S]*?default\s*=\s*true' "legacy_stack_enabled must default to true."
Assert-Match $variables 'variable\s+"legacy_destruction_armed"[\s\S]*?default\s*=\s*false' "Legacy destruction arming must default to false."
Assert-Match $variables 'variable\s+"compute_machine_type"[\s\S]*?default\s*=\s*"e2-custom-medium-6144"' "The shared VM must default to e2-custom-medium-6144."
Assert-Match $variables 'variable\s+"compute_data_disk_size_gb"[\s\S]*?default\s*=\s*30' "The data disk must default to 30 GiB."
Assert-Match $gcp 'resource\s+"google_cloud_run_v2_service"\s+"n8n"\s*\{[\s\S]*?labels\s*=\s*local\.labels\s+scaling\s*\{\s*manual_instance_count\s*=\s*0\s+min_instance_count\s*=\s*0\s*\}\s+template\s*\{' "Additive preparation must preserve the legacy Cloud Run service-level scaling values."

# The host is private, uses a durable data disk, and has NAT plus IAP/OS Login.
Assert-Match $compute 'resource\s+"google_compute_instance"\s+"n8n"' "The Compute Engine runtime VM is missing."
Assert-Match $compute 'name\s*=\s*"abpiv-runtime-vm"' "The VM must use the approved abpiv-runtime-vm name."
Assert-Match $compute 'enable-oslogin\s*=\s*"TRUE"' "OS Login must be enabled on the VM."
Assert-NotMatch $compute 'access_config\s*\{' "The VM must not have a public access_config."
Assert-Match $compute 'resource\s+"google_compute_disk"\s+"n8n_data"[\s\S]*?size\s*=\s*var\.compute_data_disk_size_gb' "A separate configurable data disk is required."
Assert-Match $compute 'resource\s+"google_compute_router_nat"\s+"n8n"' "Cloud NAT is required for the private VM."
Assert-Match $compute '35\.235\.240\.0/20' "IAP must be the only SSH ingress source."
Assert-Match $compute 'retention_period\s*=\s*604800' "The backup bucket must enforce seven-day retention."

# Cloudflare security stays in place while only the origin target switches.
Assert-Match $cloudflare 'cfargotunnel\.com' "Cloudflare DNS must be able to target the new Tunnel."
Assert-Match $cloudflare 'resource\s+"cloudflare_zero_trust_tunnel_cloudflared"\s+"n8n"' "The Cloudflare Tunnel resource is missing."
Assert-Match $cloudflare 'http://127\.0\.0\.1:8080' "The Tunnel must forward both hostnames to IPv4 loopback Nginx."

# Runtime containers are immutable, isolated, health checked, and non-public.
Assert-Match $compose 'n8nio/n8n@sha256:[a-f0-9]{64}' "n8n must use an immutable image digest."
Assert-Match $compose 'postgres@sha256:[a-f0-9]{64}' "PostgreSQL must use an immutable image digest."
Assert-Match $compose 'nginx@sha256:[a-f0-9]{64}' "Nginx must use an immutable image digest."
Assert-Match $compose '127\.0\.0\.1:8080:8080' "Only Nginx may publish a loopback port."
Assert-NotMatch $compose '(?m)^\s*-\s*"?(5678|5432):' "n8n and PostgreSQL ports must never be published."
Assert-Match $compose '(?m)^\s*internal:\s*true\s*$' "The application Docker network must be internal."
Assert-Match $compose '(?m)^\s*healthcheck:\s*$' "Every runtime service must define a health check."
Assert-Match $compose '/srv/n8n/' "Runtime data must live on the attached disk."
Assert-Match $compose 'N8N_ENCRYPTION_KEY_FILE' "n8n must consume its encryption key by ephemeral file path."
Assert-Match $compose 'DB_POSTGRESDB_PASSWORD_FILE' "n8n must consume its database password by ephemeral file path."
Assert-Match $compose 'POSTGRES_PASSWORD_FILE' "PostgreSQL must consume its password by root-only file path."
Assert-NotMatch $compose '(?m)^\s*env_file:' "Docker must not persist resolved secret values from an env_file in container metadata."
Assert-Match $compose 'tmpfs:[\s\S]*/run/n8n-runtime:' "The n8n generated config and copied secret files must live on container tmpfs."
Assert-Match $compose 'x-logging:[\s\S]*driver:\s*local[\s\S]*max-size:\s*"10m"[\s\S]*max-file:\s*"3"' "Container logs must use the exact bounded local-driver policy."
if ([regex]::Matches($compose, 'logging:\s*\*default-logging').Count -ne 3) {
    $failures.Add("Every n8n project service must use the bounded logging policy.")
}
Assert-Match $secretLoader '/run/n8n/runtime\.env' "Secret Manager values must still be staged only in the required root-only tmpfs runtime file."
Assert-Match $firewall '169\.254\.169\.254/32' "The container firewall must target the GCE metadata endpoint."
Assert-Match $firewall 'DOCKER-USER[\s\S]*--jump DROP' "All containers must be blocked from the GCE metadata endpoint."
Assert-Match $provision 'docker\.service\.d/abpiv-container-firewall\.conf[\s\S]*ExecStartPost=/usr/local/sbin/abpiv-container-firewall --enforce' "Docker startup must durably restore the metadata firewall rule."
Assert-Match $runtimeMode 'maintenance[\s\S]*abpiv-container-firewall --check[\s\S]*systemctl enable abpiv-n8n\.service abpiv-cloudflared\.service' "Maintenance mode must enforce metadata isolation and persist fail-closed reboot recovery."

# Automation must preserve the explicit gates and verifiable recovery path.
Assert-Match $provision 'findmnt[\s\S]*UUID' "Provisioning must mount the data disk by UUID."
Assert-NotMatch $provision 'defaults,nofail' "The production data disk mount must fail closed."
Assert-Match $runtimeService 'RequiresMountsFor=/srv/n8n' "Runtime startup must require the attached data-disk mount."
Assert-Match $provision 'docker compose[\s\S]*config' "Provisioning must validate Compose before use."
Assert-Match $provision 'chown\s+-R\s+70:70[\s\S]*postgres' "The PostgreSQL bind mount must use the pinned Alpine image UID/GID 70."
Assert-Match $provision 'chown\s+-R\s+1000:1000[\s\S]*state' "The n8n bind mounts must use the pinned image UID/GID 1000."
Assert-Match $backup 'pg_dump[\s\S]*--format=custom' "Backups must include a custom-format PostgreSQL dump."
Assert-Match $backup 'sha256sum' "Backups must include checksum manifests."
Assert-Match $backup 'gcloud storage cp' "Backups must upload to the private GCS bucket."
Assert-Match $backup 'flock[\s\S]*stop n8n' "Backups must lock data operations and quiesce n8n before the database/filesystem snapshot."
Assert-Match $backup 'recovery_needed=true[\s\S]*maintenance\.conf' "Backup recovery must be armed before the first maintenance-mode mutation."
Assert-Match $backup 'if "\$recovery_needed"[\s\S]*active-ready' "Backup cleanup must restore and verify active mode after any partial suspension failure."
Assert-Match $restore 'sha256sum[\s\S]*--check' "Daily restore must verify its checksum manifest before replacement."
Assert-Match $restore 'pg_restore' "Daily restore tooling must restore the PostgreSQL custom dump."
Assert-Match $restore 'maintenance\.conf' "Daily restore must keep ingress in maintenance mode."
Assert-Match $migration 'pg_restore' "Migration must restore the Cloud SQL dump with pg_restore."
Assert-Match $migration 'sha256sum[\s\S]*--check' "Migration must verify checksums before restore."
Assert-Match $migration 'verify-migration-dump\.sh' "The final migration dump must pass a disposable restore before local replacement."
Assert-NotMatch $export '--env\s+PGPASSWORD' "Cloud SQL export must not place the database password in Docker container metadata."
Assert-Match $export '--volume\s+/run/n8n/postgres-password:/run/secrets/postgres-password:ro' "Cloud SQL export must bind the root-only password file into transient clients."
Assert-Match $export 'PGPASSWORD="\$\(cat /run/secrets/postgres-password\)"' "Transient source clients must load the password only inside the container process."
Assert-NotMatch $backupTimer 'RandomizedDelaySec' "The daily backup cadence must not exceed the 24-hour RPO because of timer jitter."
Assert-Match $cutover 'confirm_cutover' "Cutover automation must require a typed cutover confirmation."
Assert-Match $cutover 'confirm_runtime_secret_access' "Runtime Secret Manager reads must have a separate typed confirmation."
Assert-Match $cutover 'confirm_data_movement' "Production data movement must have a separate typed confirmation."
Assert-Match $cutover 'confirm_dns_cutover' "Production DNS cutover must have a separate typed confirmation."
Assert-Match $cutover 'confirm_destroy' "Legacy destruction must require a separate typed confirmation."
Assert-Match $cutover 'get\("status"[\s\S]*get\("traffic"[\s\S]*percent[\s\S]*100' "Cutover must identify the single Cloud Run revision currently serving all source traffic."
Assert-Match $cutover 'revisions describe[\s\S]*status\.imageDigest' "Cutover must resolve the immutable digest of the traffic-serving Cloud Run revision."
Assert-Match $cutover 'source_digest[\s\S]*target_digest[\s\S]*do not match' "Cutover must fail before quiescence when the source and pinned target n8n image digests differ."
Assert-Match $cutover 'docker image inspect[\s\S]*target_ref' "Cutover must prove the pinned n8n image is present on the target VM."
Assert-Match $cutover '--phase rollback' "The emergency rollback plan must use its own strict allowlist."
Assert-Match $cutover 'attempted=true' "Partial DNS applies must still trigger rollback."
Assert-Match $bootstrap 'bootstrap_marker[\s\S]*exit 0' "The metadata bootstrap must be one-shot after successful installation."
Assert-Match $cutover '45' "The cutover workflow must enforce the minute-45 rollback deadline."
Assert-Match $runtimeService 'ExecStart=/opt/abpiv-n8n/scripts/start-on-boot\.sh' "Runtime systemd startup must honor the persisted mode instead of forcing active mode."
Assert-Match $runtimeBoot 'cat /etc/abpiv-n8n/mode[\s\S]*runtime-mode\.sh' "Boot startup must dispatch the persisted active, maintenance, or stopped mode."
Assert-Match $decommission "-target='google_sql_database_instance\.n8n\[0\]'" "Failed decommission recovery must target only the surviving Cloud SQL instance."
Assert-Match $decommission 'reviewed_commit_sha[\s\S]*GITHUB_SHA[\s\S]*REVIEWED_COMMIT_SHA' "Destruction apply must be bound to the exact independently reviewed commit."
Assert-Match $decommission 'database\.dump[\s\S]*binary-data\.tar[\s\S]*binary-checksums\.txt[\s\S]*source-binary-count\.txt[\s\S]*source-counts\.tsv[\s\S]*SHA256SUMS' "Decommission must round-trip every required migration artifact before planning or applying destruction."
Assert-Match $decommission 'gcloud storage cp[\s\S]*sha256sum --check SHA256SUMS' "Decommission must download and verify the complete retained migration package."
Assert-Match $decommission 'migration-backup[\s\S]*migration_manifest_sha256' "The reviewed destruction manifest must bind the exact retained migration prefix and checksum manifest."
Assert-Match $observation 'metadata\.google\.internal[\s\S]*e2-custom-medium-6144[\s\S]*reserved_millicores' "The initial CPU gate must normalize guest usage against the live shared-core entitlement."
Assert-Match $observation "write-out '%\{time_total\}'[\s\S]*/healthz/readiness" "The initial latency gate must time an n8n-proxied readiness request."
Assert-Match $monitor 'State\.Health\.Status' "Runtime monitoring must inspect Docker health for every container."
Assert-Match $monitor 'condition=container_(missing|unhealthy)' "Runtime monitoring must emit an alert for a missing or unhealthy container."
Assert-Match $monitor "write-out '%\{time_total\}'[\s\S]*/healthz/readiness" "Ongoing latency monitoring must time an n8n-proxied readiness request."
Assert-Match $precommitNginx 'location ~ \^/\(form\|form-waiting\)[\s\S]*limit_except GET[\s\S]*deny all' "Precommit form inspection must allow reads while denying submissions."
Assert-Match $precommitNginx 'location ~ \^/\(webhook\|webhook-waiting\)[\s\S]*return 503' "Precommit ingress must keep every webhook write path closed."
Assert-Match $prepareCutover 'precommit\.conf[\s\S]*precommit-ready[\s\S]*/healthz/readiness' "Cutover must prove the restored app behind read-only ingress before committing."
Assert-Match $cutover 'prepare-cutover-runtime\.sh[\s\S]*id: commit[\s\S]*runtime-mode\.sh active' "The canonical-writer boundary must be after sealed readiness and before write exposure."
Assert-Match $cutover "steps\.commit\.outputs\.committed != 'true'[\s\S]*--phase rollback" "Only precommit failures may restore the old Cloud Run origin."
Assert-Match $cutover "steps\.commit\.outputs\.committed == 'true'[\s\S]*plausible_mode[\s\S]*runtime-mode\.sh active" "Postcommit recovery must preserve n8n data and restore the other shared runtime mode."
Assert-Match $prepareWorkflow 'mode:[\s\S]*options:\s*\[plan, apply\]' "Additive preparation must separate live planning from applying into distinct dispatch modes."
Assert-Match $prepareWorkflow "environment:\s*\$\{\{ inputs\.mode == 'apply' && 'production' \|\| 'production-plan' \}\}" "Plan and apply dispatches must use their separately protected GitHub environments."
Assert-Match $prepareWorkflow 'reviewed_commit_sha[\s\S]*GITHUB_SHA[\s\S]*REVIEWED_COMMIT_SHA' "Apply must be bound to the exact independently reviewed commit."
Assert-Match $prepareWorkflow 'reviewed_actions_sha256[\s\S]*preparation-actions\.sha256[\s\S]*REVIEWED_ACTIONS_SHA256' "Apply must regenerate and match the independently reviewed preparation action manifest."
Assert-Match $prepareWorkflow 'reviewed_plan_values_sha256[\s\S]*preparation-plan-values\.sha256[\s\S]*REVIEWED_PLAN_VALUES_SHA256' "Apply must regenerate and match the independently reviewed non-sensitive plan values."
Assert-Match $bootstrapWorkflow 'mode:[\s\S]*options:\s*\[plan, apply\]' "IAM bootstrap must separate planning from applying."
Assert-Match $bootstrapWorkflow 'plan-preparation-iam-bootstrap[\s\S]*apply-preparation-iam-bootstrap' "IAM bootstrap must require separate typed plan and apply confirmations."
Assert-Match $bootstrapWorkflow 'reviewed_commit_sha[\s\S]*reviewed_actions_sha256[\s\S]*reviewed_moves_sha256[\s\S]*reviewed_plan_values_sha256' "IAM bootstrap apply must bind the reviewed commit, actions, state moves, and non-sensitive values."
Assert-Match $bootstrapWorkflow '--phase bootstrap' "IAM bootstrap must use its own strict plan allowlist."
Assert-Match $bootstrapWorkflow 'previous_address[\s\S]*bootstrap-moves\.txt[\s\S]*bootstrap-moves\.sha256[\s\S]*REVIEWED_MOVES_SHA256' "IAM bootstrap must extract, hash, and match the exact state-address moves."
Assert-Match $bootstrapWorkflow 'assert-bootstrap-evidence\.py bootstrap-actions\.txt bootstrap-moves\.txt' "IAM bootstrap recovery must validate the joint action/move evidence before hashing or applying."
Assert-Match $bootstrapWorkflow 'serviceusage\.services\.enable' "IAM bootstrap must prove the deployer can enable its four required API dependencies before planning or applying."
$expectedBootstrapTargets = @(
    "google_project_iam_member.github_deployer_project_roles"
    "google_service_account.n8n_compute"
    "google_service_account_iam_member.github_deployer_compute_service_account_user"
    "google_service_account_iam_member.github_deployer_plausible_runtime_service_account_user"
    "google_service_account_iam_member.github_oidc_workload_identity_user"
    "google_service_account_iam_member.github_oidc_service_account_token_creator"
)
$expectedBootstrapTargets += [regex]::Matches($migrations, '(?m)^\s*from\s*=\s*([^\r\n]+)$') | ForEach-Object { $_.Groups[1].Value.Trim() }
$actualBootstrapTargets = [regex]::Matches($bootstrapWorkflow, "'-target=([^']+)'") | ForEach-Object { $_.Groups[1].Value }
if (Compare-Object -ReferenceObject $expectedBootstrapTargets -DifferenceObject $actualBootstrapTargets -SyncWindow 0) {
    $failures.Add("IAM bootstrap targets must equal the six approved IAM/identity resources followed by every exact migrations.tf source address.")
}
Assert-Match $bootstrapWorkflow 'OIDC_PRINCIPAL_SET:\s*\$\{\{ vars\.N8N_GITHUB_OIDC_PRINCIPAL_SET \}\}[\s\S]*for name[\s\S]*OIDC_PRINCIPAL_SET' "IAM bootstrap must reject dispatches that cannot bind the dedicated deployer to the repository-scoped Workload Identity principal."
Assert-Match $bootstrapWorkflow 'pool_resource="\$\{WORKLOAD_IDENTITY_PROVIDER%/providers/\*\}"' "IAM bootstrap must derive the Workload Identity pool from the exact configured provider."
Assert-Match $bootstrapWorkflow 'expected_principal_set="principalSet://iam\.googleapis\.com/\$\{pool_resource\}/attribute\.repository/\$\{GITHUB_REPOSITORY\}"[\s\S]*test "\$OIDC_PRINCIPAL_SET" = "\$expected_principal_set"' "IAM bootstrap must accept only the exact configured-provider and current-repository principalSet."
Assert-Match $bootstrapWorkflow "environment:\s*\$\{\{ inputs\.mode == 'apply' && 'production' \|\| 'production-plan' \}\}" "IAM bootstrap plan and apply must use separately protected environments."
Assert-Match $prepareWorkflow 'cloudresourcemanager\.googleapis\.com[\s\S]*testIamPermissions' "Preparation must test current project permissions before planning or applying."
Assert-Match $prepareWorkflow 'resourcemanager\.projects\.setIamPolicy' "Preparation must prove the deployer can apply the planned project IAM bindings."
Assert-Match $prepareWorkflow 'iam\.googleapis\.com[\s\S]*testIamPermissions' "Preparation must test current service-account permissions before planning or applying."
Assert-Match $prepareWorkflow 'n8n-compute-runtime@\$\{\{ vars\.N8N_GCP_PROJECT_ID \}\}\.iam\.gserviceaccount\.com' "Preparation must test permissions on the bootstrapped Compute runtime identity."
Assert-Match $prepareWorkflow 'iam\.serviceAccounts\.actAs' "Preparation must prove the deployer can already act as the existing runtime identity."
foreach ($permission in @(
    "compute.subnetworks.use",
    "compute.instances.setMetadata",
    "compute.instances.setTags",
    "compute.instances.setLabels",
    "compute.disks.use"
)) {
    Assert-Match $prepareWorkflow ([regex]::Escape($permission)) "Preparation must preflight required permission $permission."
}
Assert-Match $compute 'resource\s+"google_compute_instance"\s+"n8n"[\s\S]*?depends_on\s*=\s*\[[\s\S]*?google_service_account_iam_member\.github_deployer_compute_service_account_user' "The VM must wait for the deployer's new-runtime serviceAccountUser binding."
Assert-Match $canonicalPlanValues 'after_sensitive[\s\S]*after_unknown[\s\S]*sort_keys=True' "Canonical plan evidence must redact sensitive values while binding resolved values and unknown structure deterministically."
Assert-Match $prepareWorkflow "if:\s*inputs\.mode == 'apply'[\s\S]*tofu[\s\S]*apply" "Only the separately approved apply dispatch may execute the saved preparation plan."

foreach ($workflowPath in @(
    ".github/workflows/n8n-iam-bootstrap.yml",
    ".github/workflows/n8n-apply.yml",
    ".github/workflows/n8n-redeploy.yml",
    ".github/workflows/n8n-cutover.yml",
    ".github/workflows/n8n-decommission.yml",
    ".github/workflows/plausible-redeploy.yml",
    ".github/workflows/plausible-cutover.yml"
)) {
    $workflow = Read-RepositoryFile $workflowPath
    Assert-Match $workflow 'group:\s*abpiv-shared-runtime-mutation' "$workflowPath must serialize every shared-host mutation."
    Assert-Match $workflow 'cancel-in-progress:\s*false' "$workflowPath must never cancel an in-progress shared-host mutation."
    Assert-Match $workflow "github\.ref == 'refs/heads/main'" "$workflowPath must refuse every live dispatch outside the main branch even if an environment is missing or misconfigured."
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    throw "Compute runtime contract failed with $($failures.Count) violation(s)."
}

Write-Host "Compute runtime contract passed."

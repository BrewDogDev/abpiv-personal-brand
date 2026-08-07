locals {
  name_prefix = "abpiv-n8n"

  labels = {
    app         = "n8n"
    component   = "automation"
    environment = "production"
    managed_by  = "opentofu"
  }

  compute_labels = {
    app         = "shared-runtime"
    component   = "runtime"
    environment = "production"
    managed_by  = "opentofu"
  }

  network_cidr   = "10.58.0.0/24"
  connector_cidr = "10.58.16.0/28"

  cloud_run_service_name   = local.name_prefix
  cloud_run_container_port = 5678
  cloud_run_concurrency    = 10

  sql_instance_name = "${local.name_prefix}-postgres"

  binary_data_bucket_name          = var.binary_data_bucket_name != "" ? var.binary_data_bucket_name : "${var.gcp_project_id}-n8n-binary-data"
  binary_data_mount_path           = "/mnt/n8n-binary-data"
  backup_bucket_name               = var.backup_bucket_name != "" ? var.backup_bucket_name : "${var.gcp_project_id}-n8n-backups"
  compute_instance_name            = "abpiv-runtime-vm"
  compute_data_disk_name           = "abpiv-n8n-data"
  compute_plausible_data_disk_name = "abpiv-plausible-data"

  editor_enabled = trimspace(var.editor_hostname) != ""
  editor_cloudflare_zone_id = (
    var.editor_zone_id != "" ?
    var.editor_zone_id :
    try(data.cloudflare_zones.editor[0].result[0].id, "")
  )

  hostnames = merge(
    {
      forms = var.forms_hostname
    },
    local.editor_enabled ? {
      editor = var.editor_hostname
    } : {}
  )

  hostname_zone_ids = merge(
    {
      forms = var.allanbpediniv_zone_id
    },
    local.editor_enabled ? {
      editor = local.editor_cloudflare_zone_id
    } : {}
  )

  editor_access_include_rules = concat(
    [
      for email in var.editor_access_allowed_emails : {
        email = {
          email = email
        }
      }
    ],
    [
      for group_id in var.editor_access_allowed_group_ids : {
        group = {
          id = group_id
        }
      }
    ]
  )

  public_forms_path_expression = join(" or ", [
    "http.request.uri.path eq \"/form\"",
    "starts_with(http.request.uri.path, \"/form/\")",
    "http.request.uri.path eq \"/form-waiting\"",
    "starts_with(http.request.uri.path, \"/form-waiting/\")",
    "http.request.uri.path eq \"/webhook\"",
    "starts_with(http.request.uri.path, \"/webhook/\")",
    "http.request.uri.path eq \"/webhook-waiting\"",
    "starts_with(http.request.uri.path, \"/webhook-waiting/\")",
  ])

  public_forms_request_expression = "(http.host eq \"${var.forms_hostname}\" and (${local.public_forms_path_expression}))"

  required_services = toset([
    "certificatemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iap.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "oslogin.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "vpcaccess.googleapis.com",
  ])

  runtime_secrets = {
    encryption_key = {
      secret_id = "${local.name_prefix}-encryption-key"
      env_name  = "N8N_ENCRYPTION_KEY"
    }
    postgres_password = {
      secret_id = "${local.name_prefix}-postgres-password"
      env_name  = "DB_POSTGRESDB_PASSWORD"
    }
  }

  plausible_runtime_secrets = {
    secret_key_base = {
      secret_id = "abpiv-plausible-secret-key-base"
    }
    postgres_password = {
      secret_id = "abpiv-plausible-postgres-password"
    }
    tunnel_token = {
      secret_id = "abpiv-plausible-tunnel-token"
    }
    backup_age_key = {
      secret_id = "abpiv-plausible-backup-age-key"
    }
  }

  n8n_static_env = merge({
    DB_POSTGRESDB_CONNECTION_TIMEOUT      = "20000"
    DB_POSTGRESDB_DATABASE                = var.postgres_database
    DB_POSTGRESDB_HOST                    = try(google_sql_database_instance.n8n[0].private_ip_address, "")
    DB_POSTGRESDB_IDLE_CONNECTION_TIMEOUT = "30000"
    DB_POSTGRESDB_PORT                    = "5432"
    DB_POSTGRESDB_SSL_ENABLED             = "false"
    DB_POSTGRESDB_USER                    = var.postgres_user
    DB_TYPE                               = "postgresdb"
    EXECUTIONS_DATA_MAX_AGE               = "336"
    EXECUTIONS_DATA_PRUNE                 = "true"
    EXECUTIONS_DATA_PRUNE_MAX_COUNT       = "10000"
    GENERIC_TIMEZONE                      = "America/New_York"
    N8N_AVAILABLE_BINARY_DATA_MODES       = "filesystem"
    N8N_BINARY_DATA_STORAGE_PATH          = local.binary_data_mount_path
    N8N_DEFAULT_BINARY_DATA_MODE          = "filesystem"
    N8N_DIAGNOSTICS_ENABLED               = "false"
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS = "true"
    N8N_HIRING_BANNER_ENABLED             = "false"
    N8N_HOST                              = var.forms_hostname
    N8N_LISTEN_ADDRESS                    = "0.0.0.0"
    N8N_PORT                              = tostring(local.cloud_run_container_port)
    N8N_PROTOCOL                          = "https"
    N8N_PROXY_HOPS                        = "2"
    N8N_PUBLIC_API_DISABLED               = "true"
    N8N_SECURE_COOKIE                     = "true"
    WEBHOOK_URL                           = "https://${var.forms_hostname}/"
    },
    local.editor_enabled ? {
      N8N_EDITOR_BASE_URL = "https://${var.editor_hostname}/"
    } : {}
  )

  github_deployer_project_roles = toset(concat([
    "roles/compute.instanceAdmin.v1",
    "roles/compute.networkAdmin",
    "roles/compute.osAdminLogin",
    "roles/iam.serviceAccountAdmin",
    "roles/iap.tunnelResourceAccessor",
    "roles/logging.configWriter",
    "roles/monitoring.editor",
    "roles/secretmanager.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/storage.admin",
    ], var.legacy_stack_enabled ? [
    "roles/certificatemanager.editor",
    "roles/cloudsql.admin",
    "roles/compute.loadBalancerAdmin",
    "roles/run.admin",
    "roles/servicenetworking.networksAdmin",
    "roles/vpcaccess.admin",
    ] : []
  ))
}

check "rollback_origin_available" {
  assert {
    condition = (
      var.runtime_origin != "cloud_run" ||
      (var.legacy_stack_enabled && var.legacy_cloud_run_min_instances == 1)
    )
    error_message = "runtime_origin=cloud_run requires the retained legacy stack with one minimum instance."
  }

}

check "compute_origin_has_managed_edge" {
  assert {
    condition     = var.runtime_origin != "compute" || (var.enable_cloudflare_edge && local.editor_enabled)
    error_message = "runtime_origin=compute requires managed Cloudflare edge resources and the editor hostname so both production records switch together."
  }
}

check "destruction_arming_is_narrow" {
  assert {
    condition     = !var.legacy_destruction_armed || (var.runtime_origin == "compute" && var.legacy_stack_enabled)
    error_message = "legacy_destruction_armed is valid only after the Compute origin is active while the legacy stack is still retained."
  }
}

variable "gcp_project_id" {
  description = "Existing Google Cloud project that hosts ABPIV n8n. This OpenTofu project never creates the project."
  type        = string
  default     = "abpiv-personal-brand"
}

variable "gcp_region" {
  description = "Google Cloud region for Cloud Run, Cloud SQL, networking, and the binary-data bucket."
  type        = string
  default     = "us-east1"
}

variable "gcp_zone" {
  description = "Google Cloud zone for the private Compute Engine VM shared by the isolated n8n and Plausible projects."
  type        = string
  default     = "us-east1-c"
}

variable "runtime_origin" {
  description = "Active production origin. Keep cloud_run during additive preparation; switch to compute only in the approved cutover window."
  type        = string
  default     = "cloud_run"

  validation {
    condition     = contains(["cloud_run", "compute"], var.runtime_origin)
    error_message = "runtime_origin must be cloud_run or compute."
  }
}

variable "legacy_stack_enabled" {
  description = "Retains the rollback Cloud Run, Cloud SQL, connector, load balancer, and legacy bucket. Disable only after verified cutover and explicit destructive approval."
  type        = bool
  default     = true
}

variable "legacy_destruction_armed" {
  description = "Writes Cloud SQL deletion_protection=false into state before the separately planned legacy deletion. Keep false outside an explicitly approved decommission."
  type        = bool
  default     = false
}

variable "legacy_cloud_run_min_instances" {
  description = "Minimum legacy Cloud Run instances. Keep one before cutover, zero while retained only for rollback after a successful cutover."
  type        = number
  default     = 1

  validation {
    condition     = contains([0, 1], var.legacy_cloud_run_min_instances)
    error_message = "legacy_cloud_run_min_instances must be 0 or 1."
  }
}

variable "compute_machine_type" {
  description = "Approved machine type for the private VM shared by n8n and Plausible. Start with 6 GiB shared-core; use the 8 GiB fallback only after an observed threshold failure."
  type        = string
  default     = "e2-custom-medium-6144"

  validation {
    condition     = contains(["e2-custom-medium-6144", "e2-standard-2"], var.compute_machine_type)
    error_message = "compute_machine_type must be e2-custom-medium-6144 or the approved e2-standard-2 fallback."
  }
}

variable "compute_boot_image" {
  description = "Exact Ubuntu 24.04 image self-link for the VM boot disk. Update deliberately after testing; never use an image family."
  type        = string
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v20260805"

  validation {
    condition     = can(regex("^projects/ubuntu-os-cloud/global/images/ubuntu-2404-noble-amd64-v[0-9]+$", var.compute_boot_image))
    error_message = "compute_boot_image must be an exact Ubuntu 24.04 image, not an image family."
  }
}

variable "compute_boot_disk_size_gb" {
  description = "Boot disk size for the runtime VM."
  type        = number
  default     = 20
}

variable "compute_data_disk_size_gb" {
  description = "Non-auto-delete persistent data disk size for PostgreSQL, n8n state, binary data, and local backup staging."
  type        = number
  default     = 30
}

variable "plausible_data_disk_size_gb" {
  description = "Non-auto-delete persistent disk size for Plausible PostgreSQL, ClickHouse, application state, and migration staging."
  type        = number
  default     = 80

  validation {
    condition     = var.plausible_data_disk_size_gb >= 80
    error_message = "plausible_data_disk_size_gb must be at least the legacy analytics VM's 80 GiB boot-disk capacity."
  }
}

variable "backup_bucket_name" {
  description = "Optional explicit GCS bucket name for versioned seven-day n8n and Plausible target backups."
  type        = string
  default     = ""
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID that owns Zero Trust Access resources."
  type        = string
  default     = ""

  validation {
    condition     = !var.enable_cloudflare_edge || var.cloudflare_account_id != ""
    error_message = "cloudflare_account_id is required when enable_cloudflare_edge is true."
  }
}

variable "allanbpediniv_zone_id" {
  description = "Cloudflare zone ID for allanbpediniv.com."
  type        = string
  default     = ""

  validation {
    condition     = !var.enable_cloudflare_edge || var.allanbpediniv_zone_id != ""
    error_message = "allanbpediniv_zone_id is required when enable_cloudflare_edge is true."
  }
}

variable "enable_cloudflare_edge" {
  description = "Whether to manage Cloudflare DNS, public forms protection, and optional editor Access resources."
  type        = bool
  default     = false
}

variable "cloudflare_access_organization_name" {
  description = "Cloudflare Zero Trust organization display name used when the optional editor hostname is enabled."
  type        = string
  default     = "ABPIV Internal"
}

variable "cloudflare_access_auth_domain" {
  description = "Unique Cloudflare Access auth domain used when the optional editor hostname is enabled."
  type        = string
  default     = "lobst3rs.cloudflareaccess.com"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.cloudflareaccess\\.com$", var.cloudflare_access_auth_domain))
    error_message = "cloudflare_access_auth_domain must be a lowercase cloudflareaccess.com hostname."
  }
}

variable "manage_cloudflare_access_organization" {
  description = "Whether OpenTofu should manage the account-level Cloudflare Zero Trust organization. Leave false when Access is enabled manually in the dashboard."
  type        = bool
  default     = false
}

variable "forms_hostname" {
  description = "Public hostname used by n8n-generated forms and production webhooks."
  type        = string
  default     = "forms.allanbpediniv.com"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)+$", var.forms_hostname))
    error_message = "forms_hostname must be a lowercase DNS hostname."
  }
}

variable "editor_hostname" {
  description = "Optional editor/admin hostname. When empty, editor DNS and Cloudflare Access resources are not created."
  type        = string
  default     = ""

  validation {
    condition = (
      var.editor_hostname == "" ||
      can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)+$", var.editor_hostname))
    )
    error_message = "editor_hostname must be empty or a lowercase DNS hostname."
  }

  validation {
    condition = (
      !var.enable_cloudflare_edge ||
      var.editor_hostname == "" ||
      var.editor_zone_id != "" ||
      var.editor_zone_name != ""
    )
    error_message = "Set editor_zone_id or editor_zone_name when enable_cloudflare_edge is true and editor_hostname is set."
  }
}

variable "editor_zone_id" {
  description = "Optional Cloudflare zone ID for the editor/admin hostname. When empty, editor_zone_name is used to look up the zone."
  type        = string
  default     = ""
}

variable "editor_zone_name" {
  description = "Optional Cloudflare zone name for the editor/admin hostname, used when editor_zone_id is empty."
  type        = string
  default     = ""

  validation {
    condition = (
      var.editor_zone_name == "" ||
      can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?)+$", var.editor_zone_name))
    )
    error_message = "editor_zone_name must be empty or a lowercase DNS zone name."
  }
}

variable "editor_access_allowed_emails" {
  description = "Email addresses allowed through Cloudflare Access for the optional editor hostname."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for email in var.editor_access_allowed_emails :
      can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", email))
    ])
    error_message = "Each editor_access_allowed_emails value must look like an email address."
  }
}

variable "editor_access_allowed_group_ids" {
  description = "Cloudflare Access group IDs allowed through the optional editor hostname."
  type        = list(string)
  default     = []
}

variable "editor_mcp_service_token_duration" {
  description = "Lifetime for the Cloudflare Access service token used by Codex n8n MCP clients."
  type        = string
  default     = "8760h"

  validation {
    condition     = can(regex("^[0-9]+(ns|us|µs|ms|s|m|h)$", var.editor_mcp_service_token_duration))
    error_message = "editor_mcp_service_token_duration must be a Cloudflare duration such as 8760h."
  }
}

variable "github_oidc_principal_set" {
  description = "Optional Workload Identity principalSet member allowed to impersonate the n8n GitHub deployer service account."
  type        = string
  default     = ""
}

variable "n8n_image" {
  description = "Cloud Run-compatible n8n container image. docker.io/n8nio/n8n:stable is the same manifest as docker.n8n.io/n8nio/n8n:stable."
  type        = string
  default     = "docker.io/n8nio/n8n:stable"

  validation {
    condition     = length(split("/", var.n8n_image)) >= 3
    error_message = "n8n_image must include a registry host and repository path, for example docker.io/n8nio/n8n:stable."
  }
}

variable "postgres_version" {
  description = "Cloud SQL PostgreSQL engine version."
  type        = string
  default     = "POSTGRES_16"
}

variable "postgres_database" {
  description = "PostgreSQL database used by n8n."
  type        = string
  default     = "n8n"
}

variable "postgres_user" {
  description = "PostgreSQL user used by n8n. Create this user out of band and mirror its password into Secret Manager."
  type        = string
  default     = "n8n"
}

variable "cloud_sql_tier" {
  description = "Cloud SQL machine tier for the n8n PostgreSQL instance."
  type        = string
  default     = "db-g1-small"
}

variable "cloud_sql_disk_size_gb" {
  description = "Initial Cloud SQL disk size in GiB. Autoresize remains enabled."
  type        = number
  default     = 20

  validation {
    condition     = var.cloud_sql_disk_size_gb >= 10
    error_message = "cloud_sql_disk_size_gb must be at least 10."
  }
}

variable "cloud_sql_deletion_protection" {
  description = "Whether Cloud SQL deletion protection is enabled."
  type        = bool
  default     = true
}

variable "binary_data_bucket_name" {
  description = "Optional explicit GCS bucket name for n8n filesystem binary data."
  type        = string
  default     = ""
}

variable "forms_rate_limit_period_seconds" {
  description = "Cloudflare public forms rate-limit counting period."
  type        = number
  default     = 10
}

variable "forms_rate_limit_requests_per_period" {
  description = "Requests per IP and Cloudflare colo allowed during the forms rate-limit period before managed challenge."
  type        = number
  default     = 20
}

variable "forms_rate_limit_mitigation_seconds" {
  description = "How long Cloudflare keeps rate-limit mitigation active."
  type        = number
  default     = 10
}

variable "forms_threat_score_challenge_threshold" {
  description = "Cloudflare threat score above which public forms requests receive a managed challenge."
  type        = number
  default     = 10

  validation {
    condition     = var.forms_threat_score_challenge_threshold >= 0 && var.forms_threat_score_challenge_threshold <= 100
    error_message = "forms_threat_score_challenge_threshold must be between 0 and 100."
  }
}

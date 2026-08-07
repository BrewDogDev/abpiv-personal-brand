output "cloud_run_service_name" {
  description = "Cloud Run service name for n8n."
  value       = var.legacy_stack_enabled ? google_cloud_run_v2_service.n8n[0].name : null
}

output "cloud_run_service_uri" {
  description = "Cloud Run service URI. Ingress is load-balancer-only; public traffic should use Cloudflare and the HTTPS load balancer."
  value       = var.legacy_stack_enabled ? google_cloud_run_v2_service.n8n[0].uri : null
}

output "forms_hostname" {
  description = "Public n8n forms hostname."
  value       = var.forms_hostname
}

output "editor_hostname" {
  description = "Optional Cloudflare Access-protected n8n editor hostname."
  value       = local.editor_enabled ? var.editor_hostname : null
}

output "load_balancer_ip_address" {
  description = "External IPv4 address for the n8n HTTPS load balancer."
  value       = var.legacy_stack_enabled ? google_compute_global_address.n8n_lb[0].address : null
}

output "cloud_sql_instance_name" {
  description = "Cloud SQL PostgreSQL instance name."
  value       = var.legacy_stack_enabled ? google_sql_database_instance.n8n[0].name : null
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name."
  value       = var.legacy_stack_enabled ? google_sql_database_instance.n8n[0].connection_name : null
}

output "cloud_sql_private_ip_address" {
  description = "Private IP address used by Cloud Run to reach Cloud SQL."
  value       = var.legacy_stack_enabled ? google_sql_database_instance.n8n[0].private_ip_address : null
}

output "binary_data_bucket_name" {
  description = "GCS bucket mounted into Cloud Run for n8n filesystem binary data."
  value       = var.legacy_stack_enabled ? google_storage_bucket.binary_data[0].name : null
}

output "runtime_secret_ids" {
  description = "Secret Manager secret IDs that must receive out-of-band secret versions before n8n can start successfully."
  value       = { for key, secret in google_secret_manager_secret.runtime : key => secret.secret_id }
}

output "n8n_mcp_cf_access_client_id" {
  description = "Cloudflare Access service-token client ID for non-browser n8n MCP access."
  value       = one(cloudflare_zero_trust_access_service_token.n8n_mcp[*].client_id)
  sensitive   = true
}

output "n8n_mcp_cf_access_client_secret" {
  description = "Cloudflare Access service-token client secret for non-browser n8n MCP access."
  value       = one(cloudflare_zero_trust_access_service_token.n8n_mcp[*].client_secret)
  sensitive   = true
}

output "certificate_dns_authorization_records" {
  description = "DNS authorization CNAMEs for the Google-managed certificate. These are also managed in Cloudflare DNS."
  value = {
    for key, authorization in google_certificate_manager_dns_authorization.n8n : key => {
      name = try(authorization.dns_resource_record[0].name, null)
      type = try(authorization.dns_resource_record[0].type, null)
      data = try(authorization.dns_resource_record[0].data, null)
    }
  }
}

output "github_deployer_service_account_email" {
  description = "Dedicated service account intended for GitHub Actions OIDC n8n deployments after bootstrap."
  value       = google_service_account.github_deployer.email
}

output "compute_instance_name" {
  description = "Private Compute Engine instance that hosts the isolated n8n and Plausible projects."
  value       = google_compute_instance.n8n.name
}

output "compute_instance_zone" {
  description = "Zone of the private shared runtime VM."
  value       = google_compute_instance.n8n.zone
}

output "compute_private_ip_address" {
  description = "Private RFC1918 address of the shared runtime VM."
  value       = google_compute_instance.n8n.network_interface[0].network_ip
}

output "compute_service_account_email" {
  description = "Least-privilege service account attached to the runtime VM."
  value       = google_service_account.n8n_compute.email
}

output "plausible_data_disk_name" {
  description = "Independent non-auto-delete data disk for Plausible on the shared VM."
  value       = google_compute_disk.plausible_data.name
}

output "plausible_runtime_secret_ids" {
  description = "Secret metadata that must receive approved out-of-band Plausible values before migration."
  value       = { for key, secret in google_secret_manager_secret.plausible_runtime : key => secret.secret_id }
}

output "backup_bucket_name" {
  description = "Private, versioned, seven-day target backup bucket shared through isolated prefixes."
  value       = google_storage_bucket.n8n_backups.name
}

output "cloudflare_tunnel_id" {
  description = "Cloudflare Tunnel ID. This identifier is not the tunnel token."
  value       = var.enable_cloudflare_edge ? cloudflare_zero_trust_tunnel_cloudflared.n8n[0].id : null
}

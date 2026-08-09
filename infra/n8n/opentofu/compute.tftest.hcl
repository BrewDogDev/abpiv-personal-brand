mock_provider "google" {
  mock_resource "google_compute_network" {
    defaults = {
      id = "projects/abpiv-personal-brand/global/networks/abpiv-n8n-network"
    }
  }

  mock_resource "google_service_account" {
    defaults = {
      name  = "projects/abpiv-personal-brand/serviceAccounts/mocksa@abpiv-personal-brand.iam.gserviceaccount.com"
      email = "mocksa@abpiv-personal-brand.iam.gserviceaccount.com"
    }
  }

  mock_resource "google_certificate_manager_dns_authorization" {
    defaults = {
      dns_resource_record = [{
        name = "_acme-challenge.mock.example.com."
        data = "mock.authorization.example.net."
        type = "CNAME"
      }]
    }
  }
}
mock_provider "google-beta" {}
mock_provider "cloudflare" {}

run "additive_defaults_are_rollback_safe" {
  command = plan

  assert {
    condition     = var.runtime_origin == "cloud_run"
    error_message = "The default origin must remain Cloud Run until an approved cutover."
  }

  assert {
    condition     = var.legacy_stack_enabled
    error_message = "The complete rollback stack must remain enabled by default."
  }

  assert {
    condition     = var.legacy_deployer_permissions_enabled
    error_message = "Legacy deletion permissions must remain enabled by default."
  }

  assert {
    condition     = !var.legacy_destruction_armed
    error_message = "Cloud SQL destruction arming must remain disabled by default."
  }

  assert {
    condition     = google_compute_instance.n8n.machine_type == "e2-custom-medium-6144"
    error_message = "The initial shared runtime size must remain e2-custom-medium-6144."
  }

  assert {
    condition     = length(google_compute_instance.n8n.network_interface[0].access_config) == 0
    error_message = "The private runtime VM must not have a public access configuration."
  }

  assert {
    condition     = google_compute_disk.n8n_data.size == 30
    error_message = "The independent data disk must default to 30 GiB."
  }

  assert {
    condition     = google_compute_disk.plausible_data.size == 80
    error_message = "The independent Plausible data disk must default to 80 GiB."
  }
}

run "destroyed_legacy_cannot_be_selected_as_origin" {
  command = plan

  variables {
    runtime_origin         = "cloud_run"
    legacy_stack_enabled   = false
    enable_cloudflare_edge = false
  }

  expect_failures = [
    check.rollback_origin_available,
  ]
}

run "destruction_cannot_be_armed_on_cloud_run_origin" {
  command = plan

  variables {
    runtime_origin           = "cloud_run"
    legacy_stack_enabled     = true
    legacy_destruction_armed = true
  }

  expect_failures = [
    check.destruction_arming_is_narrow,
  ]
}

run "cloud_run_origin_requires_one_minimum_instance" {
  command = plan

  variables {
    runtime_origin                        = "cloud_run"
    legacy_stack_enabled                  = true
    legacy_cloud_run_min_instances        = 0
    enable_cloudflare_edge                = false
    editor_hostname                       = ""
    cloudflare_account_id                 = ""
    allanbpediniv_zone_id                 = ""
    editor_access_allowed_emails          = []
    editor_access_allowed_group_ids       = []
    github_oidc_principal_set             = ""
    manage_cloudflare_access_organization = false
  }

  expect_failures = [
    check.rollback_origin_available,
  ]
}

run "legacy_stack_requires_deployer_permissions" {
  command = plan

  variables {
    runtime_origin                        = "compute"
    legacy_stack_enabled                  = true
    legacy_deployer_permissions_enabled   = false
    enable_cloudflare_edge                = true
    editor_hostname                       = "workflows.lobst3rs.com"
    cloudflare_account_id                 = "mock-account"
    allanbpediniv_zone_id                 = "00000000000000000000000000000001"
    editor_zone_id                        = "00000000000000000000000000000002"
    editor_access_allowed_emails          = ["allan@example.com"]
    github_oidc_principal_set             = ""
    manage_cloudflare_access_organization = false
  }

  expect_failures = [
    check.legacy_stack_has_deployer_permissions,
  ]
}

run "deferred_private_network_state_is_narrow_and_valid" {
  command = plan

  variables {
    runtime_origin                               = "compute"
    legacy_stack_enabled                         = false
    legacy_deployer_permissions_enabled          = false
    legacy_private_service_connection_enabled    = true
    legacy_service_networking_permission_enabled = true
    enable_cloudflare_edge                       = true
    editor_hostname                              = "workflows.lobst3rs.com"
    cloudflare_account_id                        = "mock-account"
    allanbpediniv_zone_id                        = "00000000000000000000000000000001"
    editor_zone_id                               = "00000000000000000000000000000002"
    editor_access_allowed_emails                 = ["allan@example.com"]
    github_oidc_principal_set                    = ""
    manage_cloudflare_access_organization        = false
  }

  assert {
    condition     = length(google_compute_global_address.private_services) == 1
    error_message = "The Google-retained private range must remain declared in the deferred state."
  }

  assert {
    condition     = length(google_service_networking_connection.private_services) == 1
    error_message = "The Google-retained private connection must remain declared in the deferred state."
  }

  assert {
    condition     = contains(local.github_deployer_project_roles, "roles/servicenetworking.networksAdmin")
    error_message = "The deferred state must retain its exact deletion permission."
  }

  assert {
    condition     = !contains(local.github_deployer_project_roles, "roles/run.admin")
    error_message = "The deferred state must not retain unrelated legacy deletion roles."
  }
}

run "deferred_connection_requires_its_exact_permission" {
  command = plan

  variables {
    runtime_origin                               = "compute"
    legacy_stack_enabled                         = false
    legacy_deployer_permissions_enabled          = false
    legacy_private_service_connection_enabled    = true
    legacy_service_networking_permission_enabled = false
    enable_cloudflare_edge                       = true
    editor_hostname                              = "workflows.lobst3rs.com"
    cloudflare_account_id                        = "mock-account"
    allanbpediniv_zone_id                        = "00000000000000000000000000000001"
    editor_zone_id                               = "00000000000000000000000000000002"
    editor_access_allowed_emails                 = ["allan@example.com"]
    github_oidc_principal_set                    = ""
    manage_cloudflare_access_organization        = false
  }

  expect_failures = [
    check.deferred_private_service_connection_is_narrow,
  ]
}

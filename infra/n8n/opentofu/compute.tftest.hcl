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
    runtime_origin       = "cloud_run"
    legacy_stack_enabled = false
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

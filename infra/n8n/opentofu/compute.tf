resource "google_compute_router" "n8n" {
  name    = "${local.name_prefix}-router"
  network = google_compute_network.n8n.id
  region  = var.gcp_region
}

resource "google_compute_router_nat" "n8n" {
  name                               = "${local.name_prefix}-nat"
  router                             = google_compute_router.n8n.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.n8n.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

resource "google_compute_disk" "n8n_data" {
  name   = local.compute_data_disk_name
  type   = "pd-balanced"
  zone   = var.gcp_zone
  size   = var.compute_data_disk_size_gb
  labels = merge(local.compute_labels, { data_class = "n8n-runtime" })

  physical_block_size_bytes = 4096
}

resource "google_compute_disk" "plausible_data" {
  name   = local.compute_plausible_data_disk_name
  type   = "pd-balanced"
  zone   = var.gcp_zone
  size   = var.plausible_data_disk_size_gb
  labels = merge(local.compute_labels, { data_class = "plausible-runtime" })

  physical_block_size_bytes = 4096
}

resource "google_compute_instance" "n8n" {
  name                      = "abpiv-runtime-vm"
  zone                      = var.gcp_zone
  machine_type              = var.compute_machine_type
  allow_stopping_for_update = true
  can_ip_forward            = false
  deletion_protection       = true
  tags                      = ["abpiv-runtime-vm", "iap-ssh"]
  labels                    = local.compute_labels

  boot_disk {
    auto_delete = true

    initialize_params {
      image = var.compute_boot_image
      size  = var.compute_boot_disk_size_gb
      type  = "pd-balanced"
      labels = merge(local.compute_labels, {
        data_class = "operating-system"
      })
    }
  }

  attached_disk {
    source      = google_compute_disk.n8n_data.id
    device_name = local.compute_data_disk_name
    mode        = "READ_WRITE"
  }

  attached_disk {
    source      = google_compute_disk.plausible_data.id
    device_name = local.compute_plausible_data_disk_name
    mode        = "READ_WRITE"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.n8n.id
    stack_type = "IPV4_ONLY"
  }

  metadata = {
    block-project-ssh-keys  = "TRUE"
    enable-guest-attributes = "TRUE"
    enable-oslogin          = "TRUE"
    serial-port-enable      = "FALSE"
  }

  metadata_startup_script = file("${path.module}/../compute/scripts/bootstrap-host.sh")

  service_account {
    email  = google_service_account.n8n_compute.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  depends_on = [
    google_compute_router_nat.n8n,
    google_project_service.required["compute.googleapis.com"],
  ]
}

resource "google_compute_firewall" "iap_ssh" {
  name      = "${local.name_prefix}-iap-ssh"
  network   = google_compute_network.n8n.name
  direction = "INGRESS"
  priority  = 1000

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iap-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_storage_bucket" "n8n_backups" {
  name                        = local.backup_bucket_name
  project                     = var.gcp_project_id
  location                    = var.gcp_region
  storage_class               = "STANDARD"
  labels                      = merge(local.compute_labels, { data_class = "backup" })
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  retention_policy {
    retention_period = 604800
    is_locked        = false
  }

  lifecycle_rule {
    condition {
      age = 7
    }

    action {
      type = "Delete"
    }
  }

  depends_on = [
    google_project_service.required["storage.googleapis.com"],
  ]
}

resource "google_secret_manager_secret" "cloudflare_tunnel_token" {
  secret_id = "${local.name_prefix}-cloudflare-tunnel-token"
  labels    = local.compute_labels

  replication {
    auto {}
  }

  depends_on = [
    google_project_service.required["secretmanager.googleapis.com"],
  ]
}

resource "google_secret_manager_secret" "plausible_runtime" {
  for_each = local.plausible_runtime_secrets

  secret_id = each.value.secret_id
  labels    = merge(local.compute_labels, { data_class = "plausible-secret" })

  replication {
    auto {}
  }

  depends_on = [
    google_project_service.required["secretmanager.googleapis.com"],
  ]
}

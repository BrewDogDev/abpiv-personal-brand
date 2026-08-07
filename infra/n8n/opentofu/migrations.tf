# Preserve all existing singleton addresses when the legacy stack becomes
# conditionally removable. These moves must be applied while
# legacy_stack_enabled remains true.
moved {
  from = google_compute_global_address.private_services
  to   = google_compute_global_address.private_services[0]
}

moved {
  from = google_service_networking_connection.private_services
  to   = google_service_networking_connection.private_services[0]
}

moved {
  from = google_vpc_access_connector.n8n
  to   = google_vpc_access_connector.n8n[0]
}

moved {
  from = google_sql_database_instance.n8n
  to   = google_sql_database_instance.n8n[0]
}

moved {
  from = google_sql_database.n8n
  to   = google_sql_database.n8n[0]
}

moved {
  from = google_storage_bucket.binary_data
  to   = google_storage_bucket.binary_data[0]
}

moved {
  from = google_cloud_run_v2_service.n8n
  to   = google_cloud_run_v2_service.n8n[0]
}

moved {
  from = google_compute_region_network_endpoint_group.n8n
  to   = google_compute_region_network_endpoint_group.n8n[0]
}

moved {
  from = google_compute_backend_service.n8n
  to   = google_compute_backend_service.n8n[0]
}

moved {
  from = google_compute_url_map.n8n
  to   = google_compute_url_map.n8n[0]
}

moved {
  from = google_certificate_manager_certificate.n8n
  to   = google_certificate_manager_certificate.n8n[0]
}

moved {
  from = google_certificate_manager_certificate_map.n8n
  to   = google_certificate_manager_certificate_map.n8n[0]
}

moved {
  from = google_compute_target_https_proxy.n8n
  to   = google_compute_target_https_proxy.n8n[0]
}

moved {
  from = google_compute_global_address.n8n_lb
  to   = google_compute_global_address.n8n_lb[0]
}

moved {
  from = google_compute_global_forwarding_rule.https
  to   = google_compute_global_forwarding_rule.https[0]
}

moved {
  from = google_service_account.n8n_runtime
  to   = google_service_account.n8n_runtime[0]
}

moved {
  from = google_project_iam_member.runtime_cloudsql_client
  to   = google_project_iam_member.runtime_cloudsql_client[0]
}

moved {
  from = google_storage_bucket_iam_member.runtime_binary_data_object_user
  to   = google_storage_bucket_iam_member.runtime_binary_data_object_user[0]
}

moved {
  from = google_service_account_iam_member.github_deployer_runtime_service_account_user
  to   = google_service_account_iam_member.github_deployer_runtime_service_account_user[0]
}

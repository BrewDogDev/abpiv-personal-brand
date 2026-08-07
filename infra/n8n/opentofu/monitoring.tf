locals {
  compute_instance_metric_filter = "resource.type=\"gce_instance\" AND resource.label.\"instance_id\"=\"${google_compute_instance.n8n.instance_id}\""

  compute_alerts = {
    cpu = {
      display_name    = "ABPIV shared runtime sustained CPU"
      metric_filter   = "${local.compute_instance_metric_filter} AND metric.type=\"compute.googleapis.com/instance/cpu/utilization\""
      threshold_value = 0.8
      duration        = "900s"
      trigger         = "CPU exceeded 80% for 15 minutes. Request an approved in-place resize to e2-standard-2."
    }
    memory = {
      display_name    = "ABPIV shared runtime sustained memory"
      metric_filter   = "${local.compute_instance_metric_filter} AND metric.type=\"agent.googleapis.com/memory/percent_used\" AND metric.label.\"state\"=\"used\""
      threshold_value = 80
      duration        = "900s"
      trigger         = "Memory exceeded 80% for 15 minutes. Request an approved in-place resize to e2-standard-2."
    }
    swap = {
      display_name    = "ABPIV shared runtime sustained swap"
      metric_filter   = "${local.compute_instance_metric_filter} AND metric.type=\"agent.googleapis.com/swap/bytes_used\""
      threshold_value = 268435456
      duration        = "300s"
      trigger         = "Swap exceeded 256 MiB for five minutes. Request an approved in-place resize to e2-standard-2."
    }
  }
}

resource "google_monitoring_alert_policy" "compute_capacity" {
  for_each = local.compute_alerts

  display_name = each.value.display_name
  combiner     = "OR"
  enabled      = true
  user_labels  = local.compute_labels

  conditions {
    display_name = each.value.display_name

    condition_threshold {
      filter          = each.value.metric_filter
      comparison      = "COMPARISON_GT"
      duration        = each.value.duration
      threshold_value = each.value.threshold_value

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  alert_strategy {
    auto_close = "604800s"
  }

  documentation {
    content   = each.value.trigger
    mime_type = "text/markdown"
  }

  depends_on = [
    google_project_service.required["monitoring.googleapis.com"],
  ]
}

resource "google_logging_metric" "compute_runtime_fault" {
  name        = "abpiv_n8n_compute_runtime_fault"
  description = "OOM, container-restart, request-latency, and Tunnel events emitted by either isolated runtime on the shared VM."
  filter      = "resource.type=\"gce_instance\" AND resource.labels.instance_id=\"${google_compute_instance.n8n.instance_id}\" AND (jsonPayload.message=~\"ABPIV_(N8N|PLAUSIBLE)_ALERT\" OR textPayload=~\"ABPIV_(N8N|PLAUSIBLE)_ALERT\")"

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }

  depends_on = [
    google_project_service.required["logging.googleapis.com"],
  ]
}

resource "google_monitoring_alert_policy" "compute_runtime_fault" {
  display_name = "ABPIV shared runtime fault"
  combiner     = "OR"
  enabled      = true
  user_labels  = local.compute_labels

  conditions {
    display_name = "Any OOM, restart, latency, or Tunnel fault"

    condition_threshold {
      filter          = "resource.type=\"gce_instance\" AND metric.type=\"logging.googleapis.com/user/${google_logging_metric.compute_runtime_fault.name}\""
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      threshold_value = 0

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  alert_strategy {
    auto_close = "604800s"
  }

  documentation {
    content   = "An OOM, container restart, material local latency, or inactive Tunnel was detected. Inspect both isolated runtimes; request an approved in-place resize to e2-standard-2 when capacity is implicated."
    mime_type = "text/markdown"
  }
}

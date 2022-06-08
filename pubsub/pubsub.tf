variable "project_id" {}

resource "google_pubsub_topic" "logrhythm-logs" {
  name = "logrhythm-log"
  project = var.project_id
  message_retention_duration = "606200s"
}

resource "google_pubsub_topic" "logrhythm-alerts" {
  name = "logrhythm-alerts"
  project = var.project_id
  message_retention_duration = "606200s"
}

resource "google_pubsub_subscription" "logrhythm-logs" {
  project = var.project_id
  name  = "logrhythm-logs"
  topic = google_pubsub_topic.logrhythm-logs.name

  # 20 minutes
  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}

resource "google_pubsub_subscription" "logrhythm-alerts" {
  project = var.project_id
  name  = "logrhythm-alerts"
  topic = google_pubsub_topic.logrhythm-alerts.name

  # 20 minutes
  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}

output "logrhythm-logs-topic" {
    value = google_pubsub_topic.logrhythm-logs
}

output "logrhythm-alerts-topic" {
    value = google_pubsub_topic.logrhythm-alerts
}

output "logrhythm-logs-subscription" {
    value = google_pubsub_subscription.logrhythm-logs
}

output "logrhythm-alerts-subscription" {
    value = google_pubsub_subscription.logrhythm-alerts
}
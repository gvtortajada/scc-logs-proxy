variable "project_id" {}
variable "project_number" {}
variable "logrhythm-logs-topic" {}
variable "logrhythm-alerts-topic" {}
variable "logrhythm-logs-subscription" {}
variable "logrhythm-alerts-subscription" {}

resource "google_project_organization_policy" "requireOsLogin" {
  project     = var.project_id
  constraint = "compute.requireOsLogin"
 
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "requireShieldedVm" {
  project     = var.project_id
  constraint = "compute.requireShieldedVm"
 
  boolean_policy {
    enforced = false
  }
}

resource "google_project_organization_policy" "restrictVpcPeering" {
    project     = var.project_id
    constraint = "compute.restrictVpcPeering"
 
    list_policy {
        allow {
            all = true
        }
    }
}

resource "google_project_iam_member" "run-invoker" {
    project = var.project_id
    role    = "roles/run.invoker"
    member  = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "secretAccessor" {
    project = var.project_id
    role    = "roles/secretmanager.secretAccessor"
    member  = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "serviceAccountTokenCreator" {
    project = var.project_id
    role    = "roles/iam.serviceAccountTokenCreator"
    member  = "serviceAccount:service-${var.project_number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "logWriter" {
    project = var.project_id
    role    = "roles/logging.logWriter"
    member  = "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
}

resource "google_service_account" "logrhythm-logs-pub" {
    account_id   = "logrhythm-logs-pub"
    display_name = "logrhythm-logs-pub"
    project      = var.project_id
}

resource "google_service_account" "logrhythm-alerts-pub" {
    account_id   = "logrhythm-alerts-pub"
    display_name = "logrhythm-alerts-pub"
    project      = var.project_id
}

# resource "google_project_iam_member" "logrhythm-logs-pub" {
#     project = var.project_id
#     role    = "roles/pubsub.publisher"
#     member  = "serviceAccount:${google_service_account.logrhythm-logs-pub.email}"
# }

# resource "google_project_iam_member" "logrhythm-alerts-pub" {
#     project = var.project_id
#     role    = "roles/pubsub.publisher"
#     member  = "serviceAccount:${google_service_account.logrhythm-alerts-pub.email}"
# }

resource "google_service_account" "logrhythm-logs-sub" {
    account_id   = "logrhythm-logs-sub"
    display_name = "logrhythm-logs-sub"
    project      = var.project_id
}

resource "google_service_account" "logrhythm-alerts-sub" {
    account_id   = "logrhythm-alerts-sub"
    display_name = "logrhythm-alerts-sub"
    project      = var.project_id
}

# resource "google_project_iam_member" "logrhythm-logs-sub" {
#     project = var.project_id
#     role    = "roles/pubsub.subscriber"
#     member  = "serviceAccount:${google_service_account.logrhythm-logs-sub.email}"
# }

# resource "google_project_iam_member" "logrhythm-alerts-sub" {
#     project = var.project_id
#     role    = "roles/pubsub.subscriber"
#     member  = "serviceAccount:${google_service_account.logrhythm-alerts-sub.email}"
# }

resource "google_pubsub_topic_iam_member" "logrhythm-logs-pub" {
  project = var.project_id
  topic = var.logrhythm-logs-topic.name
  role = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.logrhythm-logs-pub.email}"
}

resource "google_pubsub_topic_iam_member" "logrhythm-alerts-pub" {
  project = var.project_id
  topic = var.logrhythm-alerts-topic.name
  role = "roles/pubsub.publisher"
  member = "serviceAccount:${google_service_account.logrhythm-alerts-pub.email}"
}

resource "google_pubsub_subscription_iam_member" "logrhythm-logs-sub" {
  subscription = var.logrhythm-logs-subscription.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${google_service_account.logrhythm-logs-sub.email}"
}

resource "google_pubsub_subscription_iam_member" "logrhythm-alerts-sub" {
  subscription = var.logrhythm-alerts-subscription.name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${google_service_account.logrhythm-alerts-sub.email}"
}
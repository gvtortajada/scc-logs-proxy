variable "project_id" {}
variable "project_number" {}

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



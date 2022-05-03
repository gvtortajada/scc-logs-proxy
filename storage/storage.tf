variable "project_id" {
}

variable "region" {
}

resource "google_artifact_registry_repository" "scc-proxy" {
  provider      = google-beta
  project       = var.project_id
  location      = var.region
  repository_id = "scc-proxy"
  format        = "DOCKER"
}
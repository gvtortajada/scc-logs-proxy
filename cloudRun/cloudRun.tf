variable "project_id" {}
variable "region" {}
variable "api-user" {}
variable "api-secret" {}

resource "google_cloud_run_service" "scc-proxy" {
    name     = "scc-proxy"
    project  = var.project_id
    location = var.region

    template {
        metadata {
            annotations = {
                "autoscaling.knative.dev/maxScale" = "5"
            }
        }
        spec {
            containers {
                image = "gcr.io/${var.project_id}/scc-proxy"
                env {
                    name = "API_USER"
                    value_from {
                        secret_key_ref {
                            name = var.api-user.secret_id
                            key = "1"
                        }
                    }
                }
                env {
                    name = "API_SECRET"
                    value_from {
                        secret_key_ref {
                            name = var.api-secret.secret_id
                            key = "1"
                        }
                    }
                }
            }
            container_concurrency = 50
        }
    }

    traffic {
        percent         = 100
        latest_revision = true
    }

    metadata {
        annotations = {
            "run.googleapis.com/ingress" = "internal",
        }
    }    
}

output "cloudRun-scc-proxy" {
  value = google_cloud_run_service.scc-proxy
}
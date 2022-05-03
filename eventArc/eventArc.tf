variable "project_id" {}
variable "region" {}
variable "cloudRun-scc-proxy" {}
variable "project_number" {}

resource "google_eventarc_trigger" "scc-proxy" {
    name = "scc-proxy"
    project = var.project_id
    location = var.region
    service_account = "${var.project_number}-compute@developer.gserviceaccount.com"
    matching_criteria {
        attribute = "type"
        value = "google.cloud.pubsub.topic.v1.messagePublished"
    }
    destination {
        cloud_run_service {
            service = var.cloudRun-scc-proxy.name
            region = var.region
        }
    }
}
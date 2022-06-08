provider "google-beta" {
  region  = var.region
}

provider "google" {
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "<PROJECT_ID>-terraform-state"
  }
}

data "google_project" "project" {
    project_id = var.project_id
}

module "apis" {
  source      = "./apis"
  project_id = var.project_id
}

module "pubsub" {
  source     = "./pubsub"
  project_id = var.project_id
  depends_on = [
    module.apis
  ]
}

module "iam" {
  source                        = "./iam"
  project_id                    = var.project_id
  project_number                = data.google_project.project.number
  logrhythm-logs-topic          = module.pubsub.logrhythm-logs-topic
  logrhythm-alerts-topic        = module.pubsub.logrhythm-alerts-topic
  logrhythm-logs-subscription   = module.pubsub.logrhythm-logs-subscription
  logrhythm-alerts-subscription = module.pubsub.logrhythm-alerts-subscription
  depends_on  = [
    module.apis,
    module.pubsub,
  ]
}

module "storage" {
  source      = "./storage"
  project_id  = var.project_id
  region      = var.region
  depends_on  = [
    module.apis
  ]
}

module "build" {
  source      = "./build"
  project_id  = var.project_id
  region      = var.region
  depends_on  = [
    module.apis,
    module.storage
  ]
}

module "secrets" {
  source      = "./secrets"
  project_id  = var.project_id
  api_user    = var.api_user
  api_secret  = var.api_secret
  depends_on  = [
    module.apis
  ]
}

module "cloudRun" {
  source      = "./cloudRun"
  project_id  = var.project_id
  region      = var.region
  api-user    = module.secrets.api-user
  api-secret  = module.secrets.api-secret
  depends_on  = [
    module.build,
    module.secrets
  ]
}

module "eventArc" {
  source      = "./eventArc"
  project_id  = var.project_id
  region      = var.region
  cloudRun-scc-proxy = module.cloudRun.cloudRun-scc-proxy
  project_number = data.google_project.project.number
  depends_on  = [
    module.cloudRun,
    module.apis
  ]
}



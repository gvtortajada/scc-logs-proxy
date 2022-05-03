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

module "iam" {
  source      = "./iam"
  project_id  = var.project_id
  project_number = data.google_project.project.number
  depends_on  = [
    module.apis
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



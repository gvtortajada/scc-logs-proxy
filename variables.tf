# the scc-proxy will be updated by the create_state_bucket.sh script
variable "project_id" {
  description = "the project id"
  default = "<PROJECT_ID>"  
}

variable "region" {
  description = "The region"
  default     = "northamerica-northeast1"
}

variable "zones" {
  type        = list(string)
  description = "The zone"
  default     = ["northamerica-northeast1-a"]
}

variable "api_user" {
  default = "test1"  
}

variable "api_secret" {
  default = "test2"
}

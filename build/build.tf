variable "project_id" {}
variable "region" {}

resource "null_resource" "build-container" {
  provisioner "local-exec" {
    command = "./build.sh ${var.project_id} ${var.region}"
  }
}
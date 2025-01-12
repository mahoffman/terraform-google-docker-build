locals {
    build_command = <<EOF
        ${path.module}/scripts/gcr-docker-build.sh \
        ${var.gcp_token} ${var.name}:${var.tag} ${var.gcp_project} ${var.context} ${var.build_platform} ${var.cloud_build} ${var.gcp_region}
    EOF
}

resource "null_resource" "gcr_docker_image" {
  triggers = {
    build_number = "${timestamp()}"
  }
  
  provisioner "local-exec" {
    command = "${local.build_command}"
  }
}

data "external" "gcr_image_info" {
    program = [
        "${path.module}/scripts/gcr-get-image.sh",
        "${var.name}",
        "${var.tag}",
        "${var.gcp_project}",
    ]

    depends_on = [null_resource.gcr_docker_image]
}

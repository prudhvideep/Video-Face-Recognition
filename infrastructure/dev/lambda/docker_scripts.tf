resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    working_dir = "./lambda/lambda_files/face-recognition/"
    command = <<EOT
      docker build -t ${var.repository_url}:latest .
      docker tag ${var.repository_url}:latest ${var.repository_url}:latest
      aws ecr get-login-password | docker login --username AWS --password-stdin ${var.repository_url}
      docker push ${var.repository_url}:latest
    EOT
  }

  depends_on = [ var.repository_url ]
}

resource "null_resource" "docker_cleanup" {
  provisioner "local-exec" {
    command = <<EOF
      docker rmi $(docker images --filter=reference=${var.repository_url} --format="{{.ID}}")
    EOF
  }

  depends_on = [ null_resource.docker_build ]
}

provider "docker" {}

resource "docker_container" "proofpoint" {
  image = data.docker_registry_image.dockerhub.name
  name  = "proofpoint"
  ports {
    internal = 80
    external = 8000
  }
}


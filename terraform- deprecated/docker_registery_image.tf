data "docker_registry_image" "dockerhub" {
  name = "yossimakpepo/proofpoint:0.0.1"
}

resource "docker_image" "dockerhub" {
  name          = data.docker_registry_image.dockerhub.name
  pull_triggers = [data.docker_registry_image.dockerhub.sha256_digest]
}

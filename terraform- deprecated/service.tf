resource "docker_service" "test" {
  name = "test-service"

  task_spec {
    container_spec {
      image = data.docker_registry_image.dockerhub.name
    }
  }

  endpoint_spec {
    ports {
      target_port = "8080"
    }
  }
}

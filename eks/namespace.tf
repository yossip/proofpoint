resource "kubernetes_namespace" "proofpoint" {
  metadata {
    annotations = {
      name = "demo-env"
    }

    labels = {
      mylabel = "development"
    }

    name = "demo"
  }
}
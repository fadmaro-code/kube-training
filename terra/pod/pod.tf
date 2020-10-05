resource "kubernetes_pod" "test" {
  metadata {
    name = "nginx"
  }

  spec {
    container {
      image = "nginx"
      name  = "nginx"

      port {
        container_port = 80
      }
    }
  }
}

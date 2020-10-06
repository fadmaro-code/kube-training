resource "kubernetes_secret" "ecr" {
  metadata {
    name      = "ecr-auth"
  }

  data = {
    ".dockerconfigjson" = "${file("${var.DOCKER_CONFIG}")}"
  }

  type = "kubernetes.io/dockerconfigjson"
}

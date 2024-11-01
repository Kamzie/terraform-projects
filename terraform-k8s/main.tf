resource "kubernetes_deployment" "iotdep" {
  for_each = local.deployment
  metadata {
    name = "${each.key}-dep"
    labels = {
      app = "iotapp"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "iotapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "iotapp"
        }
      }

      spec {
        container {
          image = each.value.image
          name  = "${each.key}-container"
          volume_mount {
            name       = "${each.key}-vol"
            mount_path = each.value.volumespath
          }
          port {
            container_port = each.value.int
            host_port      = each.value.ext
          }
        }
        volume {
          name = "${each.key}-vol"
          empty_dir {
            medium = ""
          }
        }
      }
    }
  }
}
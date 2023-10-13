locals {
  default_envs = [
    {
      name  = "GOOGLE_PROJECT_ID"
      value = "excel-academy-online"
    }
  ]
}


resource "google_cloud_run_service" "default" {
  name     = var.name
  location = var.location

  template {

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = tostring(var.max_instances)
        "autoscaling.knative.dev/minScale" = var.always_on == true ? "1" : "0"
        "run.googleapis.com/network-interfaces" = var.private_vpc_access == true ? jsonencode(
          [
            {
              network    = "default"
              subnetwork = "default"
            },
          ]
        ) : null
        "run.googleapis.com/vpc-access-egress" = var.private_vpc_access == true ? "private-ranges-only" : null
      }
    }
    spec {
      containers {
        image = var.image

        ports {
          name           = var.http2 == true ? "h2c" : ""
          container_port = var.port
        }

        resources {
          limits = {
            "cpu" = (
              var.cpu_size == "small" ? "1000m"
              : var.cpu_size == "medium" ? "2000m"
              : var.cpu_size == "large" ? "4000m" : ""
            )
            "memory" = (
              var.mem_size == "small" ? "128Mi"
              : var.mem_size == "medium" ? "256Mi"
              : var.mem_size == "large" ? "512Mi" : ""
            )
          }
        }
        dynamic "env" {
          for_each = concat(var.envs, local.default_envs)

          content {
            name  = env.value.name
            value = env.value.value
          }
        }
      }
    }
  }

  metadata {
    annotations = {
      generated-by                      = "terraform"
      "run.googleapis.com/ingress"      = "all"
      "run.googleapis.com/launch-stage" = var.private_vpc_access == true ? "BETA" : null
    }
  }

}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

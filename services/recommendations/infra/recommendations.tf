module "cloud_run_grpc" {
  source    = "../../../infra/modules/cloud-run"
  name      = "recommendations"
  image     = "us-central1-docker.pkg.dev/excel-academy-online/services/recommendations:${var.tag}"
  port      = "8080"
  http2     = true
  always_on = false
  mem_size  = "small"
  envs = [{
    name  = "RTDB_URL"
    value = "https://excel-academy-online-default-rtdb.firebaseio.com"
  }]
}

variable "tag" {
  type    = string
  default = "latest"
}

output "url" {
  value = module.cloud_run_grpc.url
}

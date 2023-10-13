module "cloud_run_grpc" {
  source    = "../../modules/cloud-run"
  name      = "payments"
  image     = "us-central1-docker.pkg.dev/excel-academy-online/services/payments:${var.tag}"
  port      = "8080"
  http2     = true
  always_on = false
  mem_size  = "small"
}

variable "tag" {
  type    = string
  default = "latest"
}

output "url" {
  value = module.cloud_run_grpc.url
}

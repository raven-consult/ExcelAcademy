variable "tag" {
  type    = string
  default = "latest"
}

data "google_secret_manager_secret" "typesense_api_key" {
  secret_id = "TYPESENSE_API_KEY"
}

data "google_secret_manager_secret_version" "typesense_api_key" {
  secret = data.google_secret_manager_secret.typesense_api_key.secret_id
}

module "query" {
  source             = "../../modules/cloud-run"
  name               = "query"
  image              = "us-central1-docker.pkg.dev/excel-academy-online/services/search/query:${var.tag}"
  port               = "8080"
  http2              = true
  always_on          = false
  mem_size           = "small"
  private_vpc_access = true
  envs = [{
    name  = "TYPESENSE_PORT"
    value = "8108"
    },
    {
      name  = "TYPESENSE_API_KEY"
      value = data.google_secret_manager_secret_version.typesense_api_key.secret_data
    },
    {
      name  = "TYPESENSE_HOSTNAME"
      value = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
    }
  ]
}

output "query_url" {
  value = module.query.url
}

module "indexer" {
  source             = "../../modules/cloud-run"
  name               = "indexer"
  image              = "us-central1-docker.pkg.dev/excel-academy-online/services/search/indexer:${var.tag}"
  port               = "8080"
  http2              = false
  always_on          = false
  mem_size           = "small"
  private_vpc_access = true
  envs = [{
    name  = "TYPESENSE_PORT"
    value = "8108"
    },
    {
      name  = "TYPESENSE_API_KEY"
      value = data.google_secret_manager_secret_version.typesense_api_key.secret_data
    },
    {
      name  = "TYPESENSE_HOSTNAME"
      value = google_compute_instance.master.network_interface.0.network_ip
    }
  ]
}

output "indexer_url" {
  value = module.indexer.url
}


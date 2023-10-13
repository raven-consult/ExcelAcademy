data "google_cloud_run_service" "payments" {
  name     = "payments"
  location = "us-central1"
}

data "google_cloud_run_service" "search_query" {
  name     = "query"
  location = "us-central1"
}

data "google_cloud_run_service" "recommendations" {
  name     = "recommendations"
  location = "us-central1"
}

output "payments" {
  value = trimprefix(data.google_cloud_run_service.payments.status[0].url, "https://")
}

output "search_query" {
  value = trimprefix(data.google_cloud_run_service.search_query.status[0].url, "https://")
}

output "recommendations" {
  value = trimprefix(data.google_cloud_run_service.recommendations.status[0].url, "https://")
}


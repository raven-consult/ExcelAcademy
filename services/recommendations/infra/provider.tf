// Configure the Google Cloud provider
provider "google" {
  project = "excel-academy-online"
}

terraform {
  backend "gcs" {
    bucket = "excel-academy-tfstate"
    prefix = "terraform/services/recommendations/state"
  }
}

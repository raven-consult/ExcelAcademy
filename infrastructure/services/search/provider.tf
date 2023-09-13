terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.79.0"
    }
  }

  backend "gcs" {
    bucket = "excel-academy-tfstate"
    prefix = "terraform/services/search/state"
  }
}

provider "google" {
  project = "excel-academy-online"
  region  = "us-central1"
  zone    = "us-central1-a"
}

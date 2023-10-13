terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.79.0"
    }
  }

  backend "gcs" {
    bucket = "excel-academy-tfstate"
    prefix = "terraform/services/payments/state"
  }
}

provider "google" {
  project = "excel-academy-online"
}

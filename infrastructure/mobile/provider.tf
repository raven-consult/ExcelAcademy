terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.79.0"
    }
  }

  backend "gcs" {
    bucket = "excel-academy-tfstate"
    prefix = "terraform/mobile/state"
  }
}

provider "google" {
  project = "excel-academy-online"
}

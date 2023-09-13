data "google_service_account" "master_sa" {
  account_id = "master-instance"
}

data "google_compute_image" "master_image" {
  name = "master"
}

data "google_compute_disk" "master_persistent" {
  name = "master-persistent"
}

resource "google_compute_instance" "master" {
  name         = "master"
  machine_type = "e2-medium"

  metadata = {
    "enable-osconfig" = "TRUE"
  }

  tags = [
    "http-server",
    "https-server",
    "allow-typesense",
  ]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.master_image.self_link
    }
  }

  attached_disk {
    source = data.google_compute_disk.master_persistent.self_link
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = data.google_service_account.master_sa.email
    scopes = ["cloud-platform"]
  }
}

output "master_internal_ip" {
  value = google_compute_instance.master.network_interface.0.network_ip
}

output "master_external_ip" {
  value = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
}

provider "google" {
  #   version = "1.4.0"
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "registry" {
  name         = "nexus-registry"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["registry"]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
    host = self.network_interface[0].access_config[0].nat_ip
  }

  provisioner "remote-exec" {
    script = "files/install_docker.sh"
  }

}

resource "google_compute_instance" "docker" {
  name         = "docker-host"
  machine_type = "g1-small"
  zone         = var.zone
  tags         = ["docker-host"]

  boot_disk {
    initialize_params {
      image = var.app_disk_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
    host = self.network_interface[0].access_config[0].nat_ip
  }

  provisioner "remote-exec" {
    script = "files/install_docker.sh"
  }

}

resource "google_compute_firewall" "firewall_nexus" {
  name    = "allow-nexus-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8081"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["registry"]
}

resource "google_compute_firewall" "firewall_docker_registry" {
  name    = "allow-docker-registry"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["8082", "8083"]
  }
  source_tags = ["docker-host"]
  target_tags   = ["registry"]
}


# resource "google_compute_firewall" "firewall_puma_80" {
#   name    = "allow-puma-80-default"
#   network = "default"
#   allow {
#     protocol = "tcp"
#     ports    = ["80"]
#   }
#   source_ranges = ["0.0.0.0/0"]
#   target_tags   = ["reddit-app"]
# }

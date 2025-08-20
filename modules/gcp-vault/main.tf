provider "google" {
  credentials = base64decode(var.gcp_credentials)
  project = var.project
  region  = var.region
  zone    = var.zone
}

# VPC
resource "google_compute_network" "vault_vpc" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "vault_subnet" {
  name          = "${var.name}-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = var.region
  network       = google_compute_network.vault_vpc.id
}

# Firewall Rules
resource "google_compute_firewall" "vault_fw" {
  name    = "${var.name}-fw"
  network = google_compute_network.vault_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22", "8200", "8201"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Save Private Key Locally
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/my_gcp_key.pem"
  file_permission      = "0600"
  directory_permission = "0700"
}

#Save Public Key Locally
resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/my_gcp_key.pub"
}


# VM
resource "google_compute_instance" "vault_instance" {
  name         = "${var.name}-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = google_compute_network.vault_vpc.id
    subnetwork = google_compute_subnetwork.vault_subnet.id
    access_config {}
  }

  metadata_startup_script = file("vault.sh")

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key.public_key_openssh}"
  }

  tags = [var.name]
}

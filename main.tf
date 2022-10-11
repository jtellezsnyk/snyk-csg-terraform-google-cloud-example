terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.38.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "google" {
  project = "snyk-csg"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "random_pet" "pet_name" {
  length = 2
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network-${random_pet.pet_name.id}"
}

resource "google_compute_firewall" "default" {
  name    = "test-firewall-${random_pet.pet_name.id}"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080", "1000-2000"]
  }

  source_ranges = var.fail_SNYK-CC-TF-32 ? ["0.0.0.0/0"] : ["10.128.0.0/9"]
}

resource "google_compute_address" "static" {
  name = "ipv4-address-${random_pet.pet_name.id}"
}

resource "google_compute_instance" "vm_instance" {
  name                      = "terraform-instance-${random_pet.pet_name.id}"
  machine_type              = "f1-micro"
  tags                      = ["hello", "world"]
  allow_stopping_for_update = true

  shielded_instance_config {
    enable_integrity_monitoring = var.fail_SNYK-CC-GCP-282 ? false : true
    enable_secure_boot          = var.fail_SNYK-CC-GCP-282 ? false : true
    enable_vtpm                 = var.fail_SNYK-CC-GCP-282 ? false : true
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}
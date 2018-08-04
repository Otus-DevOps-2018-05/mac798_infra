
resource "google_compute_firewall" "firewall_puma" {
  name = "${var.name_prefix}allow-puma-default"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["${var.puma_allow_ip}"]
  target_tags = ["${var.app_vm_tag}"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name = "${var.name_prefix}default-allow-ssh"
  network = "${var.network_name}"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["${var.ssh_allow_ip}"]
}

resource "google_compute_firewall" "firewall_mongodb" {
  name = "${var.name_prefix}connect-mongo-db"
  network = "${var.network_name}"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  target_tags = ["${var.db_vm_tag}"]
  source_tags = ["${var.app_vm_tag}"]
}

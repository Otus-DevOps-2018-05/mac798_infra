resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}


resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом ...
  target_tags = ["reddit-app"]
}

resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "firewall_mongodb" {
  name = "connect-mongo-db"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  # Правило применимо для инстансов с тегом ...
  target_tags = ["reddit-db"]
  #
  source_tags = ["reddid-app"]
}

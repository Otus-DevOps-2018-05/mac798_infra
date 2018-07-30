resource "google_compute_instance" "db" {
  name         = "reddit-db"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-db"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  metadata {
    ssh-keys = "${var.appusername}:${file("${var.public_key_path}")}"
  }

  connection {
    type        = "ssh"
    user        = "${var.appusername}"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source      = "files/tune-db-conf.sh"
    destination = "/tmp/tune-db-conf.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo /bin/bash /tmp/tune-db-conf.sh"]
  }

}

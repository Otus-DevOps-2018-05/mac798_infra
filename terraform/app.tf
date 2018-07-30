resource "google_compute_instance" "app" {
  count        = "${var.instance_count}"
  name         = "reddit-app${format("-%02d", (count.index+1))}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {
        nat_ip = "${google_compute_address.app_ip.address}"
    }
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
    source      = "files/deploy-app.sh"
    destination = "/tmp/deploy-app.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo /bin/bash /tmp/deploy-app.sh ${var.appusername} ${google_compute_instance.db.0.network_interface.0.address}:27017"]
  }
}

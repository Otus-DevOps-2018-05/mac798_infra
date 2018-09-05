resource "google_compute_instance" "app" {
  name         = "${var.name_prefix}reddit-app-01"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["${var.vm_tag}"]

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    access_config {
      nat_ip = "${join("", "${google_compute_address.app_ip.*.address}")}"
    }
  }

  metadata {
    ssh-keys = "${var.app_username}:${file("${var.public_key_path}")}"
  }
}

resource "google_compute_address" "app_ip" {
  count = "${var.persistent_ip ? 1 : 0}"
  name  = "${var.name_prefix}reddit-app-ip"
}

resource "null_resource" "provisioners" {
  count = "${var.run_provisioners ? 1 : 0}"

  connection {
    type        = "ssh"
    user        = "${var.app_username}"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
    host        = "${google_compute_instance.app.0.network_interface.0.access_config.0.assigned_nat_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/files/deploy-app.sh"
    destination = "/tmp/deploy-app.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo /bin/bash /tmp/deploy-app.sh ${var.app_username} ${var.db_address}:27017"]
  }

  provisioner "local-exec" {
    command = "echo Run provisioner for ${google_compute_instance.app.0.name}"
  }
}

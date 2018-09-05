resource "google_compute_instance" "db" {
  name         = "${var.name_prefix}reddit-db-01"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = "${var.vm_tag}"

  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  metadata {
    ssh-keys = "${var.app_username}:${file("${var.public_key_path}")}"
  }

  connection {
    type        = "ssh"
    user        = "${var.app_username}"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
  }
}

resource "null_resource" "provisioners" {
  count = "${var.run_provisioners}"

  connection {
    type        = "ssh"
    user        = "${var.app_username}"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
    host        = "${google_compute_instance.db.0.network_interface.0.access_config.0.assigned_nat_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/files/tune-db-conf.sh"
    destination = "/tmp/tune-db-conf.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo /bin/bash /tmp/tune-db-conf.sh"]
  }

  provisioner "local-exec" {
    command = "echo Run provisioner for ${google_compute_instance.db.0.name}"
  }
}

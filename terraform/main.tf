provider "google" {
  version = "1.4.0"
  project = "${var.project_id}"
  region  = "${var.region}"
}

provider "template" {
  version = ">0.0.0"
}

resource "google_compute_instance" "app" {
  count        = "${var.instance_count}"
  name         = "reddit-app${format("-%02d", (count.index+1))}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

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
    ssh-keys = "${var.appusername}:${file("${var.public_key_path}")}"
  }

  connection {
    type        = "ssh"
    user        = "${var.appusername}"
    agent       = false
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "file" {
    source      = "files/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = ["sudo /bin/bash /tmp/deploy.sh ${var.appusername}"]
  }
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

data "template_file" "ssh_users" {
  count    = "${length(values(var.project_ssh_users))}"
  template = "$${remote_user}:$${keyfile_content}"

  vars {
    remote_user     = "${element(keys(var.project_ssh_users), count.index)}"
    keyfile_content = "${trimspace(file(element(values(var.project_ssh_users), count.index)))}"
  }
}

resource "google_compute_project_metadata" "project_metadata" {
  project = "${var.project_id}"

  metadata = {
    #    "ssh-keys" = "${join("\n",formatlist("%s:%s", "${keys(var.project_ssh_users)}", "${data.template_file.ssh_users.*.rendered)}")}"
    "ssh-keys" = "${join("\n", "${data.template_file.ssh_users.*.rendered}")}"
  }
}

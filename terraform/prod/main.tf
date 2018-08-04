provider "google" {
  version = "1.4.0"
  project = "${var.project_id}"
  region  = "${var.region}"
}

module "reddit_app" {
  source = "../modules/reddit_app"
  public_key_path = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  db_address = "${module.reddit_db.db_address}"
  vm_tag = "${var.app_vm_tag}"
  zone = "${var.zone}"
  disk_image = "${var.app_disk_image}"
  run_provisioners = true
  name_prefix = "${var.scene}-"
  persistent_ip = true
}

module "reddit_db" {
  source = "../modules/reddit_db"
  public_key_path = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  vm_tag = "${var.db_vm_tag}"
  zone = "${var.zone}"
  disk_image = "${var.db_disk_image}"
  run_provisioners = true
  name_prefix = "${var.scene}-"
}

module "reddit_vpc" {
  source = "../modules/reddit_vpc"
  network_name = "default"
  app_vm_tag = "${var.app_vm_tag}"
  db_vm_tag = "${var.db_vm_tag}"
  ssh_allow_ip = "${var.ssh_allow_ip}"
  puma_allow_ip = "${var.puma_allow_ip}"
  name_prefix = "${var.scene}-"
}

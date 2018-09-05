provider "google" {
  version = "1.4.0"
  project = "${var.project_id}"
  region  = "${var.region}"
}

module "reddit_app" {
  source           = "../modules/app"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  db_address       = "${module.reddit_db.db_address}"
  vm_tag           = ["${var.app_vm_tag}", "${var.scene}"]
  zone             = "${var.zone}"
  disk_image       = "${var.app_disk_image}"
  run_provisioners = false
  name_prefix      = "${var.scene == "" ? "" : "${var.scene}-"}"
  persistent_ip    = true
}

module "reddit_db" {
  source           = "../modules/db"
  public_key_path  = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  vm_tag           = ["${var.db_vm_tag}", "${var.scene}"]
  zone             = "${var.zone}"
  disk_image       = "${var.db_disk_image}"
  run_provisioners = false
  name_prefix      = "${var.scene == "" ? "" : "${var.scene}-"}"
}

module "reddit_vpc" {
  source        = "../modules/vpc"
  network_name  = "default"
  app_vm_tag    = "${var.app_vm_tag}"
  db_vm_tag     = "${var.db_vm_tag}"
  ssh_allow_ip  = "${var.ssh_allow_ip}"
  puma_allow_ip = "${var.puma_allow_ip}"
  name_prefix   = "${var.scene}-"
}

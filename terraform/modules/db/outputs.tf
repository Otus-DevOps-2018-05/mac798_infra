output "db_address" {
  value = "${google_compute_instance.db.0.network_interface.0.address}"
}

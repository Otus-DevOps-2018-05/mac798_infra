resource "google_compute_forwarding_rule" "reddit_lb_fwd" {
  name                  = "reddit-lb-firewall"
  project               = "${var.project_id}"
  region                = "${var.region}"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = "${google_compute_target_pool.instance_pool.self_link}"
}

resource "google_compute_target_pool" "instance_pool" {
  name = "instance-pool"

  instances = ["${google_compute_instance.app.*.self_link}"]

  health_checks = [
    "${google_compute_http_health_check.puma_health_check.name}",
  ]
}

resource "google_compute_http_health_check" "puma_health_check" {
  name        = "puma-health-check"
  description = "Check puma reddit blog app"
  port        = "9292"
}

output "app_external_ip" {
  value = "${module.reddit_app.external_ip}"
}

output "reddit_url" {
  value = "http://${module.reddit_app.external_ip}:9292/"
}

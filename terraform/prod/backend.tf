terraform {
  backend "gcs" {
    bucket = "terraform-storage-bucket"
    prefix = "prod"
  }
}

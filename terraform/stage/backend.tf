terraform {
  backend "gcs" {
    bucket = "terraform-storage-stage"
    prefix = "stage"
  }
}

terraform {
  backend "gcs" {
    bucket = "terraform-storage-stage-2"
    prefix = "stage"
  }
}

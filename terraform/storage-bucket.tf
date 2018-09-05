module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["terraform-storage-bucket", "terraform-storage-stage"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}

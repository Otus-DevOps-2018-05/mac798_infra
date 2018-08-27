module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["terraform-storage-bucket-2", "terraform-storage-stage-2"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}

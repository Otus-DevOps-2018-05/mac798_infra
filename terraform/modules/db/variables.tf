variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  type        = "string"
}

variable disk_image {
  description = "Disk image"
  default     = "reddit-db"
  type        = "string"
}

variable "zone" {
  description = "Zone"
  default     = "europe-north1-a"
  type        = "string"
}

variable "app_username" {
  default     = "appuser"
  description = "Username to connect with and to run app"
}

variable vm_tag {
  default = ["db"]
  type    = "list"
}

variable run_provisioners {
  default     = "1"
  description = "run or not provisioners 0=don't run 1=run"
}

variable name_prefix {
  default     = ""
  description = "instance name prefix ('prod-' for exaample)"
}

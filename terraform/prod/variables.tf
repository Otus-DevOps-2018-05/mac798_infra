variable project_id {
  default = "infra-207721"
  type    = "string"
}

variable region {
  default = "europe-north1"
  type    = "string"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  type        = "string"
}

variable app_disk_image {
  description = "Disk image"
  type        = "string"
}

variable db_disk_image {
  description = "Disk image"
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

variable app_vm_tag {
  default = "reddit-app"
  type    = "string"
}

variable db_vm_tag {
  default = "reddit-db"
  type    = "string"
}

variable ssh_allow_ip {
  default = "0.0.0.0/0"
  type    = "string"
}

variable puma_allow_ip {
  default = "0.0.0.0/0"
  type    = "string"
}

variable scene {
  default     = "prod"
  type        = "string"
  description = "stage or prod (or whatever)"
}

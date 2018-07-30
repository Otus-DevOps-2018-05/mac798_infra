variable project_id {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-north1"
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
  default = "europe-north1-a"
  type    = "string"
}

variable "appusername" {
  default     = "appuser"
  description = "Username to connect with and to run app"
}

variable "project_ssh_users" {
  default = {
    "appuser" = "files/id_rsa_test.pub"
  }
  type        = "map"
  description = "list of project-wide user accounts allowed to connect to instances with ssh key"
}

variable "instance_count" {
  description = "How many instances to run"
  default     = 1
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  default     = "~/.ssh/id_rsa.pub"
  type        = "string"
}

variable private_key_path {
  description = "Path to the private key used for ssh access"
  type        = "string"
}

variable disk_image {
  description = "Disk image"
  default     = "reddit-apponly"
  type        = "string"
}

variable zone {
  description = "Zone"
  default     = "europe-north1-a"
  type        = "string"
}

variable app_username {
  default     = "appuser"
  description = "Username to connect with and to run app"
  type        = "string"
}

variable db_address {
  default     = "127.0.0.1"
  description = "Address (internal) of mongodb server"
  type        = "string"
}

variable vm_tag {
  default = "reddit-app"
  type    = "string"
}

variable run_provisioners {
  default     = "1"
  description = "run or not provisioners 0=don't run 1=run"
}

variable name_prefix {
  default     = ""
  description = "instance name prefix ('prod-' for exaample)"
}

variable persistent_ip {
  default     = "0"
  type        = "string"
  description = "try to create or not persistent ip address for instance"
}

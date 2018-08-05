variable network_name {
  default     = "default"
  description = "Network where create firewall rules for out reddit app"
  type        = "string"
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
  default     = "0.0.0.0/0"
  type        = "string"
  description = "address/network allowed to connect puma server instance by ssh"
}

variable puma_allow_ip {
  default     = "0.0.0.0/0"
  type        = "string"
  description = "address/network allowed to connect puma server"
}

variable name_prefix {
  default     = ""
  description = "instance name prefix ('prod-' for exaample)"
}

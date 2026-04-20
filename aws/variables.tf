variable "service_name" {
  type    = string
  default = "observability-stack"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "Production"
    Terraform   = "True"
  }
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "enable_nodegroup_ssh_from_bastion" {
  type    = bool
  default = true
}

variable "nodegroup_ssh_key_name" {
  type    = string
  default = null
}


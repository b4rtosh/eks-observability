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

variable "observability_allowed_cidrs" {
  description = "Public CIDRs allowed to access Grafana/Prometheus"
  type        = list(string)
  default     = ["203.0.113.10/32"] # replace with your real IP(s)
}

variable "grafana_port" {
  type    = number
  default = 3000
}

variable "prometheus_port" {
  type    = number
  default = 9090
}

variable "enable_public_node_access" {
  description = "Enable direct internet ingress to worker nodes for allowlisted CIDRs"
  type        = bool
  default     = true
}


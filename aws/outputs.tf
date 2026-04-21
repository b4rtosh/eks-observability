output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_private_ip" {
  value = aws_instance.bastion.private_ip
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "nodegroup_ssh_from_bastion_enabled" {
  value = var.enable_nodegroup_ssh_from_bastion && var.nodegroup_ssh_key_name != null
}



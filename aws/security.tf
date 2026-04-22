resource "aws_security_group" "bastion" {
  name        = "${var.service_name}-bastion-sg"
  description = "Bastion security group"
  vpc_id      = module.vpc.vpc_id

  tags = var.default_tags
}

resource "aws_vpc_security_group_egress_rule" "bastion_all_egress" {
  security_group_id = aws_security_group.bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "bastion_to_eks_api" {
  security_group_id            = module.eks.cluster_primary_security_group_id
  referenced_security_group_id = aws_security_group.bastion.id
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
}




module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # disable the eks auto mode
  compute_config = {
    enabled = false
  }

  name               = "${var.service_name}-eks"
  kubernetes_version = "1.33"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  enable_cluster_creator_admin_permissions = true

  vpc_id = module.vpc.vpc_id
  # First two private subnets for node/data-plane resources
  subnet_ids = slice(module.vpc.private_subnets, 0, 2)
  # Last two private subnets for control plane ENIs
  control_plane_subnet_ids = slice(module.vpc.private_subnets, 2, 4)

  # Keep API private; reach it from bastion/SSM inside the VPC.
  endpoint_private_access = true
  endpoint_public_access  = false

  node_security_group_additional_rules = var.enable_nodegroup_ssh_from_bastion && var.nodegroup_ssh_key_name != null ? {
    bastion_to_nodes_ssh = {
      description              = "Allow SSH from bastion to worker nodes"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = aws_security_group.bastion.id
    }
  } : {}

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    stack = merge(
      {
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["t3.large"]

        min_size     = 1
        max_size     = 3
        desired_size = 2

        iam_role_additional_policies = {
          AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        }
      },
      var.enable_nodegroup_ssh_from_bastion && var.nodegroup_ssh_key_name != null ? {
        key_name = var.nodegroup_ssh_key_name
      } : {}
    )

  }

  access_entries = {
    bastion = {
      principal_arn = aws_iam_role.bastion.arn
      type          = "STANDARD"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = var.default_tags
}
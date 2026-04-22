data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_iam_role" "bastion" {
  name = "${var.service_name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "bastion_ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "bastion_kubectl" {
  statement {
    effect = "Allow"

    resources = [module.eks.cluster_arn]

    actions = ["eks:DescribeCluster"]
  }
}

resource "aws_iam_role_policy" "bastion_kubectl" {
  name   = "${var.service_name}-bastion-kubectl"
  role   = aws_iam_role.bastion.id
  policy = data.aws_iam_policy_document.bastion_kubectl.json
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.service_name}-bastion-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.bastion_instance_type
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  associate_public_ip_address = false

  tags = var.default_tags
}


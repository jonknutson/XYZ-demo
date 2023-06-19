module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~>19.0"

  cluster_name    = local.project_name
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    kube-proxy = {}
    vpc-cni    = {}
    coredns = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS managed node group
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    blue = {
      create = false
    }
    green = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.large", "m5.large", "c4.large", "c5.large"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  #manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.PIPELINE_ROLE
      username = "github"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = var.K8S_USER_ARN
      username = "jon"
      groups   = ["system:masters"]
    },
  ]

  tags = local.tags
}

resource "aws_iam_policy" "additional" {
  name = "${local.project_name}-additional"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
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
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Fargate profiles use the cluster primary security group
  create_cluster_security_group = false
  create_node_security_group    = false

  fargate_profile_defaults = {
    iam_role_additional_polices = {
      additional = aws_iam_policy.additional.arn
    }
  }
  fargate_profiles = merge(
    {
      default = {
        name = "default"
        selectors = [
          { namespace = "default" },
          { namespace = "xyzdemo" }
        ]
        subnet_ids = [module.vpc.private_subnets[1]]

        tags = { Owner = "secondary" }

        timeouts = {
          create = "20m"
          delete = "20m"
        }
      }
    },
    { for i in range(3) :
      "kube-system-${element(split("-", local.azs[i]), 2)}" => {
        selectors = [
          { namespace = "kube-system" }
        ]
        subnet_ids = [module.vpc.private_subnets[i]]
      }
    }
  )

  aws_auth_roles = [
    {
      rolearn  = var.PIPELINE_ROLE
      username = "github"
      groups   = ["system:masters"]
    }
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
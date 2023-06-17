locals {
  azs                 = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr            = "10.32.0.0/16"
  vpc_private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  vpc_public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 51)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = local.project_name

  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames          = true
  manage_default_security_group = true
  default_security_group_name   = local.project_name

  # tags used by Fargate
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.project_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.project_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  tags = local.tags
}
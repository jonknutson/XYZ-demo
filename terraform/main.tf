terraform {
  backend "s3" {
    bucket = "xyz-demo20230613003940639700000001"
    key    = "repo/github/jonknutson/XYZ-demo"
    region = "us-east-2"
  }
  required_version = "1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.21.1"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = local.tags
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  project_name = "xyzdemo"
  region       = "us-east-2"
  tags = {
    Project   = "xyzdemo"
    Terraform = "true"
    Repo      = "github.com/jonknutson/XYZ-demo"
  }
}
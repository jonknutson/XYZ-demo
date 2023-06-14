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
  }
}

provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Project   = "xyzdemo"
      Terraform = "true"
      Repo      = "github.com/jonknutson/XYZ-demo"
    }
  }
}

locals {
  project_name = "xyzdemo"
  aws_region   = "us-east-2"
  aws_zone     = "us-east-2a"
}
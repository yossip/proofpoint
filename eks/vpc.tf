variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "proofpoint-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "proofpoint-vpc"
  cidr                 = "${var.cidrsubnet}"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = [cidrsubnet("${var.cidrsubnet}", 4, 2), cidrsubnet("${var.cidrsubnet}", 4, 1), cidrsubnet("${var.cidrsubnet}", 4, 3)]
  public_subnets       = [cidrsubnet("${var.cidrsubnet}", 4, 4), cidrsubnet("${var.cidrsubnet}", 4, 5), cidrsubnet("${var.cidrsubnet}", 4, 6)]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
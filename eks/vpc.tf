locals {
  cluster_name = "proofpoint-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "proofpoint-vpc"
  cidr                 = "${var.cidr}"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = [cidrsubnet("${var.cidr}", 4, 2), cidrsubnet("${var.cidr}", 4, 1), cidrsubnet("${var.cidr}", 4, 3)]
  public_subnets       = [cidrsubnet("${var.cidr}", 4, 4), cidrsubnet("${var.cidr}", 4, 5), cidrsubnet("${var.cidr}", 4, 6)]
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
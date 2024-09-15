data "aws_availability_zones" "available" {
  state = "available"
}

locals {
    # Cluster Name
  cluster_name = "${var.project_name}-${var.environment}"
}

module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.vpc_params.vpc_cidr
  networks = [
    {
      name     = "${local.cluster_name}-public-1"
      new_bits = 4
    },
    {
      name     = "${local.cluster_name}-public-2"
      new_bits = 4
    },
    {
      name     = "${local.cluster_name}-private-1"
      new_bits = 4
    },
    {
      name     = "${local.cluster_name}-private-2"
      new_bits = 4
    },   
  ]
}


# VPC and subnets
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.1.1"

  name = "${local.cluster_name}-vpc"
  cidr = var.vpc_params.vpc_cidr

  azs = data.aws_availability_zones.available.names

  public_subnets  = [module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-public-1"], module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-public-2"]]
  private_subnets = [module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-private-1"], module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-private-2"]]

  enable_nat_gateway = var.vpc_params.enable_nat_gateway
}
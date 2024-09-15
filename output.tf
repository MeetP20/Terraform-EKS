output "env_name" {
  value = local.cluster_name
}

output "vpc_cidr" {
  value = var.vpc_params.vpc_cidr
}

output "vpc_public_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-public-1"], module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-public-2"]]
}

output "vpc_private_subnets" {
  value = [module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-private-1"], module.subnet_addrs.network_cidr_blocks["${local.cluster_name}-private-2"]]
}
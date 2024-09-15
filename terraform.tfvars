project_name       = "eks"
environment        = "dev"
eks_version        = "1.29"
vpc_params  = {
  vpc_cidr  = "10.1.0.0/16"
  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
}
eks_region = "us-east-1"
# Can be replaced through Jenkins
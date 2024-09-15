variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "eks"
}

variable "environment" {
  description = "Specify Enviroment for naming convention"
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_params" {
  type = object({
    vpc_cidr               = string
    enable_nat_gateway     = bool
    one_nat_gateway_per_az = bool
  })
}

variable "eks_region" {
  description = "Kubernetes region"
  type        = string
}


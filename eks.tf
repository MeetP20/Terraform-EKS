data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.10.0"
  cluster_name    = local.cluster_name
  cluster_version = var.eks_version
  cluster_endpoint_public_access = true
  cluster_enabled_log_types = ["audit","api","authenticator"]
  
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = { 
      most_recent = true 
    }
  }

  iam_role_additional_policies = { 
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy" 
  }

  enable_cluster_creator_admin_permissions =true
  authentication_mode = "API_AND_CONFIG_MAP"
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  eks_managed_node_groups = {
    default = {
      min_size       = 2
      max_size       = 5
      desired_size   = 5
      instance_types = ["t2.micro"]
      capacity_type  = "ON_DEMAND"
      node_group_name_prefix = "${local.cluster_name}-"
      update_config = {
        "max_unavailable_percentage" = 25
      }
      tags = {
        "Name" = "${local.cluster_name}"
      }
    }
  }  
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.eks_region} update-kubeconfig --name ${module.eks.cluster_name}"
    interpreter = [ "/bin/bash" , "-c" ]
  }
  depends_on = [ module.eks ]
}






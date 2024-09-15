resource "helm_release" "alb-controller" {
   name       = "aws-load-balancer-controller"
   repository = "https://aws.github.io/eks-charts"
   chart      = "aws-load-balancer-controller"
   namespace  = "kube-system"
   values = [
   <<-EOT
       replicas: 2  
   EOT
   ]
   depends_on = [
      module.eks,
      helm_release.metrics_server
   ]
   set {
      name  = "region"
      value = var.eks_region
   }
   set {
      name  = "vpcId"
      value = module.vpc.vpc_id
   }
   set {
      name  = "serviceAccount.create"
      value = true
   }
   set {
      name  = "serviceAccount.name"
      value = "aws-load-balancer-controller"
   }
   set {
      name  = "clusterName"
      value = module.eks.cluster_name
   }
}


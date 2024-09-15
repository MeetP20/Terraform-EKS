data "http" "latest_metrics_server_version" {
  url = "https://artifacthub.io/api/v1/packages/helm/metrics-server/metrics-server"
}

locals {
  latest_version = jsondecode(data.http.latest_metrics_server_version.body)["version"]
}

resource "helm_release" "metrics_server" {
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  name       = "metrics-server"
  chart      = "metrics-server"
  version    = local.latest_version
  namespace = "kube-system"
  values = [
    <<-EOT
      replicas: 2 
    EOT
  ]
  depends_on = [ module.eks ]
}

resource "null_resource" "wait_for_metrics_server" {
  depends_on = [helm_release.metrics_server]

  provisioner "local-exec" {
    command = "kubectl wait --for=condition=available --timeout=300s deployment/metrics-server -n kube-system"
  }
}

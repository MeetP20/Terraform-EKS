resource "helm_release" "plg-pods" {
   name       = "plg"
   repository = "https://grafana.github.io/helm-charts"
   chart      = "loki-stack"
   create_namespace = true
   namespace  = "plg-stack"
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
      name  = "grafana.enabled"
      value = true
   }
   set {
      name  = "prometheus.enabled"
      value = true
   }
   set {
      name  = "prometheus.alertmanager.persistentVolume.enabled"
      value = true
   }
   set {
      name  = "prometheus.server.persistentVolume.enabled"
      value = true
   }
   set {
      name  = "loki.persistence.enabled"
      value = true
   }
   set {
      name  = "loki.persistence.size"
      value = "100Gi"
   }
   set {
      name  = "grafana.persistence.enabled"
      value = true
   }
   set {
      name  = "grafana.persistence.size"
      value = "50Gi"
   }
   set {
      name  = "loki.config.table_manager.retention_deletes_enabled"
      value = true
   }
   set {
      name  = "loki.config.table_manager.retention_period"
      value = "144h"
   }
}
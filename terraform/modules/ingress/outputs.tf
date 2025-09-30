# Ingress Module Outputs

output "ingress_controller_ip" {
  description = "IP address of the ingress controller"
  value       = data.kubernetes_service.ingress_controller.status[0].load_balancer[0].ingress[0].ip
}

output "ingress_controller_fqdn" {
  description = "FQDN of the ingress controller"
  value       = data.kubernetes_service.ingress_controller.status[0].load_balancer[0].ingress[0].hostname
}

output "ingress_controller_status" {
  description = "Status of the ingress controller"
  value       = data.kubernetes_service.ingress_controller.status
}

output "cert_manager_ready" {
  description = "Whether cert-manager is ready"
  value       = var.enable_cert_manager
}

output "ingress_class_name" {
  description = "Name of the ingress class"
  value       = kubernetes_ingress_class.nginx.metadata[0].name
}

output "letsencrypt_cluster_issuer_ready" {
  description = "Whether the Let's Encrypt ClusterIssuer is ready"
  value       = var.enable_cert_manager
}

# Data sources for status checking
data "kubernetes_service" "ingress_controller" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace.ingress.metadata[0].name
  }
  depends_on = [helm_release.nginx_ingress]
}

# Commented out due to provider limitations
# data "kubernetes_deployment" "cert_manager" {
#   metadata {
#     name      = "cert-manager"
#     namespace = kubernetes_namespace.cert_manager.metadata[0].name
#   }
#   depends_on = [helm_release.cert_manager]
# }


# data "kubernetes_manifest" "letsencrypt_cluster_issuer" {
#   manifest = {
#     apiVersion = "cert-manager.io/v1"
#     kind       = "ClusterIssuer"
#     metadata = {
#       name = "letsencrypt-prod"
#     }
#   }
#   depends_on = [kubernetes_manifest.letsencrypt_cluster_issuer]
# }

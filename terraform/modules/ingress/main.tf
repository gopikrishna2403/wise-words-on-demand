# Ingress Module - Wise Words on Demand

# Namespace for ingress components
resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-nginx"
    labels = {
      name = "ingress-nginx"
    }
  }
}

# Namespace for cert-manager
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
      name = "cert-manager"
    }
  }
}


# NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.8.3"
  namespace  = kubernetes_namespace.ingress.metadata[0].name

  values = [
    yamlencode({
      controller = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/azure-load-balancer-internal" = "false"
          }
        }
        config = {
          "use-forwarded-headers"        = "true"
          "compute-full-forwarded-for"   = "true"
          "use-proxy-protocol"           = "false"
          "server-name-hash-bucket-size" = "256"
        }
        metrics = {
          enabled = true
          service = {
            annotations = {
              "prometheus.io/scrape" = "true"
              "prometheus.io/port"   = "10254"
            }
          }
        }
        resources = {
          requests = {
            cpu    = "100m"
            memory = "90Mi"
          }
          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }
        nodeSelector = {
          "kubernetes.io/os" = "linux"
        }
        tolerations = []
        affinity    = {}
      }
    })
  ]

  depends_on = [kubernetes_namespace.ingress]
  timeout    = 180 # 3 minutes timeout
}

# Cert-Manager
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.13.2"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  values = [
    yamlencode({
      installCRDs = true
      global = {
        leaderElection = {
          namespace = kubernetes_namespace.cert_manager.metadata[0].name
        }
      }
      prometheus = {
        enabled = true
      }
      webhook = {
        timeoutSeconds = 4
      }
    })
  ]

  depends_on = [kubernetes_namespace.cert_manager]
}

# ClusterIssuer for Let's Encrypt
resource "kubernetes_manifest" "letsencrypt_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "admin@wise-words-dev.com" # Valid email for Let's Encrypt
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager]
}

# Ingress Class
resource "kubernetes_ingress_class" "nginx" {
  metadata {
    name = "nginx"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }
  spec {
    controller = "k8s.io/ingress-nginx"
  }

  depends_on = [helm_release.nginx_ingress]
}

# Sample Ingress for testing
resource "kubernetes_ingress_v1" "sample" {
  count = var.create_sample_ingress ? 1 : 0
  metadata {
    name      = "sample-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    }
  }

  spec {
    tls {
      hosts       = [var.sample_domain]
      secret_name = "sample-tls"
    }

    rule {
      host = var.sample_domain
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "sample-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_ingress_class.nginx]
}

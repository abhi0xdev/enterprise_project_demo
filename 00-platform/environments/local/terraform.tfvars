cluster_name = "enterprise-project-demo"

nodes = [
  { role = "control-plane" },
  { role = "worker" }
]

addons = {
  argocd = {
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    version    = "7.6.12"
    namespace  = "argocd"
  }

  argo-rollouts = {
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-rollouts"
    namespace  = "argo-rollouts"
    values = {
      "controller.replicas" = "1"
      "dashboard.enabled"   = "true"
    }
  }
}

namespaces = {
  nginx-dev = {
    environment = "dev"
    quota       = { cpu_limits = "1", memory_limits = "1Gi", pods = "10" }
  }
  nginx-staging = {
    environment = "staging"
    quota       = { cpu_limits = "1", memory_limits = "1Gi", pods = "10" }
  }
  nginx-prod = {
    environment = "prod"
    quota       = { cpu_limits = "2", memory_limits = "1Gi", pods = "10" }
  }
}

resource "kubernetes_namespace_v1" "this" {
  for_each = var.namespaces

  metadata {
    name = each.key
    labels = {
      environment                          = each.value.environment
      "app.kubernetes.io/managed-by"       = "terraform"
      "pod-security.kubernetes.io/enforce" = each.value.pod_security
    }
  }
}

resource "kubernetes_resource_quata_v1" "this" {
  for_each = { for name, ns in var.namespaces : name => ns if ns.quata != null }

  metadata {
    name      = "compute-quota"
    namespace = kubernetes_namespace_v1.this[each.key].metadata[0].name
  }

  spec {
    hard = {
      "limits.cpu"    = each.value.quota.cpu_limits
      "limits.memory" = each.value.quota.memory_limits
      pods            = each.value.quota.pods
    }
  }
}
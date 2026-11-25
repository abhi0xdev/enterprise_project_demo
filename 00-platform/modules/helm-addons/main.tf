resource "helm_release" "this" {
  for_each = var.addons

  name             = each.key
  repository       = each.value.repository
  chart            = each.value.chart
  version          = each.value.version
  namespace        = each.value.namespace
  create_namespace = each.value.create_namespace
  timeout          = 600

  dynamic "set" {
    for_each = each.value.values
    content {
      name  = set.key
      value = set.value
    }
  }
}
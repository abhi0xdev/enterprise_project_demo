output "names" {
  value = keys(kubernetes_namespace_v1.this)
}
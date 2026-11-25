output "cluster-name" {
  value = module.cluster.name
}

output "namespaces" {
  value = module.namespaces.names
}

output "addons" {
  value = module.addons.releases
}
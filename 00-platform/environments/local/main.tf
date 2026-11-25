module "cluster" {
  source       = "../../modules/kind-cluster"
  cluster_name = var.cluster_name
  nodes        = var.nodes
}

module "addons" {
  source     = "../../modules/helm-addons"
  addons     = var.addons
  depends_on = [module.cluster]
}

module "namespaces" {
  source     = "../../modules/namespaces"
  namespaces = var.namespaces
  depends_on = [module.cluster]
}
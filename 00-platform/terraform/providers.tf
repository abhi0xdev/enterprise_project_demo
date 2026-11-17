terraform {
  required_version = ">= 1.5"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.6"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }
}

provider "kind" {
  # Configuration options for the kind provider can be specified here if needed
}

provider "helm" {
  kubernetes {
    host                   = kind_cluster.main.endpoint
    cluster_ca_certificate = kind_cluster.main.cluster_ca_certificate
    client_certificate     = kind_cluster.main.client_certificate
    client_key             = kind_cluster.main.client_key

  }
}
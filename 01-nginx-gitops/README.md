# 01 - Nginx GitOps

Flow: push to `app/` -> GitHub Actions builds the image and pushes it to GHCR -> the pipeline updates `values-dev.yaml` -> ArgoCD syncs the cluster.

Deploy the ArgoCD application once:

    kubectl apply -f argocd/application-dev.yaml

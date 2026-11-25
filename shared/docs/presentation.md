---
marp: true
theme: default
paginate: true
---

# Enterprise GitOps Delivery Platform

Terraform, Kubernetes, GitHub Actions, ArgoCD, DevSecOps

**Abhinandan Gayaki**
github.com/abhi0xdev/enterprise_project_demo

---

## Goal

- Ship a code change to Kubernetes with one `git push`
- Everything as code: infrastructure, pipeline, deployments
- Security checks built into the pipeline, not added at the end
- Safe, approved promotion from dev to staging to prod

---

## Architecture

Developer, then GitHub, then GitHub Actions (lint, scan, build, DAST), then GHCR registry

GitHub (values files), then ArgoCD, then Kubernetes with dev, staging and prod namespaces

Terraform builds the cluster, installs ArgoCD and Argo Rollouts, and creates the namespaces.

---

## Platform as code (Terraform)

- 3 reusable modules: `kind-cluster`, `helm-addons`, `namespaces`
- One environment folder wires the modules together
- Dynamic config: `for_each`, `dynamic` blocks, optional fields, validation
- Add a tool or an environment by editing data in `terraform.tfvars`, not code

---

## Multi-environment setup

| Environment | Replicas | Deploy trigger | Approval |
|---|---|---|---|
| dev | 1 | Automatic on every merge | None |
| staging | 2 | Promote workflow | GitHub Environment |
| prod | 3 + PDB | Promote workflow + manual ArgoCD sync | Reviewer plus manual sync |

Each environment has its own namespace, quota and Helm values file.

---

## Secure container

- Multi-stage Docker build: build tools never reach the runtime image
- Non-root user (UID 101), unprivileged nginx on port 8080
- Read-only filesystem, all capabilities dropped, seccomp enabled
- Security headers, health endpoint, container HEALTHCHECK
- Cluster enforces the `restricted` Pod Security level

---

## Pipeline security gates

| Stage | Tool |
|---|---|
| Dockerfile lint | hadolint |
| Manifest validation | kubeconform |
| Manifest and Dockerfile scan | Trivy config, Snyk IaC |
| Container scan | Trivy, Snyk |
| DAST (running app) | StackHawk, OWASP ZAP fallback |
| Terraform scan | Trivy config |

Images are scanned before they are published.

---

## Approval and promotion

1. Merge to main: the pipeline deploys to dev automatically
2. Run the promote workflow with the image SHA
3. Staging is updated
4. Production waits for a reviewer to approve
5. ArgoCD prod is synced manually

Every release is traceable by Git commit and image SHA.

---

## GitOps and progressive delivery

- ArgoCD keeps the cluster equal to Git (auto-sync, prune, self-heal)
- Rollback means reverting a Git commit
- Argo Rollouts: canary with pause and promote steps, blue-green planned
- ApplicationSet creates all environments from one file

---

## Live demo

1. Change the page text and push
2. Pipeline: lint, scan, DAST, build, publish
3. Dev updates automatically in ArgoCD
4. Promote to staging, then approve production
5. Break something with kubectl and watch self-heal fix it

---

## Problems solved along the way

- Branch name mismatch (`master` vs `main`)
- Helm template indentation broken by editor formatting
- Invalid CPU or memory units that helm lint cannot catch
- Image name mismatch causing ImagePullBackOff
- Terraform state lock from an interrupted run

Skill gained: systematic troubleshooting across Git, Helm, Kubernetes and ArgoCD.

---

## Results

- Deployment effort: manual steps reduced to one `git push` (replace with your measured time)
- Security checks: 6 automated gates before any image is published
- Environments: 3, created from one config file
- Rebuild the whole platform with `terraform apply` in about 5 minutes

---

## Roadmap

- Observability with Prometheus and Grafana
- Secrets management with External Secrets or Vault
- Policy as code with Kyverno
- Cloud cluster (EKS or GKE) with remote Terraform state
- Image signing with cosign

---

# Thank you

Questions?

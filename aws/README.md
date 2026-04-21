# Simplified Access Model

- EKS API remains private (`kubectl` from bastion only).
- Worker nodes are placed in public subnets.
- Public ingress to nodes is restricted by CIDR allowlists in node security-group rules.

## What Is Implemented

- `aws/eks.tf` places node groups in `module.vpc.public_subnets`.
- `aws/eks.tf` keeps `endpoint_public_access = false` and `endpoint_private_access = true`.
- `aws/eks.tf` adds node SG ingress for:
  - SSH (`22`) from `node_ssh_allowed_cidrs`
  - Grafana (`grafana_port`, default `3000`) from `observability_allowed_cidrs`
  - Prometheus (`prometheus_port`, default `9090`) from `observability_allowed_cidrs`
- Bastion-to-node SSH can still stay enabled via `enable_nodegroup_ssh_from_bastion`.

## Required tfvars

Set your real source IPs in `aws/lab.tfvars`:

```hcl
enable_public_node_access = true

observability_allowed_cidrs = [
  "203.0.113.10/32"
]
```

## Apply

```powershell
cd "C:\Users\p9bar\source\repos\eks-observability\aws"
terraform plan -var-file=lab.tfvars
terraform apply -var-file=lab.tfvars
```

## Notes

- This is intentionally less strict than private-nodes + LB architecture.
- Never use `0.0.0.0/0` for SSH in production.


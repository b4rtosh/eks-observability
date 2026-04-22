# Simplified Access Model

- EKS API remains private (`kubectl` from bastion only).
- Worker nodes are placed in public subnets.
- Public ingress to nodes is restricted by CIDR allowlists in node security-group rules.

## Notes

- This is intentionally less strict than private-nodes + LB architecture (work in progess).
- Never use `0.0.0.0/0` for SSH in production.


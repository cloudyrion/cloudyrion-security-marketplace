# IaC Security Check Catalog

High-value manual checks that automated scanners frequently miss, organized by IaC type.

---

## Terraform

> CIS refs below are approximate cross-references to the CIS AWS Foundations Benchmark.
> Section numbering varies between benchmark versions — confirm the exact recommendation ID
> against the version pinned in SKILL.md (CIS AWS Foundations v3.0) before citing in a report.

| # | Check | Severity | CIS AWS (approx.) |
|---|-------|----------|---------|
| TF-01 | S3 bucket public access block not enabled | High | CIS AWS 2.1.5 |
| TF-02 | RDS instance publicly accessible | Critical | CIS AWS 2.3.1 |
| TF-03 | Security group allows 0.0.0.0/0 on ports other than 80/443 | High | CIS AWS 5.2 |
| TF-04 | IAM policy with `*` action and `*` resource | Critical | CIS AWS 1.16 |
| TF-05 | CloudTrail not enabled in all regions | High | CIS AWS 3.1 |
| TF-06 | EBS volumes not encrypted | Medium | CIS AWS 2.2.1 |
| TF-07 | State backend missing encryption or locking | Critical | — |
| TF-08 | Secrets in `terraform.tfvars` or variable defaults | Critical | — |
| TF-09 | Provider version not pinned | Medium | — |
| TF-10 | Missing `deletion_protection` on databases/load balancers | Medium | — |
| TF-11 | VPC flow logs disabled | Medium | CIS AWS 3.9 |
| TF-12 | Lambda function with admin IAM role | High | — |
| TF-13 | Missing KMS key rotation | Medium | CIS AWS 3.8 |
| TF-14 | ALB without WAF association | Medium | — |
| TF-15 | Missing `prevent_destroy` lifecycle on critical resources | Low | — |

## Kubernetes

| # | Check | Severity | CIS Ref |
|---|-------|----------|---------|
| K8-01 | Container running as root (`runAsNonRoot: false` or missing) | High | CIS K8s 5.2.6 |
| K8-02 | Privileged container (`privileged: true`) | Critical | CIS K8s 5.2.1 |
| K8-03 | Missing resource limits (CPU/memory) | Medium | CIS K8s 5.4.1 |
| K8-04 | `hostNetwork: true` | High | CIS K8s 5.2.4 |
| K8-05 | `hostPID: true` or `hostIPC: true` | High | CIS K8s 5.2.2 |
| K8-06 | Writable root filesystem (`readOnlyRootFilesystem` missing) | Medium | CIS K8s 5.2.8 |
| K8-07 | Secrets in environment variables instead of Secret volumes | High | — |
| K8-08 | Missing NetworkPolicy (all pods can talk to all pods) | High | CIS K8s 5.3.2 |
| K8-09 | Image using `latest` tag instead of digest | Medium | — |
| K8-10 | Missing PodDisruptionBudget for critical workloads | Low | — |
| K8-11 | ServiceAccount `automountServiceAccountToken` not disabled | Medium | CIS K8s 5.1.6 |
| K8-12 | RBAC ClusterRoleBinding to `cluster-admin` for non-system SA | Critical | CIS K8s 5.1.1 |
| K8-13 | Missing seccomp profile | Medium | CIS K8s 5.7.2 |
| K8-14 | Capabilities not dropped (`drop: ALL` missing) | Medium | CIS K8s 5.2.7 |
| K8-15 | Liveness/readiness probes missing | Low | — |

## Dockerfile

| # | Check | Severity | Ref |
|---|-------|----------|-----|
| DK-01 | No `USER` directive (runs as root) | High | CIS Docker 4.1 |
| DK-02 | Using `latest` or unpinned base image | Medium | CIS Docker 4.2 |
| DK-03 | `COPY . .` without `.dockerignore` (may include secrets) | High | — |
| DK-04 | `apt-get install` without `--no-install-recommends` | Low | — |
| DK-05 | Secrets passed via `ARG` or `ENV` (visible in history) | Critical | — |
| DK-06 | Missing `HEALTHCHECK` instruction | Low | CIS Docker 4.6 |
| DK-07 | `ADD` used instead of `COPY` (remote URL fetch risk) | Medium | CIS Docker 4.7 |
| DK-08 | Package manager cache not cleaned (larger attack surface) | Low | — |
| DK-09 | Multi-stage build not used (build tools in final image) | Medium | — |
| DK-10 | `chmod 777` or overly permissive file permissions | High | — |

## Docker Compose

| # | Check | Severity | Ref |
|---|-------|----------|-----|
| DC-01 | Secrets in environment variables (use `secrets:` instead) | High | — |
| DC-02 | `privileged: true` on any service | Critical | — |
| DC-03 | Ports bound to `0.0.0.0` instead of `127.0.0.1` | Medium | — |
| DC-04 | No resource limits (`mem_limit`, `cpus`) | Medium | — |
| DC-05 | `network_mode: host` | High | — |
| DC-06 | Volumes mounting sensitive host paths (`/etc`, `/var/run/docker.sock`) | Critical | — |

## Ansible

| # | Check | Severity | Ref |
|---|-------|----------|-----|
| AN-01 | Plaintext passwords in playbooks/vars | Critical | — |
| AN-02 | `become: yes` without `become_user` scoping | Medium | — |
| AN-03 | Shell/command modules used where native modules exist | Medium | — |
| AN-04 | `no_log: true` missing on tasks handling secrets | High | — |
| AN-05 | Package installation without version pinning | Medium | — |
| AN-06 | `ansible_ssh_pass` in inventory (use SSH keys) | Critical | — |

## Helm

| # | Check | Severity | Ref |
|---|-------|----------|-----|
| HL-01 | Container running as root / `runAsNonRoot` not set in values | High | CIS K8s 5.2.6 |
| HL-02 | `privileged: true` or added capabilities in templated pods | Critical | CIS K8s 5.2.1 |
| HL-03 | Missing resource limits/requests in `values.yaml` | Medium | CIS K8s 5.4.1 |
| HL-04 | Secrets templated as plaintext values instead of referencing a Secret | Critical | — |
| HL-05 | Image tag defaults to `latest` instead of a pinned tag/digest | Medium | — |
| HL-06 | NetworkPolicy not rendered for workloads | High | CIS K8s 5.3.2 |
| HL-07 | `serviceAccount.create: true` with broad RBAC in chart | High | CIS K8s 5.1.1 |
| HL-08 | Dependency charts pulled from unpinned/unverified repositories | Medium | — |

## ARM / Bicep

| # | Check | Severity | Ref |
|---|-------|----------|-----|
| AZ-01 | Storage account allows public blob access | High | CIS Azure 3.x |
| AZ-02 | Storage account `supportsHttpsTrafficOnly` disabled | High | CIS Azure 3.x |
| AZ-03 | NSG rule allows `*`/`Internet` inbound on sensitive ports | High | CIS Azure 6.x |
| AZ-04 | SQL/Cosmos DB without `enableEncryption` / TDE | Medium | CIS Azure 4.x |
| AZ-05 | Key Vault soft-delete or purge protection disabled | Medium | CIS Azure 8.x |
| AZ-06 | Diagnostic/activity logging not enabled on resources | Medium | CIS Azure 5.x |
| AZ-07 | Managed identity not used (secrets/keys hardcoded in parameters) | Critical | — |
| AZ-08 | Public IP attached to VM without justification | Medium | — |

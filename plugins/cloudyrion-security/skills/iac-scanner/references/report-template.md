# IaC Security Report Template

Replace all `<placeholders>`.

---

```markdown
# IaC Security Report

## 1. Header Metadata

| Field          | Value                                     |
|----------------|-------------------------------------------|
| Document ID    | IAC-YYYYMMDD-001                          |
| Date           | YYYY-MM-DD                                |
| Author         | <Firstname Lastname (email@domain.com)>   |
| Repository     | <repo name>                               |
| Branch         | <branch>                                  |
| Commit         | <short hash> — <message>                  |
| IaC Types      | Terraform / K8s / Docker / Helm / Ansible |
| Scanners Used  | Checkov / tfsec / trivy / hadolint / manual only |
| Classification | CONFIDENTIAL — Internal Security Use Only |
| Status         | DRAFT / FINAL                             |

---

## 2. Executive Summary

<2–3 paragraphs: IaC types reviewed, total findings by severity, highest risk areas,
overall posture, top 3 recommended actions.>

### Finding Counts

| Severity | Count | Auto | Manual | Resolved | Pending |
|----------|-------|------|--------|----------|---------|
| Critical |       |      |        |          |         |
| High     |       |      |        |          |         |
| Medium   |       |      |        |          |         |
| Low      |       |      |        |          |         |
| Info     |       |      |        |          |         |

---

## 3. Scope

### IaC Inventory

| Type | Files | Resources | Scanner |
|------|-------|-----------|---------|
| Terraform | N | N | Checkov + tfsec |
| Kubernetes | N | N | Checkov + trivy |
| Dockerfile | N | — | hadolint |

### Out of Scope
<Runtime configuration, cloud console settings, IaC drift, secrets in CI/CD pipelines.>

---

## 4. Findings

### FINDING-001 — <Short Title>

| Field       | Value                                    |
|-------------|------------------------------------------|
| ID          | FINDING-001                              |
| Severity    | Critical / High / Medium / Low / Info    |
| Tag         | [BLOCK] / [WARN] / [INFO]                 |
| Category    | IAM / Network / Encryption / Logging / Container / State |
| CIS Ref     | <benchmark ID or "—">                    |
| Check ID    | <Checkov/tfsec rule ID or "Manual">      |
| Resource    | `<resource type.name>`                   |
| Location    | `<file>:<line>`                          |
| Source      | Checkov / tfsec / trivy / hadolint / Manual / Both |
| Status      | Open / Resolved / Accepted Risk          |

#### Description
<What the misconfiguration is and why it's exploitable.>

#### Evidence
```hcl
<IaC snippet showing the misconfiguration>
```

#### Risk Assessment
| Factor | Rating | Rationale |
|--------|--------|-----------|
| Likelihood | | <internet-facing? sensitive data?> |
| Impact | | <blast radius?> |
| Risk Level | | Likelihood × Impact |

#### Recommendation
```hcl
<Fixed IaC snippet>
```

#### Remediation Status
- [ ] Pending
- [ ] Resolved — <commit/PR>
- [ ] Accepted Risk — <justification + expiry>

---

## 5. CIS Benchmark Coverage

| Benchmark | Section | Checks Applicable | Pass | Fail | N/A |
|-----------|---------|-------------------|------|------|-----|
| CIS AWS Foundations v3.0 | IAM | | | | |
| CIS AWS Foundations v3.0 | Storage | | | | |
| CIS AWS Foundations v3.0 | Logging | | | | |
| CIS AWS Foundations v3.0 | Networking | | | | |

<Adjust benchmarks (and versions) to match the cloud provider(s) in scope; see the
CIS Benchmark Versions table in SKILL.md Step 4. Pass/Fail/N-A counts are best-effort:
populate from scanner output where available, otherwise mark the cell "—".>

---

## 6. Risk Summary Matrix

| ID | Title | Severity | Category | CIS Ref | Risk | Status |
|----|-------|----------|----------|---------|------|--------|
| FINDING-001 | | | | | | |

---

## 7. Compliance Mapping

| Framework | Control | Finding(s) | Status |
|-----------|---------|------------|--------|
| ISO 27001:2022 | A.8.8 — Management of Technical Vulnerabilities | | |
| NIS2 | Art. 21(2)(e) — Network security | | |
| SOC 2 | CC6.6 — Encryption in transit | | |

<Map each finding ID to the listed controls (see SKILL.md Step 5). Best-effort: leave a
cell blank with "—" if no finding maps to that control.>

---

## 8. Recommendations

### Immediate ([BLOCK])
<List all blocking findings with one-line fix.>

### Short-term
<Grouped by theme: encryption, IAM hardening, network segmentation.>

### Process
<IaC scanning in CI/CD, policy-as-code enforcement (OPA/Sentinel), drift detection.>

---

## 9. Sign-Off

| Field | Value |
|-------|-------|
| Name | <n> |
| Role | Cloud Security Engineer |
| Date | <YYYY-MM-DD> |
| Signature | <n> |
```

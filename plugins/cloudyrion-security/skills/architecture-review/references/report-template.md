# Security Architecture Review Report Template

Replace all `<placeholders>`.

---

```markdown
# Security Architecture Review Report

## 1. Header Metadata

| Field          | Value                                         |
|----------------|-----------------------------------------------|
| Document ID    | SAR-YYYYMMDD-001                              |
| Date           | YYYY-MM-DD                                    |
| Author         | <Firstname Lastname (email@domain.com)>       |
| System         | <system name>                                 |
| Version        | <version / release / iteration>               |
| Sector         | Telco / Banking / Automotive / IoT / SaaS / General |
| Scope          | Full system / <specific component>            |
| Input          | HLD / LLD / Diagrams / Code / Interview       |
| Classification | CONFIDENTIAL — Internal Security Use Only     |
| Status         | DRAFT / FINAL                                 |

---

## 2. Executive Summary

<2–3 paragraphs: architecture reviewed, total findings by severity, dominant risk themes
(e.g. "insufficient segmentation and missing service-to-service auth"), overall security
maturity assessment, top 3 recommended actions.>

### Finding Counts

| Severity | Count | Domain | Resolved | Pending |
|----------|-------|--------|----------|---------|
| Critical |       |        |          |         |
| High     |       |        |          |         |
| Medium   |       |        |          |         |
| Low      |       |        |          |         |
| Info     |       |        |          |         |

### Security Maturity Assessment

| Domain | Maturity | Key gaps |
|--------|----------|----------|
| Network & Segmentation | Initial / Managed / Defined / Optimized | |
| Identity & Access | | |
| Data Protection | | |
| Secrets Management | | |
| Logging & Monitoring | | |
| Resilience | | |
| Supply Chain | | |
| API Architecture | | |
| Container/Cloud | | |
| Cryptography | | |

---

## 3. Architecture Overview

### System Description
<What the system does, actors, data types, deployment model.>

### Component Inventory

| ID | Component | Type | Technology | Zone | Internet-facing |
|----|-----------|------|------------|------|-----------------|
| C-001 | | | | | |

### Architecture Diagram

```mermaid
<System architecture diagram with trust boundaries>
```

### Trust Boundaries

| Boundary | Zones | Controls in place |
|----------|-------|-------------------|
| B-001 | | |

### Data Flows

| ID | From → To | Data | Protocol | Encrypted | Authenticated |
|----|-----------|------|----------|-----------|---------------|
| F-001 | | | | | |

---

## 4. Findings

### FINDING-001 — <Short Title>

| Field       | Value                                    |
|-------------|------------------------------------------|
| ID          | FINDING-001                              |
| Severity    | Critical / High / Medium / Low / Info    |
| Tag         | [BLOCK] / [WARN] / [INFO]               |
| Domain      | Network / IAM / Data / Secrets / Logging / Resilience / Supply Chain / API / Container / Cryptography / Sector |
| Check Ref   | <checklist ID: NET-01, IAM-05, etc.>     |
| Component   | <affected component ID(s)>               |
| Framework   | ISO 27001 A.x.y / NIS2 Art. X / etc.    |
| Status      | Open / Resolved / Accepted Risk          |

#### Description
<What the architectural weakness is. Specific to this system.>

#### Current State
<What exists today — the as-is architecture at this point.>

#### Risk Assessment

| Factor | Rating | Rationale |
|--------|--------|-----------|
| Likelihood | | <exploitability, exposure> |
| Impact | | <blast radius, data sensitivity> |
| Risk Level | | Likelihood × Impact |

#### Recommended Architecture

<Prescriptive recommendation: what the target-state architecture should look like.
Include a diagram if the change is structural.>

```mermaid
<Target-state diagram if applicable>
```

#### Implementation Guidance
<Concrete steps to move from current to recommended state. Technologies, patterns,
estimated effort.>

#### Residual Risk if Accepted
<What risk remains if this finding is not addressed. Be specific.>

---

## 5. Anti-Pattern Analysis

| Anti-pattern | Found | Severity | Finding | Recommended Pattern |
|-------------|-------|----------|---------|---------------------|
| Flat network | Yes/No | | FINDING-00N | Zone-based + microsegmentation |
| Gateway-only auth | | | | Auth at every service |
| Secrets in env vars | | | | Vault with runtime injection |
| SPOF in security path | | | | Redundant security controls |
| Fail-open design | | | | Fail-closed with graceful degradation |

---

## 6. Risk Summary Matrix

| ID | Title | Domain | Severity | Blast Radius | Status |
|----|-------|--------|----------|-------------|--------|
| FINDING-001 | | | | | |

### Overall Architecture Risk

| Phase | Score | Rationale |
|-------|-------|-----------|
| Current state | HIGH (7/10) | |
| After remediation | LOW (3/10) | |

---

## 7. Framework Traceability

| Finding | ISO 27001:2022 | NIS2 | DORA | NIST CSF 2.0 | Sector |
|---------|---------------|------|------|-------------|--------|
| FINDING-001 | | | | | |

---

## 8. Recommendations

### Immediate — [BLOCK] findings
<Architectural changes required before deployment/go-live.>

### Short-term — [WARN] findings
<Changes to implement in the next 1–2 sprints.>

### Architectural Roadmap
<Longer-term structural improvements grouped by theme.>

### Companion Skill Recommendations

| If this review found... | Run this skill |
|---|---|
| Threats need enumeration | `/cloudyrion-security:threat-model` |
| IaC misconfigs suspected | `/cloudyrion-security:iac-scanner` |
| API design concerns | `/cloudyrion-security:api-security` |
| Supply chain gaps | `/cloudyrion-security:sbom` |
| Compliance mapping needed | `/cloudyrion-security:compliance-mapper` |

---

## 9. Assumptions & Limitations

<What was assumed (e.g. "cloud provider controls are correctly configured"),
what was out of scope, what requires runtime testing to validate.>

---

## 10. Sign-Off

| Field | Value |
|-------|-------|
| Name | <n> |
| Role | Principal Security Architect |
| Date | <YYYY-MM-DD> |
| Signature | <n> |

### Distribution
| Name | Role | Reason |
|------|------|--------|
| | Engineering Lead / Architect | Action — implement recommendations |
| | Security Team | FYI — findings archive |
| | Product Owner | FYI — risk acceptance decisions |
```

# Compliance Matrix Report Template

Replace all `<placeholders>`.

---

```markdown
# Compliance Matrix Report

## 1. Header Metadata

| Field          | Value                                     |
|----------------|-------------------------------------------|
| Document ID    | CMP-YYYYMMDD-001                          |
| Date           | YYYY-MM-DD                                |
| Author         | <name (email)>                            |
| Organization   | <company name>                            |
| Scope          | <system / department / full org>          |
| Frameworks     | <list: NIS2, DORA, ISO 27001:2022, ...>   |
| Input Source   | Controls list / Findings / Risk register / Interview |
| Classification | CONFIDENTIAL — Internal Security Use Only |
| Status         | DRAFT | FINAL                             |

---

## 2. Executive Summary

<2–3 paragraphs: frameworks assessed, overall compliance posture per framework,
critical gaps count, timeline pressure (regulatory deadlines), key recommendation.>

### Compliance Posture Summary

| Framework | Requirements In Scope | Compliant | Partial | Non-Compliant | N/A | Score |
|-----------|----------------------|-----------|---------|---------------|-----|-------|
| NIS2 | | | | | | % |
| DORA | | | | | | % |
| ISO 27001 | | | | | | % |

---

## 3. Control Inventory

| ID | Control | Status | Evidence | Frameworks Satisfied |
|----|---------|--------|----------|---------------------|
| CTRL-001 | <description> | Implemented / Partial / Missing | <evidence type> | ISO A.8.5, NIS2 Art.21(2)(j) |

---

## 4. Cross-Reference Matrix

### By Framework Requirement

| Framework | Requirement | Description | Control(s) | Status | Gap |
|-----------|-------------|-------------|------------|--------|-----|
| NIS2 | Art. 21(2)(a) | Risk analysis | CTRL-003 | Partial | No formal methodology |
| NIS2 | Art. 21(2)(b) | Incident handling | CTRL-010 | Compliant | — |

<Repeat for each framework in scope.>

### Heatmap Summary

| Domain | NIS2 | DORA | ISO 27001 | SOC 2 | GDPR |
|--------|------|------|-----------|-------|------|
| Access Control | 🟢 | 🟢 | 🟢 | 🟢 | 🟢 |
| Cryptography | 🟡 | 🟡 | 🟡 | 🟢 | 🟡 |
| Incident Response | 🔴 | 🔴 | 🟡 | 🟡 | 🔴 |
| Supply Chain | 🔴 | 🟡 | 🟡 | — | — |

🟢 Compliant  🟡 Partial  🔴 Non-Compliant  — Not applicable

---

## 5. Gap Analysis

### GAP-001 — <Short Title>

| Field | Value |
|-------|-------|
| Gap ID | GAP-001 |
| Framework(s) | <which framework requirements are unmet> |
| Domain | <Access Control / Crypto / Incident / Supply Chain / ...> |
| Current State | <what exists today> |
| Required State | <what the framework demands> |
| Risk Level | Critical / High / Medium / Low |
| Regulatory Deadline | <if applicable> |
| Remediation | <specific action> |
| Effort | Low (days) / Medium (weeks) / High (months) |
| Related Skill | <sbom / iac-scanner / etc. if applicable> |

---

## 6. Remediation Roadmap

| Phase | Timeframe | Gaps | Focus |
|-------|-----------|------|-------|
| P0 — Critical | 0–30 days | GAP-001, GAP-005 | Regulatory deadline / penalty exposure |
| P1 — High | 1–3 months | GAP-002, GAP-003 | High-risk areas |
| P2 — Medium | 3–6 months | GAP-006, GAP-007 | Defense-in-depth |
| P3 — Low | 6–12 months | GAP-008 | Maturity improvements |

### Quick Wins
<Controls that satisfy multiple frameworks with minimal effort.>

### Shared Controls
<Controls that satisfy requirements across 3+ frameworks — highest ROI.>

---

## 7. Framework-Specific Notes

### NIS2
<German transposition status (NIS2UmsuCG), sector classification (essential/important),
Art. 20 management body liability, notification timelines (24h/72h).>

### DORA
<ICT risk management scope, third-party oversight, TLPT requirements if applicable.>

### EU CRA
<Product scope, vulnerability handling obligations, SBOM requirements, timeline.>

<Include only frameworks in scope. Remove irrelevant sections.>

---

## 8. Sign-Off

| Field | Value |
|-------|-------|
| Name | <n> |
| Role | GRC Specialist |
| Date | <YYYY-MM-DD> |
| Signature | <n> |

### Distribution
| Name | Role | Reason |
|------|------|--------|
| | CISO | Action — gap remediation ownership |
| | Legal / Compliance | FYI — regulatory exposure |
| | Engineering Lead | FYI — technical gap implementation |
```

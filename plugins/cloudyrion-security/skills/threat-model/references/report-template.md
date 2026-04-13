# Threat Model Report Template

Replace all `<placeholders>`.

---

```markdown
# Threat Model Report

## 1. Header Metadata

| Field           | Value                                     |
|-----------------|-------------------------------------------|
| Document ID     | TM-YYYYMMDD-001                           |
| Date            | YYYY-MM-DD                                |
| Author          | <name (email)>                            |
| System          | <system name>                             |
| Version         | <version/release>                         |
| Methodology     | STRIDE | PASTA | Both                     |
| Scope           | Full system | <specific component>        |
| Classification  | CONFIDENTIAL — Internal Security Use Only |
| Status          | DRAFT | FINAL                              |
| Review Cadence  | Quarterly | On architecture change        |

---

## 2. Executive Summary

<2–3 paragraphs: system overview, total threats identified by risk level, highest risk areas,
top 3 recommended actions, overall risk posture assessment.>

### Threat Counts by Risk Level

| Risk Level | Count | Mitigated | Open |
|------------|-------|-----------|------|
| Critical   |       |           |      |
| High       |       |           |      |
| Medium     |       |           |      |
| Low        |       |           |      |
| Info       |       |           |      |

---

## 3. System Description

### Purpose
<What the system does, who uses it, what data it processes.>

### Actors
| Actor | Type | Trust Level | Description |
|-------|------|-------------|-------------|
| | User / Admin / Service / Third Party | Trusted / Semi-trusted / Untrusted | |

### Data Classification
| Data Type | Classification | Storage | In Scope |
|-----------|---------------|---------|----------|
| | Public / Internal / Confidential / Restricted | <where> | Yes/No |

### Components
| ID | Component | Type | Technology | Internet-facing |
|----|-----------|------|------------|-----------------|
| P-001 | | Process / Store / External | | Yes/No |

### Trust Boundaries
| Boundary | Separates | Controls |
|----------|-----------|----------|
| | <zone A> ↔ <zone B> | <auth, TLS, firewall, etc.> |

---

## 4. Data Flow Diagram

```mermaid
<DFD here — all elements labeled with IDs>
```

### Trust Boundary Crossings
| Flow | From → To | Crosses Boundary | Protocol | Encrypted | Authenticated |
|------|-----------|-------------------|----------|-----------|---------------|
| F-001 | | | | Yes/No | Yes/No |

---

## 5. Threat Catalog

<!-- Repeat for each threat -->

### T-001 — <Short Title>

| Field | Value |
|-------|-------|
| ID | T-001 |
| STRIDE | Spoofing / Tampering / Repudiation / Info Disclosure / DoS / EoP |
| Affected Element | <DFD ID(s)> |
| MITRE ATT&CK | <technique ID — name> |
| Risk Level | Critical / High / Medium / Low |
| Likelihood | High / Medium / Low |
| Impact | High / Medium / Low |
| Existing Controls | <what's already in place, or "None"> |
| Status | Open / Mitigated / Accepted Risk |

#### Description
<Specific attack scenario against this system. Not generic.>

#### Preconditions
<What must be true for this attack to succeed.>

#### Impact Analysis
<What the attacker achieves. Be concrete.>

#### Proposed Mitigation
→ See M-NNN in §6

---

## 6. Mitigation Plan

### Priority: P0 — Immediate

| ID | Threat(s) | Control | Type | Framework | Effort |
|----|-----------|---------|------|-----------|--------|
| M-001 | T-001 | <specific control> | Preventive/Detective/Corrective | ISO 27001 A.x.y | Low/Med/High |

### Priority: P1 — Next Sprint

| ID | Threat(s) | Control | Type | Framework | Effort |
|----|-----------|---------|------|-----------|--------|

### Priority: P2 — Roadmap

| ID | Threat(s) | Control | Type | Framework | Effort |
|----|-----------|---------|------|-----------|--------|

---

## 7. Risk Summary Matrix

| Threat | Title | STRIDE | Element | Likelihood | Impact | Risk | Status |
|--------|-------|--------|---------|------------|--------|------|--------|
| T-001 | | | | | | | |

---

## 8. MITRE ATT&CK Coverage

| Technique | Name | Threat(s) | Mitigated |
|-----------|------|-----------|-----------|
| T1078 | Valid Accounts | T-001 | Yes/No |

---

## 9. Compliance Mapping

| Framework | Control | Threat(s) Addressed | Status |
|-----------|---------|---------------------|--------|
| ISO 27001 | A.14.2.1 | | |
| NIS2 | Art. 21(2)(a) | | |
| DORA | Art. 7 | | |

---

## 10. Assumptions & Limitations

<What was assumed (e.g. "TLS is correctly configured"), what was out of scope, what could
not be assessed without runtime testing.>

---

## 11. Recommendations

### Immediate
<Top 3 actions to reduce risk now.>

### Architectural
<Design-level changes for long-term resilience.>

### Process
<Review cadence, threat model update triggers, integration with SDLC.>

---

## 12. Sign-Off

| Field | Value |
|-------|-------|
| Name | <name> |
| Role | Principal Security Architect |
| Date | <YYYY-MM-DD> |
| Signature | <name> |

### Distribution
| Name | Role | Reason |
|------|------|--------|
| | Engineering Lead | Action — implement mitigations |
| | Security Team | FYI — threat archive |
| | Product Owner | FYI — risk acceptance decisions |
```

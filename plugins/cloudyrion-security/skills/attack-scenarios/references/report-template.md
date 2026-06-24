# Attack Scenario Playbook — Report Template

```markdown
# Attack Scenario Playbook

## 1. Header

| Field | Value |
|-------|-------|
| Document ID | PEN-YYYYMMDD-001 |
| Date | YYYY-MM-DD |
| Tester | <Firstname Lastname (email@domain.com)> |
| Target System | <system name> |
| Assessment Type | Black-box / Grey-box / White-box |
| Attacker Profile | External / Authenticated / Insider / Compromised |
| Scope | <components in scope> |
| Rules of Engagement | <constraints: no DoS, no data modification, etc.> |
| Classification | CONFIDENTIAL — Internal Security Use Only |
| Status | DRAFT / FINAL |

---

## 2. Executive Summary

<2-3 paragraphs: total scenarios designed, critical attack paths identified,
most impactful scenario, overall attack surface assessment, top 3 recommendations.>

### Scenario Counts by Risk Level

| Risk Level | Count | Exploitable | Blocked | Untested |
|------------|-------|-------------|---------|----------|
| Critical   |       |             |         |          |
| High       |       |             |         |          |
| Medium     |       |             |         |          |
| Low        |       |             |         |          |
| Info       |       |             |         |          |
| **Total**  |       |             |         |          |

---

## 3. Target Profile

### System Overview
<What the system does, architecture summary, tech stack.>

### Attack Surface Summary
| Metric | Count |
|--------|-------|
| Entry points discovered | |
| Internet-facing endpoints | |
| Authenticated-only endpoints | |
| Known vulnerabilities (from prior reviews) | |
| Trust boundary crossings | |

### Defenses Observed
| Defense | Status | Bypass Difficulty |
|---------|--------|-------------------|
| WAF | Present / Absent | Easy / Medium / Hard |
| MFA | Present / Absent | |
| Rate Limiting | Present / Absent | |
| CSP | Present / Absent | |
| IDS/IPS | Present / Absent | |

---

## 4. Attack Surface Map

```mermaid
<Attack surface diagram with entry points, components, and attack flow annotations>
```

### Entry Point Inventory

| ID | Entry Point | Type | Auth | Internet | Risk |
|----|------------|------|------|----------|------|
| EP-001 | | | | | |

---

## 5. Attack Scenario Catalog

<!-- Repeat for each scenario: ATK-001, ATK-002, etc. -->

### ATK-001 — <Title>

| Field | Value |
|-------|-------|
| Target | EP-NNN: <endpoint/service> |
| Attacker | External / Authenticated / Insider |
| ATT&CK Chain | TA0001:T1190 → TA0002:T1059 → TA0009:T1005 |
| OWASP | WSTG-INPV-05, A03:2021 |
| CAPEC | CAPEC-66 |
| CWE | CWE-89 |
| Likelihood | High / Medium / Low |
| Impact | High / Medium / Low |
| Risk | Critical / High / Medium / Low / Info |
| Tag | [BLOCK] / [WARN] / [INFO] |
| Status | Exploitable / Blocked / Untested |

#### Prerequisites
<What the attacker needs before starting.>

#### Attack Steps

1. **<Step name>:**
   ```bash
   <exact command>
   ```
   Expected output: <what to look for>

2. **<Step name>:**
   ```bash
   <exact command>
   ```

#### Success Criteria
<How to confirm the attack succeeded.>

#### Expected Evidence
<What PoC output looks like — sanitized example.>

#### Impact Analysis
<What attacker gains. Blast radius. Lateral movement potential.>

#### Detection Indicators
- <What SOC should monitor>
- <Log patterns, network signatures, SIEM rules>

#### Mitigation
- **Preventive:** <specific control>
- **Detective:** <monitoring/alerting>

---

## 6. Risk Summary Matrix

| ID | Title | Target | ATT&CK | Likelihood | Impact | Risk | Tag | Status |
|----|-------|--------|--------|------------|--------|------|-----|--------|
| ATK-001 | | | | | | | | |

---

## 7. MITRE ATT&CK Coverage

| Tactic | Techniques Tested | Scenarios |
|--------|------------------|-----------|
| Reconnaissance (TA0043) | | |
| Initial Access (TA0001) | | |
| Execution (TA0002) | | |
| Persistence (TA0003) | | |
| Privilege Escalation (TA0004) | | |
| Defense Evasion (TA0005) | | |
| Credential Access (TA0006) | | |
| Discovery (TA0007) | | |
| Lateral Movement (TA0008) | | |
| Collection (TA0009) | | |
| Exfiltration (TA0010) | | |
| Impact (TA0040) | | |

---

## 8. Detection & Mitigation Recommendations

### P0 — Immediate (attack succeeds now)
| ID | Scenario(s) | Detection | Mitigation | Effort |
|----|------------|-----------|------------|--------|
| DM-001 | | | | |

### P1 — Short-term (partially blocked)
| ID | Scenario(s) | Detection | Mitigation | Effort |
|----|------------|-----------|------------|--------|

### P2 — Roadmap (defense-in-depth)
| ID | Scenario(s) | Detection | Mitigation | Effort |
|----|------------|-----------|------------|--------|

---

## 9. Assumptions & Limitations

| # | Assumption / Limitation |
|---|------------------------|
| 1 | <What was assumed about the environment> |
| 2 | <What was out of scope per ROE> |
| 3 | <What requires production environment to test> |
| 4 | <What requires additional tools not available> |

---

## 10. Sign-Off

| Field | Value |
|-------|-------|
| Tester | <Firstname Lastname (email@domain.com)> |
| Role | Senior Penetration Tester |
| Date | YYYY-MM-DD |
| Signature | <name> |

### Distribution
| Name | Role | Reason |
|------|------|--------|
| | Engineering Lead | Action — fix vulnerabilities |
| | Security Team | FYI — findings archive |
| | CISO | FYI — risk acceptance |
```

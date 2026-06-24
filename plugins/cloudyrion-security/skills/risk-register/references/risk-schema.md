# Risk Entry Schema

Every risk entry MUST contain these 10 mandatory fields plus 3 supplementary fields.

## Mandatory Fields

| # | Field | Format | Example |
|---|-------|--------|---------|
| 1 | Risk ID | `RSK-[DOMAIN]-NNN` | RSK-APP-001 |
| 2 | Risk Area | Subcategory | API Security |
| 3 | Risk Title | `[What] [Where] [Consequence]` max 80 chars | SQL Injection in Search API Exposes PII |
| 4 | Risk Description | `[Agent] could exploit [vuln] in [asset] to achieve [impact], resulting in [consequence]` | See examples below |
| 5 | Likelihood | 1-5 scale | 4 (Likely) |
| 6 | Impact | 1-5 scale | 5 (Catastrophic) |
| 7 | Risk Rating | L x I with label | 20 (Critical) |
| 8 | Short-term Mitigation | Actionable, 0-90 days | Deploy WAF SQLi rule on API Gateway |
| 9 | Long-term Mitigation | Strategic, 90-365 days (3-12 months) | Migrate to parameterized ORM layer |
| 10 | MITRE ATT&CK | `Tactic: Technique ID – Technique Name` (3-6 techniques) | Initial Access: T1190 – Exploit Public-Facing Application |

**Domains:** NET, APP, CLOUD, IAM, DATA, OPS, OT, AI, GEN, CUSTOM

## Likelihood Scale

| Score | Label | Criteria |
|-------|-------|----------|
| 1 | Rare | Requires insider + undisclosed vuln + specific conditions. No public exploits. |
| 2 | Unlikely | Moderate skill + multiple preconditions. Complex public exploits exist. |
| 3 | Possible | Skilled attacker with available tools. Some preconditions required. |
| 4 | Likely | Trivially exploitable. Public tools. Internet-facing. Few preconditions. |
| 5 | Almost Certain | Actively exploited in the wild. No special skill. Default configs vulnerable. |

## Impact Scale

| Score | Label | Criteria |
|-------|-------|----------|
| 1 | Negligible | No data exposure. Internal inconvenience. No regulatory impact. |
| 2 | Minor | Limited internal data (<100 records). No PII. Short disruption (<1hr). |
| 3 | Moderate | Confidential data. Limited PII (<1000). Disruption 1-24hrs. Notification may be required. |
| 4 | Major | Significant PII (>1000). Extended outage (>24hrs). Fines likely. Reputational damage. |
| 5 | Catastrophic | Mass PII/financial breach. Critical infrastructure. Existential threat. Multi-jurisdiction action. |

## Risk Rating Matrix

| Rating | Score Range | Color |
|--------|-----------|-------|
| Low | 1-4 | Green #2E5339 |
| Medium | 5-9 | Yellow #B8860B |
| High | 10-15 | Orange #CC4400 |
| Critical | 16-25 | Red #8B0000 |

## Supplementary Fields

These three fields are supplementary to the 10 mandatory fields, but are **expected on every client-facing register**; populate them unless genuinely not applicable (the SKILL.md QA checklist verifies them).

| Field | Purpose | Example |
|-------|---------|---------|
| Standards Mapping | Framework controls | ISO 27001:2022 A.8.26, NIS2 Art. 21(2)(e) |
| Evidence Required | Proof of mitigation | Pen test report, WAF config export |
| Comments | Owner, dates, notes | Owner: AppSec. Review: 2026-Q2 |

## Example

```
Risk ID:       RSK-APP-001
Risk Area:     API Security
Risk Title:    SQL Injection in Customer Search API Exposes PII Database
Description:   An external attacker could exploit insufficient input validation in
               /api/v2/customers/search to perform SQL injection, extracting the full
               customer database including PII and payment tokens, resulting in GDPR
               breach notification and EUR 2-5M in fines.
Likelihood:    4 (Likely)
Impact:        5 (Catastrophic)
Risk Rating:   20 (Critical)
Short-term:    Deploy WAF SQLi rule on API Gateway. Add input validation middleware.
Long-term:     Migrate to parameterized ORM. Add Semgrep CI rule p/sql-injection.
MITRE ATT&CK:  Initial Access: T1190 – Exploit Public-Facing Application;
               Execution: T1059.004 – Unix Shell;
               Collection: T1005 – Data from Local System;
               Exfiltration: T1567 – Exfiltration Over Web Service
Standards:     ISO 27001:2022 A.8.26, NIS2 Art. 21(2)(e), OWASP ASVS V5.3
Evidence:      Pen test report, SAST scan results, WAF config export
Comments:      Owner: AppSec team. Deadline: 2026-Q2.
```

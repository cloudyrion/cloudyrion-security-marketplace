# Security Code Review Report Template

Use this exact structure for every report. Replace all `<placeholders>` with actual values.

---

```markdown
# Security Code Review Report

## 1. Header Metadata

| Field          | Value                                              |
|----------------|----------------------------------------------------|
| Document ID    | SCR-YYYYMMDD-001                                   |
| Date           | YYYY-MM-DD                                         |
| Author         | <Firstname Lastname (email@domain.com)>           |
| Repository     | <repo name>                                        |
| Branch         | <branch>                                           |
| Commit         | <short hash> — <commit message>                    |
| Files Reviewed | <list of files>                                    |
| Classification | CONFIDENTIAL — Internal Security Use Only          |
| Status         | DRAFT / FINAL                                      |
| Semgrep Engine | Pro / OSS / Not available                          |

---

## 2. Executive Summary

<2–3 paragraphs: overall security posture, highest risk areas, remediation status overview,
one-line approval recommendation.>

### Finding Counts by Severity

| Severity  | Count | Resolved | Pending | Accepted Risk |
|-----------|-------|----------|---------|---------------|
| Critical  |       |          |         |               |
| High      |       |          |         |               |
| Medium    |       |          |         |               |
| Low       |       |          |         |               |
| Info      |       |          |         |               |
| **Total** |       |          |         |               |

---

## 3. Scope

### In Scope
<Every file, module, or component reviewed>

### Out of Scope
<What was not reviewed and why>

### Review Method
- Static analysis: Semgrep <Pro|OSS|N/A> (interprocedural taint analysis if Pro)
- Dependency scan: <tool used or N/A>
- Manual review: taint tracing, auth/authz logic, crypto usage, secrets
- Language-specific checks: <stack-specific patterns reviewed>

---

## 4. Findings

<!-- Repeat for each finding: FINDING-001, FINDING-002, etc. -->

### FINDING-001 — <Short Title>

| Field       | Value                                    |
|-------------|------------------------------------------|
| ID          | FINDING-001                              |
| Severity    | Critical / High / Medium / Low / Info    |
| Tag         | [BLOCK] / [WARN] / [INFO]                 |
| Category    | Injection / Auth / Crypto / Secrets / Config / Dependency |
| CWE         | CWE-<id> — <name>                        |
| OWASP       | A0X — <category name>                    |
| Location    | `<file>:<line>`                          |
| Confidence  | High / Medium / Low                      |
| Source      | Semgrep Pro / Semgrep OSS / Manual / Dep Scan / Both |
| Analysis    | Syntactic / Semantic / Interprocedural   |
| Status      | Open / Resolved / Accepted Risk          |

#### Description
<What the vulnerability is and why it is exploitable. Specific to this code.>

#### Risk Assessment

| Factor     | Rating              | Rationale                          |
|------------|---------------------|------------------------------------|
| Likelihood | High / Medium / Low | <why — reachability, complexity>   |
| Impact     | High / Medium / Low | <what an attacker achieves>        |
| Risk Level | Critical–Low        | Likelihood × Impact (see matrix)   |

#### Evidence
```<language>
<Vulnerable code snippet with line numbers>
```

#### Impact Analysis
<Concrete attacker outcome — not "data could be exposed" but "attacker can extract all user
records including password hashes via SQL injection in the search endpoint.">

#### Recommendation
<Specific fix with corrected code snippet. Name the safe API/pattern.>

```<language>
<Fixed code snippet>
```

#### Remediation Status
- [ ] Pending
- [ ] Resolved — <PR/commit ref>
- [ ] Accepted Risk — <justification + expiry date>

---

## 5. Risk Summary Matrix

| ID          | Title | Severity | Tag     | Likelihood | Impact | Status  |
|-------------|-------|----------|---------|------------|--------|---------|
| FINDING-001 |       |          |         |            |        |         |

### Overall Risk Score

| Phase              | Score          | Rationale |
|--------------------|----------------|-----------|
| Before remediation | <severity (score/10)> | <derive from the highest-severity open findings> |
| After remediation  | <severity (score/10)> | <residual risk once [BLOCK]/[WARN] findings are resolved> |
| Risk reduction     | <% reduction>  | <only if a numeric score is computed; otherwise omit this row> |

---

## 6. Recommendations

### Immediate Actions (P0 — Block Merge)
<All [BLOCK] findings with one-line remediation action>

### PR Description Template
```
## Security Review
Findings addressed: <FINDING IDs>
Remaining open: <IDs + justification>
Semgrep scan: PASSED | FAILED (see /security-review/<filename>)
Reviewer: <Name>  Date: <YYYY-MM-DD>
```

### Long-Term Recommendations
<Grouped by theme: e.g. "Adopt parameterized queries project-wide", "Add Semgrep CI rule for X">

---

## 7. Compliance Impact

<Include only frameworks relevant to the project. Remove inapplicable rows.>

| Framework | Control                       | Before        | After     |
|-----------|-------------------------------|---------------|-----------|
| SOC 2     | CC6.1 — Logical Access        | At Risk       | Compliant |
| ISO 27001:2022 | A.8.25 — Secure Development Life Cycle | Partial | Compliant |
| GDPR      | Art. 32 — Security of Processing | At Risk    | Compliant |
| NIS2      | Art. 21 — Risk Management     | At Risk       | Compliant |
| DORA      | Art. 7 — ICT Risk Management  | At Risk       | Compliant |

---

## 8. Conclusion

<Summary of findings, remediation status, risk reduction, and explicit approval recommendation:
APPROVED | APPROVED WITH CONDITIONS | NOT APPROVED>

---

## 9. Sign-Off

| Field     | Value                  |
|-----------|------------------------|
| Name      | <Firstname Lastname>   |
| Role      | Staff Security Engineer|
| Email     | <email>                |
| Date      | <YYYY-MM-DD>           |
| Signature | <Firstname Lastname>   |

### Distribution List
| Name | Role             | Reason                       |
|------|------------------|------------------------------|
|      | Engineering Lead | Code owner — action required  |
|      | Security Team    | FYI — findings archive        |
|      | Compliance       | FYI — compliance impact       |

---

## Appendix A — Semgrep Raw Findings

| Rule ID | Location | Severity | CWE | Confidence | Assessment          |
|---------|----------|----------|-----|------------|---------------------|
|         |          |          |     |            | TP / FP / NEEDS_REVIEW |

## Appendix B — Confirmed False Positives

| Rule ID | Location | Reason | Action                                    |
|---------|----------|--------|-------------------------------------------|
|         |          |        | nosec comment / rule tuning / acceptable risk |

## Appendix C — Dependency Scan Results

| Package | Installed | Vulnerable | CVE | Severity | Fix Available |
|---------|-----------|------------|-----|----------|---------------|
|         |           |            |     |          |               |

## Appendix D — Coverage Gaps

<Vulnerability classes or code paths that neither automated nor manual review could assess
confidently. Candidates for new rules or integration tests.>

## Appendix E — Taint Flow Map

**Sources identified:**
**Sinks reached:**
**Sanitizers present:**
**Unsanitized paths:**
**Automated coverage vs. manual:**
```

# SBOM Summary Report Template

Use this structure for the human-readable summary. Replace all `<placeholders>`.

---

```markdown
# SBOM Summary Report

## 1. Header

| Field          | Value                                          |
|----------------|------------------------------------------------|
| Document ID    | SBOM-YYYYMMDD-001                              |
| Date           | YYYY-MM-DD                                     |
| Repository     | <repo name>                                    |
| Branch         | <branch>                                       |
| Commit         | <short hash> — <message>                       |
| Author         | <Firstname Lastname (email@domain.com)>        |
| Classification | CONFIDENTIAL — Internal Security Use Only      |
| Status         | DRAFT / FINAL                                  |
| SBOM Format    | CycloneDX JSON / SPDX JSON / …                 |
| SBOM Tool      | Syft / cdxgen / manual / …                     |
| Vuln Scanner   | Grype / OSV-Scanner / N/A                      |
| SBOM File      | `sbom/<filename>`                              |

---

## 2. Component Summary

| Metric | Value |
|--------|-------|
| Total components | |
| Direct dependencies | |
| Transitive dependencies | |
| Ecosystems detected | |

### By Ecosystem

| Ecosystem | Count |
|-----------|-------|
| | |

### By License Family

| License Type | Count | Examples |
|-------------|-------|----------|
| Permissive (MIT, Apache-2.0, BSD) | | |
| Weak copyleft (LGPL, MPL) | | |
| Strong copyleft (GPL, AGPL) | | |
| Unknown / NOASSERTION | | |

---

## 3. Vulnerability Summary

<Skip this section if no vuln scanner was run. Note: "Vulnerability scan not performed.">

| Severity | Count |
|----------|-------|
| Critical | |
| High     | |
| Medium   | |
| Low      | |
| Info     | |

### Top Actionable Findings

| # | Package | Version | CVE | Severity | Tag | Fix Version | Action |
|---|---------|---------|-----|----------|-----|-------------|--------|
| 1 | | | | | [BLOCK] / [WARN] / [INFO] | | Upgrade / Replace / Accept |

---

## 4. NTIA Compliance

| Element | Status | Notes |
|---------|--------|-------|
| Supplier name | ✅ PASS / ⚠️ PARTIAL / ❌ FAIL | <coverage %> |
| Component name | | |
| Version | | |
| Unique identifier (PURL) | | |
| Dependency relationship | | |
| SBOM author | | |
| Timestamp | | |

**Overall NTIA compliance: PASS / PARTIAL / FAIL**

<If PARTIAL or FAIL, list specific gaps and remediation steps.>

---

## 5. License Risk Analysis

<Flag any components with:>
- Unknown or missing licenses → compliance blocker
- AGPL/GPL in proprietary codebases → legal review needed
- License conflicts between dependencies
- Components with license changes in recent versions

---

## 6. Regulatory Applicability

| Regulation | Applicable? | Requirement Met? | Gap |
|------------|-------------|-------------------|-----|
| EU CRA     | Yes/No      | Yes / Partial / No | |
| NIS2       | | | |
| EO 14028   | | | |
| DORA       | | | |

---

## 7. Recommendations

### [ACTION REQUIRED]
<Items that need immediate attention: critical vulns, license blockers, NTIA gaps>

### Improvements
<Nice-to-have: pin floating versions, add supplier metadata, improve PURL coverage>

### Process
<Integrate SBOM generation into CI/CD, set up periodic vuln rescanning, establish update cadence>
```

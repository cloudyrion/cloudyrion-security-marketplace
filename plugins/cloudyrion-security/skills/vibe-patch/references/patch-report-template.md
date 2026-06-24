# Security Vibe Patch Report Template

Use this structure for every patch report. Replace all `<placeholders>`.

---

```markdown
# Security Vibe Patch Report

## 1. Header Metadata

| Field            | Value                                                    |
|------------------|----------------------------------------------------------|
| Document ID      | SVP-YYYYMMDD-001                                         |
| Date             | YYYY-MM-DD                                               |
| Author           | <Firstname Lastname (email@domain.com)>                  |
| Repository       | <repo name>                                              |
| Patch Branch     | security/vibe-patch-<date>                               |
| Base Branch      | <base branch>                                            |
| Commit Range     | <base tip>..<patch tip> (N commits)                      |
| Source Report    | `security-code-review-report-<date>.md`                  |
| Source Commit    | <commit hash the code review was run against>            |
| Filter Applied   | BLOCK only / BLOCK+WARN / ALL                            |
| Classification   | CONFIDENTIAL — Internal Security Use Only                |
| Status           | DRAFT / FINAL                                            |
| Semgrep Engine   | Pro / OSS / Not available                                |

---

## 2. Executive Summary

<2–3 paragraphs: findings reviewed/patched/skipped, CWE classes remediated, aggregate risk
reduction, what remains open and why, one-line merge recommendation.>

### Patch Outcome Summary

| Outcome                               | Count |
|----------------------------------------|-------|
| Patched — Semgrep verified             |       |
| Patched — Semgrep unverified           |       |
| Skipped — Low confidence (manual)      |       |
| Skipped — Semgrep verification failed  |       |
| Skipped — Pre-commit hook rejected     |       |
| Skipped — File context changed         |       |
| Excluded — Already Resolved            |       |
| **Total findings reviewed**            |       |

### Risk Reduction Estimate

| Phase           | Open [BLOCK] | Open [WARN] | Estimated Risk |
|-----------------|-------------|-------------|----------------|
| Before patching | N           | N           | <qualitative>  |
| After patching  | N           | N           | <qualitative>  |
| Remaining manual| N           | —           | <what's left>  |

---

## 3. Patched Findings

<!-- One entry per successfully committed patch -->

### PATCH-001 — <Finding Title>

| Field          | Value                                         |
|----------------|-----------------------------------------------|
| Finding ID     | FINDING-NNN                                   |
| Severity       | [BLOCK] / [WARN]                               |
| CWE            | CWE-<id> — <name>                             |
| Location       | `<file>:<line>`                               |
| Confidence     | HIGH / MEDIUM                                  |
| Semgrep Rule   | `<rule-id>` / Manual finding                   |
| Commit         | `<short hash>` — <subject>                    |
| Verification   | Semgrep verified clean / Semgrep unverified   |

#### What Was Changed
<One precise paragraph: what lines were modified and what the change does. Describe the fix,
not the vulnerability.>

#### Before
```<language>
<vulnerable code — from finding evidence>
```

#### After
```<language>
<patched code — as committed>
```

#### Why This Fix Is Sufficient
<Trace the taint path: source → sink. How does the patch break the path?>

---

## 4. Skipped Findings — Manual Remediation Required

These findings were not patched because the fix requires business logic understanding, runtime
configuration, or side effects that cannot be determined statically. No speculative patches
were generated.

### SKIP-001 — <Finding Title>

| Field       | Value                                                    |
|-------------|----------------------------------------------------------|
| Finding ID  | FINDING-NNN                                              |
| Severity    | [BLOCK] / [WARN]                                          |
| CWE         | CWE-<id> — <name>                                        |
| Location    | `<file>:<line>`                                          |
| Skip Reason | Low confidence / Hook blocked / Verification failed / Context changed |

#### Why It Was Skipped
<Specific technical reason — name the exact concern, not "complex code".>

#### Recommended Fix
<Actionable guidance: safe API/pattern, migration steps, files to update, code snippet if
the approach is straightforward.>

#### Acceptance Criteria
<How to verify the fix: what test, scan, or behavior change confirms remediation.>

---

## 5. Verification Instructions

```bash
git checkout security/vibe-patch-<date>
git log --oneline <base-commit>..HEAD
semgrep scan --config=p/default <list patched files>
# Expected: zero findings for patched CWE classes in listed files
```

**Patched files:** <bulleted list>
**CWE classes remediated:** <bulleted list>

---

## 6. Open Finding Backlog

| Finding ID  | Title | Severity | CWE | Location | Reason Open |
|-------------|-------|----------|-----|----------|-------------|
| FINDING-NNN |       |          |     |          |             |

---

## 7. Compliance Impact

<Only rows relevant to patched CWEs. Remove inapplicable frameworks.>

| Framework | Control                          | Before    | After     |
|-----------|----------------------------------|-----------|-----------|
| SOC 2     | CC6.1 — Logical Access Controls  |           |           |
| ISO 27001:2022 | A.8.28 — Secure coding      |           |           |
| GDPR      | Art. 32 — Security of Processing |           |           |
| NIS2      | Art. 21 — Risk Management        |           |           |

---

## 8. Sign-Off

| Field     | Value                  |
|-----------|------------------------|
| Name      | <Firstname Lastname>   |
| Role      | Staff Security Engineer|
| Email     | <email>                |
| Date      | <YYYY-MM-DD>           |
| Signature | <Firstname Lastname>   |

### Distribution List
| Name | Role             | Reason                              |
|------|------------------|-------------------------------------|
|      | Engineering Lead | Code owner — review and merge PR    |
|      | Security Team    | FYI — patch archive                 |
|      | Compliance       | FYI — compliance impact             |

---
*Generated by security-vibe-patch on <YYYY-MM-DD HH:MM>*
```

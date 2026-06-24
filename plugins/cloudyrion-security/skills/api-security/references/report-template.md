# API Security Report Template

Replace all `<placeholders>`.

---

```markdown
# API Security Report

## 1. Header Metadata

| Field          | Value                                     |
|----------------|-------------------------------------------|
| Document ID    | API-YYYYMMDD-001                          |
| Date           | YYYY-MM-DD                                |
| Author         | <Firstname Lastname (email@domain.com)>   |
| Repository     | <repo name>                               |
| API Name       | <API name / service>                      |
| API Type       | REST / GraphQL / gRPC / WebSocket         |
| Spec File      | <path to OpenAPI spec or "N/A">           |
| Framework      | <detected framework>                      |
| Classification | CONFIDENTIAL — Internal Security Use Only |
| Status         | DRAFT / FINAL                             |

---

## 2. Executive Summary

<2–3 paragraphs: endpoints reviewed, total findings by severity, highest risk areas
(typically BOLA and auth), overall API security posture, top 3 actions.>

### Finding Counts

| Severity | Count | OWASP Category | Resolved | Pending |
|----------|-------|----------------|----------|---------|
| Critical |       |                |          |         |
| High     |       |                |          |         |
| Medium   |       |                |          |         |
| Low      |       |                |          |         |
| Info     |       |                |          |         |

---

## 3. API Inventory

### Endpoints Reviewed

| # | Method | Path | Auth | Rate Limited | Findings |
|---|--------|------|------|-------------|----------|
| 1 | GET | /api/v1/users/{id} | Bearer JWT | No | FINDING-001 |

### Auth Schemes

| Scheme | Endpoints Using | Assessment |
|--------|----------------|------------|
| Bearer JWT | N | <findings summary> |
| API Key | N | <findings summary> |
| None (public) | N | <acceptable / review needed> |

---

## 4. OWASP API Top 10 Coverage

| # | Category | Findings | Highest Severity | Status |
|---|----------|----------|------------------|--------|
| API1 | BOLA | N | | |
| API2 | Broken Auth | N | | |
| API3 | Property-Level Authz | N | | |
| API4 | Resource Consumption | N | | |
| API5 | BFLA | N | | |
| API6 | Business Flow Abuse | N | | |
| API7 | SSRF | N | | |
| API8 | Misconfiguration | N | | |
| API9 | Inventory Mgmt | N | | |
| API10 | Unsafe Consumption of APIs | N | | |

---

## 5. Findings

### FINDING-001 — <Short Title>

| Field       | Value                                    |
|-------------|------------------------------------------|
| ID          | FINDING-001                              |
| Severity    | Critical / High / Medium / Low / Info     |
| Tag         | [BLOCK] / [WARN] / [INFO]               |
| OWASP API   | API1–API10                               |
| CWE         | CWE-<id> — <CWE name>                    |
| Endpoint    | `METHOD /path`                           |
| Location    | `<file>:<line>` (if code reviewed)       |
| Source      | Spec analysis / Code review / Both       |
| Status      | Open / Resolved / Accepted Risk          |

#### Description
<Specific to this API — not generic OWASP text.>

#### Evidence
```
<Request/response example or code snippet showing the issue>
```

#### Risk Assessment
| Factor | Rating | Rationale |
|--------|--------|-----------|
| Likelihood | | |
| Impact | | |
| Risk Level | | |

#### Recommendation
<Specific fix with code/config example.>

---

## 6. Spec vs. Implementation Gaps

<If both spec and code were reviewed.>

| Gap | Spec Says | Code Does | Finding |
|-----|-----------|-----------|---------|
| Missing auth | `security: [bearerAuth]` | No middleware | FINDING-00N |
| Extra endpoint | Not in spec | `GET /admin/debug` | FINDING-00N |
| Schema mismatch | `maxLength: 100` | No validation | FINDING-00N |

---

## 7. Risk Summary Matrix

| ID | Title | OWASP | Severity | Endpoint | Status |
|----|-------|-------|----------|----------|--------|
| FINDING-001 | | | | | |

---

## 8. Recommendations

### Immediate ([BLOCK])
<One-line per blocking finding.>

### Authentication & Authorization
<Grouped auth/authz improvements.>

### Input Validation & Rate Limiting
<Validation and abuse prevention improvements.>

### API Hygiene
<Inventory management, deprecation, documentation.>

---

## 9. Sign-Off

| Field | Value |
|-------|-------|
| Name | <name> |
| Role | API Security Specialist |
| Date | <YYYY-MM-DD> |
| Signature | <signature> |
```

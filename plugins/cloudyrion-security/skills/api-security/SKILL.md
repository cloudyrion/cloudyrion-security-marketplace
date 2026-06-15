---
description: >
  Review APIs for security vulnerabilities against the OWASP API Security Top 10 (2023).
  Accepts OpenAPI/Swagger specs, API code, or both. Analyzes authentication, authorization,
  data exposure, rate limiting, input validation, and business logic flaws. Generates a
  formal API Security Report with per-endpoint findings and remediation guidance. Use this
  skill whenever the user asks to review an API for security, audit an OpenAPI spec, check
  REST/GraphQL endpoints for vulnerabilities, assess API auth patterns, or validate API
  design against security best practices. Also trigger on: 'API security', 'OWASP API Top 10',
  'OpenAPI review', 'Swagger audit', 'endpoint security', 'API pentest review', 'REST security',
  'GraphQL security', 'is my API secure', or any request to find security issues in API
  definitions or implementations.
---

# API Security Review

You are acting as an API Security Specialist reviewing APIs against the OWASP API Security
Top 10 (2023) and industry best practices.

Before generating, read:
→ `references/owasp-api-top10.md` — full OWASP API Top 10 (2023) with check questions
→ `references/report-template.md` — report structure

---

## Step 1 — Gather API Context

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
DATE=$(date +%Y%m%d)
REPORT_DIR="$REPO_ROOT/security-review"
mkdir -p "$REPORT_DIR"
```

### Inputs (at least one required)

| Input type | What to extract |
|---|---|
| OpenAPI/Swagger spec (`.yaml`/`.json`) | Endpoints, methods, parameters, schemas, auth schemes, response shapes |
| API code (routes/controllers) | Endpoint implementations, middleware, auth logic, DB queries, validation |
| Both spec + code | Cross-reference: does implementation match spec? Gaps = findings |
| Verbal description | Structured interview (see below) |

If code is provided, detect the framework:

| Framework | Route pattern |
|---|---|
| Express/Fastify | `app.get()`, `router.post()`, `fastify.route()` |
| Django/DRF | `urlpatterns`, `@api_view`, ViewSets |
| Flask/FastAPI | `@app.route()`, `@router.get()` |
| Spring Boot | `@GetMapping`, `@RestController` |
| Go (net/http, Gin, Echo) | `http.HandleFunc()`, `r.GET()` |
| Rails | `routes.rb`, controllers |
| GraphQL | schema definitions, resolvers |

### Build endpoint inventory

For every endpoint, capture:

```
Method:          GET/POST/PUT/DELETE/PATCH
Path:            /api/v1/users/{id}
Auth required:   Yes (Bearer JWT) / API key / None
Parameters:      path: id (integer), query: include (string), body: {schema}
Response shape:  {fields returned}
Rate limited:    Yes / No / Unknown
Pagination:      Yes / No / N/A
```

---

## Step 2 — OWASP API Top 10 (2023) Analysis

Read `references/owasp-api-top10.md` for the full check list. For each endpoint, systematically
evaluate all 10 categories:

| # | Category | Key question |
|---|---|---|
| API1 | Broken Object-Level Authorization (BOLA) | Can user A access user B's objects by changing the ID? |
| API2 | Broken Authentication | Are credentials/tokens handled securely? Can auth be bypassed? |
| API3 | Broken Object Property-Level Authorization | Does the API return fields the user shouldn't see? Can users set privileged fields? |
| API4 | Unrestricted Resource Consumption | Are there rate limits, pagination limits, payload size limits? |
| API5 | Broken Function-Level Authorization (BFLA) | Can a regular user call admin endpoints? |
| API6 | Unrestricted Access to Sensitive Business Flows | Can automated attacks abuse business logic (e.g. mass account creation)? |
| API7 | Server-Side Request Forgery (SSRF) | Does the API fetch user-supplied URLs? |
| API8 | Security Misconfiguration | CORS, error verbosity, unnecessary methods, default creds? |
| API9 | Improper Inventory Management | Deprecated/undocumented endpoints still reachable? |
| API10 | Unsafe Consumption of Third-Party APIs | Does the API trust third-party responses without validation? |

### GraphQL-specific checks (if applicable)

- Introspection enabled in production
- No query depth/complexity limits (DoS via nested queries)
- Missing field-level authorization in resolvers
- Batch query abuse (alias-based brute force)
- N+1 query patterns without DataLoader

---

### Evidence Checklist per OWASP API Category

| Category | What to grep/check | Finding if missing |
|----------|-------------------|-------------------|
| **API1 BOLA** | Grep for ID params in routes ({id}, {userId}). Check: middleware validates requesting user owns resource. | No ownership check on resource access |
| **API2 Broken Auth** | Check JWT config: alg:none rejected? Expiry enforced? Refresh tokens rotated? Passwords hashed with bcrypt/argon2? | Weak auth configuration |
| **API3 Property-Level** | Check response serialization: are internal fields (password_hash, is_admin, internal_id) excluded? | Excessive data in response |
| **API4 Unrestricted Resource** | Check if endpoints return unbounded lists. Is pagination enforced? Max page size? | Missing pagination limits |
| **API5 BFLA** | List all admin routes. Check: role/permission check via middleware or inline? | Missing function-level auth |
| **API6 SSRF** | Grep for user-supplied URLs fetched server-side. Check: URL validation, scheme allowlist, private IP blocking. | Unvalidated server-side fetch |
| **API7 Security Misconfig** | Check: CORS policy, error verbosity, debug mode, default credentials, missing security headers. | Insecure defaults |
| **API8 Injection** | Trace all user inputs to sinks (SQL, shell, template, LDAP). Check: parameterized queries, input validation. | Injection vector |
| **API9 Inventory** | Compare spec endpoints vs code routes. Grep for undocumented routes. | Undocumented/shadow APIs |
| **API10 Unsafe Consumption** | Check all outbound API calls: TLS verified? Response validated? Timeouts set? | Unsafe third-party integration |

### GraphQL-Specific Checks (apply per category above)

- **API1**: Check field-level authorization (can user A query user B fields?)
- **API3**: Check introspection exposure in production
- **API4**: Check query depth limits, complexity limits, batch query limits
- **API8**: Check for injection in variables passed to resolvers

## Step 3 — Deep Analysis Areas

### 3a. Authentication & Token Security
- JWT: algorithm validation (`alg: none`), secret strength, claim validation (`exp`, `aud`, `iss`)
- OAuth2: proper flow for client type, PKCE for public clients, token storage
- API keys: rotation mechanism, scope limitation, transmission security (header vs query param)
- Session: entropy, expiration, invalidation on password change

### 3b. Authorization Patterns
- Object-level: does every data-access endpoint verify ownership?
- Function-level: are admin routes in separate middleware/guard?
- Field-level: mass assignment protection, response filtering
- Horizontal privilege escalation: ID enumeration, IDOR

### 3c. Input Validation & Data Handling
- Schema validation enforced on all inputs
- Type coercion issues (string "true" vs boolean)
- Array/object size limits
- File upload: type validation, size limits, storage location
- SQL/NoSQL injection in query parameters

### 3d. Response Security
- Excessive data exposure: are responses filtered to role?
- Error responses: do they leak stack traces, DB info, or internal paths?
- CORS: is `Access-Control-Allow-Origin: *` used? Are credentials allowed with wildcard?
- Security headers: `X-Content-Type-Options`, `Strict-Transport-Security`, `X-Frame-Options`

### 3e. Rate Limiting & Abuse Prevention
- Per-endpoint rate limits (not just global)
- Auth endpoint rate limiting (brute force protection)
- Pagination: maximum page size enforced server-side?
- Resource-intensive operations: async or queued?

---

## Step 4 — Spec vs. Implementation Gap Analysis

If both spec and code are available, cross-reference:

| Gap type | Finding |
|---|---|
| Endpoint in code but not in spec | Undocumented API — API9 |
| Auth in spec but not enforced in code | Missing auth middleware — API2 |
| Schema validation in spec but no runtime check | Input not validated — API3/API8 |
| Deprecated endpoint still routable | Shadow API — API9 |
| Response schema wider in code than spec | Excessive data exposure — API3 |

---

## Step 5 — Severity Scoring

Same Likelihood × Impact matrix as other skills.

**API-specific likelihood factors:** Is the endpoint public? Does it handle PII? Is it
in the critical business path? Does exploitation require authentication?

**API-specific impact factors:** Data volume exposed, account takeover potential,
business logic abuse (financial transactions, data deletion).

---

## Step 6 — Generate Report

Read `references/report-template.md` and write to:
`$REPORT_DIR/api-security-report-${DATE}.md`

Document ID: `API-YYYYMMDD-001`

---

## Principles

1. **BOLA is the #1 API vulnerability** — test every data-access endpoint for it
2. **Spec ≠ implementation** — always verify if both are available
3. **Absence of rate limiting is always a finding** — severity depends on what the endpoint does
4. **GraphQL introspection in production = Critical** — it's a full schema disclosure
5. **Error verbosity is a signal** — verbose errors in one endpoint suggest systemic misconfiguration
6. **Every parameter is an attack vector** — path, query, header, body, cookie
7. **Auth at the gateway is not enough** — each service must enforce its own authorization

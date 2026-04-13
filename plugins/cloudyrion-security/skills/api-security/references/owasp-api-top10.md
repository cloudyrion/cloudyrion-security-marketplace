# OWASP API Security Top 10 (2023) — Check Reference

## API1:2023 — Broken Object-Level Authorization (BOLA)

**What it is:** API endpoints that access objects using user-supplied IDs without verifying the
requesting user owns or has permission to access that object.

**Check questions:**
- Does the endpoint use a user-supplied ID to fetch data?
- Is ownership/permission verified server-side for every request?
- Can changing the ID in the path/body return another user's data?
- Are GUIDs used instead of sequential integers? (mitigation, not fix)
- Is authorization checked in the data access layer, not just the route?

**CWE:** CWE-285 (Improper Authorization), CWE-639 (IDOR)

---

## API2:2023 — Broken Authentication

**What it is:** Weak or broken authentication mechanisms that allow attackers to impersonate
other users or bypass authentication entirely.

**Check questions:**
- Are auth endpoints rate-limited against brute force?
- Is password complexity enforced?
- Are JWTs validated properly (algorithm, expiration, audience, issuer)?
- Can `alg: none` bypass JWT verification?
- Are refresh tokens rotated on use? Are old ones invalidated?
- Is authentication enforced on every endpoint that needs it (not just assumed)?
- Are API keys transmitted in headers (not query strings)?
- Is PKCE used for OAuth2 public clients?

**CWE:** CWE-287 (Improper Authentication), CWE-798 (Hardcoded Credentials)

---

## API3:2023 — Broken Object Property-Level Authorization

**What it is:** API exposes object properties that users shouldn't access, or allows users to
set properties they shouldn't modify (mass assignment).

**Check questions:**
- Does the API return more fields than the client needs?
- Are sensitive fields (password hash, internal IDs, PII) filtered from responses?
- Can a user set `role`, `is_admin`, `balance`, or other privileged fields via POST/PUT?
- Are request schemas allowlisted (not blocklisted)?
- Are different response shapes used for different roles?

**CWE:** CWE-213 (Exposure of Sensitive Info), CWE-915 (Mass Assignment)

---

## API4:2023 — Unrestricted Resource Consumption

**What it is:** API doesn't limit the resources a single client can consume, enabling DoS
or excessive costs.

**Check questions:**
- Are rate limits applied per-endpoint (not just globally)?
- Is pagination enforced with a server-side maximum page size?
- Are file upload sizes limited?
- Are GraphQL queries limited by depth/complexity?
- Are expensive operations (reports, exports) async or queued?
- Are execution timeouts configured?
- Is there cost-based throttling for pay-per-use APIs?

**CWE:** CWE-770 (Allocation Without Limits), CWE-400 (Uncontrolled Resource Consumption)

---

## API5:2023 — Broken Function-Level Authorization (BFLA)

**What it is:** Regular users can access admin functions because function-level access control
is missing or misconfigured.

**Check questions:**
- Are admin endpoints separated from user endpoints?
- Is role-based access control enforced in middleware (not just UI)?
- Can a regular user call admin endpoints by guessing the URL?
- Are HTTP method restrictions enforced (e.g. user can GET but not DELETE)?
- Is vertical privilege escalation tested?

**CWE:** CWE-285 (Improper Authorization)

---

## API6:2023 — Unrestricted Access to Sensitive Business Flows

**What it is:** API exposes business flows that can be abused via automation without
anti-automation controls.

**Check questions:**
- Can automated scripts mass-create accounts, purchases, or bookings?
- Are CAPTCHA or proof-of-work challenges used for sensitive flows?
- Are device fingerprinting or behavioral analysis used?
- Is there velocity checking (e.g. max N actions per user per hour)?

**CWE:** CWE-799 (Improper Control of Interaction Frequency)

---

## API7:2023 — Server-Side Request Forgery (SSRF)

**What it is:** API accepts a URL from the user and fetches it server-side without validation.

**Check questions:**
- Does any endpoint accept a URL, URI, or hostname as input?
- Is the input validated against an allowlist of domains?
- Are internal/private IP ranges blocked (127.0.0.1, 10.x, 169.254.x, etc.)?
- Are redirects followed? (open redirect → SSRF chain)
- Is DNS rebinding mitigated?

**CWE:** CWE-918 (SSRF)

---

## API8:2023 — Security Misconfiguration

**What it is:** Missing security hardening, verbose errors, unnecessary features enabled,
insecure defaults.

**Check questions:**
- Is CORS configured restrictively (not `*` with credentials)?
- Do error responses leak stack traces, SQL errors, or internal paths?
- Are unnecessary HTTP methods disabled (TRACE, OPTIONS without need)?
- Are security headers present (HSTS, X-Content-Type-Options, CSP)?
- Are default credentials changed?
- Is TLS enforced (no HTTP fallback)?
- Are debug endpoints disabled in production?

**CWE:** CWE-16 (Configuration), CWE-209 (Info Exposure via Error)

---

## API9:2023 — Improper Inventory Management

**What it is:** Outdated, deprecated, or undocumented API endpoints that remain accessible.

**Check questions:**
- Are there API versions still running that should be decommissioned?
- Are there endpoints in the code not documented in the OpenAPI spec?
- Are staging/debug endpoints accessible from production?
- Is there a complete, up-to-date API inventory?
- Are deprecated endpoints returning proper deprecation headers?

**CWE:** CWE-1059 (Incomplete Documentation)

---

## API10:2023 — Unsafe Consumption of Third-Party APIs

**What it is:** API trusts data from third-party services without validation, enabling
transitive attacks.

**Check questions:**
- Are responses from third-party APIs validated/sanitized before use?
- Are third-party API calls made over TLS with certificate validation?
- Are timeouts and circuit breakers configured for external calls?
- Is there a fallback if the third-party is unavailable?
- Are third-party API keys/secrets stored securely?

**CWE:** CWE-20 (Improper Input Validation)

---
description: >
  Review system architecture documents (HLD, LLD, design specs, diagrams) against security
  best practices, Secure by Design principles, and regulatory requirements. Identifies
  architectural anti-patterns, missing security controls, and design-level risks. Produces a
  formal Security Architecture Review Report with findings, framework traceability, and
  prescriptive recommendations. Use this skill whenever the user asks to review an architecture
  for security, assess a system design, evaluate a high-level or low-level design document,
  check if an architecture follows security best practices, or perform a Secure by Design
  review. Also trigger on: 'architecture review', 'design review', 'HLD review', 'LLD review',
  'Secure by Design', 'security assessment of architecture', 'zero trust review', 'is this
  architecture secure', 'review my design', or any request to evaluate whether a system's
  structure and design decisions are secure.
---

# Security Architecture Review

You are acting as a Principal Security Architect performing a Secure by Design review of
system architecture. Your focus is on **design-level** security — not code vulnerabilities
(that's `/cloudyrion-security:code-review`) or threat enumeration (that's
`/cloudyrion-security:threat-model`).
You assess whether the architecture's structure, patterns, and control placement are sound.

Before generating, read:
→ `references/review-checklist.md` — domain-by-domain review checklist with anti-patterns
→ `references/report-template.md` — report structure

---

## Step 1 — Gather Architecture Context

### Inputs (at least one required)

| Input type | What to extract |
|---|---|
| HLD document | Components, interactions, trust boundaries, deployment model, data flows |
| LLD document | Protocols, ports, auth mechanisms, encryption specs, API contracts, storage config |
| Architecture diagrams | Topology, network zones, component placement, data paths |
| Code / repository | Infer architecture from project structure, configs, docker-compose, IaC, service mesh |
| Verbal description | Structured interview (see below) |

### Structured interview (if no document provided)

1. **System purpose** — What does it do? Who uses it?
2. **Components** — Enumerate all services, databases, caches, queues, external APIs
3. **Deployment** — Cloud (which?), on-prem, hybrid, containerized, serverless?
4. **Network topology** — Zones, segments, internet-facing surfaces, internal boundaries
5. **Identity architecture** — How do users authenticate? How do services authenticate to each other?
6. **Data lifecycle** — What data enters, where is it stored, how does it flow, where does it exit?
7. **Data classification** — What's the highest sensitivity level? PII? Financial? Health?
8. **Existing security controls** — WAF, SIEM, encryption, key management, secrets vault?
9. **Regulatory context** — NIS2, DORA, CRA, GDPR, sector-specific requirements?
10. **Scale & availability** — Expected load, SLAs, multi-region, DR requirements?

### Determine sector context

Sector-specific architectural concerns differ significantly. Identify the sector to apply
the right lens:

| Sector | Key architectural concerns |
|---|---|
| Telco / 5G | Network function isolation, signaling security (Diameter/SS7/GTP), MEC trust, NFVi hardening, 3GPP SCAS |
| Banking / Insurance | Transaction integrity, HSM integration, PSD2/open banking API security, data residency, SWIFT CSP |
| Automotive | V2X trust, OTA update integrity, ECU isolation, CAN/Ethernet gateway security, UNECE R155/R156 |
| Critical infrastructure / OT | IT/OT segmentation (Purdue model), protocol translation security, safety-security convergence |
| IoT / Consumer devices | Secure boot chain, firmware update mechanism, minimal attack surface, ETSI EN 303 645 |
| SaaS / Cloud-native | Tenant isolation, control plane security, data plane encryption, identity federation |
| Healthcare | PHI segmentation, medical device integration, HL7/FHIR API security, audit trail integrity |

---

## Step 2 — Architecture Decomposition

Build a structured inventory of the architecture:

### Component inventory

| ID | Component | Type | Technology | Zone | Internet-facing | Data handled |
|----|-----------|------|------------|------|-----------------|-------------|
| C-001 | API Gateway | Process | Kong/Envoy | DMZ | Yes | Auth tokens, request routing |
| C-002 | User Service | Process | Java/Spring | App tier | No | PII, credentials |
| C-003 | PostgreSQL | Data store | PostgreSQL 15 | Data tier | No | User records, transactions |

### Trust boundary map

| Boundary | Zones separated | Crossing controls |
|----------|----------------|-------------------|
| B-001 | Internet ↔ DMZ | WAF, DDoS protection, TLS termination |
| B-002 | DMZ ↔ App tier | Network policy, mTLS, API gateway auth |
| B-003 | App tier ↔ Data tier | Network policy, DB auth, encrypted connections |

### Data flow inventory

| ID | From → To | Data type | Protocol | Encrypted | Authenticated | Crosses boundary |
|----|-----------|-----------|----------|-----------|---------------|-----------------|
| F-001 | User → API GW | Credentials | HTTPS | Yes | No (pre-auth) | B-001 |
| F-002 | API GW → User Svc | Auth token + request | gRPC/mTLS | Yes | Yes | B-002 |

---

## Step 3 — Review Against Security Domains

Read `references/review-checklist.md` for the detailed checks per domain.

### 3a. Network Architecture & Segmentation
- Defense in depth: multiple zones, not flat network
- Zero trust: no implicit trust between services
- Microsegmentation: network policies per service, not per zone
- Egress control: outbound traffic filtered, not open
- Internet exposure minimized: only API gateway/LB in DMZ

### 3b. Identity & Access Architecture
- Centralized identity provider (IdP)
- Service-to-service authentication (mTLS, workload identity, SPIFFE)
- No shared service accounts
- Principle of least privilege at every layer
- Token lifecycle: short-lived, rotatable, revocable

### 3c. Data Protection Architecture
- Encryption at rest for all data stores (not just "sensitive" ones)
- Encryption in transit for all internal flows (not just internet-facing)
- Key management: dedicated KMS, not application-managed keys
- Data classification driving control selection
- Data residency and sovereignty addressed

### 3d. Secrets Management
- Centralized secrets vault (HashiCorp Vault, AWS Secrets Manager, etc.)
- No secrets in code, config files, environment variables, or CI/CD logs
- Dynamic/short-lived credentials where possible
- Rotation policy for all secrets

### 3e. Logging, Monitoring & Detection
- Centralized log aggregation
- Security-relevant events defined and captured
- Tamper-proof log storage
- Alerting on anomalies and security events
- Correlation capability (SIEM or equivalent)
- Sufficient retention for regulatory requirements

### 3f. Resilience & Availability
- No single points of failure in the security path
- Graceful degradation (fail-closed, not fail-open)
- DR/BCP for security-critical components (IdP, KMS, SIEM)
- Circuit breakers and timeouts for external dependencies
- Rate limiting and back-pressure mechanisms

### 3g. Supply Chain & Dependency Architecture
- SBOM generation integrated into build pipeline
- Dependency pinning (lock files, image digests)
- Private registry for internal artifacts
- Vulnerability scanning in CI/CD
- Third-party API isolation (circuit breakers, validation, timeout)

### 3h. API Architecture
- API gateway as single entry point
- Authentication enforced at gateway AND service level
- Input validation at the boundary
- Rate limiting per-endpoint
- API versioning and deprecation strategy

### 3i. Container & Orchestration Security (if applicable)
- Base image hardening (minimal, pinned, scanned)
- Pod security standards (restricted, not privileged)
- Network policies (default-deny)
- Secrets via CSI driver or operator (not env vars)
- Image signing and admission control

### 3j. Cryptographic Architecture
- Algorithm selection appropriate for data classification
- No custom crypto implementations
- TLS 1.2+ everywhere, TLS 1.3 preferred
- Certificate management (automated rotation, short-lived)
- Post-quantum readiness assessment (for long-lived data)

---

## Step 4 — Identify Anti-Patterns

Flag these common architectural anti-patterns (the per-domain checks in
`references/review-checklist.md` note the anti-pattern each control prevents):

| Anti-pattern | Risk | Better pattern |
|---|---|---|
| Flat network / no segmentation | Lateral movement | Zone-based architecture with microsegmentation |
| Shared database across services | Blast radius, coupling | Database-per-service or schema isolation |
| Auth at gateway only | Any bypass = full access | Auth at every service boundary |
| Secrets in environment variables | Container inspection exposes them | Secrets vault with runtime injection |
| Synchronous chain of >3 services | Cascading failure, latency | Async messaging for non-critical paths |
| Single IdP with no failover | Auth outage = full outage | IdP redundancy or cached auth decisions |
| Logging to local disk only | Lost on container restart | Centralized log shipping (sidecar/agent) |
| Wildcard CORS on API | Cross-origin attacks | Explicit origin allowlist |
| Self-signed certs in production | No trust chain, MitM | PKI or managed certificates |
| Monolithic security gateway | Single point of failure, bottleneck | Distributed security controls |

---

## Step 5 — Severity Scoring

Rate each finding with the standard Likelihood × Impact matrix (severity ladder:
Critical / High / Medium / Low / Info):

| Likelihood ↓ / Impact → | Low | Medium | High |
|---|---|---|---|
| **High** | Medium | High | Critical |
| **Medium** | Low | Medium | High |
| **Low** | Info | Low | Medium |

**Architecture-specific factors:**

- **Likelihood** considers: is the weakness exploitable from outside? Does it require
  compromising another component first? Is it a systemic pattern or isolated?
- **Impact** considers: blast radius (one service vs. entire platform), data sensitivity
  exposed, regulatory consequence, recovery difficulty.

### Classification tags

| Tag | Meaning |
|---|---|
| `[BLOCK]` | Critical/High must-fix — fundamental design flaw, redesign before deployment |
| `[WARN]` | Medium should-fix — significant weakness, address before production |
| `[INFO]` | Low/Info defense-in-depth — improvement opportunity / hardening enhancement |

---

## Step 6 — Framework Traceability

Map each finding to relevant framework controls. Use the `/cloudyrion-security:compliance-mapper`
skill's reference data if available, or map directly:

| Finding | ISO 27001:2022 | NIS2 | DORA | NIST CSF 2.0 | Sector-specific |
|---------|---------------|------|------|-------------|-----------------|
| Missing mTLS | A.8.24 | Art. 21(2)(h) | Art. 9(2) | PR.DS-02 | 3GPP SCAS (telco) |

---

## Step 7 — Generate Report

First, set up the report location and metadata:

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
DATE=$(date +%Y%m%d)
REPORT_DIR="$REPO_ROOT/security-review"
mkdir -p "$REPORT_DIR"
AUTHOR_NAME=$(git config user.name 2>/dev/null || echo "N/A")
AUTHOR_EMAIL=$(git config user.email 2>/dev/null || echo "N/A")
REPO_NAME=$(basename "$REPO_ROOT")
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "N/A")
REPORT="$REPORT_DIR/security-architecture-review-${DATE}.md"
```

Read `references/report-template.md` and write the report to `$REPORT`.

Document ID: `SAR-YYYYMMDD-001`

After writing the report:

```bash
echo "Report written to: $REPORT"
```

### Recommended companion actions

At the end of the report, recommend which other skills should be run:

| If the review found... | Recommend |
|---|---|
| Threat enumeration needed | → `/cloudyrion-security:threat-model` |
| IaC misconfigurations suspected | → `/cloudyrion-security:iac-scanner` |
| API design concerns | → `/cloudyrion-security:api-security` |
| Dependency/supply chain gaps | → `/cloudyrion-security:sbom` |
| Compliance mapping needed | → `/cloudyrion-security:compliance-mapper` |
| Code-level issues suspected | → `/cloudyrion-security:code-review` |

---

## Anti-Pattern Severity Matrix

| Severity | Anti-Patterns |
|----------|---------------|
| **Critical** | Flat network with PII, hardcoded secrets in infra, no auth on admin APIs, no encryption on internet-facing endpoints |
| **High** | Single point of failure for critical service, no encryption at rest for regulated data, shared admin credentials, no WAF on public APIs |
| **Medium** | Missing rate limiting, no centralized logging, shared service accounts, no network segmentation between dev/prod |
| **Low** | Missing health checks, no chaos engineering, manual deployments, no canary releases |

## Sector-Specific Checks

### Banking / DORA
1. Check ICT third-party risk assessment for each external dependency
2. Check business continuity plan covers all critical ICT services
3. Check incident reporting meets DORA deadlines: initial notification within 4h of major classification (≤24h from awareness), intermediate report within 72h, final report within 1 month

### Telco
1. Check network function isolation (separate K8s namespaces or VMs per NF)
2. Check signaling plane security (SS7/Diameter hardening)
3. Check lawful intercept system isolation from production data plane

### Healthcare
1. Check PHI encryption at rest and in transit (HIPAA, GDPR)
2. Check audit logging covers all PHI access with user identity
3. Check emergency access ("break glass") procedure exists with post-access review

## Principles

1. **Architecture review ≠ threat model** — this skill evaluates design decisions and control placement; the threat model enumerates what could go wrong. They complement each other.
2. **Patterns over point fixes** — an architectural finding affects the entire system, not one line of code. Recommendations must be structural.
3. **Secure by Default > Secure by Configuration** — prefer architectures where the safe path is the easy path.
4. **Blast radius is the key metric** — the fundamental question is: when (not if) a component is compromised, how far can the attacker go?
5. **Sector context matters** — a telco NFVi has different architectural requirements than a SaaS platform. Apply the right lens.
6. **No architecture is perfect** — the goal is risk-informed design, not zero risk. Every finding should state the residual risk if accepted.
7. **Defense in depth is non-negotiable** — a single control protecting a critical asset is always a finding, regardless of how strong that control is.
8. **Design for failure** — assume every component will be compromised. The architecture should limit the impact.

# Security Architecture Review Checklist

Structured checklist organized by security domain. For each item, assess:
- **Present**: Control exists in the architecture
- **Absent**: Control is missing — create a finding
- **Partial**: Control exists but incomplete — create a finding with lower severity
- **N/A**: Not applicable to this architecture — document why

---

## 1. Network Architecture & Segmentation

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| NET-01 | Network divided into zones (DMZ, App, Data, Mgmt) | ≥3 zones for internet-facing systems | Flat network — lateral movement trivial |
| NET-02 | Default-deny between zones | Explicit allow rules only | Implicit trust between zones |
| NET-03 | Microsegmentation within zones | Per-service network policies | Zone-level firewall only — compromised service can reach all peers |
| NET-04 | Internet exposure minimized | Only LB/API GW in DMZ | Direct service exposure to internet |
| NET-05 | Egress filtering | Outbound traffic restricted to known destinations | Unrestricted egress — data exfiltration trivial |
| NET-06 | Management plane isolated | Separate management network/VPN | Management ports on production network |
| NET-07 | DNS security | Internal DNS, DNSSEC for external | No DNS filtering, no split DNS |
| NET-08 | DDoS protection on internet edge | Cloud DDoS service or on-prem appliance | No volumetric attack mitigation |
| NET-09 | Service mesh for internal traffic (if microservices) | mTLS, observability, policy enforcement | Direct service-to-service with no control |
| NET-10 | Private endpoints for cloud services | VPC endpoints / Private Link | Cloud API traffic over public internet |

## 2. Identity & Access Management

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| IAM-01 | Centralized IdP | Single source of identity truth | Per-service user stores |
| IAM-02 | Service-to-service auth | mTLS, workload identity, or SPIFFE/SPIRE | Shared API keys or no auth between services |
| IAM-03 | No shared service accounts | Unique identity per workload | One service account for all microservices |
| IAM-04 | Least privilege enforced | Role-based, scoped to minimum needed | Broad admin roles for convenience |
| IAM-05 | MFA for human users | Required for all interactive access | Password-only authentication |
| IAM-06 | Token lifecycle management | Short-lived, rotation, revocation | Long-lived tokens, no revocation mechanism |
| IAM-07 | Break-glass procedure | Emergency access with audit trail | No emergency access — or unaudited admin backdoor |
| IAM-08 | Privilege escalation controls | Just-in-time access, approval workflow | Standing admin access 24/7 |
| IAM-09 | Federation for external partners | SAML/OIDC federation, no shared credentials | Shared username/password for partner access |
| IAM-10 | Auth enforced at service level (not just gateway) | Every service validates auth/authz independently | Gateway-only auth — bypass = full access |

## 3. Data Protection

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| DAT-01 | Encryption at rest for all data stores | AES-256 or equivalent | Unencrypted databases, file storage, or backups |
| DAT-02 | Encryption in transit for ALL flows (internal + external) | TLS 1.2+ everywhere | Plaintext between internal services |
| DAT-03 | Key management via dedicated KMS | HSM-backed, automated rotation | Application-managed keys, keys in config |
| DAT-04 | Data classification applied | Labeling drives control selection | All data treated the same (under- or over-protected) |
| DAT-05 | Data minimization | Only collect/store what's needed | "Collect everything, filter later" |
| DAT-06 | Data retention policy enforced | Automated deletion at end of retention | Data kept indefinitely |
| DAT-07 | Data residency addressed | Storage location matches regulatory requirements | Data stored in non-compliant regions |
| DAT-08 | Backup encryption | Backups encrypted with separate key | Backups as unencrypted copies |
| DAT-09 | PII pseudonymization/tokenization | Sensitive fields tokenized where possible | Raw PII in all environments including dev/staging |
| DAT-10 | Secure deletion | Crypto-shredding or certified destruction | No deletion capability — data lives forever |

## 4. Secrets Management

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| SEC-01 | Centralized secrets vault | HashiCorp Vault, AWS SM, Azure KV, etc. | Secrets in code, env vars, or config files |
| SEC-02 | Dynamic credentials | Generated on demand, auto-expire | Static long-lived database passwords |
| SEC-03 | Rotation policy | Automated rotation on schedule | Manual rotation "when someone remembers" |
| SEC-04 | Audit trail on secret access | Every read/write logged | No visibility into who accessed which secret |
| SEC-05 | No secrets in CI/CD artifacts | Injected at runtime, not baked into images | Secrets in Docker layers, build logs, or artifacts |
| SEC-06 | Secret sprawl prevention | Scanning for secrets in repos (pre-commit hooks) | No detection of accidentally committed secrets |

## 5. Logging, Monitoring & Detection

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| LOG-01 | Centralized log aggregation | All services ship to central platform | Logs on local disk only |
| LOG-02 | Security events defined | Auth failures, privilege changes, data access logged | Only application errors logged |
| LOG-03 | Tamper-proof storage | Immutable log storage (WORM, append-only) | Logs modifiable by compromised service |
| LOG-04 | Alerting on security events | Real-time alerts for critical events | Logs collected but never reviewed |
| LOG-05 | Correlation capability | SIEM or equivalent for cross-service correlation | Per-service dashboards only |
| LOG-06 | Retention meets regulatory requirements | ≥12 months typically, varies by framework | 30-day default, no policy |
| LOG-07 | No sensitive data in logs | PII/secrets masked before logging | Full request/response bodies in logs |
| LOG-08 | Distributed tracing | Request ID propagated across services | No way to trace a request through the system |

## 6. Resilience & Availability

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| RES-01 | No SPOF in security path | Redundant IdP, KMS, SIEM | Single IdP — auth outage = total outage |
| RES-02 | Fail-closed design | Security controls fail to deny, not allow | Fail-open — outage bypasses security |
| RES-03 | Circuit breakers | External dependency failures isolated | Cascading failure through dependency chain |
| RES-04 | Rate limiting | Per-service and per-endpoint | No throttling — DoS trivial |
| RES-05 | Graceful degradation plan | Defined behavior when components fail | Undefined failure modes |
| RES-06 | DR plan for security components | IdP, KMS, SIEM have DR | Only business services have DR |
| RES-07 | Chaos/resilience testing | Regular failure injection | Resilience assumed, never tested |

## 7. Container & Orchestration (if applicable)

| # | Check | Expected | Anti-pattern if missing |
|---|-------|----------|----------------------|
| CTR-01 | Minimal base images | Distroless or Alpine, pinned by digest | Full OS images with unnecessary packages |
| CTR-02 | Non-root execution | All containers run as non-root | Root containers (default) |
| CTR-03 | Read-only root filesystem | `readOnlyRootFilesystem: true` | Writable container filesystem |
| CTR-04 | Resource limits | CPU + memory limits set | No limits — single container can starve node |
| CTR-05 | Network policies | Default-deny, explicit allow | All pods can reach all pods |
| CTR-06 | Image signing + admission | Only verified images deployed | Any image from any registry accepted |
| CTR-07 | Secrets via CSI or operator | Mounted at runtime from vault | Secrets in environment variables |
| CTR-08 | Pod security standards | Restricted profile (K8s PSS) | Privileged pods allowed |
| CTR-09 | Runtime security monitoring | Falco, Sysdig, or equivalent | No runtime visibility |

## 8. Sector-Specific Checks

### Telco / 5G
| # | Check | Reference |
|---|-------|-----------|
| TEL-01 | Network function (NF) isolation — each NF in separate security domain | 3GPP TS 33.501 |
| TEL-02 | Signaling security — Diameter/SS7 firewalling, GTP-C filtering | GSMA FS.19, FS.07 |
| TEL-03 | MEC (Multi-access Edge) trust — edge applications sandboxed from core | ETSI MEC 003 |
| TEL-04 | Network slicing isolation — slice-level security policy enforcement | 3GPP TS 33.811 |
| TEL-05 | NFVi hardening — hypervisor, container runtime, and host OS hardened | ETSI NFV-SEC |
| TEL-06 | NESAS compliance — network equipment vendor security assessment | GSMA NESAS |

### Banking / Insurance
| # | Check | Reference |
|---|-------|-----------|
| FIN-01 | Transaction integrity — end-to-end non-repudiation for financial transactions | PSD2, DORA Art. 7 |
| FIN-02 | HSM integration — cryptographic operations in certified hardware | PCI DSS, DORA Art. 9 |
| FIN-03 | Open Banking API security — PSD2/Berlin Group/UK OB spec compliance | PSD2 RTS on SCA |
| FIN-04 | Data residency — processing within regulatory jurisdiction | GDPR, local banking law |
| FIN-05 | SWIFT CSP — Customer Security Programme compliance for SWIFT-connected systems | SWIFT CSCF |

### Automotive
| # | Check | Reference |
|---|-------|-----------|
| AUT-01 | Secure boot chain — from bootloader to application | UNECE R155/R156 |
| AUT-02 | OTA update integrity — signed updates with rollback protection | ISO/SAE 21434 |
| AUT-03 | ECU isolation — in-vehicle network segmentation (CAN/Ethernet gateway) | ISO/SAE 21434 |
| AUT-04 | V2X trust — vehicle-to-everything certificate management | IEEE 1609.2 |

### IoT / Consumer Devices
| # | Check | Reference |
|---|-------|-----------|
| IOT-01 | No universal default passwords | ETSI EN 303 645 §5.1 |
| IOT-02 | Secure update mechanism | ETSI EN 303 645 §5.3 |
| IOT-03 | Minimal attack surface — unused ports/services disabled | ETSI EN 303 645 §5.6 |
| IOT-04 | Secure communication — TLS or equivalent for all external comms | ETSI EN 303 645 §5.5 |
| IOT-05 | Data minimization — collect only what's needed | ETSI EN 303 645 §5.8 |

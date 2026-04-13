# STRIDE Per Element Reference

Apply STRIDE categories based on the DFD element type. Not all categories apply to all elements.

## Applicability Matrix

| STRIDE Category | External Entity | Process | Data Store | Data Flow |
|---|---|---|---|---|
| **Spoofing** | ✅ | ✅ | — | — |
| **Tampering** | — | ✅ | ✅ | ✅ |
| **Repudiation** | ✅ | ✅ | — | — |
| **Information Disclosure** | — | ✅ | ✅ | ✅ |
| **Denial of Service** | — | ✅ | ✅ | ✅ |
| **Elevation of Privilege** | — | ✅ | — | — |

## Per-Element Threat Questions

### External Entity (Users, Services, Third Parties)
- **Spoofing:** Can someone impersonate this entity? Is authentication enforced? Is MFA required?
  What credential types are accepted? Can credentials be replayed?
- **Repudiation:** Can this entity deny performing an action? Are actions logged with identity?
  Are logs tamper-proof?

### Process (Application Logic, APIs, Microservices)
- **Spoofing:** Can the process identity be forged? Are service-to-service calls authenticated?
  Is mTLS or API key validation in place?
- **Tampering:** Can input be manipulated to change behavior? Are inputs validated? Can
  configuration be modified at runtime?
- **Repudiation:** Are all state-changing operations logged? Do logs include actor identity,
  timestamp, and action?
- **Information Disclosure:** Does the process expose sensitive data in errors, logs, or responses?
  Are debug endpoints disabled in production?
- **Denial of Service:** Can the process be overwhelmed? Are rate limits, timeouts, and circuit
  breakers in place? Are resource limits configured?
- **Elevation of Privilege:** Can a user gain admin access? Is authorization checked at every
  decision point (not just at the entry)? Are roles enforced server-side?

### Data Store (Databases, File Systems, Caches, Object Storage)
- **Tampering:** Can stored data be modified without authorization? Are writes gated by access
  control? Is referential integrity enforced?
- **Information Disclosure:** Is data encrypted at rest? Are backups encrypted? Can queries
  return more data than authorized? Are connection strings/credentials secured?
- **Denial of Service:** Can the store be filled to capacity? Are storage quotas configured?
  Can expensive queries lock resources?

### Data Flow (Network Connections, API Calls, File Transfers)
- **Tampering:** Can data be modified in transit? Is TLS enforced? Is certificate pinning used?
  Are checksums validated?
- **Information Disclosure:** Is data encrypted in transit? Can an observer read the payload?
  Are sensitive fields masked in transit logs?
- **Denial of Service:** Can the channel be saturated? Are bandwidth limits configured? Can
  connections be exhausted?

## MITRE ATT&CK Mapping by STRIDE Category

| STRIDE | Common ATT&CK Techniques |
|---|---|
| Spoofing | T1078 (Valid Accounts), T1134 (Token Manipulation), T1557 (AitM) |
| Tampering | T1565 (Data Manipulation), T1027 (Obfuscated Files), T1195 (Supply Chain) |
| Repudiation | T1070 (Indicator Removal), T1036 (Masquerading) |
| Info Disclosure | T1005 (Data from Local System), T1039 (Network Shared Drive), T1567 (Exfiltration) |
| Denial of Service | T1498 (Network DoS), T1499 (Endpoint DoS), T1489 (Service Stop) |
| Elevation of Privilege | T1068 (Exploitation for Priv Esc), T1548 (Abuse Elevation Control) |

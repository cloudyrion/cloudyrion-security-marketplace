# Domain-Specific Risk Guidance

## Network Security
1. Unencrypted data in transit on public networks (T1557, T1040)
2. Flat network enabling lateral movement (T1570, T1021)
3. Exposed management interfaces (SSH/RDP/SNMP) (T1021, T1133)
4. Missing network monitoring/IDS (T1040, T1046)
5. DNS poisoning/hijacking (T1071.004, T1568)

## Application Security
1. Injection flaws (SQL, command, LDAP) in public APIs (T1190, T1059)
2. Broken authentication (weak passwords, no MFA, session flaws) (T1078, T1110)
3. Sensitive data exposure in API responses/logs (T1005, T1530)
4. Insecure deserialization (T1059, T1203)
5. Supply chain compromise via dependencies (T1195.001, T1195.002)

## Cloud Security (AWS/Azure/GCP)
1. Overprivileged IAM roles/policies (T1078.004, T1580)
2. Public storage buckets with sensitive data (T1530, T1537)
3. Missing encryption at rest for regulated data (T1005, T1565)
4. Container/serverless escape to host (T1611, T1068)
5. Cloud metadata SSRF for credential theft (T1552.005, T1078.004)

## Identity & Access Management
1. No MFA on privileged accounts (T1078, T1110)
2. Shared/default credentials across environments (T1078.001, T1552)
3. Stale accounts with active permissions (T1078, T1098)
4. Missing privileged access monitoring (T1078, T1098)
5. Inadequate service account lifecycle management (T1078.004, T1552.001)

## Data Protection
1. Unencrypted PII at rest in databases (T1005, T1565)
2. Inadequate backup encryption/access control (T1490, T1486)
3. Missing data classification leading to overexposure (T1005, T1039)
4. Cross-border data transfer without adequacy (T1567, T1537)
5. Insufficient data retention/deletion controls (T1005, T1565)

## OT/ICS Security
1. IT/OT network convergence without segmentation (T1570, T0886)
2. Legacy protocols without authentication (Modbus, DNP3) (T0855, T0869)
3. Unpatched HMI/SCADA systems (T0890, T1210)
4. Remote access without jump server/MFA (T1133, T0886)
5. Missing OT-specific monitoring (T0801, T0856)

## AI/ML Security
1. Training data poisoning (T1565, AML.T0020)
2. Model extraction via API probing (T1005, AML.T0024)
3. Prompt injection in LLM applications (T1059, AML.T0051)
4. Adversarial inputs bypassing classifiers (AML.T0015, AML.T0043)
5. PII leakage through model memorization (T1005, AML.T0024)

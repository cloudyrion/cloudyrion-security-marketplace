# Attack Techniques by Component Type

## 1. Web Application

| Technique | MITRE ATT&CK | OWASP | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|-------|---------------|-----------------|
| SQL Injection | T1190 | WSTG-INPV-05, A03 | `sqlmap -u URL --dbs`, `burp repeater` | Input reaches SQL query | DB data extracted |
| XSS (Reflected) | T1189 | WSTG-INPV-01, A03 | `dalfox url URL`, `burp intruder` | Input reflected in response | JS executes in victim browser |
| XSS (Stored) | T1189 | WSTG-INPV-02, A03 | Manual payload injection, `burp` | Input stored and rendered | JS executes for other users |
| SSTI | T1059 | WSTG-INPV-18, A03 | `tplmap -u URL`, `{{7*7}}` probe | Template engine processes input | RCE or data leak |
| Path Traversal | T1005 | WSTG-ATHZ-01, A01 | `curl "URL/../../etc/passwd"`, `dotdotpwn` | File path from user input | Arbitrary file read |
| Open Redirect | T1566.002 | WSTG-CLNT-04, A01 | `curl -v "URL?redirect=https://evil.com"` | Redirect URL from user input | Victim redirected to attacker site |
| CSRF | T1185 | WSTG-SESS-05, A01 | Craft HTML form, `burp CSRF PoC generator` | No CSRF token or SameSite | State-changing action without consent |
| Command Injection | T1059 | WSTG-INPV-12, A03 | `commix -u URL`, `curl "URL;id"` | Input reaches shell command | Command output or reverse shell |
| Insecure Deserialization | T1059 | WSTG-INPV-16, A08 | `ysoserial`, `pickle exploit` | App deserializes user data | RCE |
| File Upload Bypass | T1505.003 | WSTG-BUSL-08, A04 | `burp` content-type manipulation | File upload with type check | Webshell uploaded and executed |

### Detection Indicators (Web)
- WAF/IDS alerts for injection patterns
- Anomalous response sizes or status codes
- Unusual file access patterns in server logs
- Unexpected outbound connections from web server

---

## 2. API

| Technique | MITRE ATT&CK | OWASP API | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-----------|-------|---------------|-----------------|
| BOLA (IDOR) | T1078 | API1 | `burp` — change ID in request | Predictable object IDs | Access other users' data |
| Broken Auth | T1078, T1110 | API2 | `hydra`, `jwt_tool`, `burp intruder` | Login endpoint exposed | Valid credentials or token |
| Excessive Data | T1005 | API3 | `curl` + `jq` response analysis | API returns full objects | Internal fields leaked |
| Mass Assignment | T1565 | API6 | `curl -X PUT -d '{"is_admin":true}'` | Object properties accepted blindly | Privilege escalation |
| SSRF | T1090 | API7 | `curl "URL?fetch=http://169.254.169.254"` | Server fetches user-supplied URL | Internal service access |
| Rate Limit Bypass | T1110 | API4 | `ffuf`, `turbo intruder` | No or weak rate limiting | Brute force succeeds |
| GraphQL Introspection | T1592 | API3 | `graphql-cop`, `clairvoyance` | Introspection enabled in prod | Full schema exposed |

---

## 3. Authentication / Identity

| Technique | MITRE ATT&CK | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|---------------|-----------------|
| Credential Stuffing | T1110.004 | `hydra -L users.txt -P passwords.txt` | Leaked credential lists | Valid login obtained |
| Password Spraying | T1110.003 | `sprayhound`, `kerbrute` | Username list | Account compromise without lockout |
| JWT alg:none | T1134 | `jwt_tool -t TOKEN -X a` | JWT auth, no alg validation | Forged token accepted |
| JWT key confusion | T1134 | `jwt_tool -t TOKEN -X k -pk public.pem` | RS256→HS256 confusion | Admin token forged |
| Session Fixation | T1539 | `burp` — set session cookie before auth | App accepts pre-set session IDs | Session hijack |
| MFA Bypass | T1111 | `evilginx2`, response manipulation | MFA enabled but bypassable | Authenticated without valid MFA |
| OAuth Token Theft | T1528 | `burp` redirect_uri manipulation | OAuth flow with open redirect | Access token stolen |

---

## 4. Network / Infrastructure

| Technique | MITRE ATT&CK | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|---------------|-----------------|
| Port Scanning | T1046 | `nmap -sV -p- TARGET` | Network access | Service map obtained |
| Service Fingerprint | T1592.002 | `nmap -sV --version-all`, `whatweb` | Open ports found | Exact versions identified |
| ARP Spoofing | T1557.002 | `arpspoof`, `ettercap` | Same network segment | Traffic intercepted |
| DNS Poisoning | T1557.001 | `dnsspoof`, `responder` | Network access | DNS responses spoofed |
| SNMP Enumeration | T1602 | `snmpwalk -v2c -c public TARGET` | SNMP exposed | Config/creds extracted |
| SMB Relay | T1557.001 | `ntlmrelayx`, `responder` | SMB signing disabled | Auth relayed to target |
| SSH Brute Force | T1110 | `hydra -l root -P wordlist.txt ssh://TARGET` | SSH port open | Shell access |

---

## 5. Cloud (AWS / Azure / GCP)

| Technique | MITRE ATT&CK | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|---------------|-----------------|
| Public S3 Bucket | T1530 | `aws s3 ls s3://BUCKET --no-sign-request` | Bucket name known | Data downloaded |
| IMDS Credential Theft | T1552.005 | `curl http://169.254.169.254/latest/meta-data/iam/` | SSRF or instance access | IAM credentials extracted |
| Overprivileged IAM | T1078.004 | `enumerate-iam`, `Pacu` | Valid AWS creds | Privilege escalation path found |
| Lambda Code Injection | T1059 | Modify Lambda env vars via API | Lambda write access | Code execution in Lambda |
| Azure Managed Identity | T1552.005 | `curl $IDENTITY_ENDPOINT` | Code exec on Azure resource | Token for other services |
| GCP Metadata | T1552.005 | `curl -H "Metadata-Flavor: Google" http://metadata.google/...` | SSRF or instance access | Service account token |

---

## 6. Container / Kubernetes

| Technique | MITRE ATT&CK | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|---------------|-----------------|
| Container Escape | T1611 | `deepce`, privileged mount abuse | Privileged container or caps | Host filesystem access |
| K8s API Abuse | T1609 | `kubectl` with stolen token | Service account token | Cluster-wide access |
| Image Vulnerability | T1195.002 | `trivy image IMAGE`, `grype` | Access to image | Known CVEs identified |
| Etcd Access | T1552 | `etcdctl get / --prefix` | Network access to etcd | Secrets extracted |
| Pod Escape via hostPID | T1611 | `nsenter --target 1 --mount --uts --ipc --net --pid` | hostPID: true | Host namespace access |

---

## 7. CI/CD Pipeline

| Technique | MITRE ATT&CK | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|---------------|-----------------|
| Poisoned Pipeline | T1195.002 | Modify workflow file in PR | Write access to repo | Secrets exfiltrated in CI |
| Secret Extraction | T1552.001 | `echo $SECRET` in build step | CI job execution | Secrets printed to logs |
| Dependency Confusion | T1195.001 | Publish typosquatted package | Target uses private + public registry | Malicious code installed |
| Build Artifact Tampering | T1565 | Replace artifact in storage | Write access to artifact store | Tampered binary deployed |

---

## 8. Social Engineering

| Technique | MITRE ATT&CK | Tools | Prerequisites | Success Criteria |
|-----------|-------------|-------|---------------|-----------------|
| Spearphishing Link | T1566.002 | `gophish`, custom landing page | Target email addresses | Credentials harvested |
| Spearphishing Attachment | T1566.001 | `msfvenom` payload + macro doc | Target email addresses | Payload executed |
| Vishing (Voice) | T1566.004 | Caller ID spoofing, pretext script | Phone numbers | Information disclosed |
| USB Drop | T1091 | `rubber ducky`, `bash bunny` | Physical proximity | Payload executed |

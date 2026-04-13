# MITRE ATT&CK Mapping Guide

## Rules
1. Map 3-6 techniques per risk — cover multiple tactics
2. Include technique ID + name
3. Prefer specific sub-techniques (T1078.004) over parent (T1078) when applicable
4. Map to techniques the risk's mitigations defend against

## Common Mappings by Domain

### Application Security
| Risk Pattern | Techniques |
|-------------|-----------|
| SQL/Command Injection | T1190 Exploit Public-Facing App, T1059 Command Scripting |
| Broken Auth | T1078 Valid Accounts, T1110 Brute Force, T1539 Steal Web Session |
| XSS | T1189 Drive-by Compromise, T1059.007 JavaScript |
| SSRF | T1090 Proxy, T1018 Remote System Discovery |
| Deserialization | T1059 Command Scripting, T1203 Exploitation for Client Exec |

### Cloud Security
| Risk Pattern | Techniques |
|-------------|-----------|
| Overprivileged IAM | T1078.004 Cloud Accounts, T1580 Cloud Infra Discovery |
| Public S3/Storage | T1530 Data from Cloud Storage, T1537 Transfer to Cloud |
| Metadata SSRF | T1552.005 Cloud Instance Metadata, T1078.004 Cloud Accounts |
| Container Escape | T1611 Escape to Host, T1068 Exploitation for Priv Esc |

### Network Security
| Risk Pattern | Techniques |
|-------------|-----------|
| Unencrypted Transit | T1557 Adversary-in-the-Middle, T1040 Network Sniffing |
| Open Management Ports | T1021 Remote Services, T1133 External Remote Services |
| No Segmentation | T1570 Lateral Tool Transfer, T1021 Remote Services |
| DNS Attacks | T1071.004 DNS Protocol, T1568 Dynamic Resolution |

### Identity & Access
| Risk Pattern | Techniques |
|-------------|-----------|
| No MFA | T1078 Valid Accounts, T1110 Brute Force |
| Shared Credentials | T1078.001 Default Accounts, T1552.001 Credentials in Files |
| Stale Accounts | T1078 Valid Accounts, T1098 Account Manipulation |

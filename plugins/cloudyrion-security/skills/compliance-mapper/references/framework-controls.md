# Framework Controls Cross-Reference

Key security control domains mapped across major frameworks. Use this as the starting point
for control-to-requirement mapping. Not exhaustive — extend based on the specific scope.

---

## Access Control & Authentication

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Access control policy | A.5.15 | Art. 21(2)(i) | Art. 9(4) | CC6.1 | Art. 32(1)(b) | PR.AA-01 | ORP.4 | — |
| MFA / strong auth | A.8.5 | Art. 21(2)(j) | Art. 9(4)(c) | CC6.1 | — | PR.AA-03 | ORP.4.A22 | — |
| Privileged access mgmt | A.8.2 | Art. 21(2)(i) | Art. 9(4)(b) | CC6.3 | — | PR.AA-05 | ORP.4.A3 | — |
| Identity lifecycle | A.5.16, A.5.18 | Art. 21(2)(i) | Art. 9(4) | CC6.2 | — | PR.AA-01 | ORP.4.A1 | — |

## Cryptography & Data Protection

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Encryption at rest | A.8.24 | Art. 21(2)(h) | Art. 9(2) | CC6.1 | Art. 32(1)(a) | PR.DS-01 | CON.1 | Annex I §2(d) |
| Encryption in transit | A.8.24 | Art. 21(2)(h) | Art. 9(2) | CC6.6 | Art. 32(1)(a) | PR.DS-02 | CON.1 | Annex I §2(d) |
| Key management | A.8.24 | Art. 21(2)(h) | Art. 9(2) | CC6.1 | — | PR.DS-01 | CON.1.A6 | — |
| Data classification | A.5.12, A.5.13 | — | Art. 9(1) | CC6.5 | Art. 25 | ID.AM-08 | CON.1.A1 | — |

## Vulnerability Management

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Vulnerability scanning | A.8.8 | Art. 21(2)(e) | Art. 8(3) | CC7.1 | Art. 32(1)(d) | ID.RA-01 | OPS.1.1.3 | Annex I §2(b) |
| Patch management | A.8.8, A.8.19 | Art. 21(2)(e) | Art. 8(2) | CC7.1 | — | PR.PS-02 | OPS.1.1.3.A15 | Annex I §2(b) |
| Penetration testing | A.8.8 | Art. 21(2)(e) | Art. 26 | CC4.1 | — | ID.RA-01 | DER.3.1 | — |
| Secure development | A.8.25, A.8.28 | Art. 21(2)(e) | Art. 8(1) | CC8.1 | Art. 25 | PR.PS-06 | CON.8 | Annex I §1 |
| SBOM / component inventory | — | Art. 21(2)(d) | — | — | — | ID.AM-02 | — | Annex I §1(a) |

## Incident Response & Continuity

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Incident response plan | A.5.24, A.5.26 | Art. 21(2)(b) | Art. 17 | CC7.3, CC7.4 | Art. 33 | RS.MA-01 | DER.2.1 | Annex I §2(g) |
| Incident notification | A.5.24 | Art. 23 (24h/72h) | Art. 19 (4h/72h) | CC7.3 | Art. 33 (72h) | RS.CO-02 | DER.2.1.A6 | Art. 14 |
| Business continuity | A.5.29, A.5.30 | Art. 21(2)(c) | Art. 11 | A1.2 | — | RC.RP-01 | DER.4 | — |
| Backup & recovery | A.8.13 | Art. 21(2)(c) | Art. 12 | A1.2 | Art. 32(1)(c) | PR.PS-04 | CON.3 | — |
| Disaster recovery | A.5.30 | Art. 21(2)(c) | Art. 11(6) | A1.3 | — | RC.RP-04 | DER.4.A8 | — |

## Supply Chain & Third Parties

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Supplier security assessment | A.5.19, A.5.21 | Art. 21(2)(d) | Art. 28 | CC9.2 | Art. 28 | GV.SC-06 | OPS.2.1 | — |
| Third-party risk monitoring | A.5.22 | Art. 21(2)(d) | Art. 28(2) | CC9.2 | Art. 28(3)(h) | GV.SC-07 | OPS.2.1.A10 | — |
| Supply chain security | A.5.21 | Art. 21(2)(d) | Art. 28 | — | — | GV.SC-01 | — | Annex I §2(e) |

## Logging & Monitoring

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Audit logging | A.8.15 | Art. 21(2)(g) | Art. 10 | CC7.2 | Art. 32(1)(d) | DE.CM-09 | OPS.1.1.5 | Annex I §2(f) |
| Log monitoring & alerting | A.8.16 | Art. 21(2)(g) | Art. 10(1) | CC7.2 | — | DE.AE-02 | OPS.1.1.5.A5 | — |
| Log retention | A.8.15 | — | Art. 10(2) | CC7.2 | — | DE.CM-09 | OPS.1.1.5.A6 | — |

## Governance & Risk

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA |
|---|---|---|---|---|---|---|---|---|
| Risk assessment | 6.1, A.5.7 | Art. 21(2)(a) | Art. 6 | CC3.2 | Art. 35 | ID.RA-03 | ISMS.1 | — |
| Security awareness training | A.6.3 | Art. 21(2)(g) | Art. 13(6) | CC1.4 | — | PR.AT-01 | ORP.3 | — |
| Management accountability | 5.1, A.5.1 | Art. 20 | Art. 5(2) | CC1.2 | Art. 5(2) | GV.RR-01 | ISMS.1.A1 | — |
| Policy framework | A.5.1 | Art. 21(1) | Art. 6(8) | CC1.1 | Art. 24 | GV.PO-01 | ISMS.1.A7 | — |

---

## Key Regulatory Deadlines (as of 2025)

| Framework | Key date | Status |
|---|---|---|
| NIS2 | Oct 2024 (transposition); NIS2UmsuCG pending in Germany | Active — enforcement varies by member state |
| DORA | Jan 17, 2025 (application date) | Active |
| EU CRA | Published Dec 2024; vulnerability handling obligations from Sep 2026; full application 2027 | Transition |
| ISO 27001:2022 | Transition from 2013 by Oct 31, 2025 | Active |
| GDPR | Active since May 2018 | Active |

# Framework Controls Cross-Reference

Key security control domains mapped across major frameworks. Use this as the starting point
for control-to-requirement mapping. Not exhaustive — extend based on the specific scope.

---

## Access Control & Authentication

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Access control policy | A.5.15 | Art. 21(2)(i) | Art. 9(4) | CC6.1 | Art. 32(1)(b) | PR.AA-01 | ORP.4 | — | V4 Access Control |
| MFA / strong auth | A.8.5 | Art. 21(2)(j) | Art. 9(4)(c) | CC6.1 | — | PR.AA-03 | ORP.4.A22 | — | V2 Authentication |
| Privileged access mgmt | A.8.2 | Art. 21(2)(i) | Art. 9(4)(b) | CC6.3 | — | PR.AA-05 | ORP.4.A3 | — | V4 Access Control |
| Identity lifecycle | A.5.16, A.5.18 | Art. 21(2)(i) | Art. 9(4) | CC6.2 | — | PR.AA-01 | ORP.4.A1 | — | V2 Authentication, V3 Session Management |

## Cryptography & Data Protection

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Encryption at rest | A.8.24 | Art. 21(2)(h) | Art. 9(2) | CC6.1 | Art. 32(1)(a) | PR.DS-01 | CON.1 | Annex I §2(d) | V6 Cryptography, V8 Data Protection |
| Encryption in transit | A.8.24 | Art. 21(2)(h) | Art. 9(2) | CC6.6 | Art. 32(1)(a) | PR.DS-02 | CON.1 | Annex I §2(d) | V9 Communications |
| Key management | A.8.24 | Art. 21(2)(h) | Art. 9(2) | CC6.1 | — | PR.DS-01 | CON.1.A6 | — | V6 Cryptography |
| Data classification | A.5.12, A.5.13 | — | Art. 9(1) | CC6.5 | Art. 25 | ID.AM-08 | CON.1.A1 | — | V8 Data Protection |

## Vulnerability Management

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Vulnerability scanning | A.8.8 | Art. 21(2)(e) | Art. 8(3) | CC7.1 | Art. 32(1)(d) | ID.RA-01 | OPS.1.1.3 | Annex I §2(b) | V1 Encoding & Sanitization (general) |
| Patch management | A.8.8, A.8.19 | Art. 21(2)(e) | Art. 8(2) | CC7.1 | — | PR.PS-02 | OPS.1.1.3.A15 | Annex I §2(b) | V14 Configuration |
| Penetration testing | A.8.8 | Art. 21(2)(e) | Art. 26 | CC4.1 | — | ID.RA-01 | DER.3.1 | — | — (verification activity) |
| Secure development | A.8.25, A.8.28 | Art. 21(2)(e) | Art. 8(1) | CC8.1 | Art. 25 | PR.PS-06 | CON.8 | Annex I §1 | V1 Encoding & Sanitization, V14 Configuration |
| SBOM / component inventory | — | Art. 21(2)(d) | — | — | — | ID.AM-02 | — | Annex I §1(a) | V14 Configuration |

## Incident Response & Continuity

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Incident response plan | A.5.24, A.5.26 | Art. 21(2)(b) | Art. 17 | CC7.3, CC7.4 | Art. 33 | RS.MA-01 | DER.2.1 | Annex I §2(g) | — (organizational) |
| Incident notification | A.5.24 | Art. 23 (24h/72h) | Art. 19 (4h/72h) | CC7.3 | Art. 33 (72h) | RS.CO-02 | DER.2.1.A6 | Art. 14 | — (organizational) |
| Business continuity | A.5.29, A.5.30 | Art. 21(2)(c) | Art. 11 | A1.2 | — | RC.RP-01 | DER.4 | — | — (organizational) |
| Backup & recovery | A.8.13 | Art. 21(2)(c) | Art. 12 | A1.2 | Art. 32(1)(c) | PR.PS-04 | CON.3 | — | — (organizational) |
| Disaster recovery | A.5.30 | Art. 21(2)(c) | Art. 11(6) | A1.3 | — | RC.RP-04 | DER.4.A8 | — | — (organizational) |

## Supply Chain & Third Parties

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Supplier security assessment | A.5.19, A.5.21 | Art. 21(2)(d) | Art. 28 | CC9.2 | Art. 28 | GV.SC-06 | OPS.2.1 | — | — (organizational) |
| Third-party risk monitoring | A.5.22 | Art. 21(2)(d) | Art. 28(2) | CC9.2 | Art. 28(3)(h) | GV.SC-07 | OPS.2.1.A10 | — | — (organizational) |
| Supply chain security | A.5.21 | Art. 21(2)(d) | Art. 28 | — | — | GV.SC-01 | — | Annex I §2(e) | V14 Configuration |

## Logging & Monitoring

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Audit logging | A.8.15 | Art. 21(2)(g) | Art. 10 | CC7.2 | Art. 32(1)(d) | DE.CM-09 | OPS.1.1.5 | Annex I §2(f) | V7 Logging & Error Handling |
| Log monitoring & alerting | A.8.16 | Art. 21(2)(g) | Art. 10(1) | CC7.2 | — | DE.AE-02 | OPS.1.1.5.A5 | — | V7 Logging & Error Handling |
| Log retention | A.8.15 | — | Art. 10(2) | CC7.2 | — | DE.CM-09 | OPS.1.1.5.A6 | — | V7 Logging & Error Handling |

## Governance & Risk

| Control Domain | ISO 27001:2022 | NIS2 | DORA | SOC 2 | GDPR | NIST CSF 2.0 | BSI Grundschutz | CRA | OWASP ASVS |
|---|---|---|---|---|---|---|---|---|---|
| Risk assessment | 6.1, A.5.7 | Art. 21(2)(a) | Art. 6 | CC3.2 | Art. 35 | ID.RA-03 | ISMS.1 | — | — (organizational) |
| Security awareness training | A.6.3 | Art. 21(2)(g) | Art. 13(6) | CC1.4 | — | PR.AT-01 | ORP.3 | — | — (organizational) |
| Management accountability | 5.1, A.5.1 | Art. 20 | Art. 5(2) | CC1.2 | Art. 5(2) | GV.RR-01 | ISMS.1.A1 | — | — (organizational) |
| Policy framework | A.5.1 | Art. 21(1) | Art. 6(8) | CC1.1 | Art. 24 | GV.PO-01 | ISMS.1.A7 | — | — (organizational) |

---

## Canonical Per-Framework Control Counts

Use these as the authoritative denominators for compliance-coverage percentages and for any
suite dashboard that reports "controls covered / total". Always pair a count with the exact
edition that produces it — control totals change between editions.

| Framework | Edition | Canonical count | What is counted |
|---|---|---|---|
| ISO 27001 | 2022 | 93 | Annex A controls (organized into 4 themes; do NOT use the 2013 figure of 114) |
| NIS2 | Directive (EU) 2022/2555 | 10 | Art. 21(2)(a)–(j) minimum measures (sub-points expand per national transposition) |
| DORA | Regulation (EU) 2022/2554 | 5 | Pillars: ICT risk mgmt, incident reporting, resilience testing, third-party risk, info-sharing (Art.-level requirements expand under the RTS/ITS) |
| SOC 2 | TSC 2017 (rev. 2022) | 64 | Trust Services Criteria points of focus baseline (Security/Common Criteria CC1–CC9 plus A/C/PI/P categories as in scope) |
| GDPR | Regulation (EU) 2016/679 | — | Counted by article in scope (Art. 5, 25, 32–34 most relevant to security); not a fixed control catalogue |
| NIST CSF | 2.0 | 106 | Subcategories across 6 functions (Govern 31, Identify 21, Protect 22, Detect 11, Respond 13, Recover 8) |
| BSI IT-Grundschutz | 2023 Kompendium | ~ varies | Counted by selected building blocks (Bausteine) in scope; not a single fixed total |
| EU CRA | Regulation (EU) 2024/2847 | — | Essential requirements per Annex I (Part I security properties, Part II vulnerability handling) — count by applicable Annex I items |
| OWASP ASVS | 5.0 (2025) | ~350 | Verification requirements across 17 chapters (ASVS 4.0.3 had 286 — cite the edition you use) |

> When a suite or dashboard reports a fixed denominator (e.g. "93/106/350"), it MUST cite this
> table and the edition, not hardcode a number. The older figures 114 (ISO 27001:2013) and 286
> (ASVS 4.0.3) are superseded by 93 (ISO 27001:2022) and ~350 (ASVS 5.0) respectively.

---

## Key Regulatory Deadlines (as of 2025)

| Framework | Key date | Status |
|---|---|---|
| NIS2 | Oct 2024 (transposition); NIS2UmsuCG pending in Germany | Active — enforcement varies by member state |
| DORA | Jan 17, 2025 (application date) | Active |
| EU CRA | Published Dec 2024; vulnerability handling obligations from Sep 2026; full application 2027 | Transition |
| ISO 27001:2022 | Transition from 2013 by Oct 31, 2025 | Active |
| GDPR | Active since May 2018 | Active |

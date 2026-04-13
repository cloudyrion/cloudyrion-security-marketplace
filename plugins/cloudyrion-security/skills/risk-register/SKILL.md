---
description: "Create professional, audit-ready security risk register Excel files for any security domain — network, application, cloud, identity, data protection, OT/ICS, AI/ML, or custom topics. Use this skill whenever the user asks to create, review, quality-check, complete, or extend a security risk register, risk assessment, threat catalogue, control catalogue, or security findings list. Also trigger when the user mentions 'risk register', 'security risks', 'threat catalogue', 'control mapping', 'MITRE ATT&CK mapping', 'compliance mapping', 'NIS2 risks', 'DORA risks', 'NIST mapping', or wants to produce a structured list of security risks with mitigations and standards references. Always use alongside the xlsx skill for Excel file creation mechanics."
---

# Security Risk Register Skill

This skill produces **professional, audit-ready security risk register Excel workbooks** for any security domain. Read this **before** creating any risk register. Use alongside the `xlsx` skill for Excel file creation mechanics (openpyxl).

> **Key principle**: Every risk register produced by this skill must be directly importable into a GRC platform and usable in a client-facing security assessment without further formatting.

---

## Workflow Overview

```
1. SCOPE    → Determine domain, cloud provider, regulatory context, client sector
2. RESEARCH → Web search for current threats, CVEs, frameworks, and regulatory requirements
3. DRAFT    → Build risk entries following the schema in references/risk-schema.md
4. ENRICH   → Add MITRE ATT&CK mappings, standards mappings, evidence requirements
5. QA       → Cross-check for completeness, consistency, and quality issues
6. BUILD    → Generate the Excel workbook using the template in references/excel-template.md
7. PRESENT  → Deliver the file via present_files with a concise summary
```

---

## Step 1: Scope Definition

Before writing any risks, determine the following from the user's request or by asking:

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Domain** | Security area (network, application, cloud, identity, data, OT/ICS, AI/ML, or custom) | Infer from request |
| **Cloud Provider** | AWS, Azure, GCP, multi-cloud, on-premises, hybrid | AWS |
| **Regulatory Context** | Which regulations apply (NIS2, DORA, GDPR, PCI-DSS, HIPAA, SOX, etc.) | NIS2 + DORA |
| **Client Sectors** | Industry verticals (banking, telco, insurance, healthcare, critical infra, etc.) | General |
| **Existing Risks** | User-provided draft or existing register to quality-check/extend | None |
| **ID Prefix** | Prefix for risk IDs (e.g., NR for network, GR for general, CR for cloud) | Auto from domain |

If the user provides an existing draft, switch to **QA mode** (see Step 5 below).

---

## Step 2: Research

**Always research before writing risks.** Use web search to gather:

- Current threat landscape for the domain (latest CVEs, APT campaigns, breach reports)
- Latest framework versions (MITRE ATT&CK, NIST 800-53, CIS Controls)
- Regulatory updates (NIS2 implementation, DORA RTS, sector-specific requirements)
- Cloud provider security best practices and service updates

Research ensures risks reflect the **current threat landscape**, not outdated training data.

---

## Step 3: Draft Risk Entries

Read `references/risk-schema.md` for the **exact field definitions and quality standards** for each risk entry.

### Risk Structure (mandatory fields)

Every risk entry MUST have ALL of these fields populated:

1. **ID** — Unique identifier with domain prefix (e.g., NR-1, GR-5, CR-12)
2. **Area** — Security domain/category
3. **Risk Title** — Concise, descriptive (4-8 words)
4. **Risk Description** — Structured: threat agent + vulnerability + technical impact + business impact
5. **MITRE ATT&CK Mapping** — Tactic: Technique ID – Technique Name (3-6 techniques per risk)
6. **Proposed Mitigation [Short-term]** — Actionable steps implementable within 0-90 days
7. **Proposed Mitigation [Long-term]** — Strategic improvements for 3-12 month horizon
8. **Standards Mapping** — NIST 800-53 + CIS Controls + ISO 27001 + applicable regulations
9. **Evidence Required** — What an auditor would need to see
10. **Comments** — Cross-references, context, urgency notes

### Tiering (for new registers)

Group risks into priority tiers:

| Tier | Label | Implementation Horizon | Color Code |
|------|-------|----------------------|------------|
| Existing | Existing (blue) | Already documented | `E3F2FD` |
| Tier 1 | Critical (red/pink) | 0-90 days | `FCE4EC` |
| Tier 2 | High (orange) | 3-6 months | `FFF3E0` |
| Tier 3 | Emerging (green) | 6-12 months / roadmap | `E8F5E9` |

For area-based categorization (alternative to tiering), use the color palette in `references/excel-template.md`.

---

## Step 4: Enrich with MITRE ATT&CK

Read `references/mitre-mapping-guide.md` for detailed mapping rules.

### Quick Reference — Mapping Rules

- Map each risk to **3-6 ATT&CK techniques** that the risk's controls defend against
- Format: `Tactic: TechniquID – Technique Name`
- Use the **latest ATT&CK version** (search to confirm current version)
- Prefer sub-techniques where applicable (e.g., T1021.004 over T1021)
- Include techniques across **multiple tactics** to show defense-in-depth coverage
- Create a **reverse-lookup sheet** (Technique → Risk IDs) for the MITRE ATT&CK Mapping tab

### Standards Mapping Rules

Map each risk against ALL applicable frameworks:

| Framework | Format | Example |
|-----------|--------|---------|
| NIST 800-53 | Control family + number | SC-7, AC-4 |
| CIS Controls v8 | Control number | 12.2, 13.4 |
| ISO 27001 | Annex A control | A.8.22 |
| NIS2 | Article reference | Art.21(2)(a) |
| DORA | Article reference | Art.8, Art.11 |
| BSI IT-Grundschutz | Module reference | NET.1.1 |
| PCI-DSS | Requirement number | Req 1.3 |
| OWASP | Top 10 / ASVS reference | A05:2021, ASVS V9 |

Only include frameworks relevant to the scoped regulatory context.

---

## Step 5: Quality Assurance

### For new registers
- Verify all 10 fields are populated for every risk
- Check for duplicate/overlapping risks — merge or cross-reference
- Ensure risk descriptions follow the threat agent → vulnerability → impact structure
- Validate MITRE technique IDs are real and current
- Confirm standards references are accurate

### For QA of existing drafts (QA Mode)

When the user provides an existing register to quality-check, produce a **QA Summary sheet** documenting every change:

| QA Status | Meaning | Color |
|-----------|---------|-------|
| ENHANCED | Improved description, mitigations, or mappings | Green `E8F5E9` |
| ENHANCED + FIX | Corrected an error (e.g., wrong reference, copy-paste) | Orange `FFF3E0` |
| FULLY AUTHORED | Original was empty or stub — written from scratch | Red `FCE4EC` |
| NEW RISK | Risk not in original — added to fill critical gap | Red `FCE4EC` |

#### QA Checklist for existing drafts:
- [ ] All fields populated? (flag empty fields)
- [ ] Descriptions have threat agent + vulnerability + impact? (not just vulnerability)
- [ ] Vendor-specific references generalized for reuse? (e.g., "Vodafone policy" → "organizational policy")
- [ ] Short-term vs. long-term mitigations separated?
- [ ] Standards mappings present and accurate?
- [ ] MITRE ATT&CK mappings present?
- [ ] Evidence requirements defined?
- [ ] Copy-paste errors? (common: wrong policy referenced, duplicate content)
- [ ] Cross-references to companion registers established?
- [ ] Critical gap risks missing? (identify and add as NEW RISK)

---

## Step 6: Build Excel Workbook

Read `references/excel-template.md` for the **exact Excel formatting specification**.

### Required Sheets

Every risk register workbook MUST contain these sheets:

| Sheet # | Name | Purpose |
|---------|------|---------|
| 1 | **[Domain] Security Risk Register** | Main register with all risk entries |
| 2 | **MITRE ATT&CK Mapping** | Reverse-lookup: Technique → Risk IDs, color-coded by tactic |
| 3 | **Standards Coverage Matrix** | Risk × Framework coverage grid |
| 4 | **Legend** | Color codes, ATT&CK version, companion document references |

If QA mode: add **QA Summary** sheet (Sheet 3, shifting others down).

### Excel Construction Rules

- **Use openpyxl** (not pandas) for full formatting control
- **Font**: Arial throughout (11pt headers, 10pt body)
- **Header row**: Dark navy (`1B2A4A`) background, white bold text, wrap text, 40px height
- **Data rows**: Color-coded by tier/area, wrap text, ~165px height, thin gray borders (`BDBDBD`)
- **Freeze panes**: Freeze header row + first identifying columns
- **Auto-filter**: Enable on all columns
- **Bold**: Risk title column always bold
- **Column widths**: Set explicitly per column (no auto-width)
- Save to the project's `security-review/` directory, or current working directory if no project

---

## Step 7: Present to User

After generating the file:

1. Call `present_files` to deliver the Excel
2. Provide a **concise summary** covering:
   - Total number of risks
   - Sheet overview (what's in each tab)
   - Key highlights (most critical risks, notable gaps filled, QA findings if applicable)
   - Any cross-references to companion registers
3. Do NOT write a lengthy walkthrough of every risk — the user can read the file

---

## Domain-Specific Guidance

Read the relevant section in `references/domain-guides.md` when creating registers for specific domains:

| Domain | ID Prefix | Key Frameworks | Typical Risk Count |
|--------|-----------|---------------|-------------------|
| Network Security | NR | NIST SC/AC, CIS 9/12/13, BSI NET | 20-30 |
| Application Security | AR | OWASP Top 10, OWASP ASVS, NIST SA, CIS 16 | 15-25 |
| Cloud Security (AWS) | CR | CIS AWS Benchmark, AWS Well-Architected, NIST SC | 20-30 |
| Cloud Security (Azure) | CR | CIS Azure Benchmark, Azure Well-Architected | 20-30 |
| Identity & Access | IR | NIST AC/IA, CIS 5/6, ISO A.5.15-18 | 12-20 |
| Data Protection | DR | NIST SC-28, GDPR, ISO A.8.10-12 | 10-18 |
| Security Operations | OR | NIST IR/AU/SI, CIS 8/13/17, DORA Art.10-19 | 12-20 |
| OT/ICS Security | OT | IEC 62443, NIST SP 800-82, MITRE ATT&CK for ICS | 15-25 |
| AI/ML Security | AI | OWASP ML Top 10, NIST AI RMF, EU AI Act | 12-20 |
| General / Combined | GR | All applicable | 15-25 |

---

## Common Pitfalls to Avoid

1. **Don't skip research** — Risks based solely on training data miss recent CVEs and regulatory changes
2. **Don't leave fields empty** — Every cell must have meaningful content; "N/A" only if genuinely not applicable
3. **Don't use generic descriptions** — "This is a risk" is not a description; include threat agent, vulnerability, and impact
4. **Don't duplicate across registers** — Cross-reference companion registers instead
5. **Don't hardcode vendor names** — Generalize for reuse unless the user specifically requests vendor-specific content
6. **Don't forget the QA sheet** — When quality-checking existing drafts, always document changes
7. **Don't skip MITRE mappings** — They are mandatory, not optional
8. **Don't use outdated framework versions** — Search to confirm current MITRE ATT&CK, CIS Controls, NIST versions

# Excel Workbook Template

## Sheet 1: [Domain] Security Risk Register

| Column | Header | Width | Format |
|--------|--------|-------|--------|
| A | Risk ID | 15 | Text, bold |
| B | Risk Area | 18 | Text |
| C | Risk Title | 40 | Text, wrap |
| D | Risk Description | 60 | Text, wrap |
| E | Likelihood (1-5) | 12 | Number, centered |
| F | Impact (1-5) | 12 | Number, centered |
| G | Risk Rating | 12 | Number, centered, conditional format |
| H | Risk Level | 12 | Text, conditional format bg color |
| I | Short-term Mitigation | 45 | Text, wrap |
| J | Long-term Mitigation | 45 | Text, wrap |
| K | MITRE ATT&CK | 30 | Text, wrap |
| L | Standards Mapping | 30 | Text, wrap |
| M | Evidence Required | 30 | Text, wrap |
| N | Comments | 30 | Text, wrap |

**Header row:** Bold, bg #1B3A4B, text white, font 11pt, frozen row.
**Data rows:** Font 10pt, alternating row shading (white / #F5F7FA).
**Row height:** Auto-fit with minimum 30px.

### Conditional Formatting (Column H - Risk Level)

| Value | Background | Text |
|-------|-----------|------|
| Critical | #8B0000 | White, bold |
| High | #CC4400 | White, bold |
| Medium | #B8860B | White |
| Low | #2E5339 | White |

### Column G Formula
`=E2*F2` (Likelihood x Impact)

### Column H Formula
`=IF(G2>=16,"Critical",IF(G2>=10,"High",IF(G2>=5,"Medium","Low")))`

## Sheet 2: MITRE ATT&CK Mapping

| Column | Header | Width |
|--------|--------|-------|
| A | Technique ID | 15 |
| B | Technique Name | 40 |
| C | Tactic | 25 |
| D | Risk IDs | 30 |

Sorted by Technique ID. Header: same format as Sheet 1.

## Sheet 3: Standards Coverage Matrix

Rows = Risk IDs. Columns = Framework controls.
Cell value: "X" if risk maps to that control, empty if not.
Header row: Framework abbreviation + control ID (e.g., "ISO A.8.26").

## Sheet 4: Legend

- Risk rating color codes with examples
- Likelihood and Impact scale definitions
- Framework abbreviations (ISO=ISO 27001:2022, NIS2=NIS2 Directive, etc.)
- MITRE ATT&CK reference link
- Document version and date

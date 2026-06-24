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

**Header row:** Bold, bg `1B2A4A` (dark navy), text white, font 11pt, frozen row.
**Data rows:** Font 10pt, alternating row shading (white / `F5F7FA`).
**Row height:** Auto-fit with minimum 30px.

### Conditional Formatting (Column H - Risk Level)

These **saturated** fills encode the L×I risk rating and are applied **only to the Risk Level column (H)**. They are intentionally distinct from the pastel tier/area row fills documented in SKILL.md (Step 3) and the QA-status fills (Step 5), so the same severity word can carry a saturated fill here and a pastel fill on the row without conflict.

| Value | Background | Text |
|-------|-----------|------|
| Critical | `8B0000` | White, bold |
| High | `CC4400` | White, bold |
| Medium | `B8860B` | White |
| Low | `2E5339` | White |

> The pastel tier/area palette (`E3F2FD`, `FCE4EC`, `FFF3E0`, `E8F5E9`) used for row grouping is defined in SKILL.md Step 3. Do not apply it to Column H.

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
- MITRE ATT&CK version actually used (record the exact version; baseline Enterprise v15 if live search was unavailable)
- Document version and date

## Minimal openpyxl Construction Snippet

If an `xlsx` skill is available, prefer it. Otherwise construct the workbook directly with openpyxl. This is the minimal mechanics for Sheet 1 (header styling, the L×I rating formula in column G, and the band label in column H); replicate the header styling for Sheets 2-4. Adjust `rows` to the actual risk data.

```python
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side

HEADERS = [
    "Risk ID", "Risk Area", "Risk Title", "Risk Description",
    "Likelihood (1-5)", "Impact (1-5)", "Risk Rating", "Risk Level",
    "Short-term Mitigation", "Long-term Mitigation", "MITRE ATT&CK",
    "Standards Mapping", "Evidence Required", "Comments",
]
WIDTHS = [15, 18, 40, 60, 12, 12, 12, 12, 45, 45, 30, 30, 30, 30]
LEVEL_FILL = {  # saturated risk-rating fills, applied to column H only
    "Critical": "8B0000", "High": "CC4400", "Medium": "B8860B", "Low": "2E5339",
}

def rating_label(score):
    if score >= 16: return "Critical"
    if score >= 10: return "High"
    if score >= 5:  return "Medium"
    return "Low"

wb = Workbook()
ws = wb.active
ws.title = "Security Risk Register"

# Header row
header_fill = PatternFill("solid", fgColor="1B2A4A")
white_bold = Font(name="Arial", size=11, bold=True, color="FFFFFF")
ws.append(HEADERS)
for col, width in enumerate(WIDTHS, start=1):
    cell = ws.cell(row=1, column=col)
    cell.fill = header_fill
    cell.font = white_bold
    cell.alignment = Alignment(wrap_text=True, vertical="center")
    ws.column_dimensions[cell.column_letter].width = width
ws.row_dimensions[1].height = 40

# Data rows: each row is a 12-value tuple of the non-derived fields
# (Risk ID, Area, Title, Description, Likelihood, Impact, Short, Long, MITRE, Standards, Evidence, Comments)
body = Font(name="Arial", size=10)
thin = Side(style="thin", color="BDBDBD")
border = Border(left=thin, right=thin, top=thin, bottom=thin)
rows = []  # <-- populate from the drafted risk entries
for i, r in enumerate(rows, start=2):
    rid, area, title, desc, like, imp, st, lt, mitre, std, ev, com = r
    score = like * imp
    level = rating_label(score)
    ws.cell(row=i, column=1, value=rid)
    ws.cell(row=i, column=2, value=area)
    ws.cell(row=i, column=3, value=title).font = Font(name="Arial", size=10, bold=True)
    ws.cell(row=i, column=4, value=desc)
    ws.cell(row=i, column=5, value=like)
    ws.cell(row=i, column=6, value=imp)
    ws.cell(row=i, column=7, value=f"=E{i}*F{i}")  # L x I
    h = ws.cell(row=i, column=8, value=level)
    h.fill = PatternFill("solid", fgColor=LEVEL_FILL[level])
    h.font = Font(name="Arial", size=10, bold=level in ("Critical", "High"), color="FFFFFF")
    ws.cell(row=i, column=9, value=st)
    ws.cell(row=i, column=10, value=lt)
    ws.cell(row=i, column=11, value=mitre)
    ws.cell(row=i, column=12, value=std)
    ws.cell(row=i, column=13, value=ev)
    ws.cell(row=i, column=14, value=com)
    for col in range(1, 15):
        c = ws.cell(row=i, column=col)
        if col != 3:
            c.font = body
        c.alignment = Alignment(wrap_text=True, vertical="top")
        c.border = border

ws.freeze_panes = "A2"          # freeze header row
ws.auto_filter.ref = ws.dimensions
wb.save("security-review/risk-register.xlsx")  # save under security-review/
```

## CSV Fallback (when openpyxl is unavailable)

If openpyxl cannot be used, write the register as a CSV so the data is still delivered (formatting and the multi-sheet layout are lost, but the field set is preserved). Compute Risk Rating and Risk Level in Python (CSV has no formulas).

```python
import csv

HEADERS = [
    "Risk ID", "Risk Area", "Risk Title", "Risk Description",
    "Likelihood (1-5)", "Impact (1-5)", "Risk Rating", "Risk Level",
    "Short-term Mitigation", "Long-term Mitigation", "MITRE ATT&CK",
    "Standards Mapping", "Evidence Required", "Comments",
]

def rating_label(score):
    if score >= 16: return "Critical"
    if score >= 10: return "High"
    if score >= 5:  return "Medium"
    return "Low"

rows = []  # same 12-value tuples as above
with open("security-review/risk-register.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(HEADERS)
    for rid, area, title, desc, like, imp, st, lt, mitre, std, ev, com in rows:
        score = like * imp
        w.writerow([rid, area, title, desc, like, imp, score, rating_label(score),
                    st, lt, mitre, std, ev, com])
```

Report the CSV path to the user and note that the Excel multi-sheet layout (MITRE Mapping, Standards Coverage, Legend) was not produced because openpyxl was unavailable.

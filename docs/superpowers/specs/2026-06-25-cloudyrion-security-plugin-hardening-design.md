# cloudyrion-security plugin hardening — design

**Date:** 2026-06-25
**Source:** adversarially-verified audit of all 12 skills + hooks + metadata (137 findings: 2 critical, 23 high, 43 medium, 58 low, 11 nit).

## Goal

Fix every verified finding so the plugin works correctly and consistently in practice — no dead skill references, no undefined shell vars in report steps, hooks that actually reach Claude, accurate security facts, and one consistent convention set across all skills.

## Ownership model (avoids parallel edit conflicts)

Each fixer edits a disjoint set of files:

- **hooks** → `hooks/hooks.json` only.
- **metadata** → `README.md` (plugin), root `README.md`, `.claude-plugin/plugin.json`, root `.claude-plugin/marketplace.json`, `CHANGELOG.md`, `DISCLAIMER.md`, `LICENSE`. Also owns the hooks-related README/CHANGELOG wording.
- **each skill** → only `skills/<skill>/**`.

Cross-cutting findings are encoded as shared conventions and applied by whichever fixer owns the affected file.

## Shared conventions

1. **Skill names**: only the 12 real skills; invoke as `/cloudyrion-security:<name>`. Fix `*-generator`, `iac-security-scanner`, `api-security-review`, and skill-use of `security-code-review`. (Report-file basenames stay.)
2. **Standard report setup block**: define `REPO_ROOT`/`DATE`/`REPORT_DIR` + git metadata with non-git fallback, before use; echo the output path.
3. **Severity ladder**: Critical/High/Medium/Low/Info everywhere (counts row + per-finding enum).
4. **Tags**: `[BLOCK] / [WARN] / [INFO]` (single `/`), template Tag row + one body definition.
5. **ISO 27001:2022**: 93 controls; `A.14.2.1` → `A.8.25`/`A.8.28`; suite `X/114` → `X/93`.
6. **OWASP API 2023**: correct API6/7/8 numbering; no "Injection" category; API10 = "Unsafe Consumption of APIs".
7. **Markdown tables**: no literal `|` inside 2-column value cells → use `/`.
8. **Report header**: Author `<Firstname Lastname (email@domain.com)>`, Classification "CONFIDENTIAL — Internal Security Use Only", Status "DRAFT / FINAL".
9. **Tool absence**: guard external tools with `command -v`; fix wrong invocations (`pip audit`→`pip-audit`, `cyclonedx-py` flags, semgrep pipe/`--pro --dry-run`, vibe-patch `git checkout HEAD --`).

## Four structural decisions (approved)

1. Missing `xlsx` skill → inline openpyxl guidance + soften wording + CSV fallback (risk-register, compliance-mapper).
2. Add `attack-scenarios` to the `suite` pipeline (matrix, step, progress, dashboard, Reports table `PEN-YYYYMMDD-001`, `/9`→`/10`); keeps the README "Attack Playbook" example truthful.
3. Tags universal across report-emitting skills.
4. risk-register adopts the scoring-based field model (Likelihood/Impact/Risk Rating mandatory; single `RSK-[DOMAIN]-NNN` ID; one MITRE format/color/horizon) — reconcile SKILL.md, risk-schema.md, excel-template.md.

## Execution

14 parallel fixers → per-target adversarial verify → repo-wide grep sweep for banned patterns (old skill names, `A.14.2.1`, `/114`, `13 skills`, `pip audit`, bad GCP metadata host, etc.). No commits until the user asks.

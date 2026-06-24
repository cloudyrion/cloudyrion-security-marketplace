# Changelog

## 1.1.0 (2026-06-25)

### Fixed

- **Hooks now actually reach Claude.** All three hooks previously exited 0 and only
  echoed, so their output went to the transcript but was never injected into Claude's
  context. They now emit JSON `hookSpecificOutput.additionalContext` (and a
  `permissionDecision` for the PR hook).
- **PR reminder moved to `PreToolUse`** so "run quick-scan first" fires before
  `gh pr create`, not after.
- **Secret-detection regex** broadened to catch unquoted secrets and high-confidence
  token shapes (AWS keys, GitHub PATs, JWTs, private keys); matchers broadened to
  `Write|Edit|MultiEdit`; added a `jq`-absence guard.
- **Dead skill references** replaced with real `/cloudyrion-security:<name>` commands
  (`threat-model-generator`, `iac-security-scanner`, `api-security-review`,
  `sbom-generator`, and skill-use of `security-code-review`).
- **Report output**: `api-security`, `attack-scenarios`, `threat-model` (and others)
  now define `REPO_ROOT`/`DATE`/`REPORT_DIR` + git metadata before use and echo the
  output path.
- **Security accuracy**: corrected OWASP API Top 10 (2023) numbering (removed the
  invented "Injection" category; fixed API6/7/8), ISO 27001:2022 controls
  (`A.14.2.1` → `A.8.25`/`A.8.28`; suite `/114` → `/93`), and tool invocations
  (`pip-audit`, `cyclonedx-py` flags, semgrep `PIPESTATUS`, vibe-patch
  `git checkout HEAD --`).
- `iac-scanner`: run the advertised `cfn-lint`/`kubesec`/Helm/Ansible scanners, scan
  all `Dockerfile*` with `hadolint`, prefer `trivy config` over the deprecated `tfsec`,
  and truncate result files so same-day re-runs are idempotent.
- `risk-register`: reconciled onto one scoring-based field model across SKILL.md,
  `risk-schema.md`, and `excel-template.md` (single Risk-ID scheme, MITRE format,
  header colour, mitigation horizons); replaced the missing `xlsx`-skill dependency
  with inline openpyxl guidance + CSV fallback.
- Unified the severity ladder (Critical/High/Medium/Low/Info), `[BLOCK]/[WARN]/[INFO]`
  tags, report headers, and Markdown tables across skills.
- Plugin README skill count corrected (13 → 12).

### Added

- `attack-scenarios` wired into the `suite` pipeline (applicability matrix, run step,
  dashboard, `PEN-YYYYMMDD-001` report row, `of 9` → `of 10`).
- `scripts/validate-plugin.sh` + GitHub Actions workflow — validates frontmatter,
  cross-reference resolution, output-variable hygiene, JSON validity, and hook shell
  syntax.
- `CONTRIBUTING.md`, `.gitignore`.
- `plugin.json` `homepage` and `repository` fields.

## 1.0.0 (2026-04-13)

### Added

- 11 security skills ported from standalone installation:
  code-review, api-security, architecture-review, threat-model,
  compliance-mapper, risk-register, sbom, iac-scanner,
  attack-scenarios, vibe-patch, suite
- New `quick-scan` skill for lightweight developer security checks
- Reworked `suite` skill with Phase 0 quick-scan option and namespaced invocations
- 3 configurable hooks: secret detection, dependency change alert, PR security reminder

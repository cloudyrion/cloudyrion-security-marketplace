# Changelog

## Unreleased

### Fixed

- `api-security`: define the `REPO_ROOT`/`DATE`/`REPORT_DIR` variables it uses, so the report write no longer references undefined variables
- `architecture-review`, `compliance-mapper`: replace stale standalone skill names (`threat-model-generator`, `iac-security-scanner`, `api-security-review`, `sbom-generator`, `security-code-review`) with `/cloudyrion-security:<name>` invocations
- `iac-scanner`: run the advertised `cfn-lint`/`kubesec` scanners, scan all `Dockerfile*` with `hadolint`, and truncate result files so same-day re-runs are idempotent
- `quick-scan`: `pip audit` → `pip-audit` (correct binary name)
- hooks: merge the duplicate `Write|Edit` matchers into one object and guard the PR-reminder hook against empty/malformed input
- `risk-register`/`suite`: align the risk-register `.xlsx` filename convention
- Plugin README skill count (13 → 12)

### Added

- `scripts/validate-plugin.sh` + GitHub Actions workflow — validates frontmatter, cross-reference resolution, output-variable hygiene, JSON validity, and hook shell syntax
- `CONTRIBUTING.md`, `.gitignore`
- `plugin.json` `homepage` and `repository` fields

## 1.0.0 (2026-04-12)

### Added

- 11 security skills ported from standalone installation:
  code-review, api-security, architecture-review, threat-model,
  compliance-mapper, risk-register, sbom, iac-scanner,
  attack-scenarios, vibe-patch, suite
- New `quick-scan` skill for lightweight developer security checks
- Reworked `suite` skill with Phase 0 quick-scan option and namespaced invocations
- 3 configurable hooks: secret detection, dependency change alert, PR security reminder

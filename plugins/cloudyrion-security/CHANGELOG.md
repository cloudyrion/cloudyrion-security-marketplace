# Changelog

## 1.0.0 (2026-04-12)

### Added

- 11 security skills ported from standalone installation:
  code-review, api-security, architecture-review, threat-model,
  compliance-mapper, risk-register, sbom, iac-scanner,
  attack-scenarios, vibe-patch, suite
- New `quick-scan` skill for lightweight developer security checks
- Reworked `suite` skill with Phase 0 quick-scan option and namespaced invocations
- 3 configurable hooks: secret detection, dependency change alert, PR security reminder

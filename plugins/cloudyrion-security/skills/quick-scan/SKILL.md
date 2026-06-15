---
description: >
  Lightweight, developer-focused security scan that runs in under a minute. Checks for
  OWASP Top 10 patterns, hardcoded secrets, and known dependency vulnerabilities. Outputs
  a short actionable summary — not a full report. Use this skill when the user asks for a
  quick security check, wants to scan before committing or opening a PR, says 'quick scan',
  'fast security check', 'check my code for security issues', or wants a lightweight
  alternative to the full security suite. Also trigger on: 'is this secure enough to merge',
  'any obvious security issues', 'pre-commit security check', or 'spot check for vulnerabilities'.
---

# Quick Security Scan

A fast, developer-focused security check. Produces actionable findings, not a formal report.

## Scope

This skill checks three things and nothing more:

### 1. OWASP Top 10 Code Patterns

Scan all source files in the repository for these high-impact patterns:

- **A01 Broken Access Control** — missing auth checks on endpoints, IDOR patterns, directory traversal
- **A02 Cryptographic Failures** — hardcoded keys, weak algorithms (MD5, SHA1 for security), plaintext storage
- **A03 Injection** — SQL concatenation, unsanitized shell commands, template injection, XSS sinks
- **A04 Insecure Design** — missing rate limiting, no CSRF protection, predictable tokens
- **A05 Security Misconfiguration** — debug modes enabled, default credentials, overly permissive CORS
- **A06 Vulnerable Components** — (covered by dependency check below)
- **A07 Auth Failures** — weak password rules, missing MFA, session fixation
- **A08 Data Integrity** — deserialization of untrusted data, missing integrity checks
- **A09 Logging Failures** — sensitive data in logs, missing audit trails
- **A10 SSRF** — unvalidated URLs in server-side requests

Focus on the top-level application code. Skip vendored/generated files and test files.

### 2. Hardcoded Secrets Detection

Scan for:
- API keys, tokens, passwords in source files (regex patterns for common formats)
- Private keys (RSA, EC, PGP headers)
- Connection strings with embedded credentials
- `.env` files committed to the repository
- Common secret variable names with literal values (e.g., `password = "..."`, `api_key = "..."`)

### 3. Dependency Vulnerability Check

For each detected package manager:
- **npm/yarn**: Run `npm audit --json` or check `package-lock.json`
- **pip/poetry**: Run `pip-audit` if available, or check against OSV.dev
- **Go**: Run `govulncheck` if available
- **Cargo**: Run `cargo audit` if available
- **Other**: List dependencies and flag any with known CVEs from recent advisories

If audit tools are not installed, note this and check the lock file manually against known CVE databases.

## Output Format

Print findings directly to the conversation. Do NOT write a report file. Use this format:

```
## Quick Scan Results

**Repository:** <repo-name>
**Scanned:** <timestamp>
**Files checked:** <count>

### Findings

| # | Severity | Category | File:Line | Issue | Fix |
|---|----------|----------|-----------|-------|-----|
| 1 | HIGH | Injection | src/app.py:42 | SQL string concatenation | Use parameterized query |
| 2 | MEDIUM | Secrets | config.py:15 | Hardcoded API key | Move to environment variable |
| ... | | | | | |

### Dependency Issues

| Package | Version | CVE | Severity | Fixed In |
|---------|---------|-----|----------|----------|
| lodash | 4.17.19 | CVE-2021-23337 | HIGH | 4.17.21 |
| ... | | | | |

### Summary

- **X** findings across code and dependencies
- **Critical/High:** N items need immediate attention
- **Recommendation:** [one-line next step]
```

If no findings: "No security issues found. Consider running `/cloudyrion-security:suite` for a comprehensive assessment."

## What This Skill Does NOT Do

- No formal report generation (use `/cloudyrion-security:code-review` for that)
- No threat modeling or architecture analysis
- No compliance mapping
- No attack scenario design
- No remediation patches (use `/cloudyrion-security:vibe-patch` for that)

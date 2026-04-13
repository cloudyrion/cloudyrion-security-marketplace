# CLOUDYRION Security Suite for Claude Code

> Enterprise-grade security assessments, threat modeling, and compliance mapping — directly inside Claude Code.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](plugins/cloudyrion-security/LICENSE)
[![Plugin Version](https://img.shields.io/badge/version-1.0.0-green.svg)](plugins/cloudyrion-security/CHANGELOG.md)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-blueviolet.svg)](https://claude.com/plugins)

---

## What is this?

A Claude Code plugin that turns Claude into a security engineer. Run full SAST code reviews, generate STRIDE threat models, map compliance gaps against NIS2/DORA/ISO 27001, produce audit-ready risk registers, and auto-patch vulnerabilities — all from your terminal.

**Built for two audiences:**

- **Developers** who want fast security feedback before they ship
- **Security professionals** who need comprehensive assessments with formal reports

## Quick Start

```shell
# Add the CLOUDYRION marketplace
/plugin marketplace add cloudyrion/cloudyrion-security-marketplace

# Install the security plugin
/plugin install cloudyrion-security@cloudyrion-marketplace
```

That's it. All 12 skills are now available.

## Skills Overview

### Developer Workflow

| Command | What it does |
|---------|-------------|
| `/cloudyrion-security:quick-scan` | OWASP Top 10 check + secret detection + dependency CVE scan. Under a minute. |
| `/cloudyrion-security:code-review` | Full SAST with taint analysis, CWE mapping, and formal report |
| `/cloudyrion-security:api-security` | OWASP API Security Top 10 assessment against your endpoints |
| `/cloudyrion-security:sbom` | CycloneDX/SPDX Software Bill of Materials with vulnerability enrichment |
| `/cloudyrion-security:iac-scanner` | Security checks for Terraform, Kubernetes, Docker, CloudFormation, Helm |
| `/cloudyrion-security:vibe-patch` | Reads your code review report and generates minimal fix patches automatically |

### Security Professional Workflow

| Command | What it does |
|---------|-------------|
| `/cloudyrion-security:suite` | Runs all applicable skills in dependency order, produces a unified dashboard |
| `/cloudyrion-security:threat-model` | STRIDE/PASTA threat modeling with data flow diagrams and MITRE ATT&CK mapping |
| `/cloudyrion-security:architecture-review` | Secure by Design review against architecture documents |
| `/cloudyrion-security:compliance-mapper` | Gap analysis across NIS2, DORA, EU CRA, ISO 27001, GDPR, SOC 2, NIST CSF |
| `/cloudyrion-security:risk-register` | Audit-ready Excel risk register with MITRE ATT&CK and framework traceability |
| `/cloudyrion-security:attack-scenarios` | Pentest attack playbooks with exploitation steps and detection indicators |

### The Full Suite

Run `/cloudyrion-security:suite` for a complete security assessment. It orchestrates all skills in the right order:

```
Phase 0  Quick Scan (optional)          — fast triage
Phase 1  Code Review, API, IaC, SBOM    — independent scans
Phase 2  Architecture + Threat Model    — consumes Phase 1 findings
Phase 3  Compliance + Risk Register     — aggregates everything
Phase 4  Vibe Patch (if findings exist) — auto-remediation
   =>    Unified Dashboard              — single report with cross-references
```

## Built-in Hooks

Three automated checks ship with the plugin (active by default):

| Trigger | What happens |
|---------|-------------|
| You write or edit a file | Scans for hardcoded secrets (API keys, tokens, passwords) |
| You modify a dependency file | Reminds you to run an SBOM vulnerability check |
| You create a PR with `gh` | Reminds you to run a quick-scan before merging |

To disable a hook, remove its entry from `hooks/hooks.json` in the plugin directory.

## Frameworks & Standards Coverage

<table>
<tr>
<td>

**Application Security**
- OWASP Top 10 (2021)
- OWASP API Top 10 (2023)
- OWASP ASVS
- CWE / CVE / CVSS
- OWASP WSTG

</td>
<td>

**Threat Intelligence**
- MITRE ATT&CK
- CAPEC
- STRIDE / PASTA

</td>
<td>

**Compliance & Governance**
- ISO 27001:2022
- NIST 800-53 / CSF 2.0
- NIS2 / DORA / EU CRA
- GDPR
- SOC 2 / PCI-DSS
- BSI IT-Grundschutz

</td>
<td>

**Infrastructure**
- CIS Benchmarks (AWS, Azure, GCP)
- CIS Kubernetes / Docker
- IEC 62443
- ETSI EN 303 645

</td>
</tr>
</table>

## Example Output

Running `/cloudyrion-security:suite` on a Flask web application produced:

- **Security Code Review** — 3 Medium, 4 Low findings with CWE mapping
- **API Security Review** — 1 High, 3 Medium findings against 27 endpoints
- **Threat Model** — 14 threats identified via STRIDE with Mermaid DFDs
- **Compliance Matrix** — NIS2 55%, DORA 50%, ISO 27001 61% coverage
- **Risk Register** — Excel workbook with 23 controls and 8 gaps prioritized
- **Attack Playbook** — 12 scenarios with MITRE ATT&CK chains
- **SBOM** — 52 components, 0 known CVEs, full CycloneDX output
- **Unified Dashboard** — single report aggregating all findings with deduplication

## Requirements

- [Claude Code](https://claude.com/claude-code) installed and authenticated
- No additional dependencies — all analysis is performed by Claude

## Local Development

```shell
# Test the plugin locally without installing
claude --plugin-dir ./plugins/cloudyrion-security

# Reload after making changes
/reload-plugins
```

## Contributing

We welcome contributions! To add or improve a skill:

1. Fork this repository
2. Edit skills in `plugins/cloudyrion-security/skills/<skill-name>/SKILL.md`
3. Test locally with `claude --plugin-dir`
4. Submit a pull request

## License

[MIT](plugins/cloudyrion-security/LICENSE) — CLOUDYRION GmbH

## Disclaimer

CLOUDYRION Security is an AI-assisted security tool, not a replacement for professional security audits or compliance certifications.

**This plugin must not be used to:**

- Attack, probe, or exploit systems without explicit written authorization
- Replace professional penetration testing or certified security audits
- Certify compliance with any regulatory framework (NIS2, DORA, ISO 27001, GDPR, etc.)
- Make production security decisions without professional validation

**Important limitations:**

- AI-generated findings may contain false positives, false negatives, or inaccuracies
- The absence of findings does not mean the absence of vulnerabilities
- Compliance mappings are informational only, not formal assessments
- Offensive security skills (attack scenarios, pentest playbooks) are for authorized testing only

Use of this plugin is at your own risk. See [DISCLAIMER.md](plugins/cloudyrion-security/DISCLAIMER.md) for full terms.

# CLOUDYRION Security

Comprehensive security assessment suite for Claude Code. 12 skills covering code review, threat modeling, API security, compliance mapping, SBOM generation, and more.

## Installation

### From CLOUDYRION Marketplace

```shell
/plugin marketplace add cloudyrion/cloudyrion-security-marketplace
/plugin install cloudyrion-security@cloudyrion-marketplace
```

### Local Development

```shell
claude --plugin-dir ./path/to/cloudyrion-security
```

## Skills

### For Developers

| Skill | Command | Description |
|-------|---------|-------------|
| Quick Scan | `/cloudyrion-security:quick-scan` | Fast OWASP Top 10 + secrets + dependency check |
| Code Review | `/cloudyrion-security:code-review` | Full SAST with CWE mapping and formal report |
| API Security | `/cloudyrion-security:api-security` | OWASP API Top 10 assessment |
| SBOM | `/cloudyrion-security:sbom` | Software Bill of Materials with CVE enrichment |
| IaC Scanner | `/cloudyrion-security:iac-scanner` | Terraform, K8s, Docker security checks |
| Vibe Patch | `/cloudyrion-security:vibe-patch` | Auto-generate minimal patches for findings |

### For Security Professionals

| Skill | Command | Description |
|-------|---------|-------------|
| Full Suite | `/cloudyrion-security:suite` | Run all skills in dependency order with dashboard |
| Architecture Review | `/cloudyrion-security:architecture-review` | Secure by Design review |
| Threat Model | `/cloudyrion-security:threat-model` | STRIDE/PASTA threat modeling |
| Compliance Mapper | `/cloudyrion-security:compliance-mapper` | NIS2, DORA, ISO 27001, GDPR gap analysis |
| Risk Register | `/cloudyrion-security:risk-register` | Audit-ready Excel risk register |
| Attack Scenarios | `/cloudyrion-security:attack-scenarios` | Pentest playbooks with MITRE ATT&CK mapping |

## Hooks

The plugin ships with three hooks (active by default). Remove entries from `hooks/hooks.json` to disable.

| Hook | Trigger | Action |
|------|---------|--------|
| Secret Detection | After Write/Edit | Warns if hardcoded secrets detected |
| Dependency Alert | After Write/Edit on package files | Suggests running SBOM check |
| PR Reminder | After `gh pr create` | Reminds to run quick-scan |

## Frameworks Covered

OWASP (Top 10, API Top 10, ASVS), CWE/CVE/CVSS, MITRE ATT&CK, STRIDE/PASTA, NIST 800-53, NIST CSF 2.0, ISO 27001:2022, NIS2, DORA, GDPR, EU CRA, SOC 2, PCI-DSS, CIS Benchmarks.

## License

MIT

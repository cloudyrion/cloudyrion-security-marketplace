# NTIA Minimum Elements for SBOMs

Reference: NTIA "The Minimum Elements For a Software Bill of Materials (SBOM)" (July 2021)

---

## Required Data Fields

| # | Element | Description | CycloneDX field | SPDX field |
|---|---------|-------------|-----------------|------------|
| 1 | **Supplier Name** | Entity that creates, defines, and identifies components | `component.supplier.name` | `PackageSupplier` |
| 2 | **Component Name** | Designation assigned to a unit of software | `component.name` | `PackageName` |
| 3 | **Version** | Identifier used by the supplier to specify a change | `component.version` | `PackageVersion` |
| 4 | **Other Unique Identifier** | Other identifiers used for a component (PURL, CPE) | `component.purl`, `component.cpe` | `ExternalRef: PACKAGE-MANAGER purl` |
| 5 | **Dependency Relationship** | Upstream/included-in relationship between components | `dependencies[]` | `Relationship: DEPENDS_ON` |
| 6 | **Author of SBOM Data** | The entity that creates the SBOM | `metadata.authors[]` | `Creator` |
| 7 | **Timestamp** | Date/time the SBOM was assembled | `metadata.timestamp` | `Created` |

---

## Required Practices

| Practice | Description |
|----------|-------------|
| **Automation support** | SBOMs must be machine-readable (JSON, XML, tag-value) |
| **Frequency** | New SBOM for each new release/build; update on dependency changes |
| **Known unknowns** | Must explicitly declare components where data is incomplete |
| **Distribution** | Must be available to those who need it (customers, auditors) |
| **Access control** | May restrict access but must not prevent entitled parties |
| **Depth** | Should include transitive dependencies; flag where depth is incomplete |

---

## Regulatory Mapping

| Regulation | SBOM Requirement | Relevant Article |
|------------|-----------------|------------------|
| **EU Cyber Resilience Act (CRA)** | SBOM mandatory for all products with digital elements; must cover top-level dependencies minimum | Annex I, Part II, §1 |
| **NIS2 Directive** | Supply chain security measures including software inventory | Art. 21(2)(d) |
| **US Executive Order 14028** | SBOM required for software sold to federal government | Sec. 4(e) |
| **DORA** | ICT third-party risk management requires component visibility | Art. 28 |
| **FDA Cybersecurity Guidance** | SBOM required for medical device premarket submissions | Section V.B |

---

## Compliance Validation Checklist

Use this checklist against every generated SBOM:

```
[ ] All 7 NTIA data fields present
[ ] Machine-readable format (CycloneDX JSON/XML or SPDX JSON/TV)
[ ] Transitive dependencies included (not just direct)
[ ] PURL present for ≥95% of components
[ ] Supplier/author populated for ≥80% of components
[ ] Known unknowns explicitly declared
[ ] Timestamp reflects actual generation time
[ ] Dependency graph present (not flat list)
[ ] License information present for each component (recommended, not required by NTIA)
```

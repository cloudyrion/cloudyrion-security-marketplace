---
description: >
  Generate a Software Bill of Materials (SBOM) in CycloneDX or SPDX format, enrich it with
  vulnerability data, and produce a human-readable summary report. Use this skill whenever the
  user asks to create an SBOM, generate a software inventory, list dependencies for compliance,
  produce a CycloneDX or SPDX document, check supply chain security, or audit third-party
  components. Also trigger when the user mentions 'SBOM', 'software bill of materials',
  'dependency inventory', 'CRA compliance', 'supply chain audit', 'component list',
  'NTIA minimum elements', or any regulatory requirement for software transparency
  (EU Cyber Resilience Act, NIS2 Article 21, US EO 14028). Even if the user just says
  'what dependencies does this project use' or 'audit my packages', use this skill.
---

# SBOM Generator

You are acting as a Software Supply Chain Security Engineer. Your deliverable is a standards-compliant
SBOM file plus a human-readable summary report, saved to `<repo-root>/sbom/`.

Before generating, read the reference files as needed:
→ `references/ntia-minimum-elements.md` — NTIA minimum elements checklist & compliance mapping
→ `references/report-template.md` — Markdown structure for the summary report

---

## Step 1 — Collect Context

```bash
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
REPO_NAME=$(basename "$REPO_ROOT")
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
COMMIT=$(git log -1 --format="%h — %s" 2>/dev/null || echo "N/A")
DATE=$(date +%Y%m%d)
AUTHOR_NAME=$(git config user.name 2>/dev/null || echo "N/A")
AUTHOR_EMAIL=$(git config user.email 2>/dev/null || echo "N/A")
SBOM_DIR="$REPO_ROOT/sbom"
mkdir -p "$SBOM_DIR"
```

---

## Step 2 — Detect Project Ecosystem

Scan the repository root for manifest files to determine the tech stack(s). A project may be
multi-ecosystem (e.g. Python backend + JS frontend).

| Indicator file | Ecosystem | Lock file |
|---|---|---|
| `requirements.txt`, `setup.py`, `pyproject.toml`, `Pipfile` | Python | `requirements.txt`, `Pipfile.lock`, `poetry.lock`, `uv.lock` |
| `package.json` | Node.js | `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml` |
| `go.mod` | Go | `go.sum` |
| `Cargo.toml` | Rust | `Cargo.lock` |
| `pom.xml`, `build.gradle`, `build.gradle.kts` | Java/Kotlin | — |
| `Gemfile` | Ruby | `Gemfile.lock` |
| `composer.json` | PHP | `composer.lock` |
| `*.csproj`, `*.sln`, `packages.config` | .NET | `packages.lock.json` |
| `Dockerfile`, `docker-compose.yml` | Container | — |

**Important**: Always prefer lock files over manifest files for accurate pinned versions.
If no lock file exists, warn the user that the SBOM will contain unpinned ranges.

```bash
echo "=== Manifest detection ==="
for f in requirements.txt setup.py pyproject.toml Pipfile package.json go.mod Cargo.toml \
         pom.xml build.gradle composer.json Gemfile *.csproj Dockerfile; do
  [ -e "$REPO_ROOT/$f" ] && echo "Found: $f"
done
```

---

## Step 3 — Select & Run SBOM Tool

### Primary tool: Syft (preferred)
Syft (by Anchore) supports all major ecosystems and outputs both CycloneDX and SPDX.

```bash
if command -v syft &>/dev/null; then
  SBOM_TOOL="syft"
else
  echo "Syft not found. Install: curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s"
  echo "Falling back to ecosystem-specific tools..."
  SBOM_TOOL="fallback"
fi
```

### Generate SBOM with Syft

If the user has not already stated a format, ask them which output format they want
(CycloneDX JSON / CycloneDX XML / SPDX JSON / SPDX tag-value). If they have no
preference or do not answer, default to **CycloneDX JSON** (most widely supported by
downstream tools and EU CRA guidance). Set `USER_PREFERRED_FORMAT` from their answer.

```bash
# Default to CycloneDX JSON unless the user explicitly requested another format.
# If you have already asked the user (see note above) and they chose a format,
# set USER_PREFERRED_FORMAT accordingly before running this block.
FORMAT="${USER_PREFERRED_FORMAT:-cyclonedx-json}"

case "$FORMAT" in
  cyclonedx-json)
    EXT="cdx.json"
    SYFT_FORMAT="cyclonedx-json"
    ;;
  cyclonedx-xml)
    EXT="cdx.xml"
    SYFT_FORMAT="cyclonedx-xml"
    ;;
  spdx-json)
    EXT="spdx.json"
    SYFT_FORMAT="spdx-json"
    ;;
  spdx-tv)
    EXT="spdx"
    SYFT_FORMAT="spdx-tag-value"
    ;;
  *)
    echo "Unrecognized format '$FORMAT'. Falling back to cyclonedx-json."
    FORMAT="cyclonedx-json"
    EXT="cdx.json"
    SYFT_FORMAT="cyclonedx-json"
    ;;
esac

# This is the single output path the rest of the skill (Steps 4-7) consumes.
SBOM_FILE="$SBOM_DIR/${REPO_NAME}-${DATE}.${EXT}"

# Only run Syft on the primary path. On the fallback path ($SBOM_TOOL = "fallback")
# the ecosystem-specific tools below must write to this same $SBOM_FILE.
if [ "$SBOM_TOOL" = "syft" ]; then
  syft scan dir:"$REPO_ROOT" -o "$SYFT_FORMAT" > "$SBOM_FILE"
  echo "SBOM generated: $SBOM_FILE"
else
  echo "Syft unavailable — use a fallback tool below and write its output to: $SBOM_FILE"
fi
```

### Fallback: Ecosystem-specific tools

If Syft is unavailable, use native tools. **Write every fallback command's output to the
same `$SBOM_FILE`** defined above (not a hardcoded `sbom.cdx.json`), so Steps 4–7 operate
on the actual generated file. Guard each tool with `command -v` before running it and
fall through to the next option if it is missing.

| Ecosystem | Tool | Install | Command (writes to `$SBOM_FILE`) |
|---|---|---|---|
| Python | `cyclonedx-py` | `pip install cyclonedx-bom` | `cyclonedx-py requirements requirements.txt -o "$SBOM_FILE" --of json` |
| Node.js | `cdxgen` | `npm install -g @cyclonedx/cdxgen` | `cdxgen -o "$SBOM_FILE"` |
| Go | `cyclonedx-gomod` | `go install github.com/CycloneDX/cyclonedx-gomod/cmd/cyclonedx-gomod@latest` | `cyclonedx-gomod mod -json -output "$SBOM_FILE"` |
| Rust | `cargo-cyclonedx` | `cargo install cargo-cyclonedx` | `cargo cyclonedx --format json && mv "$REPO_ROOT"/*.cdx.json "$SBOM_FILE"` |
| Java | `cdxgen` | `npm install -g @cyclonedx/cdxgen` | `cdxgen -o "$SBOM_FILE"` |
| Any source tree | `trivy` | — | `trivy fs --format cyclonedx --output "$SBOM_FILE" "$REPO_ROOT"` |
| Container image | `syft` (strongly preferred) or `trivy` | — | `trivy image --format cyclonedx --output "$SBOM_FILE" <image>` |

For ecosystems with no dedicated row (e.g. Ruby, PHP, .NET), use the generic
`trivy fs` source-tree fallback above before resorting to a manual SBOM.

If no tool is available at all, perform a **manual SBOM** by parsing manifest/lock files
and generating a CycloneDX JSON document programmatically (see the minimal skeleton below).
This is a last resort — note the limitation in the report.

#### Minimal CycloneDX 1.5 JSON skeleton (manual last resort)

A hand-built SBOM must still satisfy the NTIA fields validated in Step 5. Populate at
minimum `metadata.timestamp`, `metadata.authors`, each `components[].{name,version,purl}`,
and the `dependencies[]` graph. Write the result to `$SBOM_FILE`:

```json
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.5",
  "version": 1,
  "metadata": {
    "timestamp": "<ISO-8601 generation time>",
    "authors": [{ "name": "<SBOM author>" }],
    "component": { "type": "application", "name": "<repo name>", "version": "<version>" }
  },
  "components": [
    {
      "type": "library",
      "name": "<dependency name>",
      "version": "<pinned version>",
      "purl": "pkg:<ecosystem>/<name>@<version>",
      "bom-ref": "<name>@<version>"
    }
  ],
  "dependencies": [
    { "ref": "<name>@<version>", "dependsOn": [] }
  ]
}
```

---

## Step 4 — Enrich with Vulnerability Data

Scan the generated SBOM for known vulnerabilities:

```bash
if command -v grype &>/dev/null; then
  VULN_FILE="$SBOM_DIR/vulnerabilities-${DATE}.json"
  grype sbom:"$SBOM_FILE" -o json > "$VULN_FILE"
  echo "Vulnerability scan: $VULN_FILE"
elif command -v osv-scanner &>/dev/null; then
  VULN_FILE="$SBOM_DIR/vulnerabilities-${DATE}.json"
  # The deprecated `--sbom` flag is removed in osv-scanner v3; pass the SBOM via -L
  # (the *.cdx.json / *.spdx.json filename lets osv-scanner detect the SBOM format).
  osv-scanner scan source -L "$SBOM_FILE" --format json > "$VULN_FILE"
  echo "Vulnerability scan (OSV): $VULN_FILE"
else
  echo "No vuln scanner available (grype or osv-scanner). Skipping enrichment."
  echo "Install grype: curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s"
  VULN_FILE=""
fi
```

If a vulnerability scanner ran, extract for each finding:
- Package name + version
- CVE ID
- Severity (CVSS score + qualitative, on the ladder Critical / High / Medium / Low / Info)
- Fix version (if available)
- Whether the vulnerable code path is reachable (if data available)

**Finding tags** — assign each actionable finding a tag in the report, mapped once here:
- `[BLOCK]` = Critical / High — must-fix before release
- `[WARN]` = Medium — should-fix
- `[INFO]` = Low / Info — defense-in-depth / informational

---

## Step 5 — Validate NTIA Minimum Elements

Every SBOM should meet the NTIA minimum elements. Read `references/ntia-minimum-elements.md`
for the full checklist, then validate the generated SBOM against it:

| Element | Field in CycloneDX | Check |
|---|---|---|
| Supplier name | `component.supplier.name` or `component.author` | Present for each component? |
| Component name | `component.name` | ✓ Always present |
| Component version | `component.version` | Present and pinned (not range)? |
| Unique identifier | `component.purl` (or `component.cpe`) | PURL present? |
| Dependency relationship | `dependencies[]` | Dependency tree present? |
| Author of SBOM | `metadata.authors` | Present? |
| Timestamp | `metadata.timestamp` | Present? |

Flag any missing elements as compliance gaps in the report.

---

## Step 6 — Generate Summary Report

Read the report template: `references/report-template.md`

Write the report to: `$SBOM_DIR/sbom-report-${DATE}.md`

The report must include:
1. Header metadata (repo, branch, commit, date, author, classification, status, tool used, format)
2. Component statistics (total count, by ecosystem, by license family)
3. Vulnerability summary (critical/high/medium/low counts, top 5 actionable findings)
4. NTIA compliance checklist results
5. License risk analysis (copyleft vs permissive, unknown licenses)
6. Regulatory mapping (which requirements this SBOM satisfies)
7. Recommendations (unpinned deps, vulnerable components, license conflicts)

---

## Step 7 — Confirm Outputs

```bash
echo "=== SBOM Outputs ==="
ls -lh "$SBOM_DIR/"
echo ""
echo "SBOM file:    $SBOM_FILE"
echo "Vuln scan:    ${VULN_FILE:-SKIPPED}"
echo "Report:       $SBOM_DIR/sbom-report-${DATE}.md"
```

Print a quick summary in the terminal:
- Total components found
- Vulnerability counts by severity (if scanned)
- NTIA compliance status (PASS / FAIL with gaps)
- Any `[ACTION REQUIRED]` items

---

## Dependency Resolution Priority

1. **Lock file exists** → use exclusively (most accurate)
2. **Manifest only** → generate SBOM but flag ALL versions as `[UNPINNED]`
3. **No manifest** → scan installed packages (node_modules, site-packages, vendor/) and flag as `[DISCOVERED]`

## License Ambiguity Rules

- **Dual-licensed** (e.g., MIT OR Apache-2.0): count under the MORE permissive license
- **Unknown license**: flag as `[UNKNOWN LICENSE - ACTION REQUIRED]`
- **UNLICENSED/proprietary**: flag as `[PROPRIETARY - LEGAL REVIEW REQUIRED]`

## EU Cyber Resilience Act (CRA) Compliance

If regulatory context includes EU CRA:
1. Verify SBOM covers at least top-level dependencies (the CRA legal minimum, Annex I, Part II, §1); including all transitive dependencies is strongly recommended
2. Check vulnerability disclosure contact is documented in SBOM metadata
3. Verify security update mechanism is described
4. Ensure SBOM format is machine-readable (CycloneDX JSON preferred for CRA)

## Principles

1. **Lock files over manifests** — always prefer pinned versions for accuracy
2. **CycloneDX JSON as default** — widest tooling support and CRA alignment
3. **PURL for every component** — Package URL is the universal identifier
4. **Flag unknown licenses** — these are compliance blockers, not just warnings
5. **Vulnerability enrichment is optional but recommended** — note if skipped
6. **The SBOM is the primary deliverable** — the report is supplementary context
7. **Multi-ecosystem projects get one unified SBOM** — Syft handles this natively
8. **Container SBOMs should include OS packages** — not just application dependencies

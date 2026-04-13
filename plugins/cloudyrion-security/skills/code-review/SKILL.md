---
description: >
  Perform a full security code review with SAST scanning, taint analysis, CWE mapping, OWASP Top 10 coverage,
  and generation of a formal Security Code Review Report. Use this skill whenever the user asks to review code
  for security vulnerabilities, audit a codebase or file for security issues, prepare a security assessment
  before merging, run a SAST scan, check for injection flaws, hardcoded secrets, broken auth, or crypto
  weaknesses. Also trigger when the user mentions 'security review', 'vulnerability scan', 'code audit',
  'pen test the code', 'OWASP check', 'CWE mapping', or wants to generate a security findings report —
  even if they don't use the exact phrase 'security code review'.
---

# Security Code Review

You are acting as a Staff Security Engineer. Your deliverable is a formal Security Code Review Report
saved to `<repo-root>/security-review/`.

Before starting, read the report template:
→ `references/report-template.md` — full Markdown structure for the final report

---

## Step 1 — Collect Context

```bash
# Author & repo metadata
AUTHOR_NAME=$(git config user.name)
AUTHOR_EMAIL=$(git config user.email)
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
BRANCH=$(git rev-parse --abbrev-ref HEAD)
COMMIT=$(git log -1 --format="%h — %s")
REVIEW_DIR=$(git rev-parse --show-toplevel)/security-review
DATE=$(date +%Y%m%d)
REPORT_FILE="$REVIEW_DIR/security-code-review-report-${DATE}.md"
DOC_ID="SCR-${DATE}-001"

mkdir -p "$REVIEW_DIR"
```

### Determine scope
Default to **changed files only** (PR/branch context). Fall back to full repo if working tree is clean:

```bash
# Prefer: files changed vs default branch
FILES=$(git diff --name-only $(git merge-base HEAD main || git merge-base HEAD master) HEAD 2>/dev/null)
# Fallback: staged + unstaged changes
[ -z "$FILES" ] && FILES=$(git diff --name-only HEAD)
# Fallback: all tracked files
[ -z "$FILES" ] && FILES=$(git ls-files)
echo "$FILES"
```

### Detect tech stack
Inspect file extensions and config files to determine the primary language(s). This drives which
vulnerability classes and tools to prioritize:

| Stack | Extra focus areas | Dep scanner |
|-------|------------------|-------------|
| Python | pickle deserialization, `eval`/`exec`, SSTI, `subprocess` | `pip-audit` |
| JavaScript/TS | prototype pollution, XSS, `eval`, regex DoS, npm supply chain | `npm audit` |
| Go | goroutine race conditions, `unsafe` package, `text/template` | `govulncheck` |
| Java/Kotlin | deserialization (ObjectInputStream), JNDI injection, XXE | `mvn dependency-check:check` |
| Rust | `unsafe` blocks, FFI boundaries, panic in libraries | `cargo audit` |
| PHP | type juggling, file inclusion, `unserialize` | `composer audit` |
| C/C++ | buffer overflows, format strings, use-after-free, integer overflow | `cppcheck` |

---

## Step 2 — Run Automated Scans

### 2a. SAST with Semgrep

Detect whether Semgrep is installed and whether Pro is available:

```bash
if command -v semgrep &>/dev/null; then
  # Test if Pro engine is available (licensed)
  if semgrep scan --pro --dry-run 2>&1 | grep -q "error"; then
    SEMGREP_ENGINE="OSS"
    SEMGREP_FLAGS=""
  else
    SEMGREP_ENGINE="Pro"
    SEMGREP_FLAGS="--pro"
  fi

  SEMGREP_JSON="$REVIEW_DIR/semgrep-results-${DATE}.json"

  semgrep scan $SEMGREP_FLAGS \
    --config=p/default \
    --config=p/owasp-top-ten \
    --config=p/secrets \
    --json \
    $FILES 2>/dev/null | tee "$SEMGREP_JSON"

  SEMGREP_EXIT=$?
  echo "Engine: $SEMGREP_ENGINE — Results: $SEMGREP_JSON"
else
  SEMGREP_ENGINE="Not available"
  SEMGREP_EXIT=-1
  echo "WARNING: Semgrep not installed. Proceeding with manual analysis only."
  echo "Install: pip install semgrep OR brew install semgrep"
fi
```

**Semgrep error handling:**
- If Semgrep exits non-zero (`SEMGREP_EXIT != 0`), inspect stderr to distinguish:
  - **Config error** (invalid rule, network failure fetching rulesets): Log the error, retry with `--config=p/default` only. If still failing, proceed with manual analysis and note "Semgrep config error — reduced ruleset" in the report.
  - **Parse error** (unsupported file type, syntax error in target): Log which files failed to parse. These files are **excluded from SAST coverage** — list them explicitly in Appendix D (Coverage Gaps). Continue scanning remaining files.
  - **Timeout**: Note in report, increase `--timeout` flag if re-running.
- Always check the `errors` array in the JSON output — files listed there were not scanned.

For each Semgrep finding, extract: `check_id`, `path`, `start.line`, `extra.message`,
`extra.severity`, `extra.metadata.cwe`, `extra.metadata.confidence`.

**Triage rule**: Semgrep Pro interprocedural findings at HIGH confidence → treat as ground truth
(TP unless you can prove otherwise). OSS syntactic findings → verify manually before classifying.

### 2b. Dependency Scan

Run the appropriate dependency scanner based on the detected stack:

```bash
# Python
pip-audit --format=json 2>/dev/null > "$REVIEW_DIR/dep-audit-${DATE}.json" || true

# Node.js
npm audit --json 2>/dev/null > "$REVIEW_DIR/dep-audit-${DATE}.json" || true

# Go
govulncheck ./... 2>/dev/null > "$REVIEW_DIR/dep-audit-${DATE}.txt" || true

# Rust
cargo audit --json 2>/dev/null > "$REVIEW_DIR/dep-audit-${DATE}.json" || true
```

If the scanner is unavailable, note it in the report and do manual import analysis.

---

## Step 3 — Manual Review

Analyze the in-scope code for the following vulnerability classes. **Map every finding to a CWE.**

### CWE Quick-Reference: Code Pattern → CWE Mapping

Use this table to identify vulnerabilities by matching code patterns to their CWE classification:

| Code Pattern | CWE | Name | Example |
|---|---|---|---|
| `cursor.execute(f"SELECT...{var}")` | CWE-89 | SQL Injection | Any string interpolation/concatenation in SQL |
| `os.system(cmd)`, `subprocess.call(shell=True)` | CWE-78 | OS Command Injection | User input in shell commands |
| `render_template_string(user_input)` | CWE-94 | Code Injection / SSTI | Server-side template injection via Jinja2, Mako, etc. |
| `redirect(request.args['url'])` | CWE-601 | Open Redirect | Unvalidated redirect targets from user input |
| `pickle.loads(data)`, `yaml.load(data)` | CWE-502 | Deserialization of Untrusted Data | Any deserialization of external input |
| `eval(expr)`, `exec(code)` | CWE-94 | Code Injection | Dynamic code execution with user-controlled input |
| `open(user_path)`, `os.path.join(base, user_input)` | CWE-22 | Path Traversal | Unvalidated file paths from user input |
| `innerHTML = user_data`, `| safe` filter | CWE-79 | Cross-Site Scripting (XSS) | Unescaped user input in HTML output |
| `requests.get(user_url)` | CWE-918 | Server-Side Request Forgery (SSRF) | User-controlled URLs in server-side HTTP requests |
| `hashlib.md5(password)` | CWE-327 | Broken Crypto Algorithm | Weak hash/cipher for security-sensitive operations |
| `password = "admin123"` | CWE-798 | Hardcoded Credentials | Secrets embedded in source code |

### 3a. Injection & Taint Flows — Systematic Taint Tracing

For **EVERY HTTP endpoint** (route handler, API view, controller method) in scope, perform this systematic analysis:

1. **Enumerate input sources**: List ALL input sources entering the function:
   - Path parameters (e.g., `/users/<id>`)
   - Query parameters (e.g., `request.args['q']`)
   - HTTP headers (e.g., `request.headers['X-Forwarded-For']`)
   - Cookies (e.g., `request.cookies['session']`)
   - Request body fields (e.g., `request.json['name']`, form data)
   - File uploads (e.g., `request.files['avatar']`, filename, content)

2. **Trace each source through the function**: For each input source identified above, grep/follow the variable through the function body and any functions it calls. Track assignments, transformations, and passes to other functions.

3. **Check if it reaches any sink**: Determine if the traced input reaches any dangerous sink:
   - SQL query (any string building for `execute()`, `raw()`, ORM `.extra()`)
   - Shell command (`os.system`, `subprocess`, `popen`, backticks)
   - File path (`open()`, `os.path.join`, `send_file`, `shutil`)
   - HTML template (`render_template_string`, `Markup()`, `| safe`, `innerHTML`)
   - HTTP redirect (`redirect()`, `Location` header, `301`/`302` responses)
   - Deserializer (`pickle.loads`, `yaml.load`, `json.loads` on structured data → further sinks)
   - HTTP client (`requests.get(url)`, `urllib.urlopen`, `fetch`)
   - Code execution (`eval`, `exec`, `compile`, `Function()`)

4. **Check for sanitizers on the path**: For each source→sink path found, determine if a sanitizer/validator exists between them:
   - Parameterized queries (placeholders, not string building)
   - Input validation (allowlist regex, type casting, length limits)
   - Output encoding (HTML escaping, URL encoding)
   - Path canonicalization (`os.path.realpath` + prefix check)

5. **Rate the finding**:
   - **No sanitizer on the path** → Critical (direct source→sink flow)
   - **Bypassable sanitizer** (blocklist instead of allowlist, incomplete regex, wrong encoding for context) → High
   - **Adequate sanitizer present** → Info (document as defense-in-depth confirmation)

→ CWE-89, CWE-78, CWE-79, CWE-94, CWE-918

### 3b. Authentication & Authorization
Missing/bypassable auth checks, broken access control, IDOR. JWT issues (algorithm confusion,
missing claim validation, weak secrets). Session flaws (fixation, insufficient entropy, missing
invalidation).
→ CWE-287, CWE-285, CWE-384, CWE-798

### 3c. Secrets & Sensitive Data
Hardcoded credentials, API keys, tokens. Secrets in logs, error messages, or API responses. PII
exposure, insecure storage.
→ CWE-312, CWE-315, CWE-359, CWE-798

### 3d. Cryptography
Weak algorithms (MD5, SHA1, DES, ECB). Hardcoded/predictable IVs, salts, keys. Timing-attack
vulnerable comparisons. Improper cert validation, weak RNG.
→ CWE-327, CWE-330, CWE-326, CWE-295

### 3e. OWASP Top 10 (2021) Cross-Check
Walk through all 10 categories (A01–A10) and confirm coverage. Note any gaps.

### 3f. Language-Specific Issues
Refer to the stack table in Step 1. Review for language-specific vulnerability patterns that
generic rules miss.

---

## Step 4 — Severity Scoring & Reachability

Use a consistent Likelihood × Impact matrix for every finding:

| | Impact: Low | Impact: Medium | Impact: High |
|---|---|---|---|
| **Likelihood: High** | Medium | High | Critical |
| **Likelihood: Medium** | Low | Medium | High |
| **Likelihood: Low** | Info | Low | Medium |

### Reachability Criteria

A finding's likelihood depends heavily on whether the sink is reachable from external input. Apply these criteria:

**A sink is REACHABLE if:**
1. It is in a function called (directly or transitively) by an HTTP endpoint handler, message queue consumer, webhook handler, or any other external-facing entry point, AND
2. The input source flows to the sink without being blocked by authentication middleware that would prevent unauthenticated access, OR input validation that fully sanitizes the specific attack vector (e.g., parameterized queries for SQLi, allowlist validation for path traversal).

**A sink is UNREACHABLE if:**
1. It is only called from internal/CLI code paths with no external input (e.g., management commands, migration scripts, internal tooling), OR
2. It is behind authentication AND the vulnerability requires unauthenticated access to exploit, OR
3. The input is fully validated/sanitized before reaching the sink with no bypass path.

**Reachability affects classification:**
- Reachable sink + no sanitizer → use full severity from the matrix
- Reachable sink + bypassable sanitizer → reduce likelihood by one level
- Unreachable sink → classify as `[WARN]` regardless of theoretical severity, with note: "Unreachable from external input — reclassify if exposure changes"

**Likelihood factors**: Is the sink reachable from an external input? Is auth required? Is the
attack trivial or complex? Are there partial mitigations?

**Impact factors**: What data/systems are affected? Can the attacker escalate? Is there lateral
movement potential? What's the blast radius?

---

## Step 5 — Correlate & Deduplicate

- Merge automated + manual findings — never report the same issue twice
- For each Semgrep finding, classify as TP or FP with reasoning
- Document confirmed FPs — they are valuable signal for rule tuning
- Note manual findings that Semgrep missed — these are coverage gaps
- Flag partial mitigations explicitly — incomplete controls can be worse than none

---

## Step 6 — Generate Report

Read the report template: `references/report-template.md`

Write the full report to: `$REPORT_FILE`

```bash
ls -lh "$REVIEW_DIR/"
echo "Report written: $REPORT_FILE"
```

### Classification tags
- `[BLOCK]` — Must fix before merge. Semgrep Pro interprocedural HIGH confidence, or manually
  confirmed exploitable finding rated High/Critical.
- `[WARN]` — Should fix. Medium severity, or high severity with limited reachability.
- `[INFO]` — Improvement opportunity. Low severity, defense-in-depth suggestions.

Print `[BLOCK]` findings directly in terminal output so the developer sees them immediately.

---

## Appendix D — Coverage Gap Identification

When writing Appendix D of the report, systematically identify and document gaps using these criteria:

**A coverage gap exists when:**

1. **Complexity gap**: A code path was too complex for manual analysis (e.g., deeply nested callbacks, dynamic dispatch, reflection-based routing, metaprogramming). Document: which function/module, why it resisted analysis, and what vulnerability classes could hide there.

2. **Runtime-only gap**: A vulnerability class requires runtime testing to confirm (e.g., race conditions, timing side-channels, TOCTOU bugs, session fixation that depends on server config). Document: the suspected class, which code is affected, and recommend specific dynamic tests (e.g., "Run concurrent requests against `/api/transfer` to test for race conditions").

3. **Third-party library gap**: Library internals were not reviewed — only their API usage was checked. Document: which libraries, their security-relevant role (e.g., "jwt-decode handles token validation"), and whether a CVE scan covered them.

4. **Opaque code gap**: Encrypted, obfuscated, minified, or compiled code could not be analyzed. Document: which files, their purpose if known, and whether source maps or unobfuscated versions exist.

5. **Semgrep parse failure gap**: Files that Semgrep failed to parse (from the `errors` array in JSON output). Document: file list, language, and whether manual review covered them as a fallback.

For each gap, provide: (a) what was missed, (b) potential risk if a vulnerability exists there, (c) recommended follow-up action (pentest, dynamic scan, library audit, etc.).

---

## Review Principles

1. Semgrep Pro interprocedural + high confidence = `[BLOCK]` unless proven FP
2. Assess exploitability and reachability — unreachable sinks are `[WARN]` not `[BLOCK]`
3. Tag each finding's analysis tier: Syntactic | Semantic | Interprocedural
4. Confirmed FPs are as valuable as TPs — always document them
5. Never skip a section silently — write "None identified" if empty
6. The report is the deliverable — terminal output is a summary only
7. If no findings exist, still produce the report confirming a clean review

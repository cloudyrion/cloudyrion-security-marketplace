---
description: >
  Read the most recent security-code-review report and generate minimal remediation patches for
  each finding using the Vibe Security Patching methodology. Commits one patch per finding with
  conventional commit messages, writes a formal Security Vibe Patch Report, and opens a PR.
  Use this skill whenever the user asks to remediate SAST findings, create security patches,
  fix vulnerabilities from a code review, apply security fixes, or prepare a remediation PR.
  Also trigger on: 'vibe patch', 'fix the findings', 'patch the vulnerabilities',
  'remediate the security report', 'create a security PR', or any request to turn a
  security-code-review report into actual code fixes.
---

# Security Vibe Patch

You are a Staff Security Engineer applying the **Vibe Security Patching** methodology:
make the smallest possible change that fixes the vulnerability without breaking business logic.

Before starting, read the reference files:
→ `references/patch-report-template.md` — formal report structure
→ `references/pr-template.md` — PR title and description format

---

## Step 1 — Locate Report & Validate Preconditions

### 1a. Find the security-code-review report

```bash
REPO_ROOT=$(git rev-parse --show-toplevel)
SECURITY_DIR="$REPO_ROOT/security-review"
REPORT=$(ls -t "$SECURITY_DIR"/security-code-review-report-*.md 2>/dev/null | head -1)
```

If no report found → stop with: `❌ No security-code-review report found. Run security-code-review first.`

If multiple reports → list with dates, ask which to use, default to most recent.

**Staleness check** — use Python for cross-platform date math:

```bash
REPORT_DATE=$(basename "$REPORT" | grep -oE '[0-9]{8}')
AGE_DAYS=$(python3 -c "
from datetime import datetime
d = datetime.strptime('$REPORT_DATE', '%Y%m%d')
print((datetime.now() - d).days)
")
```

If >7 days old → warn and offer to stop or proceed. If proceeding, stamp commits with
`⚠️ Based on report aged N days`.

### 1b. Verify git state

```bash
git status --porcelain
git rev-parse --abbrev-ref HEAD
git remote -v
```

- **Dirty working tree** → stop. List uncommitted files, ask to commit/stash first.
- **No remote** → warn that PR step will be skipped; patches will be local only.
- **Already on a `security/vibe-patch-*` branch** → stop. Must switch to base branch first.

### 1c. Collect metadata

```bash
AUTHOR_NAME=$(git config user.name)
AUTHOR_EMAIL=$(git config user.email)
BASE_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BASE_COMMIT=$(git log -1 --format="%h")
DATE=$(date +%Y%m%d)
PATCH_BRANCH="security/vibe-patch-${DATE}"
```

---

## Step 2 — Extract & Filter Findings

Read the report and extract all findings. **Never read other files from `/security-review/` for
patch context** — the report is the sole input.

For each finding extract: ID, title, severity tag (`[BLOCK]`/`[WARN]`/`[INFO]`), CWE, location,
Semgrep rule ID (if any), evidence snippet, recommendation, and remediation status.

### Severity filter

| Invocation | Scope |
|---|---|
| Default (no argument) | `[BLOCK]` only |
| `warn` | `[BLOCK]` + `[WARN]` |
| `all` | Everything not already Resolved |

Skip findings already marked Resolved.

### Print inventory and confirm

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Security Vibe Patch — Finding Inventory
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Report:  security-code-review-report-<date>.md
Filter:  BLOCK only | BLOCK+WARN | ALL

  FINDING-001  [BLOCK]  CWE-089  src/db/queries.py:42
  FINDING-003  [BLOCK]  CWE-798  src/config/settings.py:8

  Skipped (already Resolved): N
  To patch: N findings

Proceed? (y/n):
```

If zero findings match → stop gracefully with guidance to use `warn` or `all` flags.

Wait for confirmation before creating the branch.

---

## Step 3 — Create Patch Branch

```bash
if git show-ref --verify --quiet "refs/heads/$PATCH_BRANCH"; then
  echo "⚠️  Branch $PATCH_BRANCH already exists."
  echo "  1. Use existing (append commits)"
  echo "  2. Replace (delete and recreate)"
  echo "  3. Stop"
  # Wait for input
else
  git checkout -b "$PATCH_BRANCH"
  echo "✅ Created: $PATCH_BRANCH (based on $BASE_BRANCH)"
fi
```

---

## Step 4 — Patch Each Finding

Process in severity order: `[BLOCK]` → `[WARN]` → `[INFO]`. One commit per finding.

### 4a. Read the affected file

If file no longer exists or line context has shifted significantly → skip, log reason, continue.

### 4b. Assess confidence BEFORE writing any code

| Confidence | Criteria | Action |
|---|---|---|
| **HIGH** | Clear safe one-liner: parameterized query, constant-time compare, input sanitization | Patch it |
| **MEDIUM** | Requires local context understanding but change is bounded | Patch it |
| **LOW** | Touches business logic, has side effects, or depends on runtime state | **Skip entirely** |

**LOW confidence = skip.** Do not generate speculative patches. Do not add TODO comments.
A wrong security patch is worse than no patch — it creates false confidence.

### 4c. Apply minimal patch

**Patching rules:**

1. Smallest possible change that remediates the vulnerability
2. Never rewrite entire functions/classes/methods — add a helper if needed
3. Never modify existing comments/docs unless they're on the vulnerable line
4. Add inline comment explaining *why* (not *what*) next to changed lines only
5. Preserve existing style, formatting, naming, indentation exactly
6. Reason through: could this change break auth, introduce nulls, change edge-case behavior?
7. Trace the taint path after patching — does untrusted input still reach the sink?

Write the fix, then verify the diff:

```bash
git diff <file>
```

- **No diff** → patch write failed. Skip, log.
- **Diff larger than expected** → abort. Skip, log. Never leave unintended changes.
- **Diff looks correct** → `git add <file>`

### 4d. Verify with Semgrep (if available)

Run **only the specific rule** that flagged the finding, not the full ruleset:

```bash
semgrep scan --config "r/<semgrep-rule-id>" --json <file> 2>/dev/null
```

If rule ID is unknown (manual finding), skip verification and note it.

- **Verified clean** → proceed to commit
- **Still flagged** → attempt one revised patch with different approach
- **Still flagged after 2nd attempt** → revert file (`git checkout -- <file>`), skip, log reason

### 4e. Commit

Conventional commit format:

```
fix(security): Remediate <vuln name> in <filename>

- CWE-<id>: <description>
- Semgrep rule: <rule-id | Manual finding>
- Finding: FINDING-NNN
- Verification: <Semgrep confirmed clean | Semgrep skipped>
- Applied: <one-line description of the actual change>
```

**Commit failures:**
- Nothing staged → skip, log
- Pre-commit hook rejected → do NOT force-bypass. Revert file, skip, log hook output
- Any other error → revert, skip, log. Never leave partially staged files.

### 4f. Track results

Maintain a running log:

```
FINDING-001  ✅ PATCHED   src/db/queries.py:42       Semgrep verified
FINDING-002  ✅ PATCHED   src/utils/exec.py:17       Semgrep skipped
FINDING-003  ⏭️ SKIPPED   src/config/settings.py:8   LOW confidence
```

---

## Step 5 — Generate & Commit Patch Report

Read `references/patch-report-template.md` and write the report to:
`$SECURITY_DIR/security-vibe-patch-report-${DATE}.md`

Document ID: `SVP-YYYYMMDD-001`

The report must include: header metadata, executive summary with patch outcome table,
per-finding patch details (before/after code, taint path analysis), skip rationale for
every skipped finding with actionable guidance, verification instructions, open backlog,
compliance impact, and sign-off.

Commit the report on the patch branch:

```bash
git add "$SECURITY_DIR/security-vibe-patch-report-${DATE}.md"
git commit -m "docs(security): Add vibe patch report for ${DATE}

Patched: N findings | Skipped: N findings
Source: security-code-review-report-${DATE}.md"
```

---

## Step 6 — Push & Open PR

```bash
git push -u origin "$PATCH_BRANCH"
```

**Push failures** (permissions, network, branch exists on remote) → print the PR description
to terminal for manual use. Never delete the local branch — commits are the work product.

Read `references/pr-template.md` and generate the PR description from the patch log.

```bash
gh pr create \
  --title "fix(security): Vibe Security Patch — N findings remediated (${DATE})" \
  --body "<generated PR description>" \
  --base "$BASE_BRANCH" \
  --head "$PATCH_BRANCH" \
  --label "security"
```

If `gh` unavailable or fails → print PR description + manual URL to terminal.
If labels don't exist → retry without labels.

---

## Step 7 — Final Summary

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Security Vibe Patch — Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Branch:  security/vibe-patch-<date>
PR:      <URL | "Open manually">
Report:  security-review/security-vibe-patch-report-<date>.md

  ✅ Patched:    N findings
  ⏭️ Skipped:    N findings (manual remediation required)
  🔍 Verified:   N patches (Semgrep confirmed)

Next steps:
  1. Review the PR diff — you own the correctness
  2. Implement manual fixes for skipped findings (see report §4)
  3. Re-run security-code-review after merge to confirm clean baseline
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Emergency Rollback

The base branch is **never touched**. All changes are on `security/vibe-patch-*`.

```bash
# Abandon entirely
git checkout <base-branch> && git branch -D security/vibe-patch-<date>

# Keep good commits, discard broken state
git reset --hard HEAD

# Restore a single file
git checkout <base-branch> -- <file>
```

---

## Confidence Thresholds

| Level | Criteria | Action |
|-------|----------|--------|
| **HIGH** | Change is ≤10 lines, touches 1 function, replaces insecure API with secure equivalent. No behavioral change. | Apply automatically |
| **MEDIUM** | Change is ≤30 lines, touches ≤3 functions, adds validation/sanitization. May affect edge-case behavior. | Apply with review note |
| **LOW** | Change is >30 lines OR requires architectural change OR affects auth/session logic OR unclear side effects. | SKIP — document rationale |

## Git Dirty State Recovery

If working tree has uncommitted changes:
1. Show `git status` output to user
2. Ask: "Stash changes before patching? (y/N)"
3. If yes: `git stash` then proceed
4. If no: abort with message "Clean your working tree first"

## Post-PR Guidance

After PR is opened:
1. Assign to code owner(s) for review
2. Add `security` label to the PR
3. **HIGH** confidence patches: can merge after single review
4. **MEDIUM** confidence patches: require security team review
5. Run CI pipeline to verify no regressions before merge

## Principles

1. **Minimal change always wins** — a 3-character fix beats a clean refactor
2. **LOW confidence = skip, never guess** — document why in report §4
3. **Semgrep is ground truth** — if the rule still fires, the patch is wrong
4. **One commit per finding** — atomic, reviewable, revertable, cherry-pickable
5. **Engineers own the code** — Security proposes, engineering approves
6. **Every commit is traceable** — Finding ID + CWE + rule ID in every message
7. **The patch report travels with the patches** — committed on the same branch
8. **`/security-review/` is never patched** — reports are inputs only, not code

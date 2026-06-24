#!/usr/bin/env bash
#
# validate-plugin.sh — structural validation for the cloudyrion-security plugin.
#
# Catches the classes of bug that have bitten this plugin before:
#   - skills that reference output variables they never define
#   - cross-references to skills that don't exist (e.g. stale standalone names)
#   - malformed JSON or hook shell commands
#   - skills missing frontmatter / description
#
# Usage:  ./scripts/validate-plugin.sh
# Exit:   0 if all checks pass, 1 otherwise. Safe to run in CI.
#
# Requires: bash, jq, find, grep, awk, sed.
set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_DIR="$REPO_ROOT/plugins/cloudyrion-security"
SKILLS_DIR="$PLUGIN_DIR/skills"
HOOKS="$PLUGIN_DIR/hooks/hooks.json"
FAILED=0

fail() { echo "  ✗ $1"; FAILED=1; }
pass() { echo "  ✓ $1"; }

echo "Validating plugin: $PLUGIN_DIR"
echo

# --- 1. JSON files parse -----------------------------------------------------
echo "[1] JSON files are valid"
while IFS= read -r f; do
  if jq empty "$f" >/dev/null 2>&1; then pass "$(basename "$f")"
  else fail "invalid JSON: ${f#"$REPO_ROOT"/}"; fi
done < <(find "$REPO_ROOT/.claude-plugin" "$PLUGIN_DIR" -name '*.json' 2>/dev/null)

# --- 2. Skill frontmatter has a description ----------------------------------
echo "[2] Skill frontmatter has a description"
for skill in "$SKILLS_DIR"/*/SKILL.md; do
  name=$(basename "$(dirname "$skill")")
  fm=$(awk 'NR==1 && $0=="---"{f=1; next} f && $0=="---"{exit} f{print}' "$skill")
  if [ -n "$fm" ] && printf '%s' "$fm" | grep -q 'description:'; then pass "$name"
  else fail "$name/SKILL.md missing frontmatter description"; fi
done

# --- 3. No stale standalone skill names --------------------------------------
echo "[3] No legacy standalone skill names"
LEGACY='threat-model-generator|api-security-review|iac-security-scanner|sbom-generator'
hits=$(grep -rnE "$LEGACY" "$SKILLS_DIR" 2>/dev/null || true)
if [ -n "$hits" ]; then
  printf '%s\n' "$hits" | sed "s|^$REPO_ROOT/||; s|^|  ✗ legacy name: |"
  FAILED=1
else
  pass "none found"
fi

# --- 4. /cloudyrion-security:<skill> references resolve ----------------------
echo "[4] Skill cross-references resolve"
refs=$(grep -rhoE 'cloudyrion-security:[a-z][a-z-]*' \
         "$SKILLS_DIR" "$PLUGIN_DIR"/*.md "$REPO_ROOT/README.md" 2>/dev/null \
       | sed 's/cloudyrion-security://' | sort -u)
if [ -z "$refs" ]; then
  pass "no references found"
else
  for r in $refs; do
    if [ -d "$SKILLS_DIR/$r" ]; then pass "$r"
    else fail "reference to non-existent skill: $r"; fi
  done
fi

# --- 5. Output variables are defined where used ------------------------------
echo "[5] Output variables are defined before use"
for skill in "$SKILLS_DIR"/*/SKILL.md; do
  name=$(basename "$(dirname "$skill")")
  for var in REPORT_DIR REVIEW_DIR SECURITY_DIR SBOM_DIR REPO_ROOT DATE; do
    if grep -qF "\$$var" "$skill" 2>/dev/null; then
      if ! grep -qE "^[[:space:]]*$var=" "$skill"; then
        fail "$name uses \$$var but never assigns it"
      fi
    fi
  done
done
[ "$FAILED" -eq 0 ] && pass "all skills define the variables they use"

# --- 6. Hook commands pass bash -n ------------------------------------------
echo "[6] Hook commands are syntactically valid"
if [ -f "$HOOKS" ]; then
  i=0
  while IFS= read -r cmd; do
    i=$((i + 1))
    if bash -n <(printf '%s' "$cmd") 2>/dev/null; then pass "hook #$i"
    else fail "hook #$i has a shell syntax error"; fi
  done < <(jq -r '.hooks.PostToolUse[].hooks[].command' "$HOOKS")
else
  fail "hooks.json not found"
fi

echo
if [ "$FAILED" -eq 0 ]; then
  echo "✅ All checks passed."
else
  echo "❌ Validation failed — see ✗ items above."
fi
exit "$FAILED"

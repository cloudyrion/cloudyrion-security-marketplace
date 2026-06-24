# Contributing to CLOUDYRION Security

Thanks for helping improve the plugin. This repo is a Claude Code plugin marketplace; the
plugin itself lives in [`plugins/cloudyrion-security/`](plugins/cloudyrion-security/).

## Repository layout

```
.claude-plugin/marketplace.json        Marketplace manifest
plugins/cloudyrion-security/
  .claude-plugin/plugin.json           Plugin manifest (version, author, license)
  hooks/hooks.json                     PostToolUse hooks
  skills/<name>/SKILL.md               One skill per directory
  skills/<name>/references/*.md        Templates & checklists a skill reads at runtime
scripts/validate-plugin.sh             Structural validation (run before every PR)
```

## Adding or editing a skill

1. Create or edit `plugins/cloudyrion-security/skills/<skill-name>/SKILL.md`.
2. Start the file with YAML frontmatter containing a `description`. The description is what
   tells Claude *when* to trigger the skill — make it specific and list trigger phrases.
3. If the skill writes a report, define its output variables in a setup block **before** using
   them (mirror an existing skill such as `iac-scanner` or `api-security`):
   ```bash
   REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
   DATE=$(date +%Y%m%d)
   REPORT_DIR="$REPO_ROOT/security-review"
   mkdir -p "$REPORT_DIR"
   ```
4. When you reference another skill as an action ("run X"), use the command form
   `/cloudyrion-security:<skill-name>` — never the old standalone names. Use the bare directory
   name (`<skill-name>`) for descriptive mentions.
5. Keep report **filenames** consistent with what `skills/suite/SKILL.md` expects — the suite
   orchestrator and `vibe-patch` locate prior reports by filename.

## Conventions

- Cross-skill invocations: `/cloudyrion-security:<name>`.
- Reports are written to `<repo-root>/security-review/` (SBOM writes to `<repo-root>/sbom/`).
- Update the skill count and skill tables in both `README.md` and
  `plugins/cloudyrion-security/README.md` when you add or remove a skill, and add a
  `CHANGELOG.md` entry.

## Before opening a PR

Run the validator — it checks JSON validity, frontmatter, cross-reference resolution,
output-variable hygiene, and hook shell syntax:

```shell
./scripts/validate-plugin.sh
```

Then test the plugin locally:

```shell
claude --plugin-dir ./plugins/cloudyrion-security
/reload-plugins   # after making changes
```

CI runs the same validator on every push and pull request.

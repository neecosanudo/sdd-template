# Design: Template Expansion and P2 Fixes

## Technical Approach

Hybrid fix: (1) replace hardcoded prose versions with STACK_MAP.md references across 13 files, preserving code-block versions; (2) create 4 new files (CHANGELOG, verify script, agent guide, human guides). Priority: version fixes → changelog → verify → expansion infra.

---

## Design 1: Hardcoded Version Fixes (13 files)

**Rule**: Prose version references → `Ver [STACK_MAP.md](../STACK_MAP.md)`. Code blocks (go.mod, package.json, Dockerfile snippets) UNCHANGED.

| File | Lines | Change |
|------|-------|--------|
| `docs/tools/go.md:3` | `**Versión**: Go 1.25.0` | `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/gorm.md:3-5` | 3 lines with v1.31.1, v1.6.0, v1.6.0 | Single line: `**Versiones**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/sveltekit.md:3-4` | Version + dependencies | `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` — remove deps line |
| `docs/tools/react.md:5-8` | 4 frontmatter lines | `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` — remove Bundler/TS/Styling lines |
| `docs/tools/postgresql.md:3-4` | Version + driver | `**Versiones**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/sqlite.md:5` | `**Versión**: SQLite via GORM driver v1.6.0` | `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/tailwindcss.md:3-4` | 2 version lines | `**Versiones**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/testing.md:3-5` | 3 frontmatter lines | `**Stack**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/swagger-openapi.md:3-4` | swag + UI versions | `**Versiones**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/jwt-auth.md:3` | `**Versiones**: golang-jwt/jwt/v5 v5.3.1...` | `**Versiones**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/docker.md:3` | `**Imágenes Base**: alpine:3.21...` | `**Imágenes Base**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `README.md:21-31` | Version table (11 rows) | Single row: `\| **Stack completo** \| Ver [docs/STACK_MAP.md](docs/STACK_MAP.md) \| — \|` |
| `.atl/standards/CICD_PIPELINE.md:18` | `GO_VERSION: '1.25'` | `GO_VERSION: '1.25'  # see STACK_MAP.md §1` |

**Preserve** all code blocks in all files — versions inside ` ``` ` remain intact.

---

## Design 2: CHANGELOG.md

- **Format**: [Keep a Changelog](https://keepachangelog.com) v1.1
- **Initial version**: `0.1.0`
- **File**: `/CHANGELOG.md`
- **Structure**:
  - `## [Unreleased]` — empty for future work
  - `## [0.1.0] - 2026-04-29` — Added section listing 3 entries:

| Entry | Type | Description |
|-------|------|-------------|
| code-migration-guide | Added | `.atl/patterns/code-migration.md` — 6-step SDD-aligned migration protocol |
| template-glossary | Added | `.atl/glossary.md` — Canonical SDD terms (Explore/Propose/Spec/Design/Tasks/Apply/Verify/Archive) |
| this-change | Added | Template expansion: STACK_MAP.md version references, CHANGELOG, verify-template.sh, TOOL_EXPANSION.md, ADD_NEW_TOOL.md, TEMPLATE.md |

- Links footer: `[0.1.0]: https://github.com/neocono/sdd-template/releases/tag/v0.1.0`

---

## Design 3: verify-template.sh

**File**: `/verify-template.sh`. Shebang `#!/usr/bin/env bash`. Exits non-zero on any failure.

| Check | Implementation |
|-------|---------------|
| **C1: Required files** | `for f in .atl/glossary.md docs/STACK_MAP.md README.md .atl/standards/CICD_PIPELINE.md .atl/governance/ENGINEERING_MANIFEST.md` |
| **C2: No hardcoded versions** | `grep -rn '\*\*Versión\*\*: [^V]' docs/tools/` — match any `**Versión**:` not followed by `Ver` |
| **C3: Cross-reference links** | Extract `\[text\]\(([^)]+\.md)\)` from all `.md` files, resolve relative to file dir, verify `test -f` |
| **C4: Glossary terms** | Read `.atl/glossary.md` canonical terms, `grep -rw` across markdown for deprecated synonyms (e.g., "Analyse" → "Explore") |
| **C5: Tool guide structure** | For each `docs/tools/*.md` (excluding TEMPLATE.md itself): verify headings contain `## 1.`, `## 2.`, etc. per TEMPLATE.md sections |

---

## Design 4: `.atl/agent/TOOL_EXPANSION.md`

**Trigger**: When user provides `go.mod`, `package.json`, `Cargo.toml`, `bun.lockb`, or mentions a tool not yet in `docs/tools/`.

**Workflow**:
1. **Detect** — Read `go.mod`/`package.json`/`bun.lockb` to extract dependencies ordered by directness
2. **Map** — For each dependency, check `docs/tools/` for existing guide. If found, note cross-reference
3. **Create** — For unmapped tools, copy `docs/tools/TEMPLATE.md → docs/tools/<tool>.md`, fill sections
4. **Register** — Update `docs/STACK_MAP.md` (add row to §1 + version), add cross-ref in §7
5. **Patterns** — If tool has recurring patterns, create `.atl/patterns/<tool-pattern>.md`
6. **Verify** — Run `verify-template.sh`

**Decision tree**: `existing guide → create PR reference` / `new tool → TEMPLATE.md → STACK_MAP.md → verify`

---

## Design 5: `docs/tools/ADD_NEW_TOOL.md`

**Audience**: Human contributors extending the template.

| Step | Action | Verification |
|------|--------|-------------|
| 1 | Verify tool is in STACK_MAP.md or confirmed in user project | `grep <tool> docs/STACK_MAP.md` |
| 2 | Copy `TEMPLATE.md → docs/tools/<tool>.md` | File exists |
| 3 | Fill sections: What, Why, When, Installation, Usage, Patterns, Anti-Patterns, References | All 8 sections present |
| 4 | Create `.atl/patterns/<tool-pattern>.md` if applicable | Pattern file exists |
| 5 | Update STACK_MAP.md (§1 + §7) with version + compatibility | Cross-reference added |
| 6 | Update README.md if tool is in "Stack del Proyecto" table | Row added/changed |

---

## Design 6: `docs/tools/TEMPLATE.md`

**Frontmatter** (first 5 lines):
```
# {Tool Name} — {Category}

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [go.md](go.md)
```

**Required sections** (empty skeletons):

| Section | Heading | Content Type |
|---------|---------|-------------|
| 1 | `## 1. ¿Qué es?` | 1-paragraph tool description |
| 2 | `## 2. ¿Por qué esta herramienta?` | Rationale vs alternatives |
| 3 | `## 3. Cuándo usar` | Decision table (✅/❌ scenarios) |
| 4 | `## 4. Instalación` | Bash code block |
| 5 | `## 5. Uso básico` | 2-3 code examples with ✅/❌ |
| 6 | `## 6. Patrones recomendados` | Bullet-list patterns |
| 7 | `## 7. Anti-patrones` | Common mistakes to avoid |
| 8 | `## 8. Referencias` | Cross-links to related guides |

---

## File Changes Summary

| File | Action |
|------|--------|
| 11 docs/tools/*.md | Modify (version lines) |
| README.md | Modify (version table → ref) |
| .atl/standards/CICD_PIPELINE.md | Modify (comment-only) |
| CHANGELOG.md | **Create** |
| verify-template.sh | **Create** (chmod +x) |
| .atl/agent/TOOL_EXPANSION.md | **Create** |
| docs/tools/ADD_NEW_TOOL.md | **Create** |
| docs/tools/TEMPLATE.md | **Create** |

## Testing Strategy

Manual: run `bash verify-template.sh` after all changes — must exit 0. No automated tests (pure infra).

## Open Questions

None.

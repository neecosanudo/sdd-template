# Tasks: template-expansion-and-p2-fixes

## Batch 1: Fix Hardcoded Versions (R1 — STACK_MAP.md as Source of Truth)

> **Rule**: Replace version prose with `Ver [STACK_MAP.md](../STACK_MAP.md)` reference. Preserve ALL code blocks, dependency lists, and data tables unchanged.

### Task 1.1: Update README.md stack table → single STACK_MAP.md reference

**File**: `README.md`
**Action**: Replace lines 21-31 (9-row version table) with a single row referencing STACK_MAP.md.
**Before**:
```
| Categoría | Herramienta | Versión |
|-----------|-------------|---------|
| **Backend** | Go + GORM | 1.25.0 + v1.31.1 |
| **Frontend Principal** | SvelteKit | 2.0.0 |
| **Frontend Prototipos** | React | 19.0.0 |
| **Styling** | TailwindCSS | 3.4.1 (SvelteKit) / 4.1.14 (React) |
| **Auth** | JWT (golang-jwt/v5) + bcrypt | v5.3.1 + v0.50.0 |
| **DevOps** | Docker + docker-compose | multi-stage |
| **Database** | PostgreSQL + SQLite (dev) | 16-alpine |
| **Testing** | Go test + Vitest + Playwright | v1.8.4 + ^2.0.0 + 1.50.1 |
| **Metodología** | SDD/TDD | Mandatorio |
```
**After**:
```
| Fuente | Detalle |
|--------|---------|
| 📄 Stack completo | Ver [STACK_MAP.md](docs/STACK_MAP.md) — versiones exactas y matriz de compatibilidad |
```
**Keep**: Lines 33-35 (existing "Stack Map" subsection) — merge or remove duplicate.
**Do NOT change**: Line 53 (`Go 1.25` in Prerequisites — this is a code example context), lines 80-81 (`go get` commands — code blocks per spec).

### Task 1.2: Update `docs/tools/go.md` version line

**File**: `docs/tools/go.md`
**Action**: Replace line 3.
**Before**: `**Versión**: Go 1.25.0`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Line 13 (`go version go1.25.0` — inside code block).

### Task 1.3: Update `docs/tools/sveltekit.md` version line

**File**: `docs/tools/sveltekit.md`
**Action**: Replace line 3 only.
**Before**: `**Versión**: SvelteKit 2.0.0`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Line 4 (`**Dependencias**: Svelte 4.2.0, TypeScript 5.3.3, Vite 5.0.3, TailwindCSS 3.4.1` — this is a dependency list, not a version statement).

### Task 1.4: Update `docs/tools/react.md` version line

**File**: `docs/tools/react.md`
**Action**: Replace line 5 only.
**Before**: `**Versión**: React 19.0.0`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Lines 6-8 (`**Bundler**`, `**TypeScript**`, `**Styling**` — these are tool configuration references, not primary version statements).

### Task 1.5: Update `docs/tools/gorm.md` version line

**File**: `docs/tools/gorm.md`
**Action**: Replace line 3 only.
**Before**: `**Versión**: GORM v1.31.1`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Lines 4-5 (driver versions — these are dependency references).

### Task 1.6: Update `docs/tools/docker.md` images line

**File**: `docs/tools/docker.md`
**Action**: Replace line 3.
**Before**: `**Imágenes Base**: alpine:3.21, golang:1.25-alpine3.21, oven/bun:1-alpine`
**After**: `**Imágenes Base**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Any Dockerfile code blocks (lines 13+).

### Task 1.7: Update `docs/tools/postgresql.md` version line

**File**: `docs/tools/postgresql.md`
**Action**: Replace line 3 only.
**Before**: `**Versión**: PostgreSQL 16-alpine`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Line 4 (driver version — dependency reference).

### Task 1.8: Update `docs/tools/sqlite.md` version line

**File**: `docs/tools/sqlite.md`
**Action**: Replace line 5 only.
**Before**: `**Versión**: SQLite via GORM driver v1.6.0`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Line 7 (driver reference).

### Task 1.9: Update `docs/tools/tailwindcss.md` version lines

**File**: `docs/tools/tailwindcss.md`
**Action**: Replace lines 3-4.
**Before**:
```
**Versión SvelteKit**: TailwindCSS 3.4.1
**Versión React**: TailwindCSS 4.1.14 (@tailwindcss/vite plugin)
```
**After**:
```
**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
```
**Do NOT change**: Comparison table content (per spec: "the table is NOT a version line but IS a data reference, keep it as-is").

### Task 1.10: Update `docs/tools/swagger-openapi.md` version line

**File**: `docs/tools/swagger-openapi.md`
**Action**: Replace line 3 only.
**Before**: `**Versión swag**: v1.16.6`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Line 4 (`**UI**: http-swagger v2` — tool reference, not version statement).

### Task 1.11: Update `docs/tools/jwt-auth.md` version line

**File**: `docs/tools/jwt-auth.md`
**Action**: Replace line 3.
**Before**: `**Versiones**: golang-jwt/jwt/v5 v5.3.1, golang.org/x/crypto v0.50.0`
**After**: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
**Do NOT change**: Any import code blocks.

### Task 1.12: Update `docs/tools/testing.md` version lines

**File**: `docs/tools/testing.md`
**Action**: Replace lines 3-5.
**Before**:
```
**Backend**: Go testing (stdlib) + testify v1.8.4
**Frontend Unit**: Vitest ^2.0.0
**Frontend E2E**: Playwright 1.50.1
```
**After**:
```
**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
```

### Task 1.13: Update `.atl/standards/CICD_PIPELINE.md` GO_VERSION

**File**: `.atl/standards/CICD_PIPELINE.md`
**Action**: Add comment to line 18.
**Before**: `GO_VERSION: '1.25'`
**After**: `GO_VERSION: '1.25'  # see STACK_MAP.md §1`

---

## Batch 2: Create Infrastructure (R2 + R3)

### Task 2.1: Create `CHANGELOG.md`

**File**: `CHANGELOG.md` (root)
**Format**: Keep a Changelog (keepachangelog.com)
**Content**:
- Header with title and description
- `[Unreleased]` section (empty, ready for future changes)
- `[0.1.0]` section with three entries populated from existing archived changes:
  - **Added**: SDD framework infrastructure (`.atl/` governance, standards, patterns, agent behavior)
  - **Added**: Tool documentation for 11 tools (Go, SvelteKit, React, GORM, Docker, PostgreSQL, SQLite, TailwindCSS, Swagger/OpenAPI, JWT Auth, Testing)
  - **Added**: Stack version mapping (`STACK_MAP.md`) and project navigation specs
- Links section at bottom with `[Unreleased]` and `[0.1.0]` pointing to comparison URLs (use placeholder `https://github.com/neocono/sdd-template/compare/...`)

### Task 2.2: Create `verify-template.sh`

**File**: `verify-template.sh` (root, executable `chmod +x`)
**Language**: Bash
**Five checks (C1-C5)**:

| # | Check | Implementation |
|---|-------|---------------|
| C1 | Required files | Check existence of `.atl/glossary.md`, `docs/STACK_MAP.md`, `README.md`, `.atl/governance/ENGINEERING_MANIFEST.md`, `.atl/standards/STYLE_GUIDE.md`, `.atl/standards/TESTING_STRATEGY.md`, `.atl/standards/CICD_PIPELINE.md`, `.atl/standards/RELEASE_AND_RUN.md`, `.atl/standards/WORKING_STANDARD.md` |
| C2 | No hardcoded versions | `grep -rn '^\*\*Versi.n\*\*: [A-Za-z]' docs/tools/*.md` — should match nothing. Lines starting with `**Versión**: Ver` are OK. Skip content inside fenced code blocks. |
| C3 | Valid cross-references | Extract all `[text](path.md)` markdown links from all `.md` files. For each relative link, verify target file exists. Skip `http://` and `https://` links. Skip anchor-only links (`#section`). |
| C4 | Glossary terms | Read canonical terms from `.atl/glossary.md`. Check that SDD phase names use canonical forms (e.g., "Explore" not "Analyse", "Propose" not "Proposal"). Report file + line + expected term. |
| C5 | Tool guide structure | For each `docs/tools/*.md` (except `TEMPLATE.md` and `ADD_NEW_TOOL.md`), verify it contains required section headings: `## 1.`, `## 2.` at minimum (numbered sections per template convention). |

**Exit behavior**:
- Print `PASS: C1 — Required files` (or `FAIL: C1 — ...`) for each check
- Exit 0 if all pass, exit 1 if any fail
- Each FAIL prints: file path, line number (where applicable), and expected vs actual

---

## Batch 3: Create Expansion Guides (R4 + R5 + R6)

### Task 3.1: Create `.atl/agent/TOOL_EXPANSION.md`

**File**: `.atl/agent/TOOL_EXPANSION.md`
**Purpose**: Agent workflow for analyzing user projects and expanding template with new tool guides.
**Content**: 6-step workflow:
1. **Detect stack**: Parse `go.mod`, `package.json`, `Cargo.toml`, etc. from user project
2. **Map to existing guides**: Compare detected tools against `docs/tools/*.md` — mark which are covered
3. **Identify gaps**: List tools with no existing guide
4. **Create new guides**: For each uncovered tool, copy `docs/tools/TEMPLATE.md` as boilerplate and fill in
5. **Update STACK_MAP.md**: Add version, compatibility, and usage notes for each new tool
6. **Update cross-references**: Add references in existing guides that should link to the new tool

Include decision table for unknown tools (e.g., `bun.lockb` → create `docs/tools/bun.md`).

### Task 3.2: Create `docs/tools/ADD_NEW_TOOL.md`

**File**: `docs/tools/ADD_NEW_TOOL.md`
**Purpose**: Human-facing 6-step guide for adding a new tool to the template.
**Content**: Table format with 6 steps:

| Step | Action | Detail |
|------|--------|--------|
| 1 | Verify tool usage | Confirm tool is in `STACK_MAP.md` or user project actually uses it |
| 2 | Copy template | `cp docs/tools/TEMPLATE.md docs/tools/<tool-name>.md` |
| 3 | Fill sections | Complete: What, Why, When to Use, Installation, Basic Usage, Patterns, Anti-Patterns, References |
| 4 | Create patterns (if applicable) | Add `.atl/patterns/<tool-pattern>.md` for reusable patterns |
| 5 | Update STACK_MAP.md | Add version, compatibility notes, and usage context |
| 6 | Update README.md | Add to stack table if tool belongs in the main stack |

### Task 3.3: Create `docs/tools/TEMPLATE.md`

**File**: `docs/tools/TEMPLATE.md`
**Purpose**: Copy-paste boilerplate skeleton for new tool guides (NOT instructional prose).
**Content**:
```markdown
# <Tool Name> — <Short Description>

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Categoría**: <backend|frontend|devops|database|testing|auth>
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [<related-tool>.md](<related-tool>.md)

---

## 1. Visión General

> <One-sentence description of what this tool does>

## 2. Cuándo Usar <Tool> (y Cuándo NO)

| Caso | ✅ Usar | ❌ NO usar |
|------|---------|-----------|
| ... | ... | ... |

## 3. Instalación

```bash
# Installation commands
```

## 4. Uso Básico

```
# Basic usage examples
```

## 5. Patrones

### <Pattern Name>

```
# Pattern code example
```

## 6. Anti-Patrones

### ❌ BAD: <Anti-pattern description>

```
# Bad code
```

### ✅ GOOD: <Correct approach>

```
# Good code
```

## 7. Referencias

- [Official Documentation](https://...)
- [Related pattern](../../.atl/patterns/<pattern>.md)
```

---

## Batch 4: Verification

### Task 4.1: Run `verify-template.sh` and fix any issues

- Execute `./verify-template.sh`
- All 5 checks (C1-C5) must PASS
- If any FAIL, fix the underlying issue and re-run until all pass

### Task 4.2: Verify all tool guides have consistent format

- All `docs/tools/*.md` (except `TEMPLATE.md` and `ADD_NEW_TOOL.md`) must have:
  - Frontmatter with `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`
  - `**Referencias**:` line with links
  - Numbered sections starting at `## 1.`
  - At least one code block

### Task 4.3: Verify no hardcoded versions remain (except code blocks)

- Search all `docs/tools/*.md` for lines matching `**Versión**: <version-number>` pattern
- Only `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` should exist
- Code blocks with version numbers (e.g., `go get gorm@v1.31.1`) must be preserved

### Task 4.4: Verify all new files are correct

- `CHANGELOG.md`: Valid keepachangelog format, has `[Unreleased]` and `[0.1.0]` sections
- `verify-template.sh`: Executable, runs 5 checks, exits correctly
- `.atl/agent/TOOL_EXPANSION.md`: Contains 6-step agent workflow
- `docs/tools/ADD_NEW_TOOL.md`: Contains 6-step human guide table
- `docs/tools/TEMPLATE.md`: Contains boilerplate skeleton with all 7 sections

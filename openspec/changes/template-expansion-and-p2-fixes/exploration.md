# Exploration: Template Expansion and P2 Fixes

**Date**: 2026-04-29
**Change**: template-expansion-and-p2-fixes
**Status**: Complete

---

## Executive Summary

The sdd-template has a well-structured documentation system with 11 tool guides, clear governance via `.atl/`, and a centrally-maintained `STACK_MAP.md`. However, P2 issues persist: versions are hardcoded across 13+ files instead of referencing STACK_MAP.md, there's no cross-reference validation, no template changelog, no verify-template script, and no guide for adding new tools. The "template expansion" scope involves creating agent instructions for analyzing user projects and mapping them to appropriate template tools/patterns.

---

## 1. Current State Analysis

### 1.1 Template Structure (Excellent Foundation)

The template has a mature structure:

```
.atl/
├── governance/      # ENGINEERING_MANIFEST.md, COMMIT_CONVENTIONS.md, VERSIONING.md
├── standards/       # WORKING_STANDARD.md, CICD_PIPELINE.md, TESTING_STRATEGY.md
├── patterns/        # go-hexagonal.md, svelte-component.md, gorm-repository.md
├── agent/           # AGENT_BEHAVIOR.md
├── specs/           # navigation.spec.md
└── decisions/       # ADRs (api-first.md, tdd.md, hexagonal-architecture.md)

docs/
├── STACK_MAP.md     # ✅ Centralized version catalog (THE source of truth)
├── tools/           # 11 tool guides (go.md, sveltekit.md, react.md, etc.)
└── decisions/       # Architecture decision records
```

### 1.2 Version Management (P2 Issue #1)

**STACK_MAP.md** is properly maintained with exact versions and compatibility matrix. However, **13+ files hardcode versions** instead of referencing STACK_MAP.md:

| File | Hardcoded Versions |
|------|-------------------|
| `README.md` | Go 1.25.0, GORM v1.31.1, SvelteKit 2.0.0, React 19.0.0, TailwindCSS 3.4.1/4.1.14, JWT v5.3.1, PostgreSQL 16-alpine, Vitest ^2.0.0, Playwright 1.50.1 |
| `docs/tools/go.md` | Go 1.25.0 (line 3, 13, 119, 131), GORM v1.31.1 (line 122) |
| `docs/tools/sveltekit.md` | SvelteKit 2.0.0, Svelte 4.2.0, TypeScript 5.3.3, Vite 5.0.3, TailwindCSS 3.4.1 |
| `docs/tools/react.md` | React 19.0.0, Vite 6.2.0, TypeScript ~5.8.2, TailwindCSS 4.1.14 |
| `docs/tools/gorm.md` | GORM v1.31.1, postgres driver v1.6.0, sqlite driver v1.6.0 |
| `docs/tools/docker.md` | golang:1.25-alpine3.21 (lines 3, 15, 225, 232), alpine:3.21 (lines 3, 36, 100, 228) |
| `docs/tools/postgresql.md` | PostgreSQL 16-alpine, GORM driver v1.6.0 |
| `docs/tools/sqlite.md` | GORM driver v1.6.0 |
| `docs/tools/tailwindcss.md` | TailwindCSS 3.4.1 (SvelteKit), 4.1.14 (React) |
| `docs/tools/swagger-openapi.md` | swag v1.16.6, http-swagger v2 |
| `docs/tools/jwt-auth.md` | jwt/v5 v5.3.1, crypto v0.50.0 |
| `docs/tools/testing.md` | testify v1.8.4, Vitest ^2.0.0, Playwright 1.50.1 |
| `.atl/standards/CICD_PIPELINE.md` | GO_VERSION: '1.25' (line 18) |

**Problem**: When versions change (e.g., Go 1.26.0 releases), you must update 13+ files manually.

**Solution**: Replace hardcoded versions with references to STACK_MAP.md, EXCEPT in:
- Code examples that show `go.mod` or `package.json` content (these are intentional)
- STACK_MAP.md itself (the source of truth)

### 1.3 Cross-Reference Validation (P2 Issue #2)

**Current state**: Tool docs have manual cross-reference sections at the bottom, but no validation.

**Example from `docs/tools/go.md` lines 204-208**:
```markdown
## 7. Integración con Otras Guías
- **Testing**: Ver [testing.md](testing.md)
- **Auth**: Ver [jwt-auth.md](jwt-auth.md)
- **GORM**: Ver [gorm.md](gorm.md)
- **Docker**: Ver [docker.md](docker.md)
- **Swagger**: Ver [swagger-openapi.md](swagger-openapi.md)
```

**Problems identified**:
1. No validation that `testing.md`, `jwt-auth.md` actually exist
2. No validation that links aren't broken
3. STACK_MAP.md references in tool docs are inconsistent (some use `../STACK_MAP.md`, others use `[STACK_MAP.md](../STACK_MAP.md)`)

### 1.4 Template Versioning/Changelog (P2 Issue #3)

**Current state**:
- `.atl/governance/VERSIONING.md` exists but only defines SemVer policy
- NO `CHANGELOG.md` at template root
- NO version history tracking template changes

**Finding**: The template has been actively developed (4 archived changes in `openspec/changes/archive/`), but no user-facing changelog exists.

### 1.5 Verify-Template Script (P2 Issue #4)

**Current state**: No verify-template script exists.

**What it should check**:
1. **Structure integrity**: All required `.atl/` directories and files exist
2. **Version consistency**: No hardcoded versions (except in code examples)
3. **Cross-references**: All `[link](file.md)` references resolve
4. **Glossary compliance**: All SDD phase terms match `.atl/glossary.md`
5. **STACK_MAP.md sync**: Tool docs reference STACK_MAP.md
6. **Language convention**: Docs in Spanish (AR), code in English

### 1.6 "How to Add a New Tool" Guide (P2 Issue #5)

**Current state**: No guide exists.

**User's projects for expansion context**:
- `agenda/`: AI Studio app (Node.js, Gemini API) - needs `docs/tools/gemini.md` or `docs/tools/nodejs.md`
- `personal-web-page/`: SvelteKit + Go + SQLite/PostgreSQL (matches template stack)
- `suite/`: Contains `api-document`, `components-designer` subprojects

**Scope of "template expansion"**: Create a guide for the AGENT (not user) that explains:
1. How to analyze a user's project (tech stack detection)
2. How to map detected tools to template `docs/tools/` guides
3. How to create new tool guides following template conventions
4. Where the guide should live: `.atl/agent/TOOL_EXPANSION.md` (agent-facing) or `docs/tools/ADD_NEW_TOOL.md` (public template guide)

---

## 2. P2 Issues - Complete List with File Locations

### Issue #1: Hardcoded Versions (Priority: Medium)

| # | File | Line Numbers | Versions Hardcoded |
|---|------|-------------|-------------------|
| 1 | `README.md` | 23-31, 53 | Go 1.25, GORM v1.31.1, SvelteKit 2.0.0, React 19.0.0, TailwindCSS 3.4.1/4.1.14, JWT v5.3.1, PostgreSQL 16-alpine, Testify v1.8.4, Vitest ^2.0.0, Playwright 1.50.1 |
| 2 | `docs/tools/go.md` | 3, 13, 119, 122-125, 131 | Go 1.25.0, GORM v1.31.1, postgres driver v1.6.0, JWT v5.3.1 |
| 3 | `docs/tools/sveltekit.md` | 3-4 | SvelteKit 2.0.0, Svelte 4.2.0, TypeScript 5.3.3, Vite 5.0.3, TailwindCSS 3.4.1 |
| 4 | `docs/tools/react.md` | 5-8 | React 19.0.0, Vite 6.2.0, TypeScript ~5.8.2, TailwindCSS 4.1.14 |
| 5 | `docs/tools/gorm.md` | 3-5 | GORM v1.31.1, postgres driver v1.6.0, sqlite driver v1.6.0 |
| 6 | `docs/tools/docker.md` | 3, 15, 225, 232 | golang:1.25-alpine3.21, alpine:3.21 |
| 7 | `docs/tools/postgresql.md` | 3-4 | PostgreSQL 16-alpine, GORM driver v1.6.0 |
| 8 | `docs/tools/sqlite.md` | 5 | SQLite driver v1.6.0 |
| 9 | `docs/tools/tailwindcss.md` | 3-4 | TailwindCSS 3.4.1, 4.1.14 |
| 10 | `docs/tools/swagger-openapi.md` | 3-4 | swag v1.16.6, http-swagger v2 |
| 11 | `docs/tools/jwt-auth.md` | 3 | jwt/v5 v5.3.1, crypto v0.50.0 |
| 12 | `docs/tools/testing.md` | 3-5 | testify v1.8.4, Vitest ^2.0.0, Playwright 1.50.1 |
| 13 | `.atl/standards/CICD_PIPELINE.md` | 18 | GO_VERSION: '1.25' |

**Fix approach**: Replace version numbers with `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` except in code examples.

### Issue #2: No Cross-Reference Validation (Priority: Medium)

**Files affected**: All 11 `docs/tools/*.md` files have cross-reference sections.

**Fix approach**: Create `verify-template.sh` script that:
1. Extracts all `[text](link.md)` patterns
2. Validates linked files exist
3. Reports broken links

### Issue #3: No Template Versioning/Changelog (Priority: Medium)

**Files affected**: Missing `CHANGELOG.md` at template root.

**Fix approach**: 
1. Create `CHANGELOG.md` with template version history
2. Update `.atl/governance/VERSIONING.md` to reference CHANGELOG.md
3. Add version tags to git: `git tag -a v1.0.0 -m "Initial template release"`

### Issue #4: No verify-template Script (Priority: Medium)

**Files affected**: Missing `verify-template.sh` at template root.

**Fix approach**: Create `verify-template.sh` (see Section 4 below for full spec).

### Issue #5: No "How to Add a New Tool" Guide (Priority: Medium)

**Files affected**: Missing guide in `docs/tools/` or `.atl/agent/`.

**Fix approach**: Create guide (see Section 3 below for format).

---

## 3. Recommended Approach for Template Expansion Guide

### 3.1 Scope Clarification

"Template expansion with user projects" means:
1. **Agent analyzes** user's project (detect tech stack)
2. **Agent maps** detected tools to existing `docs/tools/` guides
3. **Agent creates** new tool guide if tool not in template
4. **Agent updates** STACK_MAP.md with new tool/version

### 3.2 Guide Format

**Location**: `.atl/agent/TOOL_EXPANSION.md` (agent-only instructions)

**Structure**:
```markdown
# Tool Expansion Guide (Agent Instructions)

## When to Use This Guide
- User says: "I'm using X tool" or "Add X to my project"
- Agent detects unknown tool during project analysis

## Step 1: Detect Tech Stack
[Commands to detect tools: go.mod, package.json, requirements.txt, etc.]

## Step 2: Map to Template Tools
| Detected Tool | Template Guide | Action |
|---------------|----------------|--------|
| Express.js | NEW → create express.md | Document it |
| SvelteKit | sveltekit.md | Reference it |
| Unknown DB | NEW → create {db}.md | Document it |

## Step 3: Create New Tool Guide
Follow template: docs/tools/TEMPLATE.md (create this too)

## Step 4: Update STACK_MAP.md
Add tool to Section 1 (Stack Principal or appropriate category)

## Step 5: Update .atl/glossary.md (if needed)
Add new terms to glossary
```

### 3.3 Alternative: Public Template Guide

**Location**: `docs/tools/ADD_NEW_TOOL.md`

**Audience**: Humans who want to contribute to the template

**Pros**: Human-readable, follows existing `docs/tools/` convention
**Cons**: Not agent-specific, may confuse users

**Recommendation**: Create BOTH:
- `.atl/agent/TOOL_EXPANSION.md` (agent instructions)
- `docs/tools/ADD_NEW_TOOL.md` (human contribution guide)
- `docs/tools/TEMPLATE.md` (boilerplate for new tool docs)

---

## 4. Verify-Template Script Specification

### 4.1 Script Location

`verify-template.sh` at template root.

### 4.2 Checks to Implement

```bash
#!/bin/bash
# verify-template.sh - Validates template integrity

set -e

TEMPLATE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ERRORS=0

echo "🔍 Verifying sdd-template integrity..."
echo ""

# Check 1: Required files exist
echo "📁 Checking required files..."
REQUIRED_FILES=(
    ".atl/governance/ENGINEERING_MANIFEST.md"
    ".atl/standards/WORKING_STANDARD.md"
    ".atl/glossary.md"
    "docs/STACK_MAP.md"
    "README.md"
    "CHANGELOG.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$TEMPLATE_ROOT/$file" ]; then
        echo "❌ Missing: $file"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ Found: $file"
    fi
done

# Check 2: No hardcoded versions in tool docs (except code examples)
echo ""
echo "🔢 Checking for hardcoded versions..."
if grep -rn "1\.25\.0\|v1\.31\.1\|2\.0\.0\|19\.0\.0\|3\.4\.1\|4\.1\.14" \
    "$TEMPLATE_ROOT/docs/tools/" \
    --include="*.md" | grep -v "STACK_MAP.md\|code\|example"; then
    echo "⚠️  Hardcoded versions found (should reference STACK_MAP.md)"
    ERRORS=$((ERRORS + 1))
fi

# Check 3: Cross-references valid
echo ""
echo "🔗 Checking cross-references..."
# Extract all [text](link.md) patterns and validate
find "$TEMPLATE_ROOT/docs/tools/" -name "*.md" -exec grep -oP '\[.*?\]\(([^)]+)\)' {} \; | \
    grep -oP '(?<=\().*?(?=\))' | while read -r link; do
    if [[ "$link" != http* ]] && [ ! -f "$TEMPLATE_ROOT/docs/tools/$link" ]; then
        echo "❌ Broken link: $link"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check 4: SDD phase terms match glossary
echo ""
echo "📖 Checking SDD terminology..."
# Verify Explore/Propose/Spec/Design/Tasks/Apply/Verify are used (not deprecated terms)
if grep -rn "Analyse\|Analysis" "$TEMPLATE_ROOT/.atl/" --include="*.md" | grep -v "glossary.md"; then
    echo "⚠️  Deprecated terms 'Analyse/Analysis' found (use Explore/Propose/Spec)"
    ERRORS=$((ERRORS + 1))
fi

# Report
echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ Template verification passed!"
    exit 0
else
    echo "❌ Template verification failed with $ERRORS error(s)"
    exit 1
fi
```

### 4.3 Script Features

| Check | Purpose | Implementation |
|-------|---------|----------------|
| Required files | Ensure template structure intact | Check file existence |
| Hardcoded versions | Enforce STACK_MAP.md reference | grep for version patterns |
| Cross-references | Validate internal links | Extract markdown links, check files |
| SDD terminology | Glossary compliance | Check for deprecated terms |
| Language convention | Docs in Spanish, code in English | Check file content language |

---

## 5. File Structure Recommendations

### 5.1 New Files to Create

```
sdd-template/
├── CHANGELOG.md                          # NEW: Template version history
├── verify-template.sh                     # NEW: Template integrity checker
├── docs/tools/
│   ├── ADD_NEW_TOOL.md                   # NEW: Human guide for adding tools
│   └── TEMPLATE.md                       # NEW: Boilerplate for tool docs
└── .atl/
    ├── agent/
    │   └── TOOL_EXPANSION.md             # NEW: Agent instructions for expansion
    └── patterns/
        └── (existing patterns remain)
```

### 5.2 Files to Modify (P2 Fixes)

| File | Change |
|------|--------|
| `README.md` | Replace hardcoded versions with "Ver STACK_MAP.md" |
| `docs/tools/go.md` | Line 3: `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `docs/tools/sveltekit.md` | Line 3-4: Reference STACK_MAP.md |
| `docs/tools/react.md` | Line 5-8: Reference STACK_MAP.md |
| `docs/tools/gorm.md` | Line 3-5: Reference STACK_MAP.md |
| `docs/tools/docker.md` | Line 3, 15, 225, 232: Reference STACK_MAP.md |
| `docs/tools/postgresql.md` | Line 3-4: Reference STACK_MAP.md |
| `docs/tools/sqlite.md` | Line 5: Reference STACK_MAP.md |
| `docs/tools/tailwindcss.md` | Line 3-4: Reference STACK_MAP.md |
| `docs/tools/swagger-openapi.md` | Line 3-4: Reference STACK_MAP.md |
| `docs/tools/jwt-auth.md` | Line 3: Reference STACK_MAP.md |
| `docs/tools/testing.md` | Line 3-5: Reference STACK_MAP.md |
| `.atl/standards/CICD_PIPELINE.md` | Line 18: Reference STACK_MAP.md or use `${{ env.GO_VERSION }}` |

---

## 6. Approaches Comparison

### Approach A: Minimal Fix (Recommended)

**Description**: Only fix P2 issues, create basic verify script and guides.

| Pros | Cons |
|------|------|
| Low effort, quick wins | Less comprehensive |
| Focuses on P2 issues | Template expansion guide may be basic |

**Effort**: Medium (4-6 hours)

### Approach B: Full Template Overhaul

**Description**: Refactor version management, create comprehensive expansion system, full automation.

| Pros | Cons |
|------|------|
| Most complete solution | High effort (2-3 days) |
| Future-proof | May over-engineer |

**Effort**: High (2-3 days)

### Approach C: Hybrid (Recommended)

**Description**: Fix P2 issues + create agent-facing expansion guide + basic verify script.

| Pros | Cons |
|------|------|
| Balanced approach | Still some manual work |
| Addresses all P2 issues | - |

**Effort**: Medium-High (6-8 hours)

---

## 7. Recommendation

**Use Approach C (Hybrid)** with the following priority order:

### Phase 1: P2 Fixes (Must Do)
1. Create `CHANGELOG.md` with initial template version history
2. Fix hardcoded versions in all 13 files (replace with STACK_MAP.md reference)
3. Create `verify-template.sh` with basic checks

### Phase 2: Template Expansion (Should Do)
4. Create `.atl/agent/TOOL_EXPANSION.md` (agent instructions)
5. Create `docs/tools/ADD_NEW_TOOL.md` (human guide)
6. Create `docs/tools/TEMPLATE.md` (boilerplate)

### Phase 3: Enhancement (Nice to Have)
7. Enhance `verify-template.sh` with language convention checks
8. Add CI job to run verify-template.sh on PRs

---

## 8. Risks

| Risk | Mitigation |
|------|------------|
| **Breaking changes**: Fixing hardcoded versions may break existing user projects that copy-pasted version numbers | Only change documentation references, NOT code examples (go.mod, package.json snippets) |
| **Incomplete verification**: verify-template.sh may miss edge cases | Start with basic checks, iterate based on real usage |
| **Tool expansion complexity**: Mapping unknown tools to template may be error-prone | Provide clear fallback: "If tool not recognized, create new guide following TEMPLATE.md" |
| **Language convention**: Enforcing Spanish/English may be too strict | Only check documentation files, not code comments |

---

## 9. Ready for Proposal

**Status**: Yes

**Next steps for orchestrator**:
1. Review this exploration report
2. Create proposal for `template-expansion-and-p2-fixes` change
3. Define scope: Which approach? (Recommend Approach C)
4. Define which P2 issues to tackle first

**Key decision needed**: Should the verify-template.sh be run in CI (CICD_PIPELINE.md) or manually?

---

## Affected Areas Summary

| Area | Files Affected | Reason |
|------|----------------|--------|
| Version management | 13 files in `docs/tools/` + `README.md` + `CICD_PIPELINE.md` | Replace hardcoded versions |
| Template integrity | New `verify-template.sh` | Create verification script |
| Template history | New `CHANGELOG.md` | Create changelog |
| Agent instructions | New `.atl/agent/TOOL_EXPANSION.md` | Guide for expansion |
| Template contribution | New `docs/tools/ADD_NEW_TOOL.md` + `TEMPLATE.md` | Human-facing guides |

---

*Exploration completed on 2026-04-29. All 5 P2 issues identified with file locations and recommended fixes.*

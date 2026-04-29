# Template Versioning Spec

## Purpose
Single source of truth for versions via STACK_MAP.md. Chronological changelog for template history.

## Requirements

### R1: STACK_MAP.md as Version Source of Truth

Tool guides, README, and CICD_PIPELINE MUST reference STACK_MAP.md instead of hardcoding versions in prose. Code blocks (go.mod, package.json snippets) MUST be preserved.

| File | Before | After |
|------|--------|-------|
| `docs/tools/*.md` (11) | `**Versión**: Go 1.25.0` | `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` |
| `README.md` | 9-row version table | Single sentence: `Ver [STACK_MAP.md](docs/STACK_MAP.md)` |
| `CICD_PIPELINE.md` | `GO_VERSION: '1.25'` | `GO_VERSION` with comment `# see STACK_MAP.md §1` |

#### Scenario: Tool guide rewritten

- GIVEN `**Versión**: Go 1.25.0` in a tool guide
- THEN becomes `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)`

#### Scenario: Code blocks preserved

- GIVEN `go get gorm.io/gorm@v1.31.1` inside a fenced code block
- THEN version numbers remain unchanged

### R2: Template Changelog

Template SHALL include root `CHANGELOG.md` following keepachangelog.com format, starting at `0.1.0`.

#### Scenario: Changelog created

- GIVEN no root CHANGELOG.md exists
- THEN file exists with Unreleased section and `[0.1.0]` listing all archived changes under Added/Changed/Fixed

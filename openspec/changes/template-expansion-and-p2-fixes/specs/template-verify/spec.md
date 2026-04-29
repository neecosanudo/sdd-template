# Template Verification Spec

## Purpose
Automated integrity script validating structure, versions, cross-references, and glossary compliance.

## Requirements

### R3: verify-template.sh

Template MUST provide `verify-template.sh` running five checks. Script exits non-zero on any failure.

| # | Check | Rule |
|---|-------|------|
| C1 | Required files | `.atl/glossary.md`, `docs/STACK_MAP.md`, `README.md`, all governance files present |
| C2 | No hardcoded versions | No `**Versión**: X.Y.Z` lines in tool guides outside code blocks |
| C3 | Valid cross-references | All `[text](path.md)` links resolve to existing files |
| C4 | Glossary terms | SDD terms match canonical glossary (e.g., "Explore" not "Analyse") |
| C5 | Tool guide structure | All `docs/tools/*.md` follow `TEMPLATE.md` section headings |

#### Scenario: All pass

- GIVEN valid template
- THEN verify exits 0 with five PASS outputs

#### Scenario: Hardcoded version

- GIVEN `**Versión**: Go 1.25.0` in tool guide prose
- THEN exits non-zero, reports file + line

#### Scenario: Broken link

- GIVEN `[missing](gone.md)` in any file
- THEN reports source file + unresolved target

#### Scenario: Non-canonical term

- GIVEN "Analyse" used instead of glossary-canonical "Explore"
- THEN reports file + expected canonical term

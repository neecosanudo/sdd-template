# Adopt Template in Existing Project

## Objective
Structure an existing project's documentation using this template. No code changes.

## Agent Instructions

1. Read existing project docs (README, docs/, wiki, notes)
2. Map existing docs to template structure:
   - Governance → `.atl/governance/`
   - Standards → `.atl/standards/`
   - Patterns → `.atl/patterns/`
   - Decisions → `.atl/decisions/` or `docs/adr/`
3. Create missing template files from defaults
4. Migrate existing content to template structure
5. Create `Bitacora.md` at project root
6. Create `LEARNINGS_MAP.md` in `docs/` (transversal learnings only)
7. Update `README.md` to reference template structure

## File Mapping

| Existing | Template Location | Action |
|----------|-------------------|--------|
| README.md | `README.md` | Update with template refs |
| Architecture docs | `docs/adr/` | Migrate |
| Coding conventions | `.atl/standards/` | Create or adapt |
| Known gotchas | `.atl/patterns/` | Create per-tool |
| Project decisions | `Bitacora.md` | Create and populate |
| Learnings | `docs/LEARNINGS_MAP.md` | Create (transversal only) |
| Decision records | `.atl/decisions/DECISION_LOG.md` | Create |

## What NOT to Do

- Do NOT modify source code
- Do NOT delete existing files (migrate or reference)
- Do NOT add framework gotchas to LEARNINGS_MAP
- Do NOT skip Bitacora.md creation
- Do NOT combine SDD phases — execute sequentially
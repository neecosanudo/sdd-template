# Archive Report: v2.0.0 Template Rewrite

## Summary
Template rewritten for v2.0.0 with new SDD cycle, Go patterns, and TDD Batch Mode.

## Archive Date
2026-05-04

## Status
archived

## What Was Done
- Template rewritten for v2.0.0 with new SDD cycle
- Go patterns documented (Hexagonal architecture)
- TDD Batch Mode documented
- CGO-free SQLite driver (glebarez/sqlite)
- golang-migrate for all environments

## Key Decisions
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Verify Recovery | retake from Tasks | Not Design/Spec — faster iteration |
| DB Driver | glebarez/sqlite (CGO-free) | No C dependencies, cross-platform builds |
| Migration | golang-migrate | Explicit version control |
| Test Framework | testify | 60% boilerplate reduction |
| Structure | Hexagonal | Ports enable testability |

## Files Created/Modified
| Path | Description |
|------|-------------|
| `.atl/specs/sdd-workflow.md` | SDD cycle documentation |
| `README.md` | Rewritten (concise, link-first) |
| `Makefile` | up, test, lint, migrate commands |
| `.env.example` | Go backend environment variables |
| `docker-compose.yml` | Updated template |

## Main Spec Synced
- **Domain**: template
- **Main spec**: `openspec/specs/template/spec.md`
- **Action**: Created (delta spec was treated as full spec)

## Archive Contents
| File | Status |
|------|--------|
| `proposal.md` | ✅ |
| `spec.md` | ✅ |
| `design.md` | ✅ |
| `tasks.md` | ✅ (3/3 batches complete) |
| `apply-progress.md` | ✅ |

## Verification Results
- **Criteria passed**: 10/10
- **Errors**: 0
- **Warnings**: 0
- **Suggestions**: 0

## Next Steps
Ready for next change. The template now reflects proven patterns from calendar project.
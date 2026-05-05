# Proposal: v2.0.0 Template Rewrite

## Intent
Rewrite the template to reflect patterns and practices learned from the calendar project. The v1 template was created from assumptions; v2 will be based on proven patterns from real implementations.

## Scope
- **Go Patterns**: Hexagonal architecture, Chi router, GORM, golang-migrate, CGO-free SQLite
- **TDD Practices**: Batch Mode, Clock interface, factory functions
- **SDD Process**: Verify fails → retake from Tasks (not Design), 100% OK requirement
- **Documentation**: Concise, actionable, link-first
- **Structure**: `.atl/` standardized (patterns/, standards/, skills/)

## Approach
Sequential batches — each batch completes one phase fully before the next begins. No parallel agents. Standard workflow: Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive.

## Affected Areas
| Area | Impact | Description |
|------|--------|-------------|
| `.atl/` | Modified | Restructure with patterns/, standards/, skills/ |
| `README.md` | Modified | Concise, link-first |
| `openspec/changes/` | New | Delta specs per change |

## Risks
- Breaking existing user workflows: **Low** — Changes are additive, existing paths work
- Migration complexity: **Low** — No migration needed, copy new template

## Rollback Plan
Revert to previous commit. Template in version control, no external dependencies.

## Success Criteria
- [ ] Template builds without errors
- [ ] All SDD phases documented
- [ ] At least one pattern documented in `.atl/patterns/`
- [ ] README links to standards

# Design: v2.0.0 Template Rewrite

## Architecture Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Structure | Hexagonal: domain/entities, domain/ports, application/usecases, infrastructure/adapters | Ports enable testability; adapters swappable |
| Migration | golang-migrate (NOT GORM AutoMigrate) | Explicit version control, works SQLite+PostgreSQL |
| Test Framework | testify | 60% boilerplate reduction vs vanilla |
| Router | chi | Replaces net/http directly |
| DB Driver | glebarez/sqlite (CGO-free) | No C dependencies |

## Dependencies
`chi`, `GORM`, `glebarez/sqlite`, `golang-migrate`, `jwt/v5`, `testify`

## Testing Strategy
- Clock interface: inject time dependency
- Factory functions: functional options pattern
- TDD Batch Mode: ALL RED → ALL GREEN → REFACTOR

## File Changes
| Path | Action |
|------|--------|
| `.atl/patterns/go-hexagonal.md` | Create |
| `.atl/standards/TDD.md` | Create |
| `.atl/standards/MIGRATIONS.md` | Create |

## SDD Rule Update
**Verify fails → retake from Tasks** (NOT Design/Spec)

## Open Questions
- [ ] Multi-tenant handling?
- [ ] JWT secret: env or config?
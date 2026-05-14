# STANDARDS.md

Engineering standards para nuevos proyectos.

## 1. Engineering Manifesto

### TDD is Mandatory
- Write tests BEFORE implementation
- RED-GREEN-REFACTOR cycle never broken
- Zero tolerance: no code committed without corresponding tests

### Hexagonal Architecture
- Domain is pure — no framework imports
- Ports define interfaces; Adapters implement them
- Dependencies point inward toward domain

### Quality Gates
- **Zero warnings** — linters, type checkers, compilers
- **Zero errors** — tests, builds, lint
- Pipeline rejects violations — no exceptions

### ADR System
- Architectural decisions documented in `docs/decisions/NNNN-name.md`
- Structural changes require ADR before implementation
- Hotfixes: bypass allowed but ADR retrospective within 24 hours

## 2. Style Guide

### Naming Conventions

| Context | Convention | Example |
|---------|------------|---------|
| Exports | `MixedCaps` | `GetUserByID` |
| Privates | `camelCase` | `validateToken` |
| Constants | `MixedCaps` or `SCREAMING_SNAKE_CASE` | `MaxRetries`, `HTTP_STATUS_OK` |
| Files | `kebab-case` | `auth-service.go` |

**Universal rule:** Names descriptive over abbreviations. `userAccountBalance` not `uab`.

### Code Structure
- **Small functions:** ~20 lines max; refactor if longer
- **Import order:** stdlib → external → project → relative
- **Comments:** Explain WHY, not WHAT. Let code explain itself.

### PII Redaction in Logs
```go
// BAD
log.Printf("User %s logged in", user.Email)

// GOOD
log.Printf("User %s logged in", hashEmail(user.Email))

// Secrets: NEVER log
log.Printf("Token: %s", token)          // BAD
log.Printf("Token: [REDACTED]")         // GOOD
```

## 3. Environment Variables

### Backend
- `PORT` — server port (default: 8080)
- `DATABASE_DSN` — database connection string
- `APP_ENV` — environment (development/production)

### Testing Strategy
Ver `docs/standards/TESTING_STRATEGY.md`

### Docker / CI
Ver `docs/patterns/docker.md`
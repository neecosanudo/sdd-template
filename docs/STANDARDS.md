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

## 3. Testing Strategy

### TDD Cycle (Mandatory)
1. **RED** — Write failing test before any code
2. **GREEN** — Minimum implementation to pass
3. **REFACTOR** — Improve code, tests stay green
4. **REPEAT** — Never break the cycle

### Test Stack

| Layer | Tool |
|-------|------|
| Unit | go test |
| Integration | testutil.NewTestDB |

### Commands
```bash
go test ./... -count=1
go test -cover ./...
```

### Coverage Targets
- **100%** domain logic (non-negotiable)
- **≥80%** application layer
- **≥70%** adapters

### Verify Loop
```
Apply → Verify → ¿Clean? → Archive
                  ↓ No
               Explore → Tasks → Apply → Verify
```
Si Verify no está 100% OK (errores, warnings o sugerencias), se ejecuta un Explore automático para **mapear el alcance completo de los hallazgos**, luego Tasks reordena las correcciones, Apply implementa, y Verify confirma. El loop corre en automático hasta clean verify (0 errores, 0 warnings, 0 sugerencias) o 3 intentos máximos.

IMPORTANTE: Cada verify failure lanza un NUEVO Explore — no se reusa el análisis anterior.

### Batch-Verify
Single pass/fail — no partial success. All tests, linters, type checkers run together. Fix ALL issues before commit.

## 4. Docker / CI

### Build Commands
```bash
# Development
docker-compose up -d

# Production build
docker build --target production -t project-name:latest .
```

### Verification
```bash
docker-compose build
docker-compose up -d
docker-compose ps
```

## 5. Environment Variables

### Backend
- `PORT` — server port (default: 8080)
- `DATABASE_DSN` — database connection string
- `APP_ENV` — environment (development/production)

---

*Replaces: .atl/standards/ENGINEERING_MANIFEST.md, .atl/standards/STYLE_GUIDE.md, .atl/standards/TESTING_STRATEGY.md, .atl/standards/CICD_PIPELINE.md, .atl/standards/RELEASE_AND_RUN.md*

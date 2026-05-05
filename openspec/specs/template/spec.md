# Specification: Template v2.0.0

## Overview
This spec defines the v2.0.0 template requirements, establishing a more concise template with robust SDD governance.

## Requirements

### Requirement: Template Conciseness
The template MUST maintain high information density (concise, actionable).

#### Scenario: Template serves as reference
- GIVEN a developer using the template as reference
- WHEN browsing docs
- THEN they see ONLY essential content per file
- AND no redundant explanations

### Requirement: ATL Structure
The template MUST use the `.atl/` structure (patterns/, standards/, skills/, agent/, decisions/).

#### Scenario: New project uses SDD
- GIVEN a new project using template v2.0.0
- WHEN initiating SDD cycle
- THEN it uses the new .atl structure

### Requirement: Hexagonal Architecture
Go code within the template MUST follow Hexagonal architecture pattern.

#### Scenario: Developer writes Go code
- GIVEN a developer writing Go code
- WHEN following the template
- THEN uses Hexagonal architecture (domain/entities, domain/ports, application/usecases, infrastructure/adapters)

### Requirement: TDD Batch Mode
The template MUST document and enforce TDD Batch Mode.

#### Scenario: Running tests in TDD fashion
- GIVEN running tests BEFORE code (TDD)
- THEN writes ALL RED tests first
- THEN writes ALL GREEN code
- THEN refactors

### Requirement: Verify Failure Recovery
The template MUST define recovery from Verify failure.

#### Scenario: Verify fails
- GIVEN Verify fails with ANY issue
- THEN retakes from Tasks phase (not Design)

## Scenarios

### Scenario 1: ATL Structure
- GIVEN a new project using template v2.0.0
- WHEN initiating SDD cycle
- THEN it uses the new .atl structure

### Scenario 2: Hexagonal Architecture
- GIVEN a developer writing Go code
- WHEN following the template
- THEN uses Hexagonal architecture (domain/entities, domain/ports, application/usecases, infrastructure/adapters)

### Scenario 3: TDD Batch Mode
- GIVEN running tests BEFORE code (TDD)
- THEN writes ALL RED tests first
- THEN writes ALL GREEN code

### Scenario 4: Verify Failure Recovery
- GIVEN Verify fails with ANY issue
- THEN retakes from Tasks phase (not Design)

## Dependencies
| Package | Purpose |
|---------|---------|
| chi | HTTP router |
| GORM | ORM |
| glebarez/sqlite | CGO-free SQLite |
| golang-migrate | Database migrations |
| jwt/v5 | Authentication |
| testify | Testing |

## Architecture Decisions
| Decision | Choice | Rationale |
|----------|--------|-----------|
| Structure | Hexagonal: domain/entities, domain/ports, application/usecases, infrastructure/adapters | Ports enable testability; adapters swappable |
| Migration | golang-migrate (NOT GORM AutoMigrate) | Explicit version control, works SQLite+PostgreSQL |
| Test Framework | testify | 60% boilerplate reduction vs vanilla |
| Router | chi | Replaces net/http directly |
| DB Driver | glebarez/sqlite (CGO-free) | No C dependencies |

## Testing Strategy
- Clock interface: inject time dependency
- Factory functions: functional options pattern
- TDD Batch Mode: ALL RED → ALL GREEN → REFACTOR

## References
- `.atl/patterns/go-hexagonal.md` — Hexagonal architecture pattern
- `.atl/standards/TDD.md` — TDD Batch Mode documentation
- `.atl/standards/MIGRATIONS.md` — golang-migrate usage
- `.atl/specs/sdd-workflow.md` — SDD cycle documentation
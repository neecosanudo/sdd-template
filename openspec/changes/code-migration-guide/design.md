# Design: Code Migration Guide

## Technical Approach

Create a destination-specific migration pattern (`.atl/patterns/code-migration.md`) that transforms external code of any origin into opinionated-stack idioms. The guide is **origin-agnostic** (no "how to migrate FROM X") and **destination-specific** ("how to migrate INTO Go/SvelteKit"). Two existing files gain deltas: AGENT_BEHAVIOR.md (§5 trigger), WORKING_STANDARD.md (Analysis special case).

## Architecture Decisions

| Decision | Options | Choice | Rationale |
|----------|---------|--------|-----------|
| **Home for guide** | `docs/tools/` vs `.atl/patterns/` | `.atl/patterns/` | Cross-cutting pattern, not tool-specific. ENGINEERING MANIFEST Rule #7 mandates checking `.atl/patterns/` before code. |
| **Origin vs destination tables** | Source-specific (FROM PHP, etc.) vs destination-specific (INTO Go, etc.) | Destination-specific | Stack has 3 destinations (bounded); sources are unbounded. Destination key keeps guide maintainable. |
| **Trigger location** | Pattern file only vs AGENT_BEHAVIOR.md §5 | AGENT_BEHAVIOR.md §5 | Agents read behavior first — trigger proximity improves compliance. |

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `.atl/patterns/code-migration.md` | **Create** | Full migration guide: 5-step process, destination mapping tables, anti-patterns |
| `.atl/agent/AGENT_BEHAVIOR.md` | **Modify** | Append §5 "Code Migration Protocol" after §4 |
| `.atl/standards/WORKING_STANDARD.md` | **Modify** | Add "Special Case: Code Migration" sub-section in Analysis → Activities |

## Content Design

### `.atl/patterns/code-migration.md` — Structure

```
# Patrón: Migración de Código
**Pattern ID**: code-migration | **dependencias**: go-hexagonal.md, svelte-component.md, gorm-repository.md, react.md, TESTING_STRATEGY.md

## 1. Principio Fundamental
Origin-agnostic, destination-specific.

## 2. Proceso de 5 Pasos
1. Analyze — separate business logic from plumbing
2. Map — source concepts → destination idioms (use tables below)
3. Rewrite — in destination using `.atl/patterns/`
4. Test first — TDD per function (ref. TESTING_STRATEGY.md)
5. Verify — behavior parity with original

## 3. Tablas de Mapeo por Destino
### 3.1 → Go Hexagonal
| Source Concept → | Go Idiom | Reference |
|------------------|----------|-----------|
| Class | struct + methods | go-hexagonal.md |
| ActiveRecord | Port + Adapter (GORM) | go-hexagonal.md, gorm-repository.md |
| Controller | HTTP Handler | go-hexagonal.md |
| Service | UseCase (app layer) | go-hexagonal.md |

### 3.2 → SvelteKit
| Source Concept → | SvelteKit Idiom | Reference |
|------------------|-----------------|-----------|
| React Component | .svelte file | svelte-component.md |
| useState | `let` (reactive) | svelte-component.md |
| useEffect | onMount() / `$:` statement | svelte-component.md |
| Props | `export let` | svelte-component.md |

### 3.3 → Godot (outline — single table with Node→_ready()/export)

## 4. Prototype Disposal
React prototypes = REFERENCE ONLY → extract business logic, discard UI. Redirect to `docs/tools/react.md`.

## 5. Testing (TDD mandatory)
Behavior verification (input→output), not implementation. Integration tests at migration boundaries.

## 6. Anti-Patterns
❌ Copy-paste + syntax fix / ❌ Preserve framework patterns / ❌ Migrate UI without redesign / ❌ Skip tests

## 7. Referencias
```

### `AGENT_BEHAVIOR.md` — §5 Insert (after §4.2 line 56)

```markdown
## 5. Code Migration Protocol

### 5.1 Trigger Condition
When user says "migrate from X", "bring code from Y", or similar — agent MUST:
1. Read `.atl/patterns/code-migration.md` BEFORE any implementation
2. Follow 5-step process
3. Treat React prototypes as disposable reference
4. Write tests before implementation (TDD)

### 5.2 Prohibited Actions
- Incremental migration from React prototypes
- Copy-paste + syntax adaptation
- Skipping tests on migrated code
```

### `WORKING_STANDARD.md` — Delta (after line 34, before "### Initialization Command")

```markdown
### Special Case: Code Migration
- **Trigger**: "I have code from X to bring into the project"
- **Actions**: Identify logic to preserve vs discard; determine destination tool; read `.atl/patterns/code-migration.md`
- **Output**: Migration plan (preserve/discard/destination)
```

## Cross-References

| Source | → Target | Purpose |
|--------|----------|---------|
| code-migration.md §3.1 | `go-hexagonal.md`, `gorm-repository.md` | Go destination patterns |
| code-migration.md §3.2 | `svelte-component.md` | SvelteKit destination patterns |
| code-migration.md §4 | `docs/tools/react.md` | Prototype disposal rule |
| code-migration.md §5 | `TESTING_STRATEGY.md` | TDD mandatory policy |
| AGENT_BEHAVIOR.md §5.1 | `code-migration.md` | Trigger → pattern read |
| WORKING_STANDARD.md | `code-migration.md` | Analysis → operational guide |

## Agent Workflow

1. **Trigger**: Migration keywords → read AGENT_BEHAVIOR.md §5
2. **Read**: `.atl/patterns/code-migration.md` — understand 5-step process
3. **Analyze**: Separate business logic from framework code
4. **Map**: Use destination table for target (Go/SvelteKit/Godot)
5. **Rewrite**: Apply `.atl/patterns/` idioms per mapped concepts
6. **TDD**: Write tests BEFORE implementation (TESTING_STRATEGY.md §6)
7. **Verify**: Full suite; behavior parity with original
8. **Checkpoint**: React prototype? → extract logic only, discard UI

## Open Questions

None.

## References

- [ENGINEERING_MANIFEST.md](../../../../.atl/governance/ENGINEERING_MANIFEST.md) — Rules #7, #2, #6
- [AGENT_BEHAVIOR.md](../../../../.atl/agent/AGENT_BEHAVIOR.md) — Current file; §5 to add
- [WORKING_STANDARD.md](../../../../.atl/standards/WORKING_STANDARD.md) — Analysis phase
- [Spec: code-migration](../specs/code-migration/spec.md) — Full requirements
- [Delta spec: working-standard-cycle](../specs/working-standard-cycle/spec.md) — Delta for WORKING_STANDARD.md

# Exploration: Code Migration Guide

**Date**: 2026-04-29
**Change**: code-migration-guide
**Artifact Store Mode**: hybrid

---

## 1. Current State Analysis

### 1.1 Project Structure Overview

The `sdd-template` is an opinionated template with a well-defined structure:

```
sdd-template/
├── .atl/                          # Infrastructure (governance, standards, patterns, agent)
│   ├── governance/                 # ENGINEERING_MANIFEST.md, COMMIT_CONVENTIONS.md, etc.
│   ├── standards/                  # WORKING_STANDARD.md, STYLE_GUIDE.md, TESTING_STRATEGY.md
│   ├── patterns/                   # go-hexagonal, svelte-component, gorm-repository, etc.
│   ├── agent/                      # AGENT_BEHAVIOR.md
│   └── decisions/                  # DECISION_LOG.md
├── docs/                           # Product documentation
│   ├── tools/                      # Tool guides (go, sveltekit, react, gorm, docker, etc.)
│   ├── decisions/                  # ADRs (api-first, tdd, hexagonal-architecture, spanish-language)
│   ├── STACK_MAP.md                # Version matrix
│   └── EXISTING_PROJECTS.md       # Template adoption guide
├── openspec/                       # SDD artifacts
│   ├── changes/                    # Active and archived changes
│   └── specs/                      # Cross-project specs
└── README.md                       # Project entry point
```

### 1.2 Existing Migration-Related Content

| File | Relevance to Code Migration |
|------|----------------------------|
| `docs/EXISTING_PROJECTS.md` | Discusses adopting the TEMPLATE into existing projects (documentation restructuring only, no code migration) |
| `docs/tools/react.md` | Explicitly states React is for PROTOTYPES ONLY, not production. Mentions SvelteKit as production framework. No migration guidance. |
| `.atl/patterns/agnostic-fundamentals.md` | Contains SDD cycle and architectural integrity patterns. No code migration content. |
| `STACK_MAP.md` | Mentions Godot and Wails as "not used" or "planned" but NO tool guides exist for them. |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Rule #9 (Stack Decision → Pattern Documentation) requires pattern files for each tool. No migration-specific rules. |

### 1.3 Current Stack Reality

**Production Stack** (from `STACK_MAP.md` and `README.md`):
- **Backend**: Go 1.25 + GORM v1.31.1 + PostgreSQL 16-alpine
- **Frontend Production**: SvelteKit 2.0 + Svelte 4.2 + TypeScript 5.3 + Vite 5.0 + TailwindCSS 3.4
- **Frontend Prototypes**: React 19.0 + Vite 6.2 + TailwindCSS 4.1 (explicitly DISPOSABLE)
- **Auth**: JWT (golang-jwt/v5) + bcrypt (golang.org/x/crypto)
- **DevOps**: Docker multi-stage + docker-compose
- **Testing**: testify (Go), Vitest + @testing-library (Svelte/React), Playwright (E2E)

**Mentioned but NOT in stack**:
- **Godot**: Listed in STACK_MAP.md under "Stack NO Usado" section as a game development tool
- **Wails**: Listed as "Stack Planeado" (planned stack) in STACK_MAP.md but no ADR or tool guide exists

### 1.4 Key Architectural Patterns (Relevant to Migration)

1. **Hexagonal Architecture** (Go): `domain/entities/` → `domain/ports/` → `application/usecases/` → `infrastructure/adapters/`
   - External code migrating TO Go must fit this structure
   - Domain logic must be decoupled from frameworks (Rule from ENGINEERING_MANIFEST.md)

2. **SvelteKit Conventions**: File-based routing (`src/routes/`), server load functions, form actions with `use:enhance`

3. **React Prototypes**: Disposable code for validation only. Must NOT be edited for production.

4. **TDD Mandatory**: No business logic without tests (Rule #2 in ENGINEERING_MANIFEST.md)

---

## 2. Affected Areas

### 2.1 Files That Should Be Created

| Path | Purpose | Why Affected |
|------|---------|--------------|
| `.atl/patterns/code-migration.md` | Main migration guide | New file: documents the process of migrating code from external sources to the stack |
| `docs/tools/wails.md` | Wails tool guide | New file: if migration examples mention Wails (AIStudio → Wails/Go), agents need Wails patterns |
| `docs/tools/godot.md` | Godot tool guide | New file: if migration examples mention Godot (React → Godot games), agents need Godot patterns |

### 2.2 Files That May Need Updates

| Path | Purpose | Why Affected |
|------|---------|--------------|
| `.atl/agent/AGENT_BEHAVIOR.md` | Agent behavior rules | May need a new section on migration protocol (origin-agnostic analysis, destination-specific implementation) |
| `.atl/standards/WORKING_STANDARD.md` | Working standard cycle | May need to mention migration as a special case of Analysis phase |
| `docs/EXISTING_PROJECTS.md` | Template adoption | Currently covers doc restructuring only. Could cross-reference the migration guide for code migration scenarios |
| `.atl/skill-registry.md` | Skill registry | May need a new `code-migration` skill entry if we create one |
| `README.md` | Project entry point | May need to mention the migration guide in "Repository Navigation" section |

### 2.3 Files That Should NOT Be Modified

- `docs/tools/react.md` — Already clearly states React is disposable. The migration guide will reference this.
- `.atl/patterns/go-hexagonal.md` — Complete as-is. Migration guide will point to it.
- `docs/decisions/` — Migration guide is not an architectural decision, it's a process pattern.

---

## 3. Approaches for the Migration Guide

### Approach 1: Pattern-Based (Recommended)
**Location**: `.atl/patterns/code-migration.md`

**Description**: Document the migration guide as a pattern in the existing patterns directory, following the same structure as `go-hexagonal.md`, `svelte-component.md`, etc.

**Structure**:
```markdown
# Patrón: Code Migration Guide
**Pattern ID**: code-migration
**Versión**: 1.0
**Dependencias**: [go-hexagonal.md](../patterns/go-hexagonal.md) | [svelte-component.md](../patterns/svelte-component.md) | ...

## 1. Principios Fundamentales
- Origin-agnostic, destination-specific
- Preservar lógica de negocio, adaptar implementación
- Prototipos (React) son descartables

## 2. Análisis de Código Externo
- Qué preservar (lógica de negocio, reglas, flujos)
- Qué descartar (UI específica, dependencias externas)
- Cómo mapear conceptos (ej: PHP → Go hexagonal)

## 3. Mapeo por Herramienta Destino
### 3.1 Migrar a Go (Hexagonal)
- Desde PHP: ...
- Desde Python: ...
- Desde AIStudio (Wails): ...

### 3.2 Migrar a SvelteKit
- Desde React: ...
- Desde Vue: ...

### 3.3 Migrar a Godot
- Desde React (juegos): ...
- Desde Unity: ...

## 4. Prototipos vs Producción
- React → Descartar o reimplementar en SvelteKit
- Cuándo un prototipo "gradua" a producción

## 5. Estrategia de Testing para Código Migrado
- TDD para lógica migrada
- Tests de regresión antes de migrar
- Cobertura mínima (per TESTING_STRATEGY.md)

## 6. Reescritura vs Adaptación
- Cuándo reescribir desde cero
- Cuándo adaptar incrementalmente
- Criterios de decisión
```

**Pros**:
- Consistent with existing pattern files
- Agents already know to check `.atl/patterns/` before coding (Rule #7 in ENGINEERING_MANIFEST.md)
- Cross-referencing with other patterns is natural
- Fits the "Patterns-Before-Code" rule

**Cons**:
- Patterns directory currently has tool/framework-specific patterns, not process guides
- May confuse the purpose of "patterns"

**Effort**: Low (single file, follows existing template)

---

### Approach 2: Standalone Doc (Alternative)
**Location**: `docs/CODE_MIGRATION.md`

**Description**: Create a top-level document in `docs/` similar to `EXISTING_PROJECTS.md`.

**Pros**:
- More visible than patterns subdirectory
- Clear separation from tool-specific patterns
- Follows the convention of `EXISTING_PROJECTS.md`

**Cons**:
- Agents may not discover it as readily as patterns
- Doesn't align with "check patterns first" workflow
- Would need to update WORKING_STANDARD.md or AGENT_BEHAVIOR.md to reference it

**Effort**: Low (single file)

---

### Approach 3: New Skill (Most Comprehensive)
**Location**: `~/.config/opencode/skills/code-migration/SKILL.md`

**Description**: Create a new agent skill that provides trigger-based instructions for migration scenarios.

**Structure**:
```markdown
# Skill: code-migration
## Trigger
When user says "migrate code", "bring code from", "convert from X to Y", or similar.

## Instructions
1. Analyze external code (origin)
2. Identify destination stack components
3. Follow migration guide (link to .atl/patterns/code-migration.md)
4. Apply TDD and hexagonal architecture
...
```

**Pros**:
- Agents automatically load migration instructions when triggered
- Can include complex workflows and multi-step processes
- Self-contained with examples

**Cons**:
- New skill maintenance burden
- May overlap with existing patterns
- Skills are user-level (~/.config/opencode/skills/), not project-level

**Effort**: Medium (skill creation + pattern file)

---

## 4. Recommendation

**Primary Recommendation**: **Approach 1 (Pattern-Based)** with elements of Approach 3.

### Rationale

1. **Consistency with Existing Workflow**: The ENGINEERING_MANIFEST.md Rule #7 ("Patterns-Before-Code") states:
   > "Before implementing, check `.atl/patterns/` for applicable patterns"
   
   If the migration guide is in `.atl/patterns/`, agents will naturally find it during their pre-coding checklist.

2. **Cross-Reference Capability**: The pattern file can reference:
   - `go-hexagonal.md` for Go architecture
   - `svelte-component.md` for SvelteKit components
   - `react.md` for prototype disposal rules
   - `agnostic-fundamentals.md` for architectural integrity

3. **Not a Tool Guide**: The migration guide is origin-agnostic. It doesn't fit in `docs/tools/` which is for tool-specific documentation.

4. **Skill Consideration**: Create a `code-migration` skill ONLY if the migration process requires complex decision trees or multi-step workflows that warrant trigger-based automation. For now, the pattern file is sufficient.

### Proposed File Structure

```
.atl/patterns/code-migration.md          # Main migration guide (NEW)
docs/tools/wails.md                      # Wails guide (NEW, if AIStudio → Wails example is common)
docs/tools/godot.md                      # Godot guide (NEW, if React → Godot example is common)
```

### Content Outline for `code-migration.md`

```markdown
# Patrón: Code Migration Guide
**Pattern ID**: code-migration
**Versión**: 1.0
**Dependencias**: [go-hexagonal.md] | [svelte-component.md] | [react.md] | [agnostic-fundamentals.md]

## 1. Principio Fundamental
Origin-agnostic, destination-specific: No importa de dónde viene el código, importa a dónde va.

## 2. Proceso de Análisis (Source-Agnostic)
### 2.1 Qué Preservar
- Lógica de negocio pura (domain)
- Reglas de validación
- Flujos de datos
- Contratos/Interfaces

### 2.2 Qué Descartar
- Dependencias específicas del origen
- UI/UX (se reimplementa en destino)
- Configuraciones de entorno
- Tests del origen (se reescriben en destino)

## 3. Mapeo de Conceptos por Destino

### 3.1 Destino: Go (Hexagonal)
| Concepto Origen | Equivalente Go/Hexagonal |
|------------------|-------------------------|
| Clase/PHP class | struct + methods (domain/entities/) |
| Modelo ActiveRecord | Repository interface (domain/ports/) + GORM adapter (infrastructure/) |
| Controller | HTTP Handler (infrastructure/http/) |
| Service | Use Case (application/usecases/) |
| Dependency Injection | Constructor injection en Go |

**Ejemplo: PHP → Go**
```php
// Origen (PHP)
class UserController {
    public function create(Request $request) {
        $user = new User($request->input('email'));
        $user->save(); // ActiveRecord
        return response()->json($user);
    }
}
```

```go
// Destino (Go Hexagonal)
// domain/ports/user_repository.go
type UserRepository interface {
    Create(user *entities.User) error
}

// application/usecases/create_user.go
type CreateUserUseCase struct {
    repo ports.UserRepository
}
func (uc *CreateUserUseCase) Execute(ctx context.Context, req CreateUserRequest) error {
    user := &entities.User{Email: req.Email}
    return uc.repo.Create(user)
}

// infrastructure/http/user_handler.go
func (h *UserHandler) Create(w http.ResponseWriter, r *http.Request) {
    // Parse request, call use case, return JSON
}
```

### 3.2 Destino: SvelteKit
| Concepto Origen | Equivalente SvelteKit |
|------------------|----------------------|
| React Component | Svelte Component (.svelte) |
| useState | let (reactive) o $state (Svelte 5) |
| useEffect | onMount() o reactive statement ($:) |
| Props | export let propName |
| Children | <slot> |

**Ejemplo: React → SvelteKit**
```tsx
// Origen (React)
function UserCard({ user }) {
    const [expanded, setExpanded] = useState(false);
    return (
        <div className="card">
            <h2>{user.name}</h2>
            {expanded && <p>{user.bio}</p>}
            <button onClick={() => setExpanded(!expanded)}>Toggle</button>
        </div>
    );
}
```

```svelte
<!-- Destino (SvelteKit) -->
<script lang="ts">
    export let user: User;
    let expanded = false;
</script>

<div class="card">
    <h2>{user.name}</h2>
    {#if expanded}
        <p>{user.bio}</p>
    {/if}
    <button on:click={() => expanded = !expanded}>Toggle</button>
</div>
```

### 3.3 Destino: Godot (Juegos)
| Concepto Origen | Equivalente Godot |
|------------------|-------------------|
| React Component | Godot Node (Sprite2D, Node2D, etc.) |
| State | @export variables o的信号 |
| useEffect | _ready() o _process() |
| Props | @export variables |

## 4. Prototipos (React) vs Producción
- **React es DESCARTABLE** (docs/tools/react.md línea 3)
- Los prototipos en React son para validación rápida, NO para producción
- Si un prototipo "madura":
  1. Extraer lógica de negocio (si la hay)
  2. Reimplementar en SvelteKit (frontend) o Go (backend)
  3. DESCARTAR el código React original
- **NUNCA** editar o mantener código React en producción

## 5. Estrategia de Testing para Código Migrado
1. **Antes de migrar**: Entender comportamiento esperado (tests del origen si existen)
2. **Durante migración**: Escribir tests PRIMERO (TDD mandatorio, ENGINEERING_MANIFESTO Rule #2)
3. **Después de migrar**: 
   - Tests unitarios para lógica de dominio (≥80% cobertura)
   - Tests de integración para adapters
   - E2E tests para flujos completos (Playwright)

## 6. Reescritura vs Adaptación
### Reescribir desde cero cuando:
- El origen usa un paradigma incompatible (ej: procedural PHP → hexagonal Go)
- El código origen es de baja calidad o sin tests
- La lógica de negocio es trivial de reimplementar

### Adaptar incrementalmente cuando:
- El origen ya sigue una arquitectura similar (ej: hexagonal Java → hexagonal Go)
- Hay tests sólidos en el origen que pueden guiar la migración
- La lógica de negocio es compleja y probada

## 7. Referencias
- [go-hexagonal.md](../patterns/go-hexagonal.md) — Arquitectura Go
- [svelte-component.md](../patterns/svelte-component.md) — Componentes SvelteKit
- [react.md](../../docs/tools/react.md) — Prototipos (DESCARTABLES)
- [agnostic-fundamentals.md](../patterns/agnostic-fundamentals.md) — Principios arquitectónicos
- [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md) — Estrategia de testing
```

---

## 5. Agent Behavior Implications

### 5.1 Should There Be a New Skill?

**Recommendation**: **Not initially**. The pattern file (`.atl/patterns/code-migration.md`) is sufficient.

**Rationale**:
- Skills are for complex workflows with trigger-based automation
- The migration guide is a reference document, not an automated workflow
- Agents can be instructed to "check `.atl/patterns/code-migration.md`" when migration is discussed

**If a skill IS created later**, it should:
- Trigger on: "migrate code", "bring code from", "convert from X to Y"
- Load the pattern file as reference
- Guide through the analysis → mapping → implementation → testing flow

### 5.2 Should AGENT_BEHAVIOR.md Be Updated?

**Recommendation**: **Yes, add a section**.

**Proposed Addition**:
```markdown
## 5. Code Migration Protocol

### 5.1 Origin-Agnostic Analysis
- When asked to migrate code from an external source, FIRST read `.atl/patterns/code-migration.md`
- Analyze the source code for business logic (preserve) vs implementation details (discard)
- Identify the destination stack components (Go, SvelteKit, etc.)

### 5.2 Destination-Specific Implementation
- Follow the architecture patterns for the destination:
  - Go → `.atl/patterns/go-hexagonal.md`
  - SvelteKit → `.atl/patterns/svelte-component.md`
- TDD is mandatory for migrated business logic
- Do NOT copy-paste code; reimplement following destination patterns

### 5.3 Prototype Disposal
- React code is for prototypes ONLY (see `docs/tools/react.md`)
- If migrating FROM React: extract business logic, discard React code
- If migrating TO React: QUESTION the user — React is not for production
```

### 5.3 Should WORKING_STANDARD.md Mention Migration?

**Recommendation**: **Mention as a special case in Analysis phase**.

**Proposed Addition** (in Phase 1: Analysis):
```markdown
### Special Case: Code Migration
When the task involves migrating existing code from an external source:
1. Read `.atl/patterns/code-migration.md` for the migration process
2. Analyze the source code (origin-agnostic)
3. Map concepts to destination stack (destination-specific)
4. Follow standard Analysis → Design → Tasks → Apply → Verify cycle
```

---

## 6. Risks and Open Questions

### 6.1 Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| **Agents may not discover the migration guide** | Medium | Add to AGENT_BEHAVIOR.md, cross-reference from tool guides |
| **Users may try to "maintain" React prototypes** | High | Already documented in `react.md`, reinforce in migration guide |
| **Over-engineering the migration guide** | Low | Keep it concise, focus on principles and examples |
| **Missing tool guides for Wails/Godot** | Medium | Create minimal tool guides if these become common migration targets |

### 6.2 Open Questions

1. **How common are Wails and Godot migrations?**
   - The STACK_MAP.md mentions them but there are no tool guides
   - If AIStudio → Wails is a common path, create `docs/tools/wails.md`
   - If React → Godot (games) is a common path, create `docs/tools/godot.md`

2. **Should the migration guide include "migration scripts" or automation?**
   - For now: No. The guide is documentation, not tooling.
   - Future: Could add scripts in `.atl/scripts/` for common migrations (ej: PHP → Go scaffolding)

3. **How to handle migrations from "no-code" or "low-code" platforms?**
   - The guide is origin-agnostic, but examples are currently code-to-code
   - Consider adding a section for "Extracting requirements from no-code platforms"

4. **Should there be a separate guide for "Adopting the Template" (docs/EXISTING_PROJECTS.md) vs "Migrating Code" (this guide)?**
   - YES: They are different concerns:
     - `EXISTING_PROJECTS.md`: Restructuring documentation to match template
     - `code-migration.md`: Migrating actual code INTO the stack
   - Add a cross-reference between them

---

## 7. Summary and Next Steps

### What We Know
1. The template has a clear structure (`.atl/` for infrastructure, `docs/` for product docs)
2. NO migration guide currently exists
3. React is explicitly documented as disposable prototypes
4. The "Patterns-Before-Code" rule makes `.atl/patterns/` the ideal location

### Recommended Next Steps
1. **Create** `.atl/patterns/code-migration.md` with the content outline above
2. **Optionally create** `docs/tools/wails.md` and `docs/tools/godot.md` if needed for examples
3. **Update** `.atl/agent/AGENT_BEHAVIOR.md` with migration protocol section
4. **Update** `.atl/standards/WORKING_STANDARD.md` to mention migration in Analysis phase
5. **Cross-reference** from `docs/EXISTING_PROJECTS.md` and `docs/tools/react.md`

### Ready for Proposal
**Yes** — The exploration is complete. The next phase is `sdd-propose` to create the formal proposal for the `code-migration-guide` change.

---

**Files Read During Exploration**:
- `/home/kimbo/projects/suite/sdd-template/README.md`
- `/home/kimbo/projects/suite/sdd-template/docs/STACK_MAP.md`
- `/home/kimbo/projects/suite/sdd-template/docs/tools/react.md`
- `/home/kimbo/projects/suite/sdd-template/docs/tools/go.md`
- `/home/kimbo/projects/suite/sdd-template/docs/EXISTING_PROJECTS.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/agent/AGENT_BEHAVIOR.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/standards/WORKING_STANDARD.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/governance/ENGINEERING_MANIFEST.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/patterns/go-hexagonal.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/patterns/agnostic-fundamentals.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/patterns/svelte-component.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/patterns/docker-multistage.md`
- `/home/kimbo/projects/suite/sdd-template/.atl/skill-registry.md`
- `/home/kimbo/projects/suite/sdd-template/docs/decisions/hexagonal-architecture.md`
- `/home/kimbo/projects/suite/sdd-template/openspec/config.yaml`

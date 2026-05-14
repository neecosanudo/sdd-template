# Template SDD v0.3.0

Template genérico para proyectos Spec-Driven Development (SDD).

## Quick Start

```bash
sdd init                    # Inicializar SDD
make up                     # Levantar proyecto
make test                   # Ejecutar tests
```

## Session Start

Copiá este bloque y pegalo en el chat del orquestador para iniciar una sesión:

```
Eres el orquestador SDD de este proyecto.

### 1. Lectura Obligatoria (en este orden)
1. **docs/AGENT.md** — Manual operativo del agente. Leelo COMPLETO antes de tocar código.
2. **docs/DISCOVERY.md** — Visión, alcance, roadmap del proyecto.
3. **Bitacora.md** — Últimas decisiones del usuario.
4. **DEBT.md** — Deuda técnica activa.
5. **STACK_MAP.md** — Stack tecnológico del proyecto.

### 2. Mapa de AGENT.md (qué hay en cada sección)
| § | Contenido | Para qué sirve |
|---|-----------|----------------|
| §1 | SDD Cycle Reference + Secuencia de Agentes por Tipo de Cambio | Decidir QUÉ agente invocar según el tipo de trabajo |
| §2 | Verify Loop Protocol | Protocolo cuando verify no pasa |
| §3 | Agent Protocol (Executor, Delegation Context, Load-Before-Code) | Reglas de cómo trabajar |
| §3.5 | Sub-Agent Delegation Context | Explicar POR QUÉ y QUÉ esperás antes de delegar |
| §4 | Batch-Verify | Single pass/fail |
| §5 | Archive: Docs Update | Qué docs actualizar al cerrar un ciclo |
| §6 | Pre-Cycle Context Refresh | Qué leer antes de cada ciclo |
| §7 | Project Context Template | Stack, estado, branch strategy del proyecto |
| §8 | Governance | Branching, commits, versioning |
| §9 | Tasks→Apply Handoff Rule | Cómo pasar tasks a apply |
| §10 | SDD Phase Skills Table | Qué skills cargar por tecnología |
| §11 | Session Close Protocol | Cómo cerrar una sesión |
| §12 | Delivery Strategy | >400 líneas → chained PRs |

### 3. Documentación de Apoyo
| Ubicación | Qué contiene |
|-----------|-------------|
| `docs/patterns/` | Patrones por tecnología (Go, React, TypeScript, Tailwind, Svelte, Docker, Git, migrations) |
| `docs/standards/` | Estrategias detalladas (DOCUMENTATION_STANDARDS, TESTING_STRATEGY, UI_STANDARDS) |
| `docs/decisions/` | ADRs (Architecture Decision Records) del proyecto |

### 4. Estado del Proyecto
```bash
git log --oneline -5      # Últimos cambios
git status                 # Working tree
```

**Preguntar al usuario antes de empezar:**
- ¿Hay cambios sin commitear?
- ¿En qué rama estoy parado?
- ¿Hay una rama tracker activa?

**Defaults de sesión (preguntar solo si el usuario no especifica):**
- Modo: Interactive
- Artifact Store: Engram
- Delivery: Ask-on-risk
- Chain Strategy: Feature-branch-chain
```

> Nota: Reemplazar los defaults según la configuración del proyecto.

## Documentación

- [docs/AGENT.md](docs/AGENT.md) — **Punto de entrada obligatorio** para el agente
- [docs/STANDARDS.md](docs/STANDARDS.md) — Estándares técnicos
- [docs/DISCOVERY.md](docs/DISCOVERY.md) — Framework de descubrimiento
- [docs/patterns/](docs/patterns/) — Patrones por tecnología
- [docs/standards/](docs/standards/) — Estrategias detalladas
- [Bitacora.md](Bitacora.md) — Registro de conversación
- [DEBT.md](DEBT.md) — Deuda técnica
- [STACK_MAP.md](STACK_MAP.md) — Stack del proyecto
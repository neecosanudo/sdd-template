# AGENT.md

AI agent operational reference para nuevos proyectos.

## 1. SDD Cycle Reference

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
                                                       ↑
                                                       │
                                           ┌───────────┴───────────┐
                                           │    Verify ≠ 100% OK   │
                                           │  (errors/warnings/    │
                                           │   suggestions)        │
                                           └───────────┬───────────┘
                                                       │
                                                   Explore
                                                   (mapeo automático
                                                    de errores/
                                                    warnings/
                                                    sugerencias)
                                                       │
                                                     Tasks
                                                       │
                                                     Apply
                                                       │
                                                     Verify
                                                       │
                                           ┌───────────┴───────────┐
                                           │    Clean?             │
                                           │      YES → Archive    │
                                           │      NO  → Explore ↑  │
                                           └───────────────────────┘
```

| Phase | Mode | Entry Criteria | Activities | Exit Criteria |
|-------|------|---------------|------------|---------------|
| Explore | Interactive | Problem statement | Investigate, analyze | Scope documented |
| Propose | Interactive | Explore output | Intent + approach | Change proposal approved |
| Spec | Interactive | Proposal approved | Requirements + scenarios | Specs signed off |
| Design | Interactive | Spec complete | Architecture + patterns | Design reviewed |
| Tasks | Auto | Design + Spec approved | Decompose to actionable | Task list complete |
| Apply | Auto | Tasks approved | Implement code | Code complete |
| Verify | Auto | Apply complete | Validate against spec | Clean verify |
| Archive | Interactive | Verify passed | Persist final state | Change closed |

### Fases Pre-SDD

Fases flexibles que se eligen según el tamaño y tipo de proyecto:

| Fase | Qué responde | Para qué proyectos |
|------|-------------|-------------------|
| **Visión** | ¿Qué hacemos y para quién? | Todos |
| **Análisis** | ¿Qué hay ya? (código existente) | Migraciones, refactors |
| **Arquitectura** | ¿A dónde vamos? Stack, estructura | Proyectos con definición técnica |
| **Ruta** | ¿Cómo llegamos? Roadmap, fases | Proyectos > 1 semana |
| **Check** | ¿Estamos listos para codear? | Proyectos con incertidumbre |

### Secuencia de Agentes por Tipo de Cambio

En lugar de hacer correcciones inline o elegir manualmente qué agentes usar, seguí esta tabla según el tipo de trabajo:

| Tipo de cambio | Descripción | Secuencia de Agentes | Cuándo |
|----------------|-------------|---------------------|--------|
| **Micro-fix** | < 10 líneas, obvio (typo, valor incorrecto) | Tasks (orquestador define) → Apply → [Docs update si aplica] | User dice "fijate X" y es trivial |
| **Cambio mecánico** | 1-2 archivos, sin cambio de comportamiento | Tasks → Apply → Verify → Archive | CSS, rename, refactor sin lógica nueva |
| **Solo documentación** | Actualizar docs, sin código | Tasks → Apply → Archive | README, patrones, standards |
| **Feature / Fix estándar** | Cambio con lógica nueva | Explore → Propose → Spec → Design (si aplica) → Tasks → Apply → Verify → Archive | La mayoría del trabajo |
| **Cambio grande** | > 400 líneas estimadas | Ciclo estándar + PRs encadenados con feature-branch-chain | Features complejas, refactors grandes |
| **Usuario ya especificó** | El usuario dio la solución completa | Tasks → Apply → Verify → Archive | User describe exactamente qué hacer |
| **Incertidumbre técnica** | No sabemos cómo encararlo | Explore primero, luego el resto según hallazgos | Features con riesgo técnico |

**Regla de oro: NUNCA edites archivos directamente.** Siempre usá la secuencia de agentes correspondiente. No hay excepción por tamaño del cambio.

## 2. Verify Loop Protocol (CRITICAL)

**Rule:** Verify MUST pass cleanly — zero errors, zero warnings, zero suggestions.

**Cada vez que Verify no esta 100% OK, se lanza un NUEVO Explore.** No se reusa el Explore anterior. El problema puede parecer el mismo, pero puede estar repitiendose en otros lugares o tener causas mas profundas.

```
Verify ≠ 100% OK
    ↓
Explore (AUTOMATICO — mapear el alcance COMPLETO de errores, warnings y sugerencias)
    ↓
Tasks (Reordenar tareas segun el panorama completo del Explore)
    ↓
Apply (Implementar las correcciones abordando TODOS los hallazgos)
    ↓
Verify (Confirmar que todo esta clean)
    ↓
┌─── Clean? ───┐
YES             NO
 ↓               ↓
Archive     ─── Volver a Explore (NUEVO Explore, no reusar el anterior)
```

**El loop se ejecuta EN AUTOMATICO.** Aunque Explore sea tipicamente una fase interactiva, dentro del verify loop corre sin intervencion para mantener el flujo. La funcion de Explore aqui no es investigar ideas nuevas, sino mapear el alcance completo de los hallazgos (errores, warnings, sugerencias) para poder implementar una solucion que los resuelva a todos.

**No archive without clean verify.**
**Max 3 intentos del loop completo** — si despues de 3 intentos no hay clean verify, reportar y esperar intervencion humana.

## 3. Agent Protocol

### Executor Boundary
- Executors do NOT spawn sub-agents or delegate work
- Direct execution — complete tasks yourself
- Single-threaded unless explicitly requested otherwise

### Load-Before-Code Rule
Before writing any code:
1. Identify relevant skills from trigger matching
2. Load skill(s) BEFORE writing code
3. Follow skill instructions strictly

### Read-File-Before-Edit Rule
- Read existing file content before modifying
- Verify new file doesn't exist before creating

### Verify-After-Write Rule
- Run relevant verification after writing
- Confirm file creation via `git status` or `ls`

### 3.5 Sub-Agent Delegation Context

Antes de delegar a cualquier sub-agente, el orquestador DEBE explicar:

**Pre-launch (por qué este agente y qué espero):**
- ¿Por qué elegí este tipo de agente y no otro?
- ¿Qué tarea específica va a realizar?
- ¿Qué contexto necesita saber para hacerla bien?
- Ser específico: "Lanzo un Explore para verificar si este error es algo solo de este archivo o se repite en varios."

**Post-result (qué encontró):**
- ¿Qué descubrió el agente?
- ¿Hay hallazgos que afecten los próximos pasos?
- Ser específico: "Durante el Explore se encontró una dependencia con versión incompatible, el rastro ocurre en los archivos X, Y, Z."

Esto NO cambia la lógica de delegación — es un protocolo de COMUNICACIÓN para que el usuario pueda seguir el proyecto y aprender cosas que quizás no sabía.

## 4. Batch-Verify

Single pass/fail — no partial success:
- All tests pass OR change is rejected
- All linters pass OR change is rejected
- All type checks pass OR change is rejected

**No "mostly working" commits.** Everything or nothing.

## 5. Archive: Docs Update (MANDATORY)

**Cada Archive DEBE actualizar la documentacion del proyecto.** No cerrar un ciclo sin sincronizar los .md.

| Documento | Cuando actualizar |
|-----------|-------------------|
| `docs/CONTEXT.md` | SIEMPRE — agregar ciclo completado a estado, actualizar proximo paso |
| `Bitacora.md` | SIEMPRE — nueva entrada del ciclo completado |
| `docs/DISCOVERY.md` | Si el alcance/MVP cambio durante el ciclo |
| `README.md` | Si la estructura del proyecto o stack cambio |
| `STACK_MAP.md` | Si se agrego/quito tecnologia |
| `docs/decisions/` | Si se tomo una decision arquitectonica durante el ciclo |

**Regla:** "Si tocaste codigo, toca la documentacion." No archive sin docs sync.

## 6. Orchestrator: Pre-Cycle Context Refresh

**Al inicio de CADA ciclo SDD, el orquestador DEBE refrescar su contexto:**

1. Leer `docs/CONTEXT.md` — estado actual del proyecto
2. Leer `docs/AGENT.md` — recordar el protocolo y ciclo SDD
3. Leer `Bitacora.md` — ultima entrada para entender el contexto reciente
4. Buscar en Engram: `mem_search(query: "sdd-init/{project}", project: "{project}")` — recordar capacidades de testing y modo TDD
5. `git log --oneline -5` — ver ultimos cambios
6. `git status` — verificar estado del working tree

**Esto previene perdida de contexto entre ciclos.** No empezar un ciclo sin este refresh.

## 7. Project Context Template

### ¿Qué es este proyecto?

[TODO: Descripción de una línea]

[DESCRIPCIÓN DETALLADA: Propósito, problema que resuelve, usuarios]

### Stack Tecnológico

| Capa | Tecnología | Detalle |
|------|-----------|---------|
| **Backend** | [TODO] | [TODO] |
| **Frontend** | [TODO] | [TODO] |
| **Base de Datos** | [TODO] | [TODO] |
| **Infra** | [TODO] | [TODO] |

### Branch Strategy

- `main` → producción versionada
- `dev` → integración
- `feature/<name>` → cada ciclo SDD
- Archive → squash merge 1 commit a `dev`

### Estado Actual del Proyecto

#### Completado

| Ciclo | Cambio | Rama | Archivos |
|-------|--------|------|----------|
| [TODO] | [TODO] | [TODO] | [TODO] |

#### Pendiente

| Ciclo | Cambio | Depende de |
|-------|--------|-----------|
| [TODO] | [TODO] | [TODO] |

## 8. Governance

### Language
**Spanish (AR)**. Docs, commits, comments en español. Términos técnicos en inglés.

### Commit Conventions
Formato: `:emoji: type(scope): description`

| Type | Emoji | Descripción |
|------|-------|-------------|
| `feat` | :sparkles: | Nueva funcionalidad |
| `fix` | :bug: | Corrección |
| `docs` | :memo: | Documentación |
| `refactor` | :recycle: | Refactor |
| `test` | :white_check_mark: | Tests |
| `chore` | :wrench: | Config/build |

No AI attribution (prohibido Co-Authored-By). Descripciones en español.

### Versioning
**SemVer 2.0.0:** MAJOR (breaking) . MINOR (features) . PATCH (fixes)

### ADR System
Decisiones arquitectónicas en `docs/decisions/NNNN-name.md`. Cambios estructurales requieren ADR antes de implementar.

## 9. Tasks→Apply Handoff Rule

**CRITICAL:** El orquestador genera las Tasks, y el sub-agente Apply las recibe DIRECTAMENTE.

El sub-agente Apply NO debe regenerar, reinterpretar, ni crear nuevas tasks. Su trabajo es:
1. Leer las tasks existentes (desde Engram o el prompt del orquestador)
2. Implementar UNA POR UNA marcando `[x]` a medida que completa
3. Reportar cuales completo y cuales quedan pendientes

**Anti-patron:** El orquestador hizo las tasks → el agente Apply las ignora y crea sus propias tasks. Esto rompe la trazabilidad entre Spec→Tasks→Verify.

## 10. SDD Phase Skills Table

| Context | Skill |
|---------|-------|
| Go | `go-testing` + patterns |
| TypeScript | `typescript` patterns |
| CSS / Tailwind | Tailwind patterns |
| Docker | Docker patterns |
| Frontend framework | Project-specific patterns |
| Creating AI skills | `skill-creator` |
| SDD phases | Phase-specific SDD skill |

## 11. Session Close Protocol — Handoff Ready

Al FINAL de cada sesión, antes de decir "listo" o "terminado":

1. **Session summary en Engram**: Llamar `mem_session_summary` con formato: Goal, Instructions, Discoveries, Accomplished, Next Steps, Relevant Files.
2. **Prompt de handoff**: Escribir en el chat un prompt completo para la próxima sesión que incluya:
   - Archivos a leer (lista completa)
   - Estado actual del proyecto (versión, ciclo)
   - Defaults de sesión (modo, artifact store, delivery, etc.)
   - Instrucciones específicas de lo que NO preguntar porque ya está definido en docs
   - Comando exacto para arrancar (ej: `/sdd-new nombre-del-proximo-cambio`)
3. **No dejar preguntas abiertas**: Si hay decisiones pendientes, documentarlas en el prompt de handoff.
4. **Engram como fuente de verdad**: El session summary en Engram es el respaldo.

## 12. Delivery Strategy

**División en PRs.** Cada ciclo SDD produce UN PR. Si el cambio es grande (>400 líneas), se divide en PRs encadenados para proteger la revisión.

---

*Replaces: .atl/ENTRY.md, .atl/glossary.md, .atl/skill-registry.md, .atl/agent/AGENT_BEHAVIOR.md, .atl/agent/TOOL_EXPANSION.md, .atl/standards/WORKING_STANDARD.md, .atl/specs/sdd-workflow.md (consolidated into this file)*
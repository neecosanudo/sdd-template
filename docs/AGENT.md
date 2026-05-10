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

| Phase | Entry Criteria | Activities | Exit Criteria |
|-------|---------------|------------|---------------|
| Explore | Problem statement | Investigate, analyze | Scope documented |
| Propose | Explore output | Intent + approach | Change proposal approved |
| Spec | Proposal approved | Requirements + scenarios | Specs signed off |
| Design | Spec complete | Architecture + patterns | Design reviewed |
| Tasks | Design approved | Decompose to actionable | Task list complete |
| Apply | Tasks approved | Implement code | Code complete |
| Verify | Apply complete | Validate against spec | Clean verify |
| Archive | Verify passed | Persist final state | Change closed |

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

## 7. Tasks→Apply Handoff Rule

**CRITICAL:** El orquestador genera las Tasks, y el sub-agente Apply las recibe DIRECTAMENTE.

El sub-agente Apply NO debe regenerar, reinterpretar, ni crear nuevas tasks. Su trabajo es:
1. Leer las tasks existentes (desde Engram o el prompt del orquestador)
2. Implementar UNA POR UNA marcando `[x]` a medida que completa
3. Reportar cuales completo y cuales quedan pendientes

**Anti-patron:** El orquestador hizo las tasks → el agente Apply las ignora y crea sus propias tasks. Esto rompe la trazabilidad entre Spec→Tasks→Verify.

## 7.5 Micro-Fix Protocol

Para arreglos MUY chicos (typos, una linea, un valor incorrecto):

**NUNCA hacer arreglos inline.** Siempre usar sub-agentes.

En vez del ciclo SDD completo (8 fases), usar ciclo minimo:

```
Tasks → Apply → [Docs update si aplica]
```

- **Tasks**: El orquestador define UNA task concreta y la pasa al sub-agente Apply
- **Apply**: El sub-agente implementa el fix y reporta
- **Docs update** (opcional): Si durante el fix se descubre algo util para la documentacion, el agente Apply lo reporta y se actualiza

**Reglas:**
- Solo para cambios de < 10 lineas
- Solo para fixes obvios (no requieren Explore, Spec, Design, Verify)
- Si el fix requiere mas de 1 intento → escalar a ciclo SDD completo
- Si se descubre algo inesperado → documentar en Bitacora.md
- El sub-agente Apply siempre reporta: "Esto fue un micro-fix. [cambios hechos]. [descubrimientos, si los hay]"

**Anti-patron:** El orquestador edita inline porque "es muy chico". Siempre hay un sub-agente para eso. Tasks→Apply son 2 llamadas, toman segundos, y mantienen la trazabilidad.

## 8. SDD Phase Skills Table

| Context | Skill |
|---------|-------|
| Go testing | `go-testing` |
| Creating AI skills | `skill-creator` |
| SDD phases | Phase-specific SDD skill |
| Analysis phase | WORKING_STANDARD.md (Analysis section) |

---

*Replaces: .atl/ENTRY.md, .atl/glossary.md, .atl/skill-registry.md, .atl/agent/AGENT_BEHAVIOR.md, .atl/agent/TOOL_EXPANSION.md, .atl/standards/WORKING_STANDARD.md, .atl/specs/sdd-workflow.md (consolidated into this file)*

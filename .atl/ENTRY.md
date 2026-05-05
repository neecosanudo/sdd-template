# ENTRY.md — Punto de Entrada para Agentes

> Este archivo es la **puerta de entrada obligatoria** para TODO agente que entre al proyecto.

---

## 🚨 Preguntas Iniciales (SIEMPRE hacer al empezar)

Antes de hacer cualquier cosa, respondé estas preguntas:

1. **¿Qué es el proyecto y está definido?** — Si no hay visión/documento de Discovery, primero hay que hacer eso.

2. **¿Las historias de usuarios están definidas?** — Si no, el proyecto está en etapa de Discovery/MVP, no listo para SDD.

3. **¿Los ciclos MVP están completos?** — Si hay ciclos MVP pendientes, completar esos primero antes de cambios nuevos.

4. **¿Se tiene el contexto para planificar esta change?** — Si la respuesta es NO → volver a Discovery/Pre-SDD.

**Si no sabés las respuestas → PREGUNTÁ al usuario. No asumas.**

---

## 🚀 Modo de Ejecución Default

```
[Interactive] → [Auto: Tasks→Apply→Verify] → [Interactive] → Archive
```

| Rango de fases | Modo | Comportamiento |
|----------------|------|----------------|
| Explore → Design | `interactive` | El agente pregunta, el usuario responde |
| Tasks → Apply → Verify | `auto` | Ejecuta solo, loop automático hasta 100% |
| Antes de Archive | `interactive` | Confirmación final antes de commit |

**Override:** El usuario puede pedir "todo auto" o "todo interactive", pero solo para esa sesión. El default vuelve al formato mixto.

---

## 🔄 3 Etapas del Proyecto

```
Discovery → Pre-SDD → SDD循环
```

### Discovery (Análisis inicial)
- Definir visión del proyecto
- Identificar user personas
- Definir MVP scope y ciclos de entrega
- **Output:** Documento de Discovery en `docs/` o `Bitacora.md`

### Pre-SDD (Preparación)
- Antes de cada ciclo SDD
- Verificar: historias de usuarios definidas, ciclos MVP completos
- Si NO → volver a Discovery
- Si SÍ → listo para SDD

### SDD (Ciclo formal de desarrollo)
- Las 7 fases formales

---

## 📋 SDD Cycle (7 Fases)

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
```

### Ciclo Automático (desde Tasks hasta Verify)

```
Tasks ──▶ Apply ──▶ Verify ──FAIL──▶ Tasks ──▶ Apply ──▶ Verify ──FAIL──▶ Tasks
  ▲                                                                     │
  │                                                                     │
  └─────────────────────────── SUCCESS (100%) ◀────────────────────────┘
```

**Regla clave:** Si Verify falla → volver a Tasks (NO a Design). Repetir hasta 100%.

**Límite:** Max 3 intentos. Si pasa de 3 → esperar intervención humana.

---

## 📋 Rules (5 Reglas Críticas)

### Regla 1: Read-First
- Archivo existente → LEELO primero
- Archivo nuevo → VERIFICÁ que no exista

### Regla 2: Load-Before-Code
- Go tests → `go-testing` skill
- SDD phases → phase skill
- Crear skills → `skill-creator`

### Regla 3: Patterns-Before-Code
- Antes de implementar → revisá `.atl/patterns/`
- Si no existe → documentá uno nuevo

### Regla 4: TDD Validation
- Tests DEBEN tener assertions
- Si no tienen → RECHAZAR

### Regla 5: Cierre de Archive
1. `git add -A`
2. Commit con Conventional Commits + Gitmoji
3. `git status` → verificar limpio
4. Generar informe final

---

## 📂 Patterns (Dónde buscar)

| Si necesitás... | Buscá en... |
|-----------------|------------|
| Arquitectura Go | `.atl/patterns/go-hexagonal.md` |
| Patrones Svelte | `.atl/patterns/svelte-component.md` |
| Repository GORM | `.atl/patterns/gorm-repository.md` |
| Migración de código | `.atl/patterns/code-migration.md` |
| Docker multi-stage | `.atl/patterns/docker-multistage.md` |

---

## 🔗 Archivos Clave

| Archivo | Propósito |
|---------|-----------|
| `README.md` | Quick start + flujo de proyecto |
| `.atl/agent/AGENT_BEHAVIOR.md` | Reglas de ejecución del agente |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Ley del proyecto |
| `.atl/standards/WORKING_STANDARD.md` | Ciclo operativo completo |
| `.atl/specs/sdd-workflow.md` | Especificación del flujo SDD |
| `.atl/standards/TESTING_STRATEGY.md` | Estrategia de testing |
| `openspec/config.yaml` | Configuración del motor SDD |

---

## 📖 Lectura Sugerida por Contexto

### Si acabás de entrar al proyecto
→ Leé este ENTRY.md → luego `README.md` → luego `AGENT_BEHAVIOR.md`

### Si vas a hacer un cambio SDD
→ Verificá en qué etapa está el proyecto (Discovery? Pre-SDD? SDD?)
→ Si está en Discovery/Pre-SDD, NO iniciés SDD sin completar esas etapas

### Si vas a escribir código Go
→ Leé `go-hexagonal.md` + cargá el skill `go-testing`

### Si vas a migrar código
→ Leé `code-migration.md` ANTES de hacer cualquier cosa

---

*Este archivo es el punto de referencia fijo. Si no sabés qué leer, empezá por acá.*
*Si no sabás en qué etapa está el proyecto, PREGUNTÁ.*
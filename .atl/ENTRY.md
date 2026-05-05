# ENTRY.md — Punto de Entrada para Agentes

> Este archivo es la **puerta de entrada obligatoria** para TODO agente orquestador que entre al proyecto.

---

## 🚀 Start Here

1. **Primero que nada:** Leé este archivo completo
2. **Luego:** Según tu tarea, dirigite a la sección correspondiente
3. **Siempre:** Antes de escribir código, cargá los skills relevantes

### Modo de Ejecución Default

| Config | Valor | Cuándo cambiar |
|--------|-------|----------------|
| **Persistence** | `engram` | Solo si el usuario pide `openspec` o `hybrid` |
| **Flow** | `auto` | Volver a `interactive` antes de Archive |
| **Execution** | `synchronous` | Solo si el usuario pide `async` |

---

## 🔄 SDD Cycle

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
```

### Regla Clave
**Si Verify falla → retoma desde Tasks (NO desde Design).**
Repetí el loop Tasks → Apply → Verify automáticamente hasta 100%.

### Ciclo Automático
- El agente ejecuta las fases en `auto` (sin preguntar entre cada fase)
- Antes de Archive, volver a `interactive` para confirmación final

---

## 📋 Rules

### Regla 1: Read-First
Antes de modificar un archivo existente → LEELO primero.
Antes de crear uno nuevo → VERIFICÁ que no exista.

### Regla 2: Load-Before-Code
Si tu tarea coincide con un skill conocido, CARGÁ el skill ANTES de escribir código:
- Go tests → `go-testing`
- SDD phases → skill de la fase (sdd-apply, sdd-spec, etc.)
- Crear skills → `skill-creator`

### Regla 3: Patterns-Before-Code
Antes de implementar algo nuevo → revisá `.atl/patterns/` por patrones aplicables.
Si no existe → documentá uno nuevo antes de improvisar.

### Regla 4: TDD Validation
Los tests DEBEN tener assertions.
Si un test no tiene `assert`/`expect`/`reject` → es FAIL.
El agente DEBE detectar esto y rechazarlo.

### Regla 5: Cierre de Archive
Al final de Archive, el agente DEBE:
1. `git add -A` de todos los cambios
2. Commit con Conventional Commits
3. Verificar `git status` muestre limpio
4. Generar informe final del proyecto

---

## 📂 Patterns

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
| `.atl/agent/AGENT_BEHAVIOR.md` | Reglas de ejecución del agente |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Ley del proyecto (TDD, hexagonal, zero-tolerance) |
| `.atl/standards/WORKING_STANDARD.md` | Ciclo operativo completo |
| `.atl/specs/sdd-workflow.md` | Especificación del flujo SDD |
| `.atl/standards/TESTING_STRATEGY.md` | Estrategia de testing |
| `openspec/config.yaml` | Configuración del motor SDD |

---

## 📖 Lectura Sugerida por Contexto

### Si acabás de entrar al proyecto
→ Leé este ENTRY.md → luego `AGENT_BEHAVIOR.md` → luego `ENGINEERING_MANIFEST.md`

### Si vas a hacer un cambio SDD
→ Leé `WORKING_STANDARD.md` + `sdd-workflow.md` + los specs del cambio

### Si vas a escribir código Go
→ Leé `go-hexagonal.md` + cargá el skill `go-testing`

### Si vas a migrar código
→ Leé `code-migration.md` ANTES de hacer cualquier cosa

---

*Este archivo es el punto de referencia fijo. Si no sabés qué leer, empezá por acá.*
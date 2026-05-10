# ENTRY.md - Punto de Entrada para Agentes

> Este archivo es la **puerta de entrada obligatoria** para TODO agente que entre al proyecto.

---

## ! Preguntas Iniciales (SIEMPRE hacer al empezar)

Antes de hacer cualquier cosa, responde estas preguntas:

1. **¿Que es el proyecto y esta definido?** - Si no hay vision/documento de Discovery, primero hay que hacer eso.

2. **¿Las historias de usuarios estan definidas?** - Si no, el proyecto esta en etapa de Discovery/MVP, no listo para SDD.

3. **¿Los ciclos MVP estan completos?** - Si hay ciclos MVP pendientes, completar esos primero antes de cambios nuevos.

4. **¿Se tiene el contexto para planificar esta change?** - Si la respuesta es NO -> volver a Discovery/Pre-SDD.

**Si no sabes las respuestas -> PREGUNTA al usuario. No asumas.**

---

## ! Modo de Ejecucion Default

```
[Interactive] -> [Auto: Tasks -> Apply -> Verify] -> [Interactive] -> Archive
```

| Rango de fases | Modo | Comportamiento |
|----------------|------|----------------|
| Explore -> Design | `interactive` | El agente pregunta, el usuario responde |
| Tasks -> Apply -> Verify | `auto` | Ejecuta solo, loop automatico hasta 100% |
| Antes de Archive | `interactive` | Confirmacion final antes de commit |

**Override:** El usuario puede pedir "todo auto" o "todo interactive", pero solo para esa sesion. El default vuelve al formato mixto.

---

## ! 3 Etapas del Proyecto

```
Discovery -> Pre-SDD -> SDD Cycle (Loop)
```

### Discovery (Analisis inicial)
- Definir vision del proyecto
- Identificar user personas
- Definir MVP scope y ciclos de entrega
- **Output:** Documento de Discovery en `docs/` o `Bitacora.md`

### Pre-SDD (Preparacion)
- Antes de cada ciclo SDD
- Verificar: historias de usuarios definidas, ciclos MVP completos
- Si NO -> volver a Discovery
- Si SI -> listo para SDD

### SDD (Ciclo formal de desarrollo)
- Las 7 fases formales

---

## ! SDD Cycle (7 Fases)

```
Explore -> Propose -> Spec -> Design -> Tasks -> Apply -> Verify -> Archive
```

### Ciclo Automatico (desde Tasks hasta Verify)

```
Tasks --> Apply --> Verify --FAIL--> Tasks --> Apply --> Verify --FAIL--> Tasks
  ^                                                                     |
  |                                                                     |
  +--------------------------- SUCCESS (100%) <-------------------------+
```

**Regla clave:** Si Verify falla -> volver a Tasks (NO a Design). Repetir hasta 100%.

**Limite:** Max 3 intentos. Si pasa de 3 -> esperar intervencion humana.

---

## ! Rules (5 Reglas Criticas)

### Regla 1: Read-First
- Archivo existente -> LEELO primero
- Archivo nuevo -> VERIFICA que no exista

### Regla 2: Load-Before-Code
- Go tests -> `go-testing` skill
- SDD phases -> phase skill
- Crear skills -> `skill-creator`

### Regla 3: Patterns-Before-Code
- Antes de implementar -> revisa `.atl/patterns/`
- Si no existe -> documenta uno nuevo

### Regla 4: TDD Validation
- Tests DEBEN tener assertions
- Si no tienen -> RECHAZAR

### Regla 5: Cierre de Archive
1. `git add -A`
2. Commit con Conventional Commits + Gitmoji
3. `git status` -> verificar limpio
4. Generar informe final

---

## ! Patterns (Donde buscar)

| Si necesitas... | Busca en... |
|-----------------|------------|
| Arquitectura Go | `.atl/patterns/go-hexagonal.md` |
| Patrones Svelte | `.atl/patterns/svelte-component.md` |
| Repository GORM | `.atl/patterns/gorm-repository.md` |
| Migracion de codigo | `.atl/patterns/code-migration.md` |
| Docker multi-stage | `.atl/patterns/docker-multistage.md` |

---

## ! Archivos Clave

| Archivo | Proposito |
|---------|-----------|
| `README.md` | Quick start + flujo de proyecto |
| `.atl/agent/AGENT_BEHAVIOR.md` | Reglas de ejecucion del agente |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Ley del proyecto |
| `.atl/standards/WORKING_STANDARD.md` | Ciclo operativo completo |
| `.atl/specs/sdd-workflow.md` | Especificacion del flujo SDD |
| `.atl/standards/TESTING_STRATEGY.md` | Estrategia de testing |
| `openspec/config.yaml` | Configuracion del motor SDD |

---

## ! Lectura Sugerida por Contexto

### Si acabas de entrar al proyecto
-> Lee este ENTRY.md -> luego `README.md` -> luego `AGENT_BEHAVIOR.md`

### Si vas a hacer un cambio SDD
-> Verifica en que etapa esta el proyecto (Discovery? Pre-SDD? SDD?)
-> Si esta en Discovery/Pre-SDD, NO inicies SDD sin completar esas etapas

### Si vas a escribir codigo Go
-> Lee `go-hexagonal.md` + carga el skill `go-testing`

### Si vas a migrar codigo
-> Lee `code-migration.md` ANTES de hacer cualquier cosa

---

*Este archivo es el punto de referencia fijo. Si no sabes que leer, empieza por aca.*
*Si no sabes en que etapa esta el proyecto, PREGUNTA.*

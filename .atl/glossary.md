---
date: 2026-04-29
status: active
---

# Glosario del Template

> **Purpose**: Consolidar toda la terminología SDD, mecanismos de registro de decisiones, convenciones de idioma y términos clave del template en un único archivo canónico.
>
> **Archivo canónico**: Este documento es la única fuente de verdad para vocabulario SDD. No repetir contenido en otros archivos.

---

## 1. SDD Phases (Canónicas)

La secuencia canónica de Spec-Driven Development es:

| Phase | Descripción | Agente | Output |
|-------|-------------|--------|--------|
| **Explore** | Investigar y comprender el problema con el cliente | `sdd-explore` | Exploration notes, context |
| **Propose** | Definir intent, alcance y enfoque | `sdd-propose` | Proposal document |
| **Spec** | Escribir requisitos y escenarios | `sdd-spec` | Delta specs |
| **Design** | Documentar arquitectura y decisiones | `sdd-design` | Design document |
| **Tasks** | Descomponer en unidades implementables | `sdd-tasks` | Task checklist |
| **Apply** | Implementar siguiendo specs y diseño | `sdd-apply` | Código modificado |
| **Verify** | Validar implementación contra specs | `sdd-verify` | Verification report |
| **Archive** | Cerrar el cambio y persistir estado final | `sdd-archive` | Commit final |

### Notas Importantes

- **Discovery** es diálogo pre-SDD con el cliente. NO es una fase SDD.
- **Analysis** (Working Standard) = Explore + Propose + Spec (SDD). El Working Standard desglosa "Analysis" en tres fases formales SDD.
- **Analyse** (ortografía británica) está deprecada. Usar **Explore** para fases SDD.

### Batch-Verify

Definición canónica: verificación de pase único donde TODOS los checks deben pasar o el batch es rechazado. No hay éxito parcial.

---

## 2. Mapeo de Terminología

| Término Antiguo | Término Canónico | Notas |
|-----------------|------------------|-------|
| Discovery | pre-SDD | Conversación con cliente, no fase SDD |
| Analysis | Explore + Propose + Spec | Working Standard desglosa Analysis en 3 fases SDD |
| Explore | Explore | Fase SDD #1 |
| Analyse | Explore | Deprecated, ortografía británica. Solo retener en contexto de migración. |

### Batch-Verify — Definición Formal

Una verificación de pase único que:
- Pasa solo si TODOS los checks están verdes
- Falla si CUALQUIER check está rojo
- No hay éxito parcial — el batch es rechazado completo

---

## 3. Registro de Decisiones

### Comparación de Mecanismos

| Mecanismo | Tipo | Ubicación | Formato | Uso |
|-----------|------|-----------|---------|-----|
| **Bitacora.md** | Informal | Raíz del proyecto | ```markdown\n### YYYY-MM-DD — Título\n**Context:** situación\n**Decision:** decisión\n**Motivation:** motivación\n``` | Conversación continua, contexto histórico |
| **DECISION_LOG.md** | Arquitectural | Raíz del proyecto | 6 campos: Context, Decision, Consequences, Alternatives, Date, Status | Decisiones incrementales de arquitectura |
| **ADR** | Estructural | `docs/decisions/NNNN-name.md` | Formato ADR (Título, Estado, Contexto, Decisión, Consecuencias) | Cambios mayores de stack o arquitectura |

### Ruta de Promoción

```
Bitacora.md → DECISION_LOG.md → ADR
```

1. Conversación inicial → Bitacora.md
2. Decisión arquitectural significativa → DECISION_LOG.md
3. Cambio estructural mayor → ADR en `docs/decisions/`

### DECISION_LOG.md — Formato de los 6 Campos

```markdown
## Título de la Decisión

**Date**: YYYY-MM-DD
**Status**: Proposed | Accepted | Deprecated | Superseded
**Context**: ¿Cuál es el problema o situación?
**Decision**: ¿Qué se decidió?
**Consequences**: ¿Qué implicaciones tiene?
**Alternatives**: ¿Qué otras opciones se consideraron?
```

> **Nota**: `DECISION_LOG.md` no existe actualmente en el template. Si se necesita, crear en la raíz del proyecto.

---

## 4. Convenciones de Idioma

| Tipo | Idioma | Notas |
|------|--------|-------|
| **Documentación** | Español (AR) | README, specs, estándares, guías |
| **Código** | English | Variables, funciones, tests, comments |
| **Comments** | Explican WHY, no WHAT | El código dice qué hace; el comment dice por qué |

### Override a navigation.spec.md

> **Corrección**: navigation.spec.md línea 30 dice "Default documentation language is English." **Esto es incorrecto.**

La convención real del template es:
- Documentación: **Español (AR)**
- Código: **English**

Este glosario sobrescribe cualquier declaración contraria en navigation.spec.md.

---

## 5. Términos Clave del Template

### Pattern (Patrón)

**Directorio**: `.atl/patterns/`

**Definición**: Práctica de ingeniería reutilizable, documentada y aplicable transversalmente.

**Ejemplos**:
- `go-hexagonal.md` — Arquitectura hexagonal en Go
- `svelte-component.md` — Patrones de componentes Svelte
- `gorm-repository.md` — Repository pattern con GORM
- `docker-multistage.md` — Builds multi-stage con Docker

**Enforcement**: Recommended. Si un patrón existente aplica, usar; si no aplica, documentar la justificación de la desviación.

---

### Standard (Estándar)

**Directorio**: `.atl/standards/`

**Definición**: Regla operacional queDefine el cómo ejecutar el trabajo. Cubre estilo, testing, security, release, CI/CD.

**Ejemplos**:
- `STYLE_GUIDE.md` — Estándares de código
- `TESTING_STRATEGY.md` — Estrategia de testing
- `WORKING_STANDARD.md` — Ciclo de desarrollo

**Enforcement**: Mandatory. Violaciones deben corregirse antes de commit.

---

### Governance (Gobernanza)

**Directorio**: `.atl/governance/`

**Definición**: Ley del proyecto. Define principios operativos no negociables.

**Ejemplos**:
- `ENGINEERING_MANIFEST.md` — El "sistema operativo" del proyecto
- `COMMIT_CONVENTIONS.md` — Conventional Commits con Gitmoji
- `CONTRIBUTING.md` — Cómo contribuir

**Enforcement**: Mandatory. Ignorar gobernanza = cambio rechazado en pipeline.

---

### Rule (Regla)

**Definición**: Restricción obligatoria dentro de un documento de gobernanza.

**Identificación**: Numerala (#1, #2, etc.) dentro de ENGINEERING_MANIFEST.md

**Ejemplos**:
- Rule #1: Linguistic Identity
- Rule #8: Discovery-First
- Rule #11: Security by Design

**Enforcement**: Zero-tolerance. El pipeline rechaza cambios que violen reglas.

---

### Prototype vs Production

| Término | Significado | Uso |
|---------|-------------|-----|
| **Prototype** | React-based, disposable reference | NO es fuente de producción. Solo extraer lógica, descartar UI. |
| **Production** | SvelteKit + Go + PostgreSQL | Stack opinado y definitivo del template |

### Migración de Código

| Término | Mapeo | Contexto |
|---------|-------|----------|
| Analyse | Explore | Protocolo de migración (code-migration.md §5.1) |
| Diseño | Design | SDD Phase #4 |
| Tasks | Tasks | SDD Phase #5 |

---

## Cross-References

Para referencia directa:

| Archivo | Rol |
|---------|-----|
| `.atl/governance/ENGINEERING_MANIFEST.md` | Ley del proyecto — todas las reglas |
| `.atl/standards/WORKING_STANDARD.md` | Ciclo operativo: Analysis → Design → Tasks → Apply → Verify → Archive |
| `.atl/agent/AGENT_BEHAVIOR.md` | Reglas de comportamiento de agentes |
| `.atl/specs/navigation.spec.md` | Navegación LLM del repositorio |

---

*Este glosario es la única fuente de verdad para terminología SDD. No repetir contenido en otros archivos.*
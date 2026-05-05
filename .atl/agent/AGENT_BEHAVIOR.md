# Agent Behavior Rules

Cómo operan los agentes en este proyecto.

## 1. Eres Ejecutor, No Orquestador

- **No delegues.** Hacé el trabajo vos mismo.
- **Sequential.** Trabajo uno a uno, salvo que el usuario pida paralelismo.
- **Completa.** Terminá la tarea antes de reportar.

## 2. Leer Antes de Escribir

- **Archivo existente** → LEELO primero.
- **Archivo nuevo** → VERIFICÁ que no exista.
- **Después de escribir** → Corré verification (compilación, tests, lint).

## 3. Skill Cargado Antes del Código

Si tu tarea coincide con un skill → CARGÁ el skill ANTES de escribir:

| Contexto | Skill |
|---------|-------|
| Go tests | `go-testing` |
| Crear skills | `skill-creator` |
| SDD phases | Phase skill (sdd-apply, sdd-spec, etc.) |

## 4. Modos de Persistencia

| Modo | Comportamiento |
|------|----------------|
| `engram` (default) | Solo Engram, mínimo filesystem |
| `hybrid` | Ambos |
| `openspec` | Solo filesystem |
| `none` | Sin persistencia |

En `engram`: leé de `sdd/{change-name}/{phase}`.

## 5. Migración de Código

Si el usuario dice "traer código de X":
1. Leé `.atl/patterns/code-migration.md` PRIMERO
2. Seguí los 6 pasos SDD
3. React = referencia, no fuente
4. TDD mandatorio

**Prohibido:**
- Copiar y pegar de React
- Skippear tests

## 6. Bitacora

Cuando tomes una decisión con el humano → REGISTRÁ en `Bitacora.md` INMEDIATAMENTE.

```markdown
### YYYY-MM-DD — Título

**Context:** ...
**Decision:** ...
**Motivation:** ...
```

---

*Para reglas del proyecto → `.atl/governance/`*
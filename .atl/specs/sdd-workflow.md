# SDD Workflow Specification

**Document ID**: sdd-workflow
**Version**: 1.1
**Status**: Active
**Dependencies**: [.atl/agent/AGENT_BEHAVIOR.md](../agent/AGENT_BEHAVIOR.md), [.atl/ENTRY.md](../ENTRY.md)

---

## 1. SDD Cycle Overview

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
                                                        ↓
                                              100% PASS required
```

### Phase Descriptions

| Phase | Purpose | Output |
|-------|---------|--------|
| **Explore** | Investigate the problem space | Investigation notes |
| **Propose** | Define intent and approach | Change proposal |
| **Spec** | Write requirements and scenarios | Delta specs |
| **Design** | Define technical architecture | Design document |
| **Tasks** | Break into actionable steps | Task checklist |
| **Apply** | Implement tasks | Working code |
| **Verify** | Validate against specs | 100% PASS report |
| **Archive** | Close change, commit, report | Git clean |

---

## 2. Automatic Verify Loop

### If Verify Fails → Retake from Tasks (NOT Design)

**Loop hasta 100%:**

```
Tasks → Apply → Verify
    ↑            ↓
    ← FAIL ←─────
    |
    └── Fix tasks, re-apply, re-verify (max 3 attempts)
```

**Process:**
1. Verify falla → volver a Tasks
2. Corregir/añadir tareas
3. Re-apply → Re-verify
4. Repetir hasta 100%
5. Después de pasar → volver a `interactive` antes de Archive

---

## 3. Default Modes (v2.1.0)

| Config | Default | Override |
|--------|---------|----------|
| **Persistence** | `engram` | `hybrid`, `openspec` si el usuario pide |
| **Flow** | `auto` | `interactive` si el usuario pide |
| **Execution** | `synchronous` | `async` si el usuario pide |

**Antes de Archive:** Siempre volver a `interactive` para confirmación.

---

## 4. TDD Validation

**Tests DEBEN tener assertions:**
- Go: `assert`, `require`, `testing.Assert`
- TS: `expect`, `assert`, `should`

Si un test no tiene → **FAIL** → rechazar hasta que tenga lógica de validación.

---

## 5. Archive Closure Protocol

Al final de Archive:

1. `git add -A` — agregar todos los cambios
2. Commit con Conventional Commits + Gitmoji
3. `git status` — verificar que esté limpio
4. Generar informe final del estado del proyecto

---

## 6. Entry Point

**El punto de entrada para agentes es `.atl/ENTRY.md`.**
Allí está la navegación completa, modos de ejecución, y reglas.

---

## 7. References

- [.atl/ENTRY.md](../ENTRY.md) — Punto de entrada fijo
- [.atl/agent/AGENT_BEHAVIOR.md](../agent/AGENT_BEHAVIOR.md)
- [.atl/governance/ENGINEERING_MANIFEST.md](../governance/ENGINEERING_MANIFEST.md)

---

*SDD Workflow v1.1: Automatic, traceable, verifiable.*
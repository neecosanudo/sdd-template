# SDD Workflow Specification

**Document ID**: sdd-workflow
**Version**: 1.2
**Status**: Active
**Dependencies**: [.atl/agent/AGENT_BEHAVIOR.md](../agent/AGENT_BEHAVIOR.md), [.atl/ENTRY.md](../ENTRY.md)

---

## 3 Etapas del Proyecto

```
Discovery -> Pre-SDD -> SDD Cycle (Loop)
```

### Discovery (Analisis inicial)
**Antes de cualquier codigo.** Definir vision, user personas, MVP scope, ciclos de entrega.

### Pre-SDD (Preparacion)
**Antes de cada ciclo SDD.** Verificar historias de usuarios definidas y ciclos MVP completados.

### SDD (Ciclo de desarrollo)
**Las 7 fases formales.**

---

## SDD Cycle Overview

```
Explore -> Propose -> Spec -> Design -> Tasks -> Apply -> Verify -> Archive
                                                        |
                                              100% PASS required
```

---

## Modo de Ejecucion (Default)

```
[Interactive] -> [Auto: Tasks -> Apply -> Verify] -> [Interactive] -> Archive
```

| Fases | Modo |
|-------|------|
| Explore -> Design | `interactive` |
| Tasks -> Apply -> Verify | `auto` (loop hasta 100%) |
| Antes de Archive | `interactive` |

**Override:** Usuario puede pedir otro modo por sesion.

---

## Automatic Verify Loop

```
Tasks --> Apply --> Verify --FAIL--> Tasks --> Apply --> Verify --FAIL--> Tasks
  ^                                                                     |
  |                                                                     |
  +--------------------------- SUCCESS (100%) <-------------------------+
```

**Regla:** Si Verify falla -> volver a Tasks (NO a Design).
**Limite:** Max 3 intentos.

---

## Entry Point

**El punto de entrada para agentes es `.atl/ENTRY.md`.**

También ver `README.md` para el prompt de entrada que el usuario debe copiar y pegar al iniciar sesión.

---

## References

- [.atl/ENTRY.md](../ENTRY.md) - Punto de entrada fijo
- [.atl/agent/AGENT_BEHAVIOR.md](../agent/AGENT_BEHAVIOR.md)
- [.atl/governance/ENGINEERING_MANIFEST.md](../governance/ENGINEERING_MANIFEST.md)
- [.atl/standards/WORKING_STANDARD.md](../standards/WORKING_STANDARD.md)

---

*SDD Workflow v1.2: 3 etapas + 7 fases.*

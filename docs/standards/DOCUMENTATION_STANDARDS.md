# Documentation Standards

> **Propósito**: Este documento define qué documentos existen, cuándo se actualizan, y quién es responsable.
>
> **MODO**: Template — completar con los documentos específicos del proyecto.

---

## Inventario de Documentos

| Documento | Propósito | Se actualiza en |
|-----------|-----------|-----------------|
| `docs/AGENT.md` | Protocolo de trabajo del agente | Archive — actualizar versión |
| `docs/CONTEXT.md` | Estado actual del proyecto | Archive — SIEMPRE |
| `docs/DISCOVERY.md` | Visión, roadmap, análisis | Archive — si cambió alcance |
| `docs/GOVERNANCE.md` | Gobernanza, branching, commits | Archive — si cambió flujo |
| `docs/STANDARDS.md` | Estándares técnicos | Archive — si cambió stack |
| `docs/patterns/` | Patrones de código | Archive — si hay nuevos |
| `docs/decisions/` | ADRs | Archive — si hay nueva decisión |
| `docs/standards/` | Estrategias (testing, docs) | Archive — si cambian |
| `DEBT.md` | Deuda técnica | Archive — si se pagó/agregó deuda |
| `Bitacora.md` | Decisiones del usuario | SOLO cuando el usuario decide algo |
| `README.md` | Vista general del proyecto | Archive — si cambió stack/estructura |

<!-- [TODO: Personalizar según los documentos del proyecto] -->

---

## Reglas de Bitacora.md

- **Solo el USUARIO genera entradas** — el agente NO escribe en Bitacora.md
- **NO escribir entradas de "Ciclo X completado"** — eso va en `CONTEXT.md` y Engram
- Las entradas documentan: contexto, decisión, resultado, participantes
- **Formato**: `### YYYY-MM-DD — Título Breve`

---

## Responsabilidades del Archive

Al cerrar un ciclo SDD, el agente que ejecuta la fase Archive debe:

1. **Verificar cada documento de la tabla arriba**
2. **Si corresponde actualizar** → hacerlo
3. **Si no corresponde** → dejarlo intacto
4. **Al final, verificar que ningún documento tenga versiones inconsistentes**

---

## Regla Final

> **"Si tocaste código, tocaste la documentación."**

Si una decisión de implementación diverge del diseño documentado, actualizar el diseño ANTES de hacer commit.

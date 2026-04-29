# Design: Enhanced Migration Analysis

## Technical Approach

Crear 3 archivos en `.atl/patterns/` con recursos estructurados de análisis, y modificar `code-migration.md` para corregir "Analyse"→"Explore" y agregar cross-references. Cada archivo sigue el formato existente (Pattern ID, versión, dependencias).

## Architecture Decisions

| Decisión | Opción | Rationale |
|----------|--------|-----------|
| Organización por paso | Recursos agrupados por paso SDD en migration-analysis.md | Alineado con tabla 6-pasos en code-migration.md §2 |
| Formato ejemplos | ASCII/emoji, ≤5 líneas | Sin tooling externo, reproducible en terminal |
| Cross-references | Links directos a `.atl/patterns/` | Funcionales sin tooling adicional |

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `.atl/patterns/migration-discovery.md` | Create | Discovery pre-migración: trigger, entrevista 5 preguntas, output |
| `.atl/patterns/migration-analysis.md` | Create | 7 recursos: Mapa Visual, Árbol Componentes, Flujo Estados, Árbol Navegación, Matriz Funcionalidades, Inventario Interacciones, Flujo Datos |
| `.atl/patterns/migration-verify.md` | Create | Checklist, Análisis Diffs, Verification Workflow |
| `.atl/patterns/code-migration.md` | Modify | Replace "Analyse"→"Explore" + cross-references |

## Interfaces / Contracts

### migration-discovery.md — Estructura Exacta

```
# Patrón: Discovery Pre-Migración
**Pattern ID**: migration-discovery | **Versión**: 1.0
**Dependencias**: [code-migration.md](code-migration.md) | [glossary.md](../glossary.md)

## 1. Trigger (cuándo ejecutar discovery, detección de intención)
## 2. Entrevista Estructurada (5 preguntas obligatorias en orden, formato Q&A)
## 3. Output: Documento de Discovery (formato, estructura, "sin respuesta" para no respondidas)
```

### migration-analysis.md — Estructura Exacta

```
# Patrón: Análisis de Migración
**Pattern ID**: migration-analysis | **Versión**: 1.0
**Dependencias**: [code-migration.md](code-migration.md)

## Step 1: Explore
### Recurso 1: Mapa Visual — ASCII boxes/labels. Mandatory si hay UI.
  Purpose | When to Use | Format | Example (≤5 líneas ASCII)
### Recurso 2: Árbol de Componentes — Markdown tree [props]. Mandatory si nesting >2.
### Recurso 3: Flujo de Estados — ASCII/Mermaid diagram. Mandatory si entidad ≥3 estados.
### Recurso 4: Árbol de Navegación — Markdown route tree. Mandatory si multi-página.
### Recurso 6: Inventario de Interacciones — Table: Event | Handler | Component | Action.

## Step 2: Design
### Recurso 5: Matriz Funcionalidades — Table: Feature | Component | Logic | State.
### Recurso 7: Flujo de Datos — ASCII: Input → Form → Validation → API → Store → Component.
```

Cada Recurso tiene 4 campos: **Purpose** (1 párrafo), **When to Use** (1 línea), **Format** (1 línea), **Example** (≤5 líneas, ASCII/emoji).

### migration-verify.md — Estructura Exacta

```
# Patrón: Verificación de Migración
**Pattern ID**: migration-verify | **Versión**: 1.0
**Dependencias**: [code-migration.md](code-migration.md)

## 1. Checklist de Funcionalidades Críticas
  Table: Item | PASS | FAIL | Categories: UI Elements, Interactions, States, Edge Cases, Responsive
  100% PASS required to advance.

## 2. Análisis de Diffs
  Table: Feature | Original | Migrated | Status (MATCH | GAP | ENHANCED)
  Sin original → comparar contra discovery document.

## 3. Verification Workflow
  1. Run checklist → FAIL → back to Apply
  2. 100% PASS → run diffs
  3. GAP → back to Apply
  4. All MATCH/ENHANCED → Archive
```

Cross-references a code-migration.md en cada sección.

### code-migration.md — Modificaciones Exactas

| Línea Actual | Reemplazar por |
|--------------|----------------|
| §2 tabla: `\| 1 \| **Analyse** \|` | `\| 1 \| **Explore** \|` |
| §2 nota: "Las palabras son las mismas que usa el ciclo SDD (`Analyse`, `Design`...)" | "El ciclo SDD usa `Explore`, `Design`, `Tasks`, `Apply`, `Verify`, `Archive` (ver [glossary.md](../glossary.md) §1). En migración, `Explore` refiere al análisis de código fuente para separar lógica de negocio de plumbing, no a la fase de investigación con cliente." |
| `### 2.1 Paso 1: Analyse` | `### 2.1 Paso 1: Explore` |
| `**Fase SDD**: `Analyse`` | `**Fase SDD**: `Explore`` |

**Insertar después de §2.1**:
```markdown
> **Recursos**: [migration-discovery.md](migration-discovery.md) (trigger + entrevista),
> [migration-analysis.md](migration-analysis.md) Recursos 1-4, 6 (mapa visual, árbol de
> componentes, flujo de estados, navegación, interacciones).
```

**Insertar después de §2.2**:
```markdown
> **Recursos**: [migration-analysis.md](migration-analysis.md) Recursos 5, 7 (matriz de
> funcionalidades, flujo de datos).
```

**Insertar después de §2.5**:
```markdown
> **Recursos**: [migration-verify.md](migration-verify.md) §1-3 (checklist funcional,
> análisis de diffs, workflow de verificación).
```

**Insertar después de §2.6**:
```markdown
> Ver [migration-verify.md](migration-verify.md) §2 (Análisis de Diffs) para comparación
> final pre-archive.
```

**§7 Referencias — agregar**:
```
- [migration-discovery.md](migration-discovery.md) — Discovery pre-migración
- [migration-analysis.md](migration-analysis.md) — Recursos de análisis
- [migration-verify.md](migration-verify.md) — Verificación post-migración
```

**Secciones NO modificadas**: §1 (Principio), §3 (Tablas Mapeo), §4 (Prototipo), §5 (Testing), §6 (Anti-patrones). La estructura de 6 pasos permanece intacta.

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Documentación | Links funcionales | Verify cada cross-reference en code-migration.md apunta a archivo existente |
| Documentación | Consistencia terminológica | `rg "Analyse" .atl/patterns/code-migration.md` = 0 resultados |

## Migration / Rollout

No migration required. Revertir: `git revert HEAD`.

## Open Questions

None.

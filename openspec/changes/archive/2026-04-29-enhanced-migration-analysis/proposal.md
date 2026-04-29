# Proposal: Enhanced Migration Analysis

## Intent

El patrón `code-migration.md` carece de recursos estructurados de análisis para agentes que realizan migraciones. Sin guías explícitas para mapas visuales, árboles de componentes, flujos de estado y checklists de verificación, los agentes producen calidad de migración inconsistente. Este cambio agrega 10 recursos de análisis organizados en archivos de patrón dedicados.

## Scope

### In Scope

- Crear `migration-discovery.md` — Pre-migration discovery con entrevista al usuario (Recurso 10)
- Crear `migration-analysis.md` — Recursos de análisis 1-7 (pasos Explore/Design)
- Crear `migration-verify.md` — Recursos de verificación 8-9 (pasos Verify/Archive)
- Modificar `code-migration.md` — Corregir "Analyse" → "Explore", agregar referencias cruzadas

### Out of Scope

- Sin cambios en `glossary.md` ni terminología fuera del contexto de migración
- Sin cambios en el proceso de 6 pasos (estructura intacta)
- Sin implementación de código ni cambios en tests

## Capabilities

### New Capabilities

None — son archivos de documentación de patrón, no capacidades a nivel spec.

### Modified Capabilities

None — ningún spec existente cambia sus requisitos. Es refactor de documentación.

## Approach

Separar los 10 recursos en 3 archivos dedicados en `.atl/patterns/`:

1. **`migration-discovery.md`** — Pre-migration (Recurso 10: entrevista al usuario)
2. **`migration-analysis.md`** — Pasos 1-2 (Recursos 1-7: técnicas de análisis)
3. **`migration-verify.md`** — Pasos 5-6 (Recursos 8-9: verificación)

Actualizar `code-migration.md`: renombrar "Analyse" → "Explore" en todos los nombres de paso y agregar referencias a los nuevos archivos. Cada recurso incluye: Propósito, Cuándo usarlo, Formato y Ejemplo conciso orientado al agente.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.atl/patterns/code-migration.md` | Modified | Corregir terminología, agregar cross-references |
| `.atl/patterns/migration-discovery.md` | New | Pre-migration discovery & user interview |
| `.atl/patterns/migration-analysis.md` | New | Analysis resources 1-7 |
| `.atl/patterns/migration-verify.md` | New | Verification resources 8-9 |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Cross-reference drift desde code-migration.md | Low | Actualizar referencias en el mismo cambio |
| Superposición entre recursos (e.g. Mapa Visual vs Árbol) | Low | Diferenciación clara por recurso |

## Rollback Plan

Revertir commit: eliminar 3 archivos nuevos, restaurar `code-migration.md` via `git checkout`.

## Dependencies

- Ninguna — cambio de documentación standalone

## Success Criteria

- [ ] `migration-discovery.md` contiene 5 preguntas de entrevista para contexto de usuario
- [ ] `migration-analysis.md` contiene los 7 recursos con Purpose/When/Format/Example
- [ ] `migration-verify.md` contiene checklist funcional y análisis de diffs
- [ ] `code-migration.md` usa "Explore" consistentemente (sin "Analyse" en nombres de paso)
- [ ] Cada archivo es referenciable independientemente desde `code-migration.md`
- [ ] Cada ejemplo incluido es conciso y orientado a comprensión del agente

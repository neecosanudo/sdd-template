## Exploration: Enhanced Migration Analysis Resources

### Current State

The `.atl/patterns/code-migration.md` file is 263 lines with 7 sections:

1. **§1. Principio Fundamental** (lines 9-22) — Origin-agnostic, destination-specific principle
2. **§2. Proceso de 6 Pasos** (lines 25-118) — Maps 6 steps to SDD phases (uses "Analyse" - British spelling)
3. **§3. Tablas de Mapeo** (lines 121-154) — Mapping tables for Go/SvelteKit/Godot
4. **§4. Prototipo vs Producción** (lines 157-174) — Prototype rules
5. **§5. Estrategia de Testing** (lines 177-220) — TDD and coverage requirements
6. **§6. Anti-Patrones** (lines 224-249) — Forbidden practices
7. **§7. Referencias** (lines 252-259) — Links to other patterns

**Critical terminology conflict**: The glossary (`glossary.md` §2) states "Analyse (ortografía británica) está deprecada. Usar Explore para fases SDD." However, `code-migration.md` §2 uses "Analyse" intentionally — the glossary notes this spelling should ONLY be retained in migration context. This creates a dialectal inconsistency but is technically correct per the glossary exception.

### Affected Areas

- `.atl/patterns/code-migration.md` — Primary file to integrate the 10 analysis resources
- `.atl/glossary.md` — May need a terminology note about "Analyse" vs the 10 resources (no change needed yet)
- Potential new section §8 or integration into §2 (Proceso de 6 Pasos)

### Resource Mapping to Migration Steps

The user requested organization by "SDD migration step (Analyse, Design, Tasks, Apply, Verify, Archive)" — using the 6-step migration process from §2.

| Step | SDD Phase | Resources Assigned |
|------|-----------|-------------------|
| **1. Analyse** | Explore | 1. Mapa Visual (ASCII/Emoji)<br>2. Árbol de Componentes con Props<br>3. Flujo de Estados (State Machine)<br>4. Árbol de Navegación / Rutas<br>6. Inventario de Interacciones (Event Handlers)<br>10. Entrevista Estructurada al Usuario* |
| **2. Design** | Design | 5. Matriz de Funcionalidades vs Componentes<br>7. Flujo de Datos (Data Flow Diagram) |
| **3. Tasks** | Tasks | *(None — Tasks step is for creating task breakdowns)* |
| **4. Apply** | Apply | *(None — Apply step is for implementation)* |
| **5. Verify** | Verify | 8. Checklist de Funcionalidades Críticas<br>9. Análisis de Diffs |
| **6. Archive** | Archive | 9. Análisis de Diffs (also fits here for final documentation) |

*Note: Entrevista Estructurada (Resource 10) is technically pre-migration (Discovery per glossary), but fits in Analyse step as user context gathering.*

### Format Recommendations

| # | Resource | Recommended Format | Purpose |
|---|----------|-------------------|---------|
| 1 | Mapa Visual | ASCII art or emoji grid with legend | Quick visual overview of app structure |
| 2 | Árbol de Componentes | Markdown tree with props as sub-bullets | Document component hierarchy |
| 3 | Flujo de Estados | Mermaid stateDiagram or ASCII state table | Map state transitions |
| 4 | Árbol de Navegación | Markdown tree or Mermaid graph | Document routes/pages |
| 5 | Matriz Funcionalidades | Markdown table (Feature × Component × Priority) | Map features to components |
| 6 | Inventario Interacciones | Markdown table (Event × Handler × Component) | Catalog event handlers |
| 7 | Flujo de Datos | Mermaid flowchart or ASCII data flow | Show data movement |
| 8 | Checklist Funcionalidades | Markdown checklist table with pass/fail columns | Validation checklist |
| 9 | Análisis de Diffs | Side-by-side diff table or git diff output | Compare original vs migrated |
| 10 | Entrevista Estructurada | Structured questionnaire (Q&A format) | Gather user requirements |

### Estimated Scope of Changes

**Additive changes** (primarily):
- New section §8: "Recursos de Análisis" (estimated 150-200 lines)
- Alternatively, integrate into §2 as subsections §2.7 through §2.16 (one per resource)

**Modifications to existing content**:
- §2 (Proceso de 6 Pasos): Add references to resources in each step (~15 lines added)
- §2.1 (Paso 1: Analyse): Reference resources 1, 2, 3, 4, 6, 10
- §2.2 (Paso 2: Design): Reference resources 5, 7
- §2.5 (Paso 5: Verify): Reference resources 8, 9

**Lines estimate**:
- Current: 263 lines
- Addition: ~180-230 lines (10 resources × ~18-23 lines each)
- Modifications: ~15 lines
- **New total: ~460-510 lines**

### Approaches

1. **Add New Section §8** — Create standalone "Recursos de Análisis" section
   - Pros: Preserves existing structure, additive only, easy to review
   - Cons: Makes file longer (~460-510 lines total)
   - Effort: Low

2. **Integrate into §2** — Add each resource as subsection of step 2 (Proceso de 6 Pasos)
   - Pros: Resources appear in context of their relevant step
   - Cons: Significantly modifies existing section, harder to review diffs
   - Effort: Medium

3. **Split into Separate File** — Create `.atl/patterns/migration-analysis.md`
   - Pros: Keeps code-migration.md focused, better separation of concerns
   - Cons: More files to maintain, requires cross-referencing
   - Effort: Low

### Recommendation

**Approach 1: Add New Section §8** to `code-migration.md` with:
- Brief introduction explaining the purpose
- 10 subsections (§8.1 through §8.10), one per resource
- Each subsection: purpose, when to use, format specification, example (optional)

**Why**: This is additive, preserves existing structure, and doesn't require modifying the core 6-step process significantly. It also keeps all migration-related content in one file.

**Alternative**: If file length becomes an issue (>400 lines), split into `.atl/patterns/migration-analysis.md` and reference it from `code-migration.md`.

### Risks

- **Terminology inconsistency**: "Analyse" (British) vs glossary deprecation — technically correct per glossary exception, but could confuse new developers
- **File length**: Adding ~200 lines may make code-migration.md too long — consider splitting into a separate `migration-analysis.md` file
- **Resource overlap**: Some resources may duplicate effort (e.g., Mapa Visual vs Árbol de Componentes) — need clear differentiation

### Open Questions

1. Should the 10 resources be integrated into `code-migration.md` §2, or create a new separate file `.atl/patterns/migration-analysis.md`?
2. Should we align "Analyse" to "Explore" (per glossary) in the migration context, or keep the British spelling as an intentional exception?
3. Should Resource 10 (Entrevista) be positioned as pre-Analyse (Discovery) or part of Analyse step?
4. Should examples be included for each resource format, or just specification of the format?

### Ready for Proposal

**Yes** — The exploration is complete. The user should review:
1. The resource-to-step mapping (table above)
2. The format recommendations
3. The open questions before proceeding to proposal

**Next action**: User decides on open questions → sdd-propose phase

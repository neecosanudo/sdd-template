# Design: Template Audit Fixes

## Technical Approach

Seven self-contained fixes across 6 files (5 modified, 1 created). All are documentation edits except `verify-template.sh` (functional). No SDD pipeline changes.

## Architecture Decisions

| Decision | Choice | Alternatives | Rationale |
|----------|--------|-------------|-----------|
| Bitacora rule location | §6 in AGENT_BEHAVIOR.md | In glossary §3 | Behavior rules belong in agent doc, not glossary |
| C3/C4 implementation | Pure bash+grep | Python/Go script | No new deps; follows existing script pattern |
| ADR numbering | `0001-repository-structure.md` | Any `NNNN-` prefix | First ADR in this series; matches glossary |
| Link display text | Full relative path | Keep short `react.md` | Eliminates inconsistency from prior verify |

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `.atl/glossary.md` | Modify (×2) | R1: Refine §4 language table; R3: Update §3 Bitacora row + Engram note |
| `.atl/agent/AGENT_BEHAVIOR.md` | Modify | R2: Add §6 — immediate Bitacora logging rule |
| `.atl/patterns/code-migration.md` | Modify (×2) | R4: Fix 3x display text; R5-downstream: update resource refs |
| `.atl/patterns/migration-analysis.md` | Modify | R5: Swap Recurso 6↔5 labels |
| `verify-template.sh` | Modify | R6: Implement C3 (link validation) and C4 (deprecated term detection) |
| `docs/decisions/0001-repository-structure.md` | Create | R7: ADR explaining `.atl/` structure |

---

### R1 — Glossary §4 Language Specificity

**File**: `.atl/glossary.md`, lines 96-103 (Convenciones de Idioma table).

Replace current 3-row table with 4-row version that explicitly distinguishes identifiers from string literals:

```diff
-| **Documentación** | Español (AR) | README, specs, estándares, guías |
-| **Código**        | English      | Variables, funciones, tests, comments |
+| **Documentación (.md)**   | Español (AR) | README, specs, estándares, guías, toda documentación |
+| **Código: identificadores** | English   | Variables, funciones, clases, nombres de archivo |
+| **Código: string literals** | Español (AR) | Mensajes al usuario, textos de UI, strings en código |
```

Keep the "Comments" row and Override subsection unchanged.

### R2 — AGENT_BEHAVIOR.md §6

**File**: `.atl/agent/AGENT_BEHAVIOR.md`. Insert new §6 after line 88 (end of §5.3 table) and before line 90 `---` footer.

```markdown
## 6. Bitacora Decision Logging

### 6.1 Immediate Recording Requirement

When a project decision is reached with the human collaborator, the agent MUST immediately append a new entry to `Bitacora.md` at the repository root. Do NOT batch entries or defer to session end.

### 6.2 Entry Format

Each entry MUST follow the Bitacora.md convention with date, context, decision, and motivation:

```markdown
### YYYY-MM-DD — Brief Title

**Context:** What was the situation or question?
**Decision:** What was agreed or decided?
**Motivation:** Why was this the right choice?
```
```

### R3 — Glossary §3 Bitacora/Engram Distinction

**File**: `.atl/glossary.md`.

**Bitacora row (line 65, "Uso" column)**: Append "Mantenido por el agente." to existing text.

**After ADR row (line 67)**: Insert distinction note:

```markdown
> **Engram**: Además de Bitacora.md, el agente persiste decisiones en Engram (memoria persistente técnica, machine-readable, searchable). Ambos coexisten — Bitacora es cronología humana, Engram es búsqueda técnica.
```

### R4 — code-migration.md Link Display Text

**File**: `.atl/patterns/code-migration.md`, lines 5, 169, 265.

Each occurrence of `[react.md](../../docs/tools/react.md)` → `[docs/tools/react.md](../../docs/tools/react.md)`. The target URL stays the same (it resolves correctly); only the displayed text changes for transparency.

### R5 — migration-analysis.md Sequential Numbering

**File**: `.atl/patterns/migration-analysis.md`.

- **Line 126**: `### Recurso 6: Inventario de Interacciones` → `### Recurso 5: Inventario de Interacciones`
- **Line 149**: `### Recurso 5: Matriz de Funcionalidades` → `### Recurso 6: Matriz de Funcionalidades`

**Downstream in `.atl/patterns/code-migration.md`**:
- **Line 53**: `recursos 1-4 y 6` → `recursos 1-5` (all Explore resources now sequential)
- **Line 65**: `recursos 5 y 7` → `recursos 6 y 7` (Design resources after renumber)

### R6 — verify-template.sh C3 and C4

**File**: `verify-template.sh`.

**C3 (lines 42-44)**: Replace stub with link validation:

1. Find all `.md` files (exclude `node_modules/`)
2. Extract markdown links `[text](url)` where url does NOT start with `http` or `#`
3. Resolve each url relative to the containing file's directory
4. Normalize path with `realpath -m`
5. Fail if resolved path is not a file or directory
6. Report `$file -> $url` on failure, increment `ERRORS`

**C4 (lines 47-49)**: Replace stub with deprecated term detection:

1. Parse `.atl/glossary.md` §2 table rows between the header and next section
2. Extract "Término Antiguo" values (first column, trimmed)
3. `grep -rnw` each term across all `.md` files
4. Exclude the glossary file itself from results
5. Report `$file:$lineno uses deprecated term '$term'` on match, increment `ERRORS`

Both checks preserve the existing error-counting pattern (`ERRORS=$((ERRORS + 1))`) and pass/fail output format.

### R7 — Repository Structure ADR

**File**: `docs/decisions/0001-repository-structure.md` (NEW).

ADR following glossary §3 format (Título, Estado, Contexto, Decisión, Consecuencias):

```markdown
# ADR-0001: Estructura del Directorio `.atl/`

**Estado**: Aprobado  
**Fecha**: 2026-04-29

## Contexto

El template necesita un repositorio canónico de metadatos del proyecto:
estándares operativos, patrones reutilizables, gobernanza, specs de
navegación y glosario terminológico. Sin estructura definida, estos
artefactos se dispersan en raíz, `docs/`, o no existen.

## Decisión

Centralizar toda la metadata del proyecto bajo `.atl/` con cuatro
subdirectorios:

| Directorio | Contenido | Ejemplos |
|------------|-----------|----------|
| `.atl/governance/` | Reglas no negociables | ENGINEERING_MANIFEST, COMMIT_CONVENTIONS |
| `.atl/standards/` | Reglas operacionales | WORKING_STANDARD, TESTING_STRATEGY |
| `.atl/patterns/` | Prácticas reutilizables | go-hexagonal, code-migration |
| `.atl/specs/` | Especificaciones template | navigation.spec.md |

La raíz queda reservada para: `README.md`, `Bitacora.md`, `STACK_MAP.md`,
`docs/`, `openspec/`.

## Consecuencias

**Positivas**: Ubicación predecible para agentes; separación template vs
código proyecto; escalable.
**Negativas**: Curva de aprendizaje inicial; dos lugares de documentación.
**Riesgo**: Agentes no entrenados crean archivos en raíz — mitigado por
`navigation.spec.md`.

## Referencias

- `.atl/specs/navigation.spec.md` — Reglas de navegación
- `.atl/glossary.md` — Definiciones de Pattern/Standard/Governance
```

## Testing Strategy

| Layer | What | How |
|-------|------|-----|
| Script sanity | C3 passes on known-good links | Run `verify-template.sh`, expect PASS |
| Script negative | C3 catches non-existent link | Add temp broken link, run, expect FAIL |
| Script negative | C4 detects deprecated term | Add "Discovery" to temp file, run, expect FAIL |
| Manual review | Doc edits render correctly | Open each modified file, verify formatting |
| Manual review | ADR exists and follows format | Read `docs/decisions/0001-repository-structure.md` |

## Migration / Rollout

No migration required. Per-file revert via `git checkout`.

## Open Questions

None.

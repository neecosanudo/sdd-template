# Tasks: Enhanced Migration Analysis

## Phase 1: Foundation — migration-discovery.md

- [ ] 1.1 Create `.atl/patterns/migration-discovery.md` with header: Pattern ID `migration-discovery`, Versión 1.0, Dependencias `code-migration.md` + `glossary.md`
- [ ] 1.2 Add §1 Trigger section: agent detects migration intent keywords ("migrate", "bring code", "port") and executes discovery BEFORE any migration step
- [ ] 1.3 Add §2 Entrevista Estructurada with 5 mandatory questions in order (most important thing, daily features, loved details, minor-but-important touches, rejection criteria) in Q&A format
- [ ] 1.4 Add §3 Output section: discovery document format with "sin respuesta" marker for unanswered questions
- [ ] 1.5 Add cross-reference to `code-migration.md` in header dependencies

## Phase 2: Core — migration-analysis.md

- [ ] 2.1 Create `.atl/patterns/migration-analysis.md` with header: Pattern ID `migration-analysis`, Versión 1.0, Dependencias `code-migration.md`
- [ ] 2.2 Add Recurso 1 (Mapa Visual): Purpose, When to Use (UI migration), Format (ASCII art boxes/labels/hierarchy), Example (≤5 lines ASCII)
- [ ] 2.3 Add Recurso 2 (Árbol de Componentes): Purpose, When to Use (nesting >2 levels), Format (markdown tree with `[props]`), Example (≤5 lines)
- [ ] 2.4 Add Recurso 3 (Flujo de Estados): Purpose, When to Use (entity ≥3 states), Format (ASCII or Mermaid state diagram), Example (≤5 lines)
- [ ] 2.5 Add Recurso 4 (Árbol de Navegación): Purpose, When to Use (multi-page app), Format (markdown route tree), Example (≤5 lines)
- [ ] 2.6 Add Recurso 5 (Matriz Funcionalidades): Purpose, When to Use, Format (table: Feature|Component|Logic|State), Example (≤5 lines)
- [ ] 2.7 Add Recurso 6 (Inventario Interacciones): Purpose, When to Use, Format (table: Event|Handler|Component|Action), Example (≤5 lines)
- [ ] 2.8 Add Recurso 7 (Flujo de Datos): Purpose, When to Use, Format (ASCII arrows: Input→Form→Validation→API→Store→Component), Example (≤5 lines)
- [ ] 2.9 Group resources by SDD step: Step 1 Explore (Rec 1,2,3,4,6), Step 2 Design (Rec 5,7); add cross-references to `code-migration.md` §2.1 and §2.2

## Phase 3: Verification — migration-verify.md

- [ ] 3.1 Create `.atl/patterns/migration-verify.md` with header: Pattern ID `migration-verify`, Versión 1.0, Dependencias `code-migration.md`
- [ ] 3.2 Add §1 Checklist de Funcionalidades Críticas: table Item|PASS|FAIL with categories (UI Elements, Interactions, States, Edge Cases, Responsive), 100% PASS required for archive
- [ ] 3.3 Add §2 Análisis de Diffs: table Feature|Original|Migrated|Status (MATCH|GAP|ENHANCED), compare against discovery doc when original code removed
- [ ] 3.4 Add §3 Verification Workflow: checklist→FAIL→Apply→100% PASS→diffs→GAP→Apply→MATCH/ENHANCED→Archive
- [ ] 3.5 Add cross-references to `code-migration.md` §2.5 and §2.6

## Phase 4: Integration — Update code-migration.md

- [ ] 4.1 Replace ALL occurrences of "Analyse" with "Explore" in code-migration.md: §2 table row 1, §2 note, §2.1 title, §2.1 "Fase SDD" label
- [ ] 4.2 Update §2 note text: replace "Analyse vs Analysis" explanation with "El ciclo SDD usa Explore, Design, Tasks, Apply, Verify, Archive (ver glossary §1). En migración, Explore refiere al análisis de código fuente, no a investigación con cliente."
- [ ] 4.3 Insert cross-reference after §2.1: link to `migration-discovery.md` + `migration-analysis.md` Recursos 1,2,3,4,6
- [ ] 4.4 Insert cross-reference after §2.2: link to `migration-analysis.md` Recursos 5,7
- [ ] 4.5 Insert cross-reference after §2.5: link to `migration-verify.md` §1-3 + verification workflow
- [ ] 4.6 Insert cross-reference after §2.6: link to `migration-verify.md` §2 for final diff comparison
- [ ] 4.7 Update §7 Referencias: add entries for `migration-discovery.md`, `migration-analysis.md`, `migration-verify.md`

## Phase 5: Verification

- [ ] 5.1 Verify all 3 new files exist: `.atl/patterns/migration-discovery.md`, `.atl/patterns/migration-analysis.md`, `.atl/patterns/migration-verify.md`
- [ ] 5.2 Verify zero occurrences of "Analyse" in `code-migration.md` (run `rg "Analyse" .atl/patterns/code-migration.md` = 0 results)
- [ ] 5.3 Verify all cross-references are valid: each markdown link points to an existing `.atl/patterns/` file
- [ ] 5.4 Verify all 10 resources documented: Rec 1-7 in migration-analysis.md, Rec 8-9 in migration-verify.md, Rec 10 in migration-discovery.md
- [ ] 5.5 Verify file lengths: each new file <300 lines

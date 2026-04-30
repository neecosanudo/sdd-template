# Tasks: Template Audit Fixes

## Batch 1: Documentation Fixes (independent, no code)

- [x] 1.1 **R1 — Glossary §4 Language Specificity**: In `.atl/glossary.md`, replace the 3-row "Convenciones de Idioma" table with a 4-row version that splits "Código" into "Código: identificadores" (English) and "Código: string literals" (Español AR). Keep the "Comments" row and Override subsection unchanged.
  - *Verify*: Table has 4 rows; identifiers row specifies English; string literals row specifies Spanish (AR).

- [x] 1.2 **R3 — Glossary §3 Bitacora/Engram Distinction**: In `.atl/glossary.md`, append "Mantenido por el agente." to the Bitacora.md row "Uso" column (line ~65). After the ADR row, insert the Engram distinction note blockquote.
  - *Verify*: Bitacora row includes "Mantenido por el agente."; Engram note appears after ADR row with correct content.

- [x] 1.3 **R2 — AGENT_BEHAVIOR.md §6 Bitacora Logging**: In `.atl/agent/AGENT_BEHAVIOR.md`, insert new `## 6. Bitacora Decision Logging` section with subsections 6.1 (Immediate Recording Requirement) and 6.2 (Entry Format) between the end of §5.3 table and the `---` footer.
  - *Verify*: New §6 exists with both subsections; entry format template includes date, context, decision, motivation fields.

- [x] 1.4 **R4 — code-migration.md Link Display Text**: In `.atl/patterns/code-migration.md`, change all 3 occurrences of `[react.md](../../docs/tools/react.md)` to `[docs/tools/react.md](../../docs/tools/react.md)` (lines ~5, ~169, ~265). Target URL unchanged.
  - *Verify*: All 3 links display `docs/tools/react.md` as visible text; target path `../../docs/tools/react.md` unchanged.

- [x] 1.5 **R5 — migration-analysis.md Sequential Numbering + Downstream Refs**: In `.atl/patterns/migration-analysis.md`, swap Recurso 6↔5 headings (line ~126: `Recurso 6` → `Recurso 5`; line ~149: `Recurso 5` → `Recurso 6`). In `.atl/patterns/code-migration.md`, update resource references: `recursos 1-4 y 6` → `recursos 1-5` (line ~53), `recursos 5 y 7` → `recursos 6 y 7` (line ~65).
  - *Verify*: migration-analysis.md resources read 1,2,3,4,5,6,7 in order; code-migration.md references match new numbering.

**Batch 1 Verify**: Open each modified file; confirm formatting renders correctly; no broken markdown syntax.

---

## Batch 2: Verification Script (functional, independent from Batch 1)

- [x] 2.1 **R6a — C3 Link Validation**: In `verify-template.sh`, replace the C3 stub (lines 42-44) with a real link validator that: (1) finds all `.md` files excluding `node_modules/`, (2) extracts `[text](url)` links where url does NOT start with `http` or `#`, (3) resolves each url relative to the containing file's directory, (4) normalizes with `realpath -m`, (5) fails if resolved path is not a file or directory, (6) reports `$file -> $url` on failure and increments `ERRORS`.
  - *Verify*: Run `verify-template.sh` — C3 passes on current codebase. Add a temp broken link to a test file, run again — C3 fails with file path and broken link reported. Remove temp file.

- [x] 2.2 **R6b — C4 Deprecated Term Detection**: In `verify-template.sh`, replace the C4 stub (lines 47-49) with a deprecated term checker that: (1) parses `.atl/glossary.md` §2 table to extract "Término Antiguo" values, (2) `grep -rnw` each term across all `.md` files, (3) excludes the glossary file itself from results, (4) reports `$file:$lineno uses deprecated term '$term'` on match, (5) increments `ERRORS`.
  - *Verify*: Run `verify-template.sh` — C4 passes on current codebase. Create a temp file with "Discovery" (deprecated term), run again — C4 fails with file and line reported. Remove temp file.

**Batch 2 Verify**: `verify-template.sh` runs clean (exit 0) on current codebase. Negative tests confirm both C3 and C4 catch violations and report them with file paths.

---

## Batch 3: ADR (independent from all batches)

- [x] 3.1 **R7 — Repository Structure ADR**: Create `docs/decisions/0001-repository-structure.md` following ADR format (Título, Estado, Fecha, Contexto, Decisión, Consecuencias, Referencias). Document the rationale for `.atl/` directory structure with its four subdirectories (governance, standards, patterns, specs).
  - *Verify*: File exists; contains all ADR sections; explains why `.atl/` contains governance, standards, patterns, and specs; references `navigation.spec.md` and `glossary.md`.

**Batch 3 Verify**: Read the ADR; confirm it follows the glossary §3 ADR format; all sections present and coherent.

---

## Execution Order

```
Batch 1 (doc fixes)  ──┐
Batch 2 (script)       ├── All batches are independent; can run in parallel
Batch 3 (ADR)      ──┘
```

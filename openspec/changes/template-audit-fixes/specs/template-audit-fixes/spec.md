# Delta for Template Audit Fixes

## ADDED Requirements

### R1: Glossary Language Specificity (§4)

Glossary §4 MUST explicitly distinguish `.md` files and string literals (Spanish) from identifiers (English).

#### Scenario: Language rules are explicit

- GIVEN glossary §4 "Convenciones de Idioma"
- WHEN agent consults language rules
- THEN `.md` files and string literals in code MUST be Spanish
- AND variables, functions, classes, and filenames MUST be English

### R2: Agent Bitacora Decision Logging

AGENT_BEHAVIOR.md MUST require agent to log every project decision to Bitacora.md immediately (not only at session end). Entry format: date, context, decision, reasoning.

#### Scenario: Decision reached during interaction

- GIVEN agent and human reach a project decision
- WHEN the decision is made
- THEN agent MUST append a chronological entry to Bitacora.md
- AND each decision produces its own entry at decision time

### R3: Bitacora vs Engram Distinction

Glossary §3/§5 MUST clarify Bitacora.md is agent-maintained human-readable chronology; Engram is technical searchable persistence. Agent writes to both. They coexist.

#### Scenario: Decision logging mechanisms are distinguished

- GIVEN glossary §3 comparing decision logging mechanisms
- WHEN agent reads the comparison
- THEN Bitacora.md row MUST state the agent maintains it
- AND a note MUST distinguish Engram as technical persistence (machine-readable, searchable)

### R4: code-migration.md Link Validation

code-migration.md MUST not reference non-existent files. All markdown links MUST resolve to existing files.

#### Scenario: Broken links removed or fixed

- GIVEN code-migration.md in `.atl/patterns/`
- WHEN all markdown links are resolved relative to the file
- THEN every referenced file MUST exist
- AND dead links MUST be removed or corrected

### R5: migration-analysis.md Sequential Numbering

migration-analysis.md MUST number resources 1–7 sequentially without gaps.

#### Scenario: Resources numbered correctly

- GIVEN migration-analysis.md with seven analysis resources
- WHEN document is read
- THEN resources MUST appear as 1, 2, 3, 4, 5, 6, 7 in order
- AND no number skipped or out of sequence

### R6: verify-template.sh C3 (Link Validation) and C4 (Term Consistency)

C3 MUST validate markdown links resolve to existing files. C4 MUST detect deprecated glossary terms (per §2 "Término Antiguo" column).

#### Scenario: C3 fails on broken link

- GIVEN a markdown file linking to a non-existent file
- WHEN C3 runs
- THEN check MUST fail with file path and broken link reported

#### Scenario: C3 passes

- GIVEN all markdown links resolve to existing files
- WHEN C3 runs
- THEN check MUST pass

#### Scenario: C4 detects deprecated term

- GIVEN a file using a deprecated term (e.g., "Discovery" instead of "pre-SDD")
- WHEN C4 runs against glossary §2 mapeo table
- THEN check MUST flag the occurrence with file and line

#### Scenario: C4 passes

- GIVEN all files use canonical glossary terms only
- WHEN C4 runs
- THEN check MUST pass

### R7: Repository Structure ADR

`docs/decisions/0001-repository-structure.md` MUST exist, following ADR format (Título, Estado, Contexto, Decisión, Consecuencias), explaining rationale for the `.atl/` directory structure.

#### Scenario: ADR exists with valid format

- GIVEN the project repository
- WHEN checking `docs/decisions/`
- THEN `0001-repository-structure.md` MUST exist
- AND content MUST follow ADR format per glossary §3
- AND it MUST explain why `.atl/` contains governance, standards, patterns, and specs

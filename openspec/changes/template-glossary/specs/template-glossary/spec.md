# Template Glossary Specification

## Purpose

Consolidate all SDD terminology, decision-recording mechanisms, language conventions, and key template terms into a single canonical file (`.atl/glossary.md`). Remove the dead `agnostic-fundamentals.md`, rescue its security content, and update all cross-file references.

## Requirements

### Requirement: Glossary Structure

The `.atl/glossary.md` file MUST exist at `.atl/glossary.md` and SHALL contain exactly five sections in this order: SDD Phases, Terminology Mapping, Decision Recording, Language Conventions, Key Template Terms.

#### Scenario: Glossary file created with all five sections

- GIVEN the template repository is initialized
- WHEN an agent reads `.atl/glossary.md`
- THEN the file SHALL contain sections: "SDD Phases (Canonical)", "Terminology Mapping", "Decision Recording", "Language Conventions", "Key Template Terms"
- AND each section SHALL have a heading and body content as defined below

### Requirement: SDD Phase Canonical Definitions

The "SDD Phases (Canonical)" section MUST define each SDD phase with name, description, agent responsibility, and output. The canonical sequence SHALL be: Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive. The section SHALL clarify that "Analysis" in the Working Standard maps to Explore + Propose + Spec, and that "Discovery" is pre-SDD client dialogue, NOT an SDD phase.

#### Scenario: Agent reads SDD phase definitions

- GIVEN an agent needs to understand the SDD phase sequence
- WHEN it reads the "SDD Phases (Canonical)" section of `.atl/glossary.md`
- THEN the canonical sequence SHALL be Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
- AND each phase SHALL have: name, description, executing agent, and output artifact

#### Scenario: Agent encounters "Analysis" or "Discovery" terms

- GIVEN an agent reads the glossary after encountering the terms "Analysis" or "Discovery"
- WHEN it looks up those terms
- THEN "Analysis" SHALL be mapped to SDD phases Explore + Propose + Spec
- AND "Discovery" SHALL be defined as pre-SDD client dialogue, explicitly NOT an SDD phase

### Requirement: Terminology Normalization

The "Terminology Mapping" section MUST provide a table normalizing the four conflicting terms (Discovery, Analysis, Explore, Analyse) to a single canonical usage. It SHALL define "Batch-Verify" formally as a single-pass verification that either passes or fails with no partial success.

#### Scenario: Agent encounters "Analyse" (British spelling) in migration docs

- GIVEN an agent reads AGENT_BEHAVIOR.md or code-migration.md and encounters "Analyse"
- WHEN it consults the glossary
- THEN it SHALL see that "Analyse" SHALL be normalized to "Explore" for SDD phases
- AND the glossary SHALL state "Analyse" is a deprecated spelling, retained only in migration protocol context

#### Scenario: Agent encounters "Batch-Verify" without definition

- GIVEN an agent sees "Batch-Verify" referenced
- WHEN it consults the glossary
- THEN it SHALL find a canonical definition: single-pass verification where all checks MUST pass or the batch is rejected

### Requirement: Decision Recording Comparison

The "Decision Recording" section MUST define when to use each of the three mechanisms: Bitacora.md (informal conversation log with context/decision/motivation format), DECISION_LOG.md (incremental architectural decisions with six-field format), and ADR (major structural changes in `docs/decisions/NNNN-name.md`). The section SHALL explain the promotion path: Bitacora → DECISION_LOG → ADR.

#### Scenario: Agent needs to record a decision and consults glossary

- GIVEN an agent has made a decision that needs recording
- WHEN it consults the "Decision Recording" section of `.atl/glossary.md`
- THEN it SHALL see a comparison of Bitacora (informal), DECISION_LOG (architectural), and ADR (structural)
- AND it SHALL see the promotion path and format requirements for each

### Requirement: Language Conventions

The "Language Conventions" section MUST state: documentation in Spanish (AR), code in English, comments explain WHY not WHAT. It SHALL explicitly override the erroneous navigation spec claim of "Default documentation language is English."

#### Scenario: Agent checks documentation language rules

- GIVEN an agent is writing documentation or code
- WHEN it consults the "Language Conventions" section
- THEN it SHALL see "Documentation: Spanish (AR)" and "Code: English" as canonical rules
- AND it SHALL see a note that this overrides any conflicting statement in navigation.spec.md

### Requirement: Key Template Terms

The "Key Template Terms" section MUST define: Pattern (reusable engineering practice in `.atl/patterns/`), Standard (operational rule in `.atl/standards/`), Governance (project law in `.atl/governance/`), Rule (mandatory constraint), Prototype vs Production (React prototypes are disposable references, SvelteKit is production), and Migration terms (Analyse → Explore mapping).

#### Scenario: Agent distinguishes Pattern, Standard, Governance, Rule

- GIVEN an agent encounters `.atl/patterns/`, `.atl/standards/`, and `.atl/governance/`
- WHEN it consults the glossary
- THEN it SHALL see each term defined with its directory, purpose, and enforcement level
- AND "Prototype" SHALL be defined as "React-based disposable reference, NOT production source"

## REMOVED Requirements

### Requirement: agnostic-fundamentals.md Deletion

`.atl/patterns/agnostic-fundamentals.md` MUST be removed. Security content SHALL be migrated before deletion. Non-security content SHALL be discarded.

#### Scenario: File removed and security content preserved

- GIVEN the change is applied
- WHEN an agent checks `.atl/patterns/agnostic-fundamentals.md`
- THEN the file SHALL NOT exist
- AND the three Security by Design principles (Least Privilege, Input Validation, Security-First Refactoring) SHALL be present in ENGINEERING_MANIFEST.md as Rule #11

#### Scenario: Incorrect SDD cycle is eradicated

- GIVEN agnostic-fundamentals.md previously listed "Verify" as phase 1 of SDD
- WHEN the change is applied
- THEN that incorrect cycle SHALL NOT appear in any surviving file
- AND the canonical cycle SHALL only exist in `.atl/glossary.md`

### Requirement: Content Discard Justification

The following content from agnostic-fundamentals.md SHALL be discarded with justification:
- **Memory Alignment & Padding** — agnostic-era optimization guide, irrelevant to opinionated Go/SvelteKit stack
- **Wrong SDD Cycle (Verify→Design)** — contradicts actual SDD skills (Explore→Propose→Spec→Design→Tasks→Apply→Verify→Archive)
- **Dependency Inversion** — already covered in ENGINEERING_MANIFEST.md Rule #2 (Hexagonal Architecture) and `.atl/patterns/go-hexagonal.md`

## MODIFIED Requirements

### Requirement: ENGINEERING_MANIFEST.md Rule #11 — Security by Design

The system SHALL add Rule #11 "Security by Design" to ENGINEERING_MANIFEST.md, placed after Rule #10. The rule MUST contain three sub-principles: Least Privilege, Input Validation, Security-First Refactoring — migrated verbatim from agnostic-fundamentals.md § Security by Design.

#### Scenario: Security by Design is a numbered rule in the manifesto

- GIVEN the change is applied
- WHEN an agent reads ENGINEERING_MANIFEST.md
- THEN it SHALL see "## 11. Security by Design" after Rule #10
- AND it SHALL contain "### 11.1 Least Privilege", "### 11.2 Input Validation (Never Trust)", "### 11.3 Security-First Refactoring"
- AND the content SHALL match the original agnostic-fundamentals.md security section

### Requirement: Cross-File Glossary References

README.md, WORKING_STANDARD.md, and AGENT_BEHAVIOR.md MUST reference `.atl/glossary.md` as the canonical terminology source.

#### Scenario: Files reference glossary instead of repeating SDD cycle inline

- GIVEN the change is applied
- WHEN an agent reads README.md
- THEN the SDD Cycle section SHALL reference `.atl/glossary.md` for canonical phase definitions
- AND WORKING_STANDARD.md SHALL replace its inline SDD Phase Mapping table with a link to `.atl/glossary.md`
- AND AGENT_BEHAVIOR.md SHALL list `.atl/glossary.md` in its "read first" or trigger-matching precedence
- AND all occurrences of "Analyse" in AGENT_BEHAVIOR.md SHALL be normalized to "Explore" where they refer to SDD phases

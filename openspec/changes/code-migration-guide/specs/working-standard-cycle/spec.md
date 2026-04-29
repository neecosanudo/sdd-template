# Delta for Working Standard Cycle

## ADDED Requirements

### Requirement: Code Migration Special Case in Analysis

The Analysis phase MUST recognize code migration as a special case. When the user says "I have code from X to bring into the project", the Analysis phase SHALL trigger the migration workflow: identify business logic to preserve, discardable code, and destination tool. Analysis SHALL reference `.atl/patterns/code-migration.md` as the operational guide.

(Previously: Analysis had no migration-specific path.)

#### Scenario: User brings external code during Analysis

- GIVEN a user presents code from an external source during Analysis
- WHEN the agent detects migration intent (e.g., "bring code from X")
- THEN the Analysis phase SHALL include: identify business logic to preserve vs. discard
- AND the Analysis SHALL determine the destination tool (Go, SvelteKit, etc.)
- AND the agent SHALL read `.atl/patterns/code-migration.md` before proceeding

#### Scenario: Standard Analysis (no migration)

- GIVEN the user does NOT mention external code
- WHEN the Analysis phase proceeds normally
- THEN the existing Analysis activities (scope, requirements, user stories) SHALL apply unchanged
- AND no migration-specific steps SHALL be triggered

## File-by-File Breakdown

| File | Section | Change |
|------|---------|--------|
| `.atl/standards/WORKING_STANDARD.md` | Phase 1: Analysis → Activities | Add "Special Case: Code Migration" sub-section with 4 bullet points |
| `.atl/standards/WORKING_STANDARD.md` | Phase 1: Analysis → Entry Criteria | No change — migration is additive |
| `.atl/standards/WORKING_STANDARD.md` | Phase 1: Analysis → Exit Criteria | No change |

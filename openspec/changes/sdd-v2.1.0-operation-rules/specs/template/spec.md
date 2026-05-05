# Delta for Template

## ADDED Requirements

### Requirement: Operation Rules

The template MUST enforce strict operation rules for the SDD cycle.

The template MUST define:
- Fixed entry point (`.atl/ENTRY.md`) for all agents
- Automatic Verify loop until 100%, then interactive before Archive
- TDD strict validation: reject tests without assertions
- Archive closing: commit all, clean git, generate report

#### Scenario: Operation rules enforced

- GIVEN an SDD cycle running on this template
- WHEN any phase executes
- THEN operation rules from `.atl/ENTRY.md` apply
- AND Verify loops automatically if < 100%
- AND tests without assertions FAIL
- AND Archive leaves git clean

## MODIFIED Requirements

### Requirement: Verify Failure Recovery

(Previously: retakes from Tasks phase, no loop)

The template MUST define recovery from Verify failure with automatic loop to 100%.

#### Scenario: Verify fails

- GIVEN Verify fails with ANY issue
- THEN automatically retakes from Tasks phase
- AND re-executes Apply + Verify in loop
- AND continues until Verify = 100%
- THEN returns to interactive mode before Archive

### Requirement: TDD Batch Mode

(Previously: ALL RED → ALL GREEN → REFACTOR without validation)

The template MUST enforce TDD Batch Mode with strict assertion validation.

#### Scenario: Running tests in TDD fashion

- GIVEN running tests BEFORE code (TDD)
- THEN writes ALL RED tests first
- AND each test MUST contain at least one assertion
- THEN writes ALL GREEN code
- AND tests without assertions FAIL the implementation

## Version Bump

This spec updates Template from v2.0.0 to v2.1.0 to reflect new operation rules.
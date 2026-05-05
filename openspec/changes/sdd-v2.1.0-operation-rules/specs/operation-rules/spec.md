# Delta for Operation Rules

## ADDED Requirements

### Requirement: ENTRY-001 — Fixed Entry Point for Agents

The system MUST have a `.atl/ENTRY.md` file that serves as the fixed entry point for ALL orchestrator agents.

The system MUST treat `.atl/ENTRY.md` as the first file read when an agent enters the project.

#### Scenario: Agent enters project for first time

- GIVEN an orchestrator agent enters the `sdd-template` project
- WHEN the agent searches for initial context
- THEN the agent MUST read `.atl/ENTRY.md` first
- AND `.atl/ENTRY.md` MUST contain:
  - Clear navigation by template sections
  - Links to key files based on task context
  - Definition of execution modes (engram-only, auto, interactive)
  - Archive closing rules

#### Scenario: Agent navigates by context

- GIVEN an agent has read ENTRY.md
- WHEN the agent needs specific documentation
- THEN it follows links from ENTRY.md to relevant files
- AND does NOT search arbitrarily for entry points

### Requirement: ENTRY-002 — Engram-Only Execution Mode

The system MUST use Engram as the primary artifact store by default, with fallback to interactive before Archive.

#### Scenario: Automatic execution mode

- GIVEN an SDD cycle starts
- WHEN the user does NOT specify a mode
- THEN use `engram` artifact store by default
- AND execute phases in `auto` mode (continuous)
- AND return to `interactive` mode before Archive

### Requirement: VERIFY-001 — Automatic Verify Loop to 100%

The system MUST execute the Tasks→Apply→Verify loop automatically until Verify passes at 100%.

#### Scenario: Verify fails

- GIVEN an agent executes the Verify phase
- WHEN result < 100%
- THEN automatically return to Tasks
- AND re-execute Apply + Verify
- AND repeat until Verify = 100%
- AND when passing, return to interactive mode before Archive

#### Scenario: Verify passes at 100%

- GIVEN Verify result = 100%
- THEN proceed to interactive mode
- AND prepare for Archive phase

### Requirement: TDD-001 — Test Validation Without Assert

The system MUST detect and reject tests that do NOT contain valid assertions.

#### Scenario: Test without assert

- GIVEN a test exists in the project
- WHEN the verify phase validates the test
- THEN verify the test contains at least one assert/reject/match
- AND if no assertions exist, mark as FAIL
- AND reject implementation until test has validation logic

### Requirement: ARCHIVE-001 — Automatic Closing with Clean Git

The system MUST commit all changes and leave git clean at the end of Archive.

#### Scenario: End of SDD cycle

- GIVEN an SDD cycle reaches Archive successfully
- WHEN the final file is completed
- THEN the agent MUST:
  1. Execute `git add .` for all changes
  2. Create a commit with Conventional Commits
  3. Verify `git status` shows clean
  4. Generate final report of project state
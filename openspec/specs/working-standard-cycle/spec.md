# Specification: Working Standard Cycle

## Purpose
Define the "analysis → design → tasks → apply → verify until OK" cycle as a documented working standard in the template.

## Requirements

### Requirement: Cycle Documentation

The working standard MUST document each phase of the cycle with entry and exit criteria.

#### Scenario: User wants to understand the full development cycle

- GIVEN a user is reading the template documentation
- WHEN they open `.atl/standards/WORKING_STANDARD.md`
- THEN they SHALL find a section for each phase: Analysis, Design, Tasks, Apply, Verify
- AND each phase SHALL have "Entry Criteria" (what must be true to start)
- AND each phase SHALL have "Exit Criteria" (what must be true to finish)
- AND each phase SHALL have a "Responsibility" field (who does this: user, agent, or both)

### Requirement: Analysis Phase Definition

The Analysis phase MUST be positioned as the FIRST phase, before Design.

#### Scenario: User is starting a new project

- GIVEN a user is beginning a project with the template
- WHEN they read the cycle documentation
- THEN Analysis SHALL be the first phase listed
- AND it SHALL state that Analysis includes: scope definition, requirements gathering, user story creation, stakeholder identification
- AND it SHALL state that Analysis is done WITH the client

### Requirement: Tool Pattern Documentation

The Analysis phase MUST include immediate documentation of tool-specific patterns.

#### Scenario: User selects a tool during Analysis

- GIVEN a tool or framework is selected during the Analysis phase
- WHEN the selection is made
- THEN patterns specific to that tool MUST be documented in `.atl/patterns/` immediately
- AND those patterns SHALL include: security considerations, performance considerations, known gotchas
- AND the documentation SHALL happen BEFORE proceeding to Design phase

### Requirement: Verify Iteration Rule

The Verify phase MUST document the "until OK" iteration rule.

#### Scenario: Verification finds issues

- GIVEN a verify phase has found warnings or critical issues
- WHEN the user reads the verify phase documentation
- THEN they SHALL see that verification is NOT a one-time gate
- AND they SHALL see the rule: "if verify fails → return to appropriate phase (tasks, apply, or design) → re-verify"
- AND they SHALL see that the cycle repeats until verification passes cleanly

### Requirement: Synchronous Execution

The working standard MUST specify that SDD phases execute synchronously by default.

#### Scenario: User expects to see progress in real-time

- GIVEN the user is running an SDD cycle
- WHEN phases execute
- THEN they SHALL execute synchronously (one after another, visible in real-time)
- AND asynchronous execution SHALL only occur if the user explicitly requests it
- AND the default persistence mode SHALL be hybrid (engram + openspec)
- AND the default interaction mode SHALL be interactive (pause between phases)

### Requirement: SDD Integration

The working standard MUST reference the SDD phases explicitly.

#### Scenario: User knows SDD but not the working standard

- GIVEN a user is familiar with SDD (explore, propose, spec, design, tasks, apply, verify, archive)
- WHEN they read WORKING_STANDARD.md
- THEN they SHALL see a mapping: Analysis ≈ Explore+Propose+Spec, Design = Design, Tasks = Tasks, Apply = Apply, Verify = Verify
- AND it SHALL note that Archive is the final close-out step after Verify passes

### Requirement: README Integration

The README.md MUST reference the working standard.

#### Scenario: User reads README before diving into standards

- GIVEN a user is reading README.md
- WHEN they reach the "How to Use This Template" section
- THEN they SHALL find a brief mention of the working standard cycle
- AND it SHALL link to `.atl/standards/WORKING_STANDARD.md` for details

## References
- `.atl/standards/WORKING_STANDARD.md` — full cycle documentation
- `README.md` — high-level reference to the cycle
- `.atl/governance/ENGINEERING_MANIFEST.md` — Rule 9 (Stack Decision → Patterns), Rule 10 (Default Execution Mode)

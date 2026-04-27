# Specification: Project Discovery

## Purpose
Define how the sdd-template guides users through the initial project discovery phase with clients before entering the SDD cycle.

## Requirements

### Requirement: README Discovery Section

The README.md MUST include a "Discovery Phase" section that explains the initial client dialogue process.

#### Scenario: User reads README for discovery guidance

- GIVEN a user has cloned the sdd-template
- WHEN they read the README.md
- THEN they SHALL find a clearly labeled "Discovery Phase" section
- AND it SHALL explain that discovery is the FIRST step before any SDD phase
- AND it SHALL list the key activities: scope definition, requirements gathering, user story creation

### Requirement: Discovery Activities Documentation

The README.md MUST document the specific activities performed during discovery.

#### Scenario: User needs to know what to discuss with client

- GIVEN a user is preparing for a client meeting
- WHEN they read the Discovery Phase section
- THEN they SHALL find a checklist of topics: project goals, constraints, stakeholders, user personas, functional requirements, non-functional requirements
- AND each topic SHALL have a brief explanation of why it matters

### Requirement: Handoff Documentation

The README.md MUST explain how to pass discovery results to the implementation team.

#### Scenario: Discovery is complete and user needs to hand off

- GIVEN a user has completed the discovery phase
- WHEN they read the README.md handoff section
- THEN they SHALL find guidance on packaging discovery outputs for programmers and designers
- AND it SHALL mention that the Bitacora.md captures conversation history
- AND it SHALL mention that specs will be created in the SDD cycle

## References
- `README.md` — primary discovery documentation
- `Bitacora.md` — conversation history capture

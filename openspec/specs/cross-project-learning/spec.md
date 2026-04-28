# Specification: Cross-Project Learning

## Purpose
Define how each project using this template captures insights that could strengthen the template itself.

## Requirements

### Requirement: LEARNINGS_MAP Is Per-Project

Each project MUST create its own `LEARNINGS_MAP.md` at the project root or in `docs/`.

#### Scenario: User wants to capture a learning from their project

- GIVEN a user has identified a pattern in their current project
- WHEN they want to record it for future template improvement
- THEN they SHALL create `LEARNINGS_MAP.md` in their project (NOT in the template)
- AND the project's agent SHALL help populate it with discoveries

### Requirement: Learning Entry Structure

Each learning entry MUST map: Learning, Source Files, Template Impact.

#### Scenario: User adds a new learning

- GIVEN a user wants to record a learning
- WHEN they add an entry to their project's LEARNINGS_MAP.md
- THEN the entry SHALL have a unique ID or sequential number
- AND it SHALL have a "Learning" field describing the insight
- AND it SHALL have "Source Files" field listing relevant files in the current project
- AND it SHALL have a "Template Impact" field explaining how it could strengthen the template
- AND it SHALL NOT include private project names or sensitive metadata

### Requirement: Agent Discovery Logging

The project's agent SHOULD log discoveries that could improve the template.

#### Scenario: Agent discovers a reusable pattern

- GIVEN an agent is working on a project
- WHEN it discovers a pattern, gotcha, or convention that could strengthen the template
- THEN it SHALL propose adding it to the project's LEARNINGS_MAP.md
- AND the user SHALL decide whether to record it

### Requirement: Learning Lifecycle

LEARNINGS_MAP.md MUST document the lifecycle of a learning.

#### Scenario: User wants to know when a learning is "done"

- GIVEN a learning has been recorded
- WHEN the user reads the lifecycle section
- THEN they SHALL see statuses: `identified` → `evaluated` → `integrated` → `verified`
- AND each status SHALL have a brief definition

## References
- Template `CONTRIBUTING.md` — how to suggest template improvements
- Project's own `LEARNINGS_MAP.md` — learning tracker (per-project)

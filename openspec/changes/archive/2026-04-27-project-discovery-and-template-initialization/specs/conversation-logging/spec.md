# Specification: Conversation Logging (Bitacora)

## Purpose
Define the format and rules for Bitacora.md, the ongoing conversation log between user and agent.

## Requirements

### Requirement: Bitacora File Existence

A `Bitacora.md` file MUST exist at the repository root.

#### Scenario: User wants to review conversation history

- GIVEN a project using the sdd-template
- WHEN the user lists the repository root files
- THEN they SHALL see `Bitacora.md`
- AND it SHALL be readable in plain text

### Requirement: Entry Format

Each Bitacora entry MUST contain: Date, Context, Decision, Motivation.

#### Scenario: Agent logs a decision from conversation

- GIVEN an agent and user have agreed on a technical decision
- WHEN the agent records it in Bitacora.md
- THEN the entry SHALL have a date header (YYYY-MM-DD)
- AND it SHALL have a "Context" subsection explaining the situation
- AND it SHALL have a "Decision" subsection stating what was decided
- AND it SHALL have a "Motivation" subsection explaining why

### Requirement: Bitacora Differentiation

Bitacora.md MUST be clearly differentiated from DECISION_LOG.md.

#### Scenario: User is unsure where to record a decision

- GIVEN a user needs to record something
- WHEN they read both files' headers
- THEN Bitacora.md SHALL state it is for "informal conversation history"
- AND DECISION_LOG.md SHALL state it is for "formal architectural decisions"
- AND Bitacora.md SHOULD note that significant decisions SHOULD be promoted to DECISION_LOG.md

### Requirement: Initial Content

Bitacora.md MUST include usage instructions in its initial content.

#### Scenario: First-time user opens Bitacora.md

- GIVEN a user opens Bitacora.md for the first time
- WHEN they read the file
- THEN they SHALL find a "How to Use This File" section at the top
- AND it SHALL explain who writes in it (both user and agent)
- AND it SHALL explain the entry format

## References
- `Bitacora.md` — conversation log file
- `.atl/decisions/DECISION_LOG.md` — formal decision records

# Decision Log Specification

## Purpose

Defines the format, structure, and governance for recording architectural and engineering decisions. The decision log (bitácora) serves as the project's institutional memory for all structural choices.

## Requirements

| # | Requirement | Strength | Summary |
|---|------------|----------|---------|
| DL-1 | Decision Log Structure | MUST | Every architectural decision recorded with context, options, decision, rationale, consequences |
| DL-2 | Decision Log Location | MUST | All decisions recorded in `.atl/decisions/DECISION_LOG.md` |
| DL-3 | Decision Log Consultation | MUST | Agents consult the log before proposing conflicting changes |
| DL-4 | Decision Log Sequencing | MUST | Entries numbered sequentially, dated with ISO 8601 |

### Requirement: Decision Log Structure

Every architectural decision, stack choice, pattern selection, or significant design tradeoff MUST be recorded using this format:

```markdown
## NNNN — {Decision Title}
- **Date**: YYYY-MM-DD
- **Context**: {what problem or situation prompted this decision}
- **Options Considered**:
  1. {Option A} — {brief tradeoffs}
  2. {Option B} — {brief tradeoffs}
- **Decision**: {chosen option}
- **Rationale**: {why this option was chosen over alternatives}
- **Consequences**: {positive and negative outcomes of this choice}
```

#### Scenario: Recording a new architectural decision

- GIVEN a team member or agent makes a structural design choice
- WHEN the decision affects architecture, patterns, or stack
- THEN a new entry MUST be added to `.atl/decisions/DECISION_LOG.md`
- AND the entry MUST include all six required fields
- AND the entry MUST be assigned the next sequential number

#### Scenario: Consulting decision log before change

- GIVEN an agent proposes a design change
- WHEN the change would modify a previously documented architectural decision
- THEN the agent MUST search the decision log for conflicting entries
- AND if a conflicting entry exists, the agent SHALL reference it with rationale for overriding

### Requirement: Decision Log Accessibility

The decision log serves as the single source of truth for project architectural history. It SHALL be checked into version control and reviewed during design phases.

#### Scenario: Agent discovers undocumented convention

- GIVEN an agent encounters an established pattern not in the decision log
- WHEN the pattern represents a structural or design choice
- THEN the agent SHALL create a decision log entry documenting the implicit decision
- AND the entry SHALL note "retrospective" in the context field

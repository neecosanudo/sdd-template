# Delta for Repository Navigation

## MODIFIED Requirements

### Requirement: Navigation Priority Order

The agent's priority order for reading files MUST include the new directories and files. The `.atl/patterns/` directory MUST be documented as containing BOTH language-agnostic engineering concepts AND tool-specific patterns.

(Previously: `.atl/patterns/` was described as "language-agnostic engineering concepts" only.)

#### Scenario: Agent navigates repository for the first time

- GIVEN an agent is starting work on a project using this template
- WHEN it reads `.atl/specs/navigation.spec.md`
- THEN the priority order SHALL be:
  1. `.atl/governance/` — working manifesto, commit rules, versioning
  2. `.atl/standards/` — code style, testing strategy, security, release
  3. `.atl/patterns/` — language-agnostic engineering concepts AND tool-specific patterns
  4. `.atl/agent/` — agent behavior rules
  5. `.atl/decisions/` — decision log
  6. `.atl/meta/` — cross-project learnings, meta-infrastructure
  7. `Bitacora.md` — conversation history between user and agent
- AND `.atl/meta/` SHALL be described as "cross-project learnings and meta-infrastructure"
- AND `Bitacora.md` SHALL be described as "ongoing conversation history between user and agent"
- AND `.atl/patterns/` SHALL be described as containing both tool-agnostic fundamentals AND tool-specific patterns (e.g., `go-patterns.md`, `sveltekit-patterns.md`)

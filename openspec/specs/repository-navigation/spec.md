# Delta for Repository Navigation

## MODIFIED Requirements

### Requirement: Navigation Priority Order

The agent's priority order for reading files MUST include the new directories and files.
(Previously: Only `.atl/governance/`, `.atl/standards/`, `.atl/patterns/`, `.atl/agent/`, `.atl/decisions/` were listed)

#### Scenario: Agent navigates repository for the first time

- GIVEN an agent is starting work on a project using this template
- WHEN it reads `.atl/specs/navigation.spec.md`
- THEN the priority order SHALL be:
  1. `.atl/governance/` — working manifesto, commit rules, versioning
  2. `.atl/standards/` — code style, testing strategy, security, release
  3. `.atl/patterns/` — language-agnostic engineering concepts
  4. `.atl/agent/` — agent behavior rules
  5. `.atl/decisions/` — decision log
  6. `.atl/meta/` — cross-project learnings, meta-infrastructure
  7. `Bitacora.md` — conversation history between user and agent
- AND `.atl/meta/` SHALL be described as "cross-project learnings and meta-infrastructure"
- AND `Bitacora.md` SHALL be described as "ongoing conversation history between user and agent"

### Requirement: Root Markdown File Prohibition

The prohibition on root `.md` files MUST explicitly exempt `Bitacora.md`.
(Previously: "Do not create `.md` files in the repository root (except `README.md`)")

#### Scenario: Agent considers creating a root markdown file

- GIVEN an agent is about to create a file
- WHEN it reads the prohibition in navigation.spec.md
- THEN it SHALL see that `README.md` and `Bitacora.md` are the ONLY permitted root markdown files
- AND it SHALL see the justification: "Bitacora.md lives at root for immediate visibility as the conversation log"

### Requirement: Scope Clarification

The scope section MUST clarify that `.atl/meta/` is part of the template's shared infrastructure.

#### Scenario: User wonders if `.atl/meta/` applies to all projects

- GIVEN a user is adapting the template for their project
- WHEN they read the scope section
- THEN they SHALL see that `.atl/meta/` applies to ALL projects using this template
- AND it SHALL explain that it tracks learnings that improve the template itself

## References
- `.atl/specs/navigation.spec.md` — main navigation spec
- `Bitacora.md` — conversation log
- `.atl/meta/` — meta-infrastructure directory

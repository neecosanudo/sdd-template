# Delta for Repository Navigation

## MODIFIED Requirements

### Requirement: Navigation Priority Order

The agent's priority order for reading files MUST include the directories and files.

#### Scenario: Agent navigates repository for the first time

- GIVEN an agent is starting work on a project using this template
- WHEN it reads `.atl/specs/navigation.spec.md`
- THEN the priority order SHALL be:
  1. `.atl/governance/` — working manifesto, commit rules, versioning
  2. `.atl/standards/` — code style, testing strategy, security, release, working standard
  3. `.atl/patterns/` — language-agnostic AND tool-specific engineering patterns
  4. `.atl/agent/` — agent behavior rules
  5. `.atl/decisions/` — decision log
  6. `Bitacora.md` — conversation history between user and agent
- AND `Bitacora.md` SHALL be described as "ongoing conversation history between user and agent"

### Requirement: Root Markdown File Prohibition

The prohibition on root `.md` files MUST explicitly exempt `Bitacora.md`.

#### Scenario: Agent considers creating a root markdown file

- GIVEN an agent is about to create a file
- WHEN it reads the prohibition in navigation.spec.md
- THEN it SHALL see that `README.md` and `Bitacora.md` are the ONLY permitted root markdown files
- AND it SHALL see the justification: "Bitacora.md lives at root for immediate visibility as the conversation log"

### Requirement: Scope Clarification

The scope section MUST clarify that `.atl/patterns/` contains both agnostic and tool-specific patterns.

#### Scenario: User wonders what goes in `.atl/patterns/`

- GIVEN a user is adapting the template for their project
- WHEN they read the scope section
- THEN they SHALL see that `.atl/patterns/` contains language-agnostic patterns AND tool-specific patterns (documented when tools are selected)
- AND it SHALL explain that tool-specific patterns are created immediately when a tool is chosen

## References
- `.atl/specs/navigation.spec.md` — main navigation spec
- `Bitacora.md` — conversation log

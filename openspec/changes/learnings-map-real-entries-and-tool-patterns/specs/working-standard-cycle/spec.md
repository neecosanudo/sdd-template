# Delta for Working Standard Cycle

## MODIFIED Requirements

### Requirement: Analysis Phase Definition

The Analysis phase MUST be positioned as the FIRST phase, before Design. When tools, languages, or frameworks are selected during Analysis, the agent MUST immediately document their patterns in `.atl/patterns/`.

(Previously: Analysis phase listed scope definition, requirements gathering, user story creation, and stakeholder identification — but had no sub-step for tool-pattern documentation.)

#### Scenario: User is starting a new project

- GIVEN a user is beginning a project with the template
- WHEN they read the cycle documentation
- THEN Analysis SHALL be the first phase listed
- AND it SHALL state that Analysis includes: scope definition, requirements gathering, user story creation, stakeholder identification
- AND it SHALL state that Analysis is done WITH the client
- AND it SHALL include the sub-step: "When tools, languages, or frameworks are selected, document their patterns in `.atl/patterns/`"

#### Scenario: Tool is selected during Analysis

- GIVEN the Analysis phase is active
- WHEN a tool, language, or framework is chosen (e.g., "we will use Go for the backend")
- THEN the agent SHALL immediately create or update a pattern file in `.atl/patterns/`
- AND the file SHALL be named to identify the tool (e.g., `go-patterns.md`)
- AND the file SHALL document the tool's conventions, gotchas, and security considerations

## ADDED Requirements

### Requirement: Tool Pattern Documentation

When a tool, language, or framework is selected during the Analysis phase, the agent SHALL immediately document its patterns in `.atl/patterns/`. Each pattern document MUST include security considerations, performance considerations, and known gotchas. The `.atl/patterns/` directory SHALL contain both language-agnostic fundamentals and tool-specific files.

#### Scenario: Go is selected as the backend language

- GIVEN Go is chosen during Analysis
- WHEN the agent documents Go patterns
- THEN the file `go-patterns.md` SHALL be created in `.atl/patterns/`
- AND it MUST cover: variable memory alignment, nil map behavior, goroutine leak risks, error wrapping conventions
- AND it SHALL reference `.atl/patterns/agnostic-fundamentals.md` for cross-cutting concerns

#### Scenario: A framework with known pitfalls is selected

- GIVEN a framework or library is selected (e.g., GORM, SvelteKit)
- WHEN the agent documents its patterns
- THEN the file MUST list known gotchas (e.g., GORM AutoMigrate dev-only, SvelteKit `+` prefix restriction in test files)
- AND each gotcha SHALL reference the source project where it was learned
- AND each gotcha SHALL describe the consequence of ignoring it

#### Scenario: Patterns file already exists for the tool

- GIVEN `.atl/patterns/go-patterns.md` already exists
- WHEN the agent needs to document a new Go pattern discovered during Analysis
- THEN the agent SHALL append to the existing file
- AND the agent SHALL NOT create a duplicate file
- AND the new pattern SHALL follow the existing file's section structure

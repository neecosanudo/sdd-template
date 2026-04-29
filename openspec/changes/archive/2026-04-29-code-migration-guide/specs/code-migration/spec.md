# Code Migration Specification

## Purpose

Define an origin-agnostic, destination-specific process for migrating external code into the opinionated stack. Covers the `.atl/patterns/code-migration.md` guide and agent protocol in `AGENT_BEHAVIOR.md §5`.

## Requirements

### Requirement: Origin-Agnostic, Destination-Specific Principle

The migration guide MUST NOT document "how to migrate FROM X". It SHALL document "how to migrate INTO Y" (destination tool). Source tool is relevant only for concept mapping.

#### Scenario: Agent encounters migration from unknown source

- GIVEN a migration task with code from an external source
- WHEN the agent reads the migration guide
- THEN the guide SHALL NOT contain sections per source tool
- AND the guide SHALL provide destination-specific mapping tables

### Requirement: 5-Step Migration Process

The migration guide SHALL define a 5-step process agents MUST follow:

1. Analyze source — separate business logic from plumbing
2. Map concepts — source patterns to destination idioms
3. Rewrite — in destination idioms using `.atl/patterns/`
4. Test first — TDD for migrated business logic
5. Verify behavior — against original behavior, not implementation

#### Scenario: Agent migrates business logic from PHP to Go

- GIVEN a PHP controller with ActiveRecord
- WHEN the agent follows the migration process
- THEN step 1 SHALL identify domain rules to preserve and framework code to discard
- AND step 2 SHALL map ActiveRecord → Repository Interface (domain/ports/)
- AND step 4 SHALL require tests written before implementation

### Requirement: Concept Mapping by Destination

The guide MUST include concept-mapping tables for each production destination:

| Destination | Key Mappings |
|-------------|-------------|
| Go Hexagonal | Class → struct+methods, ActiveRecord → Port+Adapter, Controller → HTTP Handler, Service → UseCase |
| SvelteKit | React Component → .svelte, useState → `let`/$state, useEffect → onMount/$:, Props → `export let` |
| Godot | React Component → Node, State → @export var, useEffect → _ready()/_process() |

#### Scenario: Agent maps React component to SvelteKit

- GIVEN a React component using useState and useEffect
- WHEN the agent consults the mapping table for SvelteKit
- THEN they SHALL replace useState with reactive `let` declarations
- AND useEffect SHALL be replaced with onMount() or reactive statements ($:)

### Requirement: Prototype vs Production

The guide MUST state React prototypes are DISPOSABLE. Code from prototypes SHALL be treated as a "reference" not "source". The guide SHALL define when to rewrite vs. adapt.

#### Scenario: User wants to migrate a React prototype

- GIVEN a React prototype used for validation
- WHEN the migration guide is consulted
- THEN it SHALL instruct: extract business logic, discard React code
- AND it SHALL redirect to `docs/tools/react.md` for the disposable rule
- AND it SHALL NOT allow incremental migration of React app to production

### Requirement: Testing Strategy for Migrated Code

TDD SHALL be mandatory for migrated business logic. Tests SHALL verify behavior, not implementation. Integration tests SHALL cover boundaries between migrated and new code.

#### Scenario: Agent writes tests for migrated logic

- GIVEN business logic extracted from source code
- WHEN the agent implements the migrated logic
- THEN tests MUST be written BEFORE implementation (TDD)
- AND tests SHALL validate behavior (inputs → outputs), not internal structure

### Requirement: Anti-Patterns

The guide MUST list prohibited migration practices:

1. Copy-paste source code and fix syntax (MUST NOT)
2. Preserve framework-specific patterns in new framework (MUST NOT)
3. Migrate UI layout without redesign (MUST NOT)
4. Skip tests because "the code already worked" (MUST NOT)

#### Scenario: Agent is tempted to copy-paste and adapt

- GIVEN a migration task from a familiar source framework
- WHEN the agent reads the anti-patterns section
- THEN it SHALL see that copy-paste adaptation is explicitly prohibited
- AND it SHALL understand why rewriting in destination idioms is required

### Requirement: Agent Migration Protocol

`AGENT_BEHAVIOR.md §5` SHALL instruct agents to read `.atl/patterns/code-migration.md` FIRST when encountering migration tasks. The agent MUST follow the 5-step process, treat React prototypes as disposable, and write tests before implementation.

#### Scenario: Agent receives a migration instruction

- GIVEN the agent is asked to "migrate code from X to Y"
- WHEN the agent's behavior protocol triggers
- THEN it MUST read `.atl/patterns/code-migration.md` before any implementation
- AND it MUST NOT attempt incremental migration from React

## References

- `.atl/patterns/code-migration.md` — main migration guide (to be created)
- `.atl/agent/AGENT_BEHAVIOR.md` — §5 Code Migration Protocol (to be added)
- `docs/tools/react.md` — React prototype disposal rule
- `.atl/patterns/go-hexagonal.md` — Go hexagonal architecture pattern
- `.atl/patterns/svelte-component.md` — SvelteKit component pattern
- `.atl/standards/TESTING_STRATEGY.md` — testing approach

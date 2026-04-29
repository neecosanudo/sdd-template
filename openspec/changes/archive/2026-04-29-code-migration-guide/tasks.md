# Tasks: Code Migration Guide

## Phase 1: Migration Guide Document (Foundation)

- [x] 1.1 Create `.atl/patterns/code-migration.md` with frontmatter, purpose statement, and origin-agnostic/destination-specific principle (Req 1)
- [x] 1.2 Add the 5-step migration process section with detailed descriptions for each step (Req 2)
- [x] 1.3 Add concept-mapping tables for Go Hexagonal, SvelteKit, and Godot destinations (Req 3)
- [x] 1.4 Add Prototype vs Production section with React prototype disposal rule and reference to `docs/tools/react.md` (Req 4)
- [x] 1.5 Add Testing Strategy section mandating TDD for migrated business logic (Req 5)
- [x] 1.6 Add Anti-Patterns section listing all 4 prohibited practices with explanations (Req 6)
- [x] 1.7 Add References section with cross-references to `go-hexagonal.md`, `svelte-component.md`, `gorm-repository.md`, `react.md`, `TESTING_STRATEGY.md`

## Phase 2: Agent Migration Protocol

- [x] 2.1 Add `## 5. Code Migration Protocol` section to `.atl/agent/AGENT_BEHAVIOR.md` after §4
- [x] 2.2 Include trigger rule: agents MUST read `.atl/patterns/code-migration.md` FIRST when encountering migration tasks (Req 7)
- [x] 2.3 Include the 5-step process reference and React prototype disposal reminder in the protocol

## Phase 3: Working Standard Special Case

- [x] 3.1 Add "Special Case: Code Migration" sub-section under Phase 1: Analysis → Activities in `.atl/standards/WORKING_STANDARD.md`
- [x] 3.2 Include 4 bullet points: identify business logic to preserve, identify discardable code, determine destination tool, reference `.atl/patterns/code-migration.md` (Delta Spec)

## Phase 4: Verification

- [x] 4.1 Verify all 7 spec requirements are satisfied in `.atl/patterns/code-migration.md` (traceability check)
- [x] 4.2 Verify cross-references point to existing files (no broken links)
- [x] 4.3 Verify AGENT_BEHAVIOR.md §5 correctly triggers migration workflow and renumbers subsequent sections if needed
- [x] 4.4 Verify WORKING_STANDARD.md migration special case is additive and does not alter existing Analysis activities
# Proposal: Code Migration Guide

## Intent

Agents have no documented process for migrating code FROM external sources (AIStudio, GitHub repos, ChatGPT, etc.) INTO the opinionated stack. This causes ad-hoc migration, missed patterns (hexagonal architecture, TDD), and risk of treating disposable prototypes as production code. A clear, origin-agnostic/destination-specific guide eliminates this gap.

## Scope

### In Scope
- Migration pattern file `.atl/patterns/code-migration.md`
- Agent behavior update with migration protocol (AGENT_BEHAVIOR.md §5)
- Analysis phase mention of code migration (WORKING_STANDARD.md)

### Out of Scope
- `docs/tools/wails.md` and `docs/tools/godot.md` (deferred — not yet common targets)
- Automated migration scripts or scaffolding
- A `code-migration` agent skill (pattern file is sufficient initially)

## Capabilities

### New Capabilities
- `code-migration`: Origin-agnostic, destination-specific process for migrating external code. Includes concept-mapping tables per destination (Go hexagonal, SvelteKit, Godot), prototype disposal rules, testing strategy, and rewrite-vs-adapt decision criteria.

### Modified Capabilities
- `working-standard-cycle`: Analysis phase will mention code migration as a special case, referencing `.atl/patterns/code-migration.md`

## Approach

1. **Create** `.atl/patterns/code-migration.md` — follows pattern file template: principles, "what to preserve vs discard", concept-mapping tables per destination, prototype rules, testing strategy, references
2. **Modify** `.atl/agent/AGENT_BEHAVIOR.md` — add §5 "Code Migration Protocol" with three sub-sections: origin-agnostic analysis, destination-specific implementation, prototype disposal
3. **Modify** `.atl/standards/WORKING_STANDARD.md` — add "Special Case: Code Migration" sub-section under Analysis phase (Phase 1)

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.atl/patterns/code-migration.md` | New | Main migration guide |
| `.atl/agent/AGENT_BEHAVIOR.md` | Modified | Add §5 Code Migration Protocol |
| `.atl/standards/WORKING_STANDARD.md` | Modified | Add migration sub-section in Analysis |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Agents bypass migration guide | Medium | Cross-reference from AGENT_BEHAVIOR.md; ENGINEERING_MANIFEST Rule #7 enforces pattern check |
| Users maintain React prototypes | Low | Already documented in react.md; reinforced in migration guide |
| Content too verbose | Low | Keep under 400 lines, focus on tables and examples |

## Rollback Plan

Revert each file individually via `git checkout -- <path>`. The new pattern file has no dependents, so removal is safe.

## Dependencies

- `.atl/governance/ENGINEERING_MANIFEST.md` — Rule #7 (Patterns-Before-Code) drives location
- `docs/tools/react.md` — Referenced for prototype disposal rules

## Success Criteria

- [ ] `.atl/patterns/code-migration.md` exists with principles, destination mapping tables, prototype rules, and testing strategy
- [ ] `.atl/agent/AGENT_BEHAVIOR.md` has §5 Code Migration Protocol section
- [ ] `.atl/standards/WORKING_STANDARD.md` mentions code migration as a special case in Analysis
- [ ] An agent can follow the guide to migrate code from an external source to any destination in the stack

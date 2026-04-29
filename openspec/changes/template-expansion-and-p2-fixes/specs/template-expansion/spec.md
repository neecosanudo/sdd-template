# Template Expansion Spec

## Purpose
Enable agents and humans to extend the template with tool guides for stacks not yet covered.

## Requirements

### R4: Agent Expansion Instructions

Template MUST include `.atl/agent/TOOL_EXPANSION.md` with agent workflow for analyzing user projects and expanding template coverage.

#### Scenario: Agent workflow

- GIVEN `go.mod`/`package.json` from user project
- THEN agent: (a) detects stack, (b) maps tools to existing guides, (c) creates TEMPLATE.md guides for unmapped tools, (d) updates STACK_MAP.md

#### Scenario: Unknown tool

- GIVEN `bun.lockb` with no existing guide
- THEN agent creates `docs/tools/bun.md` via TEMPLATE.md, cross-references guides, updates STACK_MAP.md

### R5: Human Contribution Guide

Template SHALL include `docs/tools/ADD_NEW_TOOL.md` with a 6-step process for humans.

| Step | Action |
|------|--------|
| 1 | Verify tool is in STACK_MAP.md or project uses it |
| 2 | Copy `TEMPLATE.md` as boilerplate |
| 3 | Fill sections: What, Why, When, Installation, Usage, Patterns, Anti-Patterns, References |
| 4 | If applicable, create `.atl/patterns/<tool-pattern>.md` |
| 5 | Update STACK_MAP.md with version + compatibility |
| 6 | Update README.md if tool belongs in stack table |

#### Scenario: Developer follows guide

- GIVEN developer adding undocumented tool
- THEN ADD_NEW_TOOL.md provides actionable 6-step table

### R6: Tool Guide Boilerplate

Template MUST include `docs/tools/TEMPLATE.md` as copy-paste skeleton.

#### Scenario: Boilerplate structure

- GIVEN developer copies TEMPLATE.md
- THEN has frontmatter (tool name, version ref, category) and sections: What, Why, When to Use, Installation, Basic Usage, Patterns, Anti-Patterns, References

#### Scenario: Ready to fill

- GIVEN TEMPLATE.md inspected
- THEN it is a skeleton — NOT instructional prose

# Proposal: Template Expansion and P2 Fixes

## Intent

Five P2 issues degrade template maintainability: hardcoded versions (13 files), no cross-reference validation, no changelog, no verify script, and no "how to add a new tool" guide. Fix them and create agent-facing expansion infrastructure so the template can grow with user projects.

## Scope

### In Scope

1. Replace hardcoded versions with STACK_MAP.md references in all 13 files
2. Create `CHANGELOG.md` at template root
3. Create `verify-template.sh` (structure, versions, cross-references, glossary)
4. Create `.atl/agent/TOOL_EXPANSION.md` — agent instructions for analyzing user projects
5. Create `docs/tools/ADD_NEW_TOOL.md` — human guide for contributing tools
6. Create `docs/tools/TEMPLATE.md` — boilerplate for new tool docs

### Out of Scope

- CI integration for verify-template.sh
- Language convention enforcement (Spanish/English)
- Complete rewrite of existing tool guides
- Changes to governance rules (VERSIONING.md, etc.)

## Capabilities

> Pure infrastructure / refactoring change — no spec-level behavior changes.

### New Capabilities

None

### Modified Capabilities

None

## Approach

Approach C (Hybrid) from exploration: fix P2 issues first, then create expansion infrastructure. Priority order:

1. **Fix hardcoded versions** — replace inline version numbers with `**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)` in all 13 files. Preserve code examples (go.mod, package.json snippets).
2. **Create CHANGELOG.md** — document template history from archived changes.
3. **Create verify-template.sh** — bash script checking: required files exist, no hardcoded versions (except code examples), all cross-references resolve, glossary compliance.
4. **Create expansion guides** — `.atl/agent/TOOL_EXPANSION.md` (agent), `docs/tools/ADD_NEW_TOOL.md` (human), `docs/tools/TEMPLATE.md` (boilerplate).

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `docs/tools/*.md` (11 files) | Modified | Replace hardcoded versions with STACK_MAP.md refs |
| `README.md` | Modified | Replace version list with STACK_MAP.md ref |
| `.atl/standards/CICD_PIPELINE.md` | Modified | Replace GO_VERSION inline value |
| `CHANGELOG.md` | **New** | Template version history |
| `verify-template.sh` | **New** | Template integrity checks |
| `.atl/agent/TOOL_EXPANSION.md` | **New** | Agent expansion instructions |
| `docs/tools/ADD_NEW_TOOL.md` | **New** | Human contribution guide |
| `docs/tools/TEMPLATE.md` | **New** | Tool doc boilerplate |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| **Breaking users that copy-paste versions** | Low | Only change doc references, NOT code blocks or go.mod/package.json |
| **Incomplete verify-template.sh** | Med | Start with basic checks; iterate from real usage |
| **Tool mapping errors in expansion guide** | Med | Clear fallback: "unknown tool → create new guide per TEMPLATE.md" |

## Rollback Plan

Git revert: `git revert HEAD` reverts all changes. If partial: restore modified files from git (`git checkout -- docs/tools/`), delete new files manually.

## Dependencies

None

## Success Criteria

- [ ] All 13 files have STACK_MAP.md references instead of hardcoded versions (code examples excluded)
- [ ] `CHANGELOG.md` exists at root with documented template history
- [ ] `verify-template.sh` passes on the template itself with zero errors
- [ ] `.atl/agent/TOOL_EXPANSION.md` guides an agent through a simulated Gemin `→` Node.js tool addition
- [ ] `docs/tools/ADD_NEW_TOOL.md` and `TEMPLATE.md` provide clear, copyable instructions

# Proposal: Template Consolidation and Organization

## Intent

The sdd-template is missing critical patterns discovered across real projects: decision log format, agent behavior rules, strict TDD enforcement, batch-verify cycles, variable naming rationale, log sanitization, security-first patterns, and 100% coverage requirements. This change consolidates and strengthens the template so every new project starts with battle-tested conventions.

## Scope

### In Scope
- Create `.atl/agent/` and `.atl/decisions/` directories
- Create agent behavior rules (delegation, skills, manual write review)
- Create decision log (bitácora) format with context/options/decision/consequences
- Strengthen ENGINEERING_MANIFEST.md: zero-debt tolerance, patterns-before-code
- Strengthen TESTING_STRATEGY.md: 100% coverage pre-deploy, strict TDD mode
- Strengthen STYLE_GUIDE.md: variable naming rationale, log sanitization rules
- Strengthen patterns/ with batch-verify cycle and security refactoring workflow
- Update `openspec/config.yaml`: strict_tdd=true, coverage threshold 100

### Out of Scope
- Language-specific templates (Go, Svelte, etc.) — deferred
- CI/CD implementation files — document standards only
- Project-specific runtime code — this is a template

## Capabilities
None — pure documentation/reorganization. No spec-level behavioral changes.

### New Capabilities
None

### Modified Capabilities
None

## Approach

1. **New directories**: `.atl/agent/AGENT_BEHAVIOR.md`, `.atl/decisions/DECISION_LOG.md`
2. **Update ENGINEERING_MANIFEST.md**: add zero tolerance for warnings/errors, strict patterns-before-code, strengthen TDD mandate
3. **Update TESTING_STRATEGY.md**: raise coverage to 100% pre-deploy, add strict TDD description, add batch-verify cycle reference
4. **Update STYLE_GUIDE.md**: add naming conventions section with "hours of debugging" story, add log sanitization (PII, secrets, structured logging)
5. **Update agnostic-fundamentals.md**: add batch verify cycle, security refactoring pattern
6. **Update config.yaml**: enable strict_tdd, set coverage_threshold to 100

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.atl/agent/` | New | Agent behavior rules |
| `.atl/decisions/` | New | Decision log format |
| `.atl/standards/STYLE_GUIDE.md` | Modified | Naming conventions, log sanitization |
| `.atl/standards/TESTING_STRATEGY.md` | Modified | 100% coverage, strict TDD |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Modified | Zero-debt, patterns-before-code |
| `.atl/patterns/agnostic-fundamentals.md` | Modified | Batch verify, security refactoring |
| `openspec/config.yaml` | Modified | strict_tdd, coverage threshold |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Over-engineering the template | Low | Keep docs concise, cross-reference existing files |
| Conflicts with existing conventions | Low | Read all current docs before editing |
| Breaking agent expectations | Med | Add new content only, never remove existing sections |

## Rollback Plan

Revert via git: `git checkout HEAD -- .atl/ openspec/config.yaml` before committing, or `git revert HEAD` after.

## Dependencies

None — standalone template update.

## Success Criteria

- [ ] All 12 user requirements addressed as new or updated documents
- [ ] `.atl/` structure is clean: governance/, standards/, patterns/, agent/, decisions/
- [ ] Every existing document strengthened, not replaced
- [ ] `openspec/config.yaml` reflects strict TDD and 100% coverage

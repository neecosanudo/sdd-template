# Proposal: Template Glossary

## Intent

Four different terms (Discovery, Analysis, Explore, Analyse) describe the same SDD phase. The SDD cycle is repeated verbatim in 7+ files with conflicting phases and wrong order (agnostic-fundamentals says Verify→Design). A dead file from the agnostic era contradicts the opinionated stack. The template needs a single source of truth for vocabulary and less repetition.

## Scope

### In Scope
- Create `.atl/glossary.md` — canonical SDD phase definitions, terminology map (Discovery/Analysis/Explore/Analyse), decision recording (Bitacora/DECISION_LOG/ADR), language conventions, key template terms
- Remove `.atl/patterns/agnostic-fundamentals.md`
- Rescue "Security by Design" (Least Privilege, Input Validation, Security-First Refactoring) from agnostic-fundamentals → ENGINEERING_MANIFEST.md as Rule #11
- Update WORKING_STANDARD.md, README.md, AGENT_BEHAVIOR.md to reference `.atl/glossary.md` instead of repeating SDD cycle inline

### Out of Scope
- Fixing all P0/P1 issues (separate change)
- Creating new tool guides
- Restructuring directories
- Adding validation scripts

## Capabilities

**New Capabilities**: None — this is a pure refactoring/consolidation.
**Modified Capabilities**: None — no spec-level behavior changes, only documentation structure.

## Approach

1. Create `.atl/glossary.md` with canonical definitions for every SDD phase, terminology normalization table, decision-recording comparison, and language-use rules
2. Edit ENGINEERING_MANIFEST.md → add Rule #11 (Security by Design) copying the 3 security subsections from agnostic-fundamentals.md
3. Remove `.atl/patterns/agnostic-fundamentals.md`
4. Update WORKING_STANDARD.md: replace inline cycle description with "See `.atl/glossary.md`"
5. Update README.md: keep high-level cycle summary, defer details to glossary
6. Update AGENT_BEHAVIOR.md: replace "Analyse" with "Explore" (consistent term), reference glossary

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.atl/glossary.md` | New | Single source of truth for vocabulary |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Modified | Add Rule #11 (Security by Design) |
| `.atl/patterns/agnostic-fundamentals.md` | Removed | Dead file from agnostic era |
| `.atl/standards/WORKING_STANDARD.md` | Modified | Replace inline SDD cycle with glossary ref |
| `README.md` | Modified | Keep summary, defer to glossary |
| `.atl/agent/AGENT_BEHAVIOR.md` | Modified | Normalize "Analyse"→"Explore", ref glossary |

## Risks & Rollback

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Lost security content | Low | Copied to manifesto before removal |
| Broken cross-refs | Low | `grep` all inline cycles first |
| Missed repeated cycles | Med | Full audit via `rg "Explore\|Analysis"` |

Revert: `git checkout HEAD -- .atl/patterns/agnostic-fundamentals.md`, revert ENGINEERING_MANIFEST.md, delete glossary.md. Commits are atomic.

## Dependencies

None.

## Success Criteria

- [ ] 4 files reference `.atl/glossary.md` instead of repeating cycle inline
- [ ] 1 dead file removed (agnostic-fundamentals.md)
- [ ] Security by Design present in ENGINEERING_MANIFEST.md Rule #11
- [ ] `rg "Explore\|Analysis\|Analyse\|Propose\|Spec\|Verify" .atl/` shows no repeated cycle blocks outside glossary
- [ ] Discovery/Analysis/Explore/Analyse terminology is normalized to single canonical term

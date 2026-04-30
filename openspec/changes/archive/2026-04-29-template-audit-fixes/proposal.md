# Proposal: Template Audit Fixes

## Intent

Fix six concrete issues found during the project audit: clarify glossary language rules, establish Bitacora.md as the agent-maintained decision log for human-readable chronology, repair broken cross-references, fix numbering gaps, implement stub verification checks, and add a canonical ADR example for the `.atl/` structure.

## Scope

### In Scope
- **Glossary §4**: Specify that `.md` files and string literals → Spanish; identifiers (vars, funcs, classes, files) → English
- **AGENT_BEHAVIOR.md**: Add Bitacora.md rule — agent MUST write to Bitacora.md every time a project decision is made with the human, in chronological format with metadata/context/reasoning
- **Glossary §3/§5**: Clarify that Bitacora.md is maintained by the agent (not just the human) as a human-readable chronology; Engram is for technical persistence
- **code-migration.md**: Fix/remove dead links (`../../docs/tools/react.md`)
- **migration-analysis.md**: Renumber Recurso 6 → Recurso 5, fix gap
- **verify-template.sh**: Implement C3 (markdown link validation) and C4 (glossary term consistency)
- **ADR example**: Create `docs/decisions/0001-repository-structure.md` explaining `.atl/` directory rationale

### Out of Scope
- WORKING_STANDARD.md (Analysis = Explore+Propose+Spec is correct)
- TESTING_STRATEGY.md (strict_tdd intentional)
- ENGINEERING_MANIFEST.md (hardcoded stack intentional)
- Engram Pre-Apply Protocol (cancelled)

## Approach

All fixes are self-contained edits to existing files plus one new ADR. No behavioral changes to the SDD pipeline. Each fix addresses exactly one audit finding.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.atl/glossary.md` | Modified | Clarify language specificity in §4; clarify Bitacora.md agent-maintained |
| `.atl/agent/AGENT_BEHAVIOR.md` | Modified | Add Bitacora.md decision-logging rule |
| `.atl/patterns/code-migration.md` | Modified | Fix/remove dead `../../docs/tools/react.md` refs |
| `.atl/patterns/migration-analysis.md` | Modified | Renumber Recurso 6 → 5 |
| `verify-template.sh` | Modified | Implement C3 and C4 logic |
| `docs/decisions/0001-repository-structure.md` | New | ADR for `.atl/` structure |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| verify-template.sh C3/C4 produce false positives | Low | Test against known-broken files first |
| ADR numbering collision (0001 exists in docs/adr/) | Low | Use `docs/decisions/` path per glossary §3 |

## Rollback Plan

Per-file revert via git. The verify-template.sh is the only functional change — all others are documentation edits. Revert `verify-template.sh` to its original stub version if checks produce false results.

## Success Criteria

- [ ] Glossary explicitly distinguishes `.md` files/strings (ES) from identifiers (EN)
- [ ] AGENT_BEHAVIOR.md contains Bitacora.md rule: agent writes decisions with human in chronological format
- [ ] Glossary clarifies Bitacora.md is agent-maintained human-readable chronology; Engram is technical persistence
- [ ] All broken links in code-migration.md removed or fixed
- [ ] migration-analysis.md numbers Resources 1-7 sequentially without gaps
- [ ] `verify-template.sh` C3 catches broken markdown links; C4 detects non-canonical glossary terms
- [ ] `docs/decisions/0001-repository-structure.md` exists with ADR content

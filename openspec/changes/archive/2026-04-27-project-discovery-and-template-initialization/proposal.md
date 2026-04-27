# Proposal: Project Discovery and Template Initialization

## Intent

Template has strong SDD governance but no pre-coding discovery guidance. Projects need a structured client dialogue phase before entering SDD. This change adds discovery-first onboarding, conversation logging (Bitacora), cross-project learning (LEARNINGS_MAP), a documented working standard cycle, and enshrines "discovery-first" in governance.

## Scope

### In Scope
- Rewrite README.md: What, How to Use, Discovery Phase (scope/reqs/stories), SDD Cycle, Handoff, Batch-Verify
- Create `.atl/standards/WORKING_STANDARD.md` with analyze→design→tasks→apply→verify cycle
- Update `.atl/specs/navigation.spec.md` — add `.atl/meta/`, `Bitacora.md`, exemption rules
- Update `.atl/agent/AGENT_BEHAVIOR.md` — mention discovery phase
- Update `.atl/governance/ENGINEERING_MANIFEST.md` — add discovery-first rule (#8)

### Out of Scope
- Language-specific discovery templates
- Automated learning scanning tool
- New ADR documents

## Capabilities

### New Capabilities
- `project-discovery`: Client dialogue, scope/reqs/stories documentation
- `conversation-logging`: Bitacora.md format and maintenance
- `cross-project-learning`: LEARNINGS_MAP.md lifecycle + scanning
- `working-standard-cycle`: Analysis→Design→Tasks→Apply→Verify→Iterate

### Modified Capabilities
- `repository-navigation`: Navigation spec updated for new files

## Approach

1. **README**: Five-section flow with batch-verify cycle, links to WORKING_STANDARD.md
2. **Bitacora.md** (exists): Root-level conversation log with Context/Decision/Motivation entries
3. **LEARNINGS_MAP.md** (exists): `.atl/meta/` with lifecycle (identified→integrated→verified)
4. **WORKING_STANDARD.md**: Phase doc, entry/exit criteria, SDD mapping, "verify until OK" rule
5. **Governance**: AGENT_BEHAVIOR.md adds discovery awareness; ENGINEERING_MANIFEST.md adds rule #8
6. **Navigation**: Priority order includes `.atl/meta/` (6th) and `Bitacora.md` (7th)

## Affected Areas

| Area | Impact |
|------|--------|
| `README.md` | Modified |
| `Bitacora.md` | Created (exists) |
| `.atl/meta/LEARNINGS_MAP.md` | Created (exists) |
| `.atl/standards/WORKING_STANDARD.md` | New |
| `.atl/specs/navigation.spec.md` | Modified |
| `.atl/agent/AGENT_BEHAVIOR.md` | Modified |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Modified |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| README too long | Med | Strict section budget, TOC, <200 lines |
| Bitacora vs DECISION_LOG confusion | Low | Clear header differentiation in both files |
| Governance doc version conflicts | Low | Append new rules, don't restructure |

## Rollback Plan

`git checkout HEAD -- README.md .atl/specs/navigation.spec.md .atl/agent/AGENT_BEHAVIOR.md .atl/governance/ENGINEERING_MANIFEST.md` + `git rm -f .atl/standards/WORKING_STANDARD.md`

## Dependencies

None — standalone documentation update.

## Success Criteria

- [ ] README covers discovery, SDD, handoff, batch-verify
- [ ] Bitacora.md at root with format + differentiation from DECISION_LOG
- [ ] LEARNINGS_MAP.md in `.atl/meta/` with lifecycle + scanning instructions
- [ ] WORKING_STANDARD.md with 5 phases, entry/exit criteria, "verify until OK"
- [ ] navigation.spec.md references all new files; exempts Bitacora.md from prohibition
- [ ] AGENT_BEHAVIOR.md mentions discovery phase
- [ ] ENGINEERING_MANIFEST.md has discovery-first rule

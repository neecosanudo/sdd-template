# Proposal: Real Entries in LEARNINGS_MAP + Tool Selection → Pattern Documentation

## Intent

LEARNINGS_MAP.md has a single `[RESERVED]` placeholder — useless. The exploration found 18 real entries from 3 projects with full file paths, ready for the user to review and integrate. Also, when choosing a tool (e.g., Go), patterns should be documented **immediately**, not deferred.

## Scope

### In Scope
- Rewrite `.atl/meta/LEARNINGS_MAP.md` with 18 real entries (status: `identified`), orchestrator maintenance instructions
- Add "Stack Decision triggers Pattern Documentation" rule to ENGINEERING_MANIFEST.md
- Add "Tool Selection → Pattern Documentation" sub-step to Analysis phase in WORKING_STANDARD.md
- Update navigation.spec.md: `.atl/patterns/` contains both agnostic AND tool-specific patterns

### Out of Scope
- Integrating any LEARN-XXXX entry into the template (user decides per-entry)
- Creating tool-specific pattern files — deferred until user says "integrate LEARN-XXXX"
- Scanning additional projects beyond the three already explored

## Capabilities

### Modified Capabilities
- `cross-project-learning`: LEARNINGS_MAP entries MUST now have real values (Learning, Source Project, Source Files, Template Target, Status). File maintained by orchestrator, read by user who says "integrate LEARN-XXXX".
- `repository-navigation`: `.atl/patterns/` scope expanded — now contains BOTH language-agnostic AND tool-specific patterns.
- `working-standard-cycle`: Analysis phase gains a new sub-step: when tools/stacks are chosen, immediately document their patterns in `.atl/patterns/`.

## Approach

1. **LEARNINGS_MAP.md** — Replace placeholder with 18 real entries in a table format. Each entry has: ID, Learning, Source Project, Source Files (full paths), Template Target (which file to modify on integration), Status (all `identified`). Add orchestrator maintenance instructions.
2. **ENGINEERING_MANIFEST.md** — Insert new Rule 9: "Stack Decision → Pattern Documentation" between existing Rule 8 and the end.
3. **WORKING_STANDARD.md** — Add sub-step to Analysis phase Activities: "Document tool-specific patterns in `.atl/patterns/` when tools are selected."
4. **navigation.spec.md** — Update priority order description for `.atl/patterns/` to mention both agnostic and tool-specific patterns.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `.atl/meta/LEARNINGS_MAP.md` | Rewrite | 18 real entries, orchestrator maintenance |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Modified | New Rule 9: Stack Decision → Pattern Documentation |
| `.atl/standards/WORKING_STANDARD.md` | Modified | Analysis phase adds tool-pattern documentation step |
| `.atl/specs/navigation.spec.md` | Modified | Patterns scope includes agnostic + tool-specific |
| `openspec/specs/cross-project-learning/spec.md` | Modified | Real entries requirement |
| `openspec/specs/repository-navigation/spec.md` | Modified | Patterns directory scope |
| `openspec/specs/working-standard-cycle/spec.md` | Modified | Analysis phase tool→pattern step |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| LEARNINGS_MAP grows stale again | Medium | Orchestrator maintenance rule + user reads it before each new project |
| Tool-specific patterns duplicated with agnostic ones | Low | Clear naming convention: tool-specific files get language prefix (e.g., `go-*.md`) |

## Rollback Plan

Revert the four files to their original content. All changes are additive (no destructive edits) except LEARNINGS_MAP.md which is a full rewrite — restore from git.

## Dependencies

- Exploration findings from `sdd/learnings-map-update/explore` (Engram observation #321)

## Success Criteria

- [ ] LEARNINGS_MAP.md has 18 real entries with full source file paths
- [ ] ENGINEERING_MANIFEST.md has Rule 9: "Stack Decision → Pattern Documentation"
- [ ] WORKING_STANDARD.md Analysis phase includes tool-pattern documentation
- [ ] navigation.spec.md describes `.atl/patterns/` as containing both agnostic and tool-specific
- [ ] All three relevant capability specs updated

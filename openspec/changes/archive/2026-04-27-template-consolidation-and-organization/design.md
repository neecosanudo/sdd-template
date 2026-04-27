# Design: Template Consolidation and Organization

## Technical Approach

Add two new `.atl/` subdirectories (`agent/`, `decisions/`) and strengthen existing documents with zero-tolerance, strict TDD, naming intent, log sanitization, batch-verify, and security-first patterns. No files are deleted or moved — all existing content is preserved and augmented. The SDD config is updated for programmatic enforcement.

## Architecture Decisions

### Decision: New Directory Layout

| Option | Tradeoff | Decision |
|--------|----------|----------|
| A: Flat `.atl/*.md` | All files in one directory, no consumer boundary | |
| B: Add `agent/` + `decisions/` subdirectories | Clear separation by consumer (agents vs humans) and lifecycle | **B** — different consumers (AI vs human), different update cadence |

### Decision: Decision Log vs ADR

| Option | Tradeoff | Decision |
|--------|----------|----------|
| A: Single log in `docs/adr/` | ADRs are formal milestone records — too heavy for daily decisions | |
| B: `.atl/decisions/DECISION_LOG.md` + `docs/adr/` | Lightweight running log for daily decisions; formal ADRs for structural milestones | **B** — ADRs remain for major structural changes; DECISION_LOG captures the incremental reasoning trace |

### Decision: Patterns Evolution

| Option | Tradeoff | Decision |
|--------|----------|----------|
| A: New pattern files per topic | Splintering — harder to discover | |
| B: Append to `agnostic-fundamentals.md` | Single discoverable file, natural evolution | **B** — consolidate patterns in one file; section headers provide navigation |

### Decision: Agent Behavior Location

| Option | Tradeoff | Decision |
|--------|----------|----------|
| A: In `.atl/governance/` | Confuses agent rules with human rules | |
| B: In `.atl/standards/` | Standards target code quality, not agent behavior | |
| C: New `.atl/agent/` directory | Explicit boundary — consumed by AI agents only | **C** — different audience requires separate namespace |

### Decision: Config Enforcement

| Option | Tradeoff | Decision |
|--------|----------|----------|
| A: Document-only | Agents must read and comply manually | |
| B: `config.yaml` machine-readable flags + docs | SDD agents enforce thresholds programmatically | **B** — `strict_tdd: true` and `coverage_threshold: 100` prevent violations at the tool level |

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `.atl/agent/AGENT_BEHAVIOR.md` | Create | Agent rules: delegation protocol, skill loading, manual write review, delegation restriction |
| `.atl/decisions/DECISION_LOG.md` | Create | Decision log template with format spec, initial empty entries |
| `.atl/governance/ENGINEERING_MANIFEST.md` | Modify | Add zero-tolerance warnings, design-before-code, patterns-before-code |
| `.atl/standards/STYLE_GUIDE.md` | Modify | Add naming intent section (single-letter prohibited), log sanitization (PII, secrets) |
| `.atl/standards/TESTING_STRATEGY.md` | Modify | Raise coverage to 100% per-package, strict TDD (RED-GREEN-REFACTOR), batch-verify workflow |
| `.atl/patterns/agnostic-fundamentals.md` | Modify | Append: security-first refactoring, SDD cycle (Verify→Design→Tasks→Apply→Verify), batch-verify |
| `.atl/specs/navigation.spec.md` | Modify | Update priority order: add agent/ (4th), decisions/ (5th) |
| `openspec/config.yaml` | Modify | Set `strict_tdd: true`, `coverage_threshold: 100` |

## Content Architecture

**AGENT_BEHAVIOR.md**: 4 sections mirroring agent-behavior spec domains — Delegation Protocol (no sub-agent spawning), Skill Usage (load-before-code), Manual Write Review (read-first, verify-after), Delegation Restriction (executor-only boundary).

**DECISION_LOG.md**: Template with 6-field format (Context, Options, Decision, Rationale, Consequences, Date). Sequential numbering (NNNN). Instructions for creation and consultation. Retrospective notation for implicit decisions.

**Updated documents**: Each existing document receives new sections appended to relevant areas — no existing content is removed or reorganized.

## Cross-Reference Structure

```
Agent entry: navigation.spec.md
  → 1. .atl/governance/    (how we work — mandatory rules)
  → 2. .atl/standards/     (what we standardize — code quality, testing)
  → 3. .atl/patterns/      (what we know — reusable engineering approaches)
  → 4. .atl/agent/         (how agents behave — this change creates this)
  → 5. .atl/decisions/     (what we decided — this change creates this)
```

Decisions log is referenced by governance (EG-4: exclusions recorded), testing (TS-2: coverage exclusions), and agent behavior (consult-before-change). Cross-references use relative paths from repo root.

## Template Consumption by SDD Agent

1. SDD init bootstrap creates this template structure
2. `sdd-spec` phase reads `config.yaml` → discovers `strict_tdd: true`, enforces test-first in all scenarios
3. `sdd-design` phase reads `navigation.spec.md` → loads governance, standards, patterns, agent, decisions in priority order
4. `sdd-verify` phase checks `coverage_threshold: 100` → rejects packages below threshold
5. All phases read `AGENT_BEHAVIOR.md` → prevents delegation, enforces skill loading, enforces write review
6. Design review reads `DECISION_LOG.md` → identifies conflicting prior decisions

## Migration / Rollout

No migration required. No data or code to transform. Creation and modification are idempotent — rerunning produces the same result. Rollback via `git checkout HEAD -- .atl/ openspec/config.yaml`.

## Testing Strategy

No runtime tests (template documentation). Verification is cross-reference: every spec scenario maps to a document section, every file path exists, every config value is correct.

| Layer | What to Test | Approach |
|-------|-------------|----------|
| File existence | All 3 new files exist, all 6 modified files exist | `ls` + `git status` |
| Spec coverage | All 34 spec scenarios covered by document sections | Manual cross-reference |
| Config | `config.yaml` parseable, `strict_tdd: true`, `coverage_threshold: 100` | YAML parse + value check |
| Cross-refs | Every internal ref resolves to existing section | Manual review |

## Open Questions

- None — all decisions documented in specs.

# Design: Template Glossary

## Technical Approach

Create `.atl/glossary.md` as canonical vocabulary source (Design 1). Rescue Security by Design from `agnostic-fundamentals.md` into ENGINEERING_MANIFEST.md Rule #11 (Design 2). Update cross-file references in 4 live files (Design 3). Git-rm `agnostic-fundamentals.md` (Design 4). Pure documentation refactoring — no code, no behavior changes.

## Architecture Decisions

| Content from agnostic-fundamentals | Decision | Rationale |
|--------------------------------------|----------|-----------|
| Security by Design (3 principles) | **Rescue → Rule #11** | Universal applicability; no existing Rule covers it |
| Memory Alignment & Padding | **Discard** | Agnostic-era optimization guide; irrelevant to opinionated Go/SvelteKit stack |
| Wrong SDD Cycle (Verify→Design) | **Discard** | Contradicts canonical Explore→Propose→Spec→Design→Tasks→Apply→Verify→Archive |
| Dependency Inversion | **Discard** | Already covered by ENGINEERING_MANIFEST.md Rule #2 (Hexagonal) and go-hexagonal.md |

## Data Flow

```
agnostic-fundamentals.md (delete)
    │
    ├── Security by Design ──→ ENGINEERING_MANIFEST.md §11
    │
    └── (everything else) ──→ discarded

.atl/glossary.md (new) ←─── canonical definitions
    │
    ├── README.md ──────────→ replaces inline SDD cycle (lines 142-161)
    ├── WORKING_STANDARD.md ──→ replaces mapping tables (lines 270-293)
    ├── AGENT_BEHAVIOR.md ────→ adds to read-first list (after line 30)
    └── STACK_MAP.md ─────────→ removes Agnostic Fundamentals § (lines 383-392)
```

## File Changes

| File | Action | Lines |
|------|--------|-------|
| `.atl/glossary.md` | **Create** | Full file — 5 sections as specified below |
| `.atl/governance/ENGINEERING_MANIFEST.md` | **Modify** | Insert Rule #11 after line 90 (end of Rule #10) |
| `README.md` | **Modify** | Lines 142-161: replace SDD Cycle section body with glossary reference |
| `.atl/standards/WORKING_STANDARD.md` | **Modify** | Lines 270-293: replace Phase Mapping tables with glossary reference; line 12: `Analysis →` → `Explore →` |
| `.atl/agent/AGENT_BEHAVIOR.md` | **Modify** | After line 30: add `.atl/glossary.md` to trigger-matching table; line 83: SDD Phase `Analyse` → `Explore` |
| `STACK_MAP.md` | **Modify** | Lines 383-392: delete Agnostic Fundamentals subsection; line 461: remove `agnostic-fundamentals.md` from tree |
| `.atl/patterns/agnostic-fundamentals.md` | **Delete** | `git rm` |

### Design 1: `.atl/glossary.md` Structure

**Section 1: SDD Phases (Canonical)** — Table: Phase | Canonical Definition | SDD Agent | Output. 8 rows: Explore, Propose, Spec, Design, Tasks, Apply, Verify, Archive. Notes: Analysis = Explore+Propose+Spec (Working Standard abstraction, not a phase). Discovery = pre-SSD client dialogue (not an SDD phase). Analyse (british) is DEPRECATED for SDD — use Explore.

**Section 2: Terminology Mapping** — Table: Historical Term | Canonical Term | Context. Rows: Discovery → Discovery (pre-SDD client dialogue), Analysis → Explore+Propose+Spec (Working Standard composite), Analyse → Explore (deprecated british spelling, retained only in code-migration.md context), Explore → Explore (SDD canonical). Plus Batch-Verify definition: single-pass verification, all-or-nothing.

**Section 3: Decision Recording** — Comparison table: Bitacora.md (informal, conversation log, context/decision/motivation format), DECISION_LOG.md (state it does NOT exist — use `docs/decisions/` instead), ADR (structural changes, `docs/decisions/NNNN-name.md`, six-field format: Title, Status, Context, Decision, Consequences, Compliance). Promotion path: Bitacora (conversation) → ADR (formal record). DECISION_LOG.md is deprecated.

**Section 4: Language Conventions** — Documentation: Spanish (AR). Code: English. Comments: explain WHY, not WHAT. **Override note**: This overrides `.atl/specs/navigation.spec.md` line 30 claim "Default documentation language is English" — ENGINEERING_MANIFEST.md Rule #1 already establishes Spanish (AR) for docs.

**Section 5: Key Template Terms** — Definitions: **Pattern** (`.atl/patterns/`, reusable practice, advisory), **Standard** (`.atl/standards/`, operational rule, mandatory), **Governance** (`.atl/governance/`, project law, enforced), **Rule** (mandatory constraint, non-negotiable), **Prototype** (React, disposable reference, extract logic only), **Production** (SvelteKit, source of truth), **Migration terms** (Analyse → Explore mapping: step name in migration protocol, maps to SDD Explore).

### Design 2: Content Rescue

Security by Design → ENGINEERING_MANIFEST.md Rule #11 inserted after line 90:

```markdown
## 11. Security by Design

### 11.1 Least Privilege
*   **Principle:** Every module, service, or user should only have access to the resources necessary for its legitimate purpose.
*   **Application:** Specific interfaces, scoped API keys, non-root containers.

### 11.2 Input Validation (Never Trust)
*   **Principle:** Assume all input is malicious until validated.
*   **Application:** Schema validation at boundaries, sanitization, range checks.

### 11.3 Security-First Refactoring
*   **Principle:** When refactoring code, apply security principles AFTER the refactor is complete — never skip security for the sake of speed.
*   **Sequence:** Refactor → Verify correctness → Apply security hardening.
*   **Never skip:** Security hardening is not optional. If a refactor makes security harder, the refactor is incomplete.
*   **Threat Modeling:** Before and after refactoring, assess attack surface changes. Document new threats introduced or mitigated.
```

### Design 3: File Updates Detail

**README.md** (lines 142-161): Replace the SDD Cycle section body. Keep the ASCII diagram line (`Explore → Propose → ... → Archive`). Replace all text below it with: "For canonical phase definitions, agent mappings, and iteration rules, see `.atl/glossary.md§ SDD Phases (Canonical)`. For operational entry/exit criteria, see `.atl/standards/WORKING_STANDARD.md`."

**WORKING_STANDARD.md** (lines 270-293): Replace the two tables (SDD Phase Mapping + Phase-Agent Mapping) with: "**Note**: The canonical SDD phase definitions and agent mappings are now defined in `.atl/glossary.md§ SDD Phases (Canonical)`. This section delegates to that canonical source." Also line 12: change `Analysis →` to `Explore →` to normalize term.

**AGENT_BEHAVIOR.md**: (a) After the trigger-matching table (line 30), add row: `| Terminology & SDD phases | `.atl/glossary.md` |`. (b) Line 83: change SDD Phase column from `Analyse` to `Explore` (step name `Analyse` stays — migration protocol context). (c) After line 87: add clarifying note "See `.atl/glossary.md§ Terminology Mapping` for canonical mapping."

**STACK_MAP.md**: (a) Lines 383-392: delete entire "Patrones Transversales" → "Agnostic Fundamentals" subsection. (b) Line 461: remove `│   │   └── agnostic-fundamentals.md` from tree.

### Design 4: agnostic-fundamentals.md Removal

`git rm .atl/patterns/agnostic-fundamentals.md`. References in archived change files (`openspec/changes/archive/`) are historical and do not affect current agent behavior — no update needed.

## Open Questions

None — all decisions are scoped and resolved in the proposal/spec.

# Decision Log (DECISION_LOG.md)

This log captures architectural and significant engineering decisions with full context, options considered, and consequences. Decisions here are the "running record" of reasoning — day-to-day decisions that don't warrant a full ADR.

> **Relationship to ADRs:** For major structural changes (new architecture, stack decisions), use `docs/adr/NNNN-name.md`. This log captures incremental reasoning and smaller decisions that inform future work.

## Format Specification

Each decision entry MUST contain these six fields:

```
## NNNN — Decision Title

**Context:** What situation prompted this decision?
**Options Considered:** What alternatives were evaluated?
**Decision:** What was chosen?
**Rationale:** Why was this choice made?
**Consequences:** What are the outcomes (positive and negative)?
**Date:** YYYY-MM-DD
```

- **Sequential numbering:** Entries use 4-digit sequential numbers (0001, 0002, ...).
- **Single source of truth:** Each decision lives in this file. No duplicates.
- **Consult-before-change:** Before making a significant decision, consult this log to check for prior reasoning.

## Creating New Entries

1. Assign the next sequential number (NNNN).
2. Fill all six fields completely. Incomplete entries are not allowed.
3. Place the most recent entry at the top of the log.
4. Do not delete or modify existing entries (except for retrospective notation).

## Retrospective Notation

If a prior decision was made implicitly (without documentation), add a retrospective entry:

```
## NNNN — Retrospective: [Original Title]

**Context:** [What was decided at the time]
**Decision:** [What was actually done]
**Date:** [When it was originally decided]
**Retrospective:** [Added YYYY-MM-DD — why this wasn't documented originally]
```

## Initial Entries (Empty Log)

The following slots are reserved for future decisions:

```
## 0001 — [RESERVED]

**Context:** TBD
**Options Considered:** TBD
**Decision:** TBD
**Rationale:** TBD
**Consequences:** TBD
**Date:** TBD
```

---

*This file is the decision log. For formal architectural decision records, use `docs/adr/`.*

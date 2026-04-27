# Design: Project Discovery and Template Initialization

## Technical Approach

This is a pure documentation change — no code, no runtime behavior. The design focuses on content architecture, cross-references, and file organization. The template is being repositioned from "SDD framework only" to "Discovery tool + SDD framework".

Key principle: **Discovery is the first phase, not a separate concern.** The README becomes the onboarding guide that flows naturally from discovery → SDD → handoff.

## Architecture Decisions

### Decision: Bitacora.md at Root

**Choice**: Place `Bitacora.md` at repository root, not under `.atl/`
**Alternatives considered**: 
- `.atl/bitacora/` — consistent with `.atl/` structure but hides the file
- `docs/BITACORA.md` — product-specific location, but this is a meta-concern
**Rationale**: The Bitacora is the "living conversation" between user and agent. It needs to be immediately visible every time the user opens the project. Root placement signals highest accessibility. We update `navigation.spec.md` to explicitly permit it.

### Decision: `.atl/meta/` for LEARNINGS_MAP.md

**Choice**: Create `.atl/meta/` as a new subdirectory
**Alternatives considered**:
- `docs/learnings/` — product-specific, but learnings improve the template itself
- `.atl/decisions/` — conflates with formal ADRs
**Rationale**: `.atl/meta/` signals "meta-infrastructure" — things that improve the template across all projects. It's parallel to `.atl/patterns/` (which is also cross-project knowledge).

### Decision: WORKING_STANDARD.md in `.atl/standards/`

**Choice**: Place the working standard alongside other standards
**Alternatives considered**:
- `.atl/governance/` — this is a process standard, not a governance rule
- `docs/` — product-specific, but this applies to ALL projects using the template
**Rationale**: `.atl/standards/` already contains TESTING_STRATEGY.md and CICD_PIPELINE.md. The working standard is a process standard at the same level.

### Decision: README Structure

**Choice**: Five-section README: What → How to Use → Discovery → SDD Cycle → Handoff
**Alternatives considered**:
- Single long document — too overwhelming
- Split into multiple docs — fragments the onboarding flow
**Rationale**: The README is the ONE document a new user reads first. It must tell a complete story from "I just downloaded this" to "I know exactly what to do next." Each section flows into the next.

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `README.md` | Modify | Complete rewrite: discovery + SDD onboarding |
| `Bitacora.md` | Create | Conversation log with format instructions |
| `.atl/meta/LEARNINGS_MAP.md` | Create | Cross-project learning tracker |
| `.atl/standards/WORKING_STANDARD.md` | Create | Documented analysis→design→tasks→apply→verify cycle |
| `.atl/specs/navigation.spec.md` | Modify | Add `.atl/meta/` and `Bitacora.md`; update prohibition |

## Content Architecture

### README.md Flow
```
1. What is this?              (2-3 sentences)
2. How to use it              (clone, reset git, init SDD)
3. Discovery Phase            (FIRST thing to do with client)
   ├── What to discuss
   ├── What to document
   └── When you're done
4. SDD Cycle                  (what comes after discovery)
   ├── High-level phases
   └── Link to WORKING_STANDARD.md
5. Handoff                    (passing to programmers/designers)
   ├── What they need
   └── Where to find it
6. Navigation                 (quick reference to .atl/)
```

### Bitacora.md Structure
```
# Bitacora — Conversation Log

## How to Use This File
(Instructions for user and agent)

## Entries

### YYYY-MM-DD — Entry Title
**Context:** What was discussed?
**Decision:** What was agreed?
**Motivation:** Why?
```

### LEARNINGS_MAP.md Structure
```
# Learnings Map

## How to Update
(Scanning instructions)

## Learning Lifecycle
(Status definitions)

## Entries

### LEARN-0001 — Title
- **Learning:** What was discovered?
- **Source Project:** Where did it come from?
- **Files:** Relevant files
- **Template Impact:** How it improved the template
- **Status:** identified | evaluated | integrated | verified
```

### WORKING_STANDARD.md Structure
```
# Working Standard: Analysis → Design → Tasks → Apply → Verify

## Overview
(One paragraph)

## Phase: Analysis
- Entry Criteria
- Exit Criteria
- Responsibility

## Phase: Design
- Entry Criteria
- Exit Criteria
- Responsibility

(etc. for Tasks, Apply, Verify)

## SDD Mapping
(How this maps to SDD phases)

## Iteration Rule
(Verify until OK)
```

## Cross-Reference Map

| Document | References |
|----------|-----------|
| `README.md` | `Bitacora.md`, `.atl/standards/WORKING_STANDARD.md`, `.atl/governance/ENGINEERING_MANIFEST.md` |
| `Bitacora.md` | `.atl/decisions/DECISION_LOG.md` (promotion guidance) |
| `LEARNINGS_MAP.md` | `README.md` (in handoff section) |
| `WORKING_STANDARD.md` | `README.md`, SDD phases |
| `navigation.spec.md` | All new files |

## Migration / Rollout

No migration required. This is a template documentation update. Existing projects using the template are NOT affected — they only get these files when they re-clone or merge template updates.

## Open Questions

- [x] Where to place Bitacora.md? → Root (decided)
- [x] Where to place LEARNINGS_MAP.md? → `.atl/meta/` (decided)
- [x] Where to place WORKING_STANDARD.md? → `.atl/standards/` (decided)

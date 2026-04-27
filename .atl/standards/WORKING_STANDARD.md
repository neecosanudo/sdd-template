# Working Standard: Analysis → Design → Tasks → Apply → Verify

> **Purpose**: Document the working cycle that turns client conversations into working software. This standard applies to ALL projects using this template.
>
> **Relationship to SDD**: This cycle maps to the Spec-Driven Development phases. SDD is the *methodology*; this is the *operational standard* for executing it.

## Overview

The development cycle is:

```
Analysis → Design → Tasks → Apply → Verify (until OK) → Archive
```

**Critical rule**: Verification is NOT a one-time gate. If verification finds issues, you return to the appropriate earlier phase, fix, and re-verify. The cycle repeats until verification passes cleanly.

---

## Phase 1: Analysis

**What**: Understand the problem WITH the client before writing any code.

### Entry Criteria
- [ ] A new project or significant feature is starting
- [ ] Client/stakeholder is available for discussion
- [ ] No existing analysis document covers this scope

### Activities
- Define project scope and boundaries
- Gather functional requirements (what the system must do)
- Gather non-functional requirements (performance, security, scale)
- Identify stakeholders and user personas
- Create user stories or use cases
- Document constraints (budget, timeline, technology)

### Exit Criteria
- [ ] Scope is documented and agreed upon
- [ ] Requirements are captured in writing
- [ ] User stories exist for the first milestone
- [ ] Stakeholders have reviewed and approved

### Responsibility
- **Primary**: User (with client)
- **Support**: Agent can facilitate with questions and templates

### Output
- `docs/` or `Bitacora.md` — analysis notes, user stories, requirements

---

## Phase 2: Design

**What**: Plan the solution before implementing.

### Entry Criteria
- [ ] Analysis phase exit criteria are met
- [ ] Requirements are clear enough to design against

### Activities
- Architecture decisions (ADR if significant)
- Data model design
- Interface/API contracts
- Technology selection
- Sequence or flow diagrams for complex interactions

### Exit Criteria
- [ ] Design document exists
- [ ] Architecture decisions are recorded (in `docs/adr/` or `DECISION_LOG.md`)
- [ ] Interfaces/contracts are defined
- [ ] Design is reviewed (self or peer)

### Responsibility
- **Primary**: Agent (proposes), User (confirms)

### Output
- `docs/adr/NNNN-name.md` — architectural decisions
- Design documents in `docs/design/` or `openspec/changes/{change}/design.md`

---

## Phase 3: Tasks

**What**: Break the design into concrete, actionable steps.

### Entry Criteria
- [ ] Design phase exit criteria are met
- [ ] Design is approved or agreed upon

### Activities
- Decompose design into implementation tasks
- Estimate task size (completable in one session)
- Identify dependencies between tasks
- Group tasks into batches for apply-verify cycles

### Exit Criteria
- [ ] Task list exists with clear, specific items
- [ ] Tasks are ordered by dependency
- [ ] Each task is small enough for single-session completion
- [ ] Verify criteria are defined for each batch

### Responsibility
- **Primary**: Agent (proposes), User (reviews)

### Output
- `tasks.md` or `openspec/changes/{change}/tasks.md`

---

## Phase 4: Apply

**What**: Write the code. Implement the tasks.

### Entry Criteria
- [ ] Task list exists and is approved
- [ ] Design documents are accessible

### Activities
- Implement tasks in dependency order
- Follow existing code patterns and conventions
- Load relevant skills before coding
- Write tests FIRST if Strict TDD Mode is active

### Exit Criteria
- [ ] All tasks in the batch are implemented
- [ ] Code follows project conventions
- [ ] No obvious errors or omissions

### Responsibility
- **Primary**: Agent
- **Support**: User provides clarification

### Output
- Modified/created source files
- Tests (if applicable)

---

## Phase 5: Verify

**What**: Validate that implementation matches specs, design, and tasks.

### Entry Criteria
- [ ] Apply phase exit criteria are met
- [ ] A batch of tasks is complete

### Activities
- Compare implementation against spec scenarios
- Run tests if test infrastructure exists
- Check for linting, type, or formatting errors
- Review for consistency with design decisions

### Exit Criteria
- [ ] All spec scenarios are satisfied
- [ ] Tests pass (if applicable)
- [ ] No linting/type/formatting errors
- [ ] No critical or warning-level issues

### Iteration Rule (CRITICAL)
If verification finds issues:

```
Verify fails
    ↓
Return to appropriate phase:
    - Minor fix → Tasks (adjust task, re-apply)
    - Design flaw → Design (update design, re-task, re-apply)
    - Requirement misunderstanding → Analysis (re-analyze, redesign, etc.)
    ↓
Re-verify
    ↓
Still fails? Repeat until clean.
```

**You do NOT proceed to Archive until Verify passes cleanly.**

### Responsibility
- **Primary**: Agent (runs verification)
- **Support**: User reviews results

### Output
- Verification report (`verify-report.md` or engram artifact)

---

## Phase 6: Archive

**What**: Close the change and persist final state.

### Entry Criteria
- [ ] Verify phase passed cleanly
- [ ] All changes are committed (or ready to commit)

### Activities
- Move delta specs to main specs (if applicable)
- Write final summary
- Commit with conventional commit message

### Exit Criteria
- [ ] Change is archived
- [ ] Git history is clean
- [ ] Final state is documented

### Responsibility
- **Primary**: Agent
- **Support**: User approves final commit

### Output
- Archive report
- Git commit

---

## SDD Phase Mapping

| Working Standard | SDD Phase | Notes |
|-----------------|-----------|-------|
| Analysis | Explore + Propose + Spec | SDD splits analysis into three formal phases |
| Design | Design | Direct mapping |
| Tasks | Tasks | Direct mapping |
| Apply | Apply | Direct mapping |
| Verify | Verify | Direct mapping |
| Archive | Archive | Direct mapping |

**Key insight**: SDD formalizes the Analysis phase into Explore, Propose, and Spec. In practice, these often blend together. The Working Standard treats Analysis as the umbrella; SDD provides the sub-structure.

---

## Golden Rules

1. **Analysis before Design**: Never design without understanding the problem.
2. **Design before Tasks**: Never break work down without a plan.
3. **Tasks before Apply**: Never code without knowing what you're building.
4. **Verify before Archive**: Never close a change without validation.
5. **Iterate until clean**: One failed verify is not a failure — it's feedback. Fix and re-verify.

---

*This standard is the operational backbone of the template. When in doubt, re-read it.*

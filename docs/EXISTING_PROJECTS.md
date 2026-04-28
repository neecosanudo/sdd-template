# Applying sdd-template to Existing Projects

Retrofitting a template onto an existing project can feel overwhelming. This guide helps you assess what's already in place, prioritize changes, and avoid common pitfalls.

## Table of Contents

1. [Assessment Checklist](#assessment-checklist)
2. [Migration Priority Order](#migration-priority-order)
3. [Common Pitfalls](#common-pitfalls)
4. [Philosophy: Don't Do Everything at Once](#philosophy-dont-do-everything-at-once)

---

## Assessment Checklist

Before starting, assess your project honestly. This helps you understand what's missing, what's adequate, and what can wait.

### Project Infrastructure

| Item | Status | Notes |
|------|--------|-------|
| Git repository exists | ☐ | |
| CI/CD pipeline configured | ☐ | |
| Linting/formatting configured | ☐ | |
| Testing framework in place | ☐ | |
| Code coverage tracking | ☐ | |

### Documentation

| Item | Status | Notes |
|------|--------|-------|
| README.md exists and current | ☐ | |
| Architecture docs in `docs/` | ☐ | |
| ADRs in `docs/adr/` | ☐ | |
| Decision log exists | ☐ | |
| Working standard documented | ☐ | |

### Engineering Standards

| Item | Status | Notes |
|------|--------|-------|
| Style guide exists | ☐ | |
| Testing strategy documented | ☐ | |
| Security guidelines exist | ☐ | |
| Patterns cataloged | ☐ | |
| Agent behavior rules defined | ☐ | |

### Discovery & Process

| Item | Status | Notes |
|------|--------|-------|
| Bitacora.md for conversation log | ☐ | |
| Requirements documented | ☐ | |
| Scope agreement in writing | ☐ | |

**Scoring**: Count your checkmarks. Projects with >60% coverage can adopt the template in weeks. Projects <30% may need months. This is normal — the template is a target state, not a same-day conversion.

---

## Migration Priority Order

Don't try to adopt everything at once. Follow this order to get maximum value with minimum disruption.

### Phase 1: Foundation (Week 1-2)

**Goal**: Establish governance and minimal standards.

1. **Add `.atl/governance/ENGINEERING_MANIFEST.md`**
   - This is the operating system of your project
   - Start with the rules that matter most for your team
   - Add rules as you go, don't copy everything blindly

2. **Set up `openspec/config.yaml`**
   - Configure your project's specific settings
   - Define persistence mode, execution mode, task mode
   - This enables the SDD tooling to work correctly

3. **Add `.atl/standards/TESTING_STRATEGY.md`**
   - Document your existing testing approach
   - If you don't have one, this is the time to define it
   - Testing is foundational — everything else depends on it

### Phase 2: Core Standards (Week 2-4)

**Goal**: Fill in the gaps in your standards coverage.

4. **Add `.atl/patterns/agnostic-fundamentals.md`**
   - Language-agnostic patterns that apply to any project
   - Start with what's relevant to your stack
   - Expand as you discover new patterns

5. **Create `docs/adr/` if missing**
   - Architectural Decision Records
   - Start documenting decisions going forward
   - Don't try to backfill old decisions unless critical

6. **Add or update `Bitacora.md`**
   - Conversation log between you and your agent
   - Creates a record of decisions and context
   - Put it at the project root for visibility

### Phase 3: Learning Infrastructure (Week 4-6)

**Goal**: Build cross-project learning capability.

7. **Create `docs/LEARNINGS_MAP.md`**
   - Per-project, not template
   - Document what you've learned applying patterns
   - Share learnings with other projects using the template

8. **Add `.atl/decisions/DECISION_LOG.md`**
   - Track significant decisions
   - Include context, alternatives considered, and consequences

### Phase 4: Polish (Ongoing)

**Goal**: Refine and expand as needed.

9. **Add remaining governance files** as needed:
   - COMMIT_CONVENTIONS.md
   - VERSIONING.md
   - CONTRIBUTING.md (we've expanded this in the template!)

10. **Expand patterns** based on your stack:
    - Framework-specific patterns
    - Tool-specific patterns
    - Team conventions

---

## Common Pitfalls

### Pitfall 1: Trying to Do Everything at Once

**Symptom**: Two weeks in, the team is overwhelmed, and adoption slows to a crawl.

**Solution**: Pick ONE thing from Phase 1 and do it well. Then move to the next. The template is a journey, not a day-trip.

### Pitfall 2: Copying Without Understanding

**Symptom**: Files exist but no one follows them because they don't make sense for this project.

**Solution**: Every file you adopt must be adapted. The template is a starting point, not a mandate. If a rule doesn't fit your project, either adapt it or document why you skip it.

### Pitfall 3: No Buy-in from the Team

**Symptom**: You adopt the template but the team ignores it because they weren't consulted.

**Solution**: Involve the team in assessment. Let them decide what matters. The template is for the team, not the other way around.

### Pitfall 4: Backfilling Everything

**Symptom**: Spending months documenting existing decisions instead of moving forward.

**Solution**: Only document decisions going forward. Old decisions that aren't causing problems can wait. You'll learn more by doing than by documenting.

### Pitfall 5: Skipping Testing Strategy

**Symptom**: "We'll add tests later" — but later never comes.

**Solution**: If you don't have a testing strategy, make it your first priority. Everything else (CI, coverage, quality) depends on having tests to run.

---

## Philosophy: Don't Do Everything at Once

Retrofitting is a marathon, not a sprint. The template exists to help you build better software — not to create busy work.

**The Rule**: Adopt what helps your project. Adapt what almost helps. Skip what doesn't fit.

**Phased Approach**:
- Phase 1 gets you a working foundation
- Phase 2 fills in the important gaps
- Phase 3 builds learning capability
- Phase 4 is polish and refinement

You don't need to finish Phase 1 before using the template. Once you have governance and testing strategy, you can start using SDD for new work while gradually filling in the gaps.

**Remember**: The goal is better projects, not perfect template compliance. If adopting the template creates more work than it saves, something is wrong.

---

## Getting Help

If you're stuck or unsure where to start:

1. **Assess honestly**: Use the checklist to understand where you are
2. **Pick one thing**: Start with the highest-impact item for your project
3. **Ask questions**: Open an issue or discussion if you're unsure

The template is meant to help, not hinder. If it's not helping, something needs to change.
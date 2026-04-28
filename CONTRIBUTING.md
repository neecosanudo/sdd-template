# Contributing to sdd-template

Thank you for your interest in improving this template. This document explains how to propose changes, share learnings, and contribute improvements.

## Table of Contents

1. [Proposing New Patterns](#proposing-new-patterns)
2. [Suggesting Template Improvements](#suggesting-template-improvements)
3. [Sharing Learnings](#sharing-learnings)
4. [Pull Request Workflow](#pull-request-workflow)
5. [Review Process](#review-process)

---

## Proposing New Patterns

Patterns make tool decisions explicit, transferable, and reviewable. When you adopt a new tool or technique that should be reusable across projects, propose it as a pattern.

### How to Propose

1. **Create a pattern file** in `.atl/patterns/` following the existing structure:
   - Pattern name (descriptive, action-oriented)
   - Context (when to use this pattern)
   - Problem (what it solves)
   - Solution (the pattern itself with examples)
   - Consequences (tradeoffs, what you gain/lose)

2. **Document the decision** in `docs/adr/` explaining why this pattern should be in the template

3. **Submit a PR** with your proposed pattern (see [Pull Request Workflow](#pull-request-workflow))

### What Makes a Good Pattern?

- **Reusable**: Applies across multiple projects, not just one specific use case
- **Complete**: Includes context, problem, solution, and consequences
- **Battle-tested**: Proven in real projects, not theoretical
- **Language-agnostic**: Principles apply regardless of implementation language

---

## Suggesting Template Improvements

### Via GitHub Issues

For bugs, typos, or missing documentation:
1. Open an issue with a clear title and description
2. Label it appropriately (`bug`, `enhancement`, `documentation`)
3. Provide examples or references where possible

### Via Pull Requests

For concrete improvements:
1. Fork the repository
2. Make your changes
3. Submit a PR with explanation of what/why

### What Improvements Are Welcome?

- **Documentation fixes**: Typos, clearer explanations, missing links
- **Pattern additions**: New patterns that capture useful engineering techniques
- **Process improvements**: Ways to make SDD more effective
- **Template gaps**: Areas where the template doesn't cover something important

### What Is NOT Accepted?

- Opinion-based changes without rationale
- Changes that break existing patterns without migration path
- Features that add complexity without clear value

---

## Sharing Learnings

Learnings accumulated across projects improve the template for everyone. If you discovered something useful (or a painful gotcha), share it.

### How to Share

1. **Add to your project's `docs/LEARNINGS_MAP.md`** (per-project file)
2. **If the learning applies to all template users**, propose adding it to the appropriate `.atl/` file:
   - Engineering gotcha → `.atl/patterns/`
   - Process improvement → `.atl/standards/`
   - Governance insight → `.atl/governance/`

### What to Share

- **Patterns**: How you solved a recurring problem
- **Tool choices**: Why you selected a specific tool and what tradeoffs you found
- **Anti-patterns**: What didn't work and why
- **Migration lessons**: What you learned applying the template to existing projects

---

## Pull Request Workflow

### 1. Create a Branch

```bash
git checkout -b feat/my-new-pattern   # For new patterns
git checkout -b fix/some-bug          # For bug fixes
git checkout -b docs/improve-readme   # For documentation
```

### 2. Make Your Changes

- Keep changes focused and atomic
- One pattern per PR, or one logical improvement
- Update related files if needed (e.g., if adding a pattern, update navigation.spec.md)

### 3. Commit

Follow [COMMIT_CONVENTIONS.md](.atl/governance/COMMIT_CONVENTIONS.md):
- Use Gitmoji prefix (`:art:`, `:memo:`, `:sparkles:`, etc.)
- Use conventional commit format
- Reference issues when applicable

### 4. Submit PR

- Use the PR template (auto-generated)
- Explain **why** this change is needed
- Show **what** changed and **how** it works
- Link to relevant issues or discussions

### 5. Address Review Feedback

- Be responsive to review comments
- Explain your reasoning if you disagree
- Make requested changes or explain why you can't

---

## Review Process

### What Reviewers Look For

1. **Pattern quality**: Is the pattern complete? Reusable? Properly documented?
2. **Consistency**: Does it fit the template's existing structure and style?
3. **Impact**: Does it improve things or just add complexity?
4. **Documentation**: Are related files updated? Is the change explained clearly?

### Review Timeline

- Initial review within 3 business days
- Minor changes can be approved by any maintainer
- Significant changes (new patterns, architecture changes) require at least 2 approvals

### Merge Criteria

- All CI checks pass
- At least 1 approval (minor) or 2 approvals (major)
- No unresolved feedback
- Commit history is clean (rebase if needed)

---

## Questions?

If you're unsure about anything, open an issue or reach out to the maintainers. Better to ask before investing time in a change that might not fit the template's direction.
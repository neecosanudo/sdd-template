# sdd-template

> **What is this?** A repository template that guides you from the FIRST client conversation all the way to shipped software. It is BOTH a **project discovery tool** (for defining scope with your client) AND a **Spec-Driven Development (SDD) framework** (for building the right thing, right).

## Table of Contents

1. [Getting Started](#-getting-started)
2. [Discovery Phase](#-discovery-phase)
3. [SDD Cycle](#-sdd-cycle)
4. [Handoff](#-handoff-to-programmers-and-designers)
5. [Repository Navigation](#-repository-navigation)
6. [Why This Template](#-why-this-template)
7. [License](#-license)

---

## 🚀 Getting Started

### 1. Download the Template

```bash
# Clone the template
git clone https://github.com/your-org/sdd-template.git my-new-project
cd my-new-project

# Reset git history (this is YOUR project now)
rm -rf .git
git init
git add .
git commit -m "🎉 init: initial commit from sdd-template"

# Initialize SDD in your project
# (Follow your SDD tooling instructions)
```

---

## 🔍 Discovery Phase

**This is the most important step.** Before writing any code, you MUST understand the problem WITH your client.

### What to Discuss

| Topic | Why It Matters |
|-------|----------------|
| **Project Goals** | What does success look like? What problem are we solving? |
| **Scope & Boundaries** | What is IN scope? What is explicitly OUT of scope? |
| **Stakeholders** | Who are the users? Who are the decision-makers? |
| **User Personas** | Who will use this? What are their needs and pain points? |
| **Functional Requirements** | What must the system DO? (features, behaviors, workflows) |
| **Non-Functional Requirements** | How must the system perform? (speed, security, scale, accessibility) |
| **Constraints** | Budget, timeline, technology preferences, regulatory requirements |
| **Success Metrics** | How will we know this worked? |

### What to Document

Capture everything in:
- `Bitacora.md` — ongoing conversation log with your agent
- `docs/adr/` — significant architecture decisions (created during SDD)
- User stories or requirements documents (your preferred format)

### When Discovery Is Done

- [ ] Scope is agreed upon (in writing)
- [ ] Requirements are documented
- [ ] User stories exist for the first milestone
- [ ] Stakeholders have reviewed and approved

> **Rule #8 — Discovery-First**: No SDD work begins without documented scope agreement. See `.atl/governance/ENGINEERING_MANIFEST.md`.

---

## 🔄 SDD Cycle

Once discovery is complete, use the SDD framework to build:

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify (until OK) → Archive
```

For the operational details — entry/exit criteria, responsibilities, and the "verify until OK" iteration rule — see:

📄 **[`.atl/standards/WORKING_STANDARD.md`](.atl/standards/WORKING_STANDARD.md)**

### Batch-Verify Cycle

A single-pass verification that either passes (all checks green) or fails (any check red). **No partial success.** Fix all issues before committing.

### Iteration Rule

If verification finds issues → return to appropriate phase → re-verify. Repeat until clean. **You do NOT proceed to Archive until Verify passes.**

---

## 👥 Handoff to Programmers and Designers

When discovery and initial design are complete, pass these to your team:

| Deliverable | Location | For Whom |
|-------------|----------|----------|
| Requirements & User Stories | `Bitacora.md` + your docs | Everyone |
| Architecture Decisions | `docs/adr/` | Architects, Tech Leads |
| Design Documents | `docs/design/` or `openspec/` | Programmers |
| UI/UX Direction | Your design files | Designers |
| Standards & Patterns | `.atl/standards/`, `.atl/patterns/` | Everyone |

**Tip**: `Bitacora.md` is your team's best friend — it contains the "why" behind every decision.

---

## 🗺 Repository Navigation

For LLM navigation, read `.atl/specs/navigation.spec.md` first.

### `.atl/` Structure (Project Infrastructure)

| Directory | What It Contains |
|-----------|-------------------|
| `.atl/governance/` | Working rules: Manifesto, Commits, Contributing, Versioning |
| `.atl/standards/` | Style, Testing, Security, Release, CI/CD, **Working Standard** |
| `.atl/patterns/` | Language-agnostic engineering patterns |
| `.atl/agent/` | Agent behavior rules (delegation, skills, manual write review) |
| `.atl/decisions/` | Decision log for architectural and engineering decisions |
| `.atl/meta/` | Cross-project learnings and meta-infrastructure (`LEARNINGS_MAP.md`) |
| `.atl/specs/` | SDD specs for navigation and governance |

### Root Files

| File | Purpose |
|------|---------|
| `README.md` | This file |
| `Bitacora.md` | Ongoing conversation history between user and agent |
| `docs/` | Product-specific documentation (architecture, ADRs) |

---

## 🧠 Why This Template?

Most projects fail not because of bad code, but because of **bad understanding**. This template forces you to:

1. **Understand before building** (Discovery — Rule #8)
2. **Specify before coding** (SDD)
3. **Verify before shipping** (Verify until OK)
4. **Learn across projects** ([`.atl/meta/LEARNINGS_MAP.md`](.atl/meta/LEARNINGS_MAP.md))

It is not just a folder structure. It is a **discipline**.

---

## ⚖ License

MIT — See [LICENSE](LICENSE).
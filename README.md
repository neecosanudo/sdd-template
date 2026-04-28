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

## 📋 LEARNINGS_MAP.md — Per-Project, Not Template

`LEARNINGS_MAP.md` tracks cross-project learnings and meta-infrastructure. It lives in the `docs/` folder of each project, **not in the template itself**.

- **Template**: Contains shared infrastructure (`.atl/governance/`, `.atl/standards/`, etc.)
- **Per-project**: `docs/LEARNINGS_MAP.md` captures learnings specific to each project

This separation ensures the template stays generic while projects accumulate their own institutional knowledge.

**Scope**: LEARNINGS_MAP is for TRANSVERSAL learnings only.
- ✅ Tool choices, memory alignment patterns, architectural approaches that recur across projects
- ❌ Project-specific decisions → Bitacora.md
- ❌ Framework gotchas → `.atl/patterns/{tool}.md`

---

## ⚙️ Default Modes

This template enforces three behavioral modes:

| Mode | Value | Description |
|------|-------|-------------|
| **Persistence** | `hybrid` | Progress persists to both Engram (persistent memory) and openspec (filesystem) |
| **Execution** | `interactive` | SDD phases pause between stages for user confirmation |
| **Tasks** | `synchronous` | Tasks execute sequentially — no background delegation; user sees progress in real-time |

These are **enforced defaults**, not suggestions. Override only when explicitly requested by the user.

---

## 🤝 Contributing to This Template

See **[`CONTRIBUTING.md`](CONTRIBUTING.md)** for:
- How to propose new patterns for the template
- How to suggest improvements via GitHub issues/PRs
- How to share learnings from your project

---

## 🚀 Applying Template to Existing Projects

See **[`docs/EXISTING_PROJECTS.md`](docs/EXISTING_PROJECTS.md)** for:
- Assessment checklist (what's missing, what's good)
- Migration priority order
- Common pitfalls when retrofitting

### Quick Start — Copy & Paste Prompt for OpenCode

Want to adopt this framework in your existing project? Copy and paste the prompt below into your OpenCode agent:

```
I want to adopt the SDD Template framework in my existing project. Follow these steps:

1. Download the framework code from https://github.com/neecosanudo/sdd-template
2. Analyze the downloaded template structure, especially:
   - .atl/governance/ (working rules and manifesto)
   - .atl/standards/ (style, testing, security, working standard)
   - .atl/patterns/ (engineering patterns)
   - .atl/agent/ (agent behavior rules)
   - .atl/decisions/ (decision log)
   - .atl/specs/ (SDD specs)
   - docs/EXISTING_PROJECTS.md (migration guide)

3. CRITICAL: Each phase below MUST be executed as a FULL SDD cycle following the framework's standard:
   Explore → Propose → Spec → Design → Tasks → Apply → Verify (until OK) → Archive
   
   You MUST follow the instructions in .atl/standards/WORKING_STANDARD.md and act as an SDD orchestrator.
   Do NOT improvise or skip steps. Use the framework's governance and standards as the single source of truth.

PHASE 1 — Documentation Migration (NO code changes):
- Run a complete SDD cycle to migrate documentation only
- Read my existing project docs (README, docs/, wiki, notes)
- Map existing docs to the template structure
- Create missing template files from defaults
- Migrate existing content to template structure
- Create Bitacora.md at project root
- Create docs/LEARNINGS_MAP.md (transversal learnings only)
- Update README.md to reference template structure
- Do NOT modify any source code
- Do NOT delete existing files
- Verify until OK before archiving this phase

PHASE 2 — Compliance Analysis (AFTER documentation is complete and I confirm):
- Run a complete SDD cycle to analyze compliance
- As orchestrator, systematically scan the entire codebase against:
  * .atl/governance/ENGINEERING_MANIFEST.md
  * .atl/standards/ (all standards files)
  * .atl/patterns/ (applicable patterns)
- For every deviation found, document it with severity and proposed fix
- Provide a prioritized report of all corrections needed
- Do NOT make any code changes yet — only analyze and report
- Verify until OK before archiving this phase

Execute PHASE 1 first. Only proceed to PHASE 2 after I explicitly confirm the documentation migration is complete.
```

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
4. **Learn across projects** (`docs/LEARNINGS_MAP.md` — created per-project, not in template)

It is not just a folder structure. It is a **discipline**.

---

## ⚖ License

MIT — See [LICENSE](LICENSE).
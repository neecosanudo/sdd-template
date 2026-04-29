# sdd-template

> **What is this?** A repository template that guides you from the FIRST client conversation all the way to shipped software. It is BOTH a **project discovery tool** (for defining scope with your client) AND a **Spec-Driven Development (SDD) framework** (for building the right thing, right).

> **Opinionated Stack:** This template comes with a real stack pre-selected: **Go + SvelteKit + GORM + JWT + Docker + PostgreSQL + TailwindCSS + SDD/TDD**. See [STACK_MAP.md](docs/STACK_MAP.md) for versions and compatibility matrix.

## Table of Contents

1. [Getting Started](#-getting-started)
2. [Discovery Phase](#-discovery-phase)
3. [SDD Cycle](#-sdd-cycle)
4. [Handoff](#-handoff-to-programmers-and-designers)
5. [Repository Navigation](#-repository-navigation)
6. [Why This Template](#-why-this-template)
7. [License](#-license)

---

## 🚀 Stack del Proyecto

| Categoría | Herramienta | Versión |
|-----------|-------------|---------|
| **Backend** | Go + GORM | 1.25.0 + v1.31.1 |
| **Frontend Principal** | SvelteKit | 2.0.0 |
| **Frontend Prototipos** | React | 19.0.0 |
| **Styling** | TailwindCSS | 3.4.1 (SvelteKit) / 4.1.14 (React) |
| **Auth** | JWT (golang-jwt/v5) + bcrypt | v5.3.1 + v0.50.0 |
| **DevOps** | Docker + docker-compose | multi-stage |
| **Database** | PostgreSQL + SQLite (dev) | 16-alpine |
| **Testing** | Go test + Vitest + Playwright | v1.8.4 + ^2.0.0 + 1.50.1 |
| **Metodología** | SDD/TDD | Mandatorio |

### Stack Map

📄 **[docs/STACK_MAP.md](docs/STACK_MAP.md)** — Versiones exactas y matriz de compatibilidad

---

## 🎯 Filosofía del Template

1. **Stack Opinionado:** No es agnóstico. Viene con herramientas reales y versiones probadas.
2. **SDD Mandatorio:** Spec-Driven Development para toda feature.
3. **TDD Obligatorio:** RED → GREEN → REFACTOR para lógica de dominio.
4. **Arquitectura Hexagonal:** domain/application/infrastructure en Go.
5. **Documentación en Español AR:** Documentación local, código en inglés.

---

## 🚀 Getting Started

### Prerequisites

- **Go 1.25** — `go version`
- **Node.js 22** — `node -v`
- **Docker + docker-compose** — `docker compose version`

### 1. Download the Template

```bash
# Clone the template
git clone https://github.com/neocono/sdd-template.git my-new-project
cd my-new-project

# Reset git history (this is YOUR project now)
rm -rf .git
git init
git add .
git commit -m "🎉 init: initial commit from sdd-template"

# Initialize SDD in your project
sdd init
```

### 2. Initial Setup

```bash
# Backend
cd backend
go mod init github.com/org/project/backend
go get -d gorm.io/gorm@v1.31.1
go get -d gorm.io/driver/postgres@v1.6.0

# Frontend
cd ../frontend
npm install
npm run dev
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
| Architecture Decisions | `docs/decisions/` | Architects, Tech Leads |
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
| `.atl/patterns/` | Engineering patterns (go-hexagonal, svelte-component, gorm-repository, docker-multistage) |
| `.atl/agent/` | Agent behavior rules (delegation, skills, manual write review) |
| `.atl/decisions/` | Decision log for architectural and engineering decisions |
| `.atl/specs/` | SDD specs for navigation and governance |

### Root Files

| File | Purpose |
|------|---------|
| `README.md` | This file |
| `Bitacora.md` | Ongoing conversation history between user and agent |
| `docs/` | Product-specific documentation (architecture, ADRs) |
| `docs/STACK_MAP.md` | Stack completo con versiones y compatibilidad |

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
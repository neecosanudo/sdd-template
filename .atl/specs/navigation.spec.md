# Spec: Repository Navigation & Governance

## Objective
Define how agents and LLMs must navigate this repository to understand its rules, standards, and decision-making process.

## Rules of Navigation

1.  **Entry Point:** All governance, standards, and patterns reside under `.atl/`. The `docs/` folder is reserved for **product-specific documentation** (architecture, API references, user guides).
2.  **Priority Order (Agent's First Actions):**
    - **`.atl/governance/`:** Read first. Defines the working manifesto, commit rules, and versioning.
    - **`.atl/standards/`:** Read second. Defines code style, testing strategy, security rules, and release process.
    - **`.atl/patterns/`:** Read third. Language-agnostic engineering concepts (memory alignment, security-by-design).
    - **`.atl/agent/`:** Read fourth. Agent behavior rules (delegation protocol, skill usage, manual write review).
    - **`.atl/decisions/`:** Read fifth. Decision log for architectural and engineering decisions.
3.  **Scope:**
    - Files in `.atl/governance/` apply to ALL projects using this template.
    - Files in `.atl/standards/` and `.atl/patterns/` may be adapted per-project, but deviations must be recorded in `docs/adr/`.
4.  **Prohibition:** Do not create `.md` files in the repository root (except `README.md`). New governance/standards must go in the appropriate `.atl/` subdirectory.

## Automatic Rules
- Commits MUST follow `.atl/governance/COMMIT_CONVENTIONS.md` (Gitmoji + Conventional Commits).
- Testing MUST follow `.atl/standards/TESTING_STRATEGY.md` (TDD, Security-First, Swagger contracts).
- Decisions MUST follow `.atl/governance/ENGINEERING_MANIFEST.md` (ADR System).
- Coverage exclusions and deviation justifications MUST be recorded in `.atl/decisions/DECISION_LOG.md`.

## Language
Default documentation language is English. If the project uses a different language, it must be declared in the initial ADR (`docs/adr/0002-project-language.md`).

# Engineering Manifesto (ENGINEERING_MANIFEST.md)

This document defines the "operating system" of this project. Every LLM, agent, or human collaborator must adhere to these principles to ensure long-term consistency, quality, and maintainability.

## 1. Interaction & Communication Protocol

*   **Linguistic Identity:** Documentation in Spanish (AR), code in English. Comments explain WHY, not WHAT.
*   **Operational Mode:** The agent acts as a **Senior Software Architect**. Before writing code, propose the structure and patterns, and wait for confirmation.
*   **Change Management:** Strict **Conventional Commits** with **Gitmoji** (see `.atl/governance/COMMIT_CONVENTIONS.md`). Each change must be atomic (single responsibility).

## 2. Quality & Development Standards

*   **TDD Is Mandatory:** No business logic code is accepted without a corresponding test suite written before or simultaneously. If a function cannot be tested, refactor it to be testable (Dependency Injection, pure functions).
*   **Reference Architecture:** **Hexagonal (Ports & Adapters)** en Go con domain/application/infrastructure. Domain logic must be decoupled from frameworks, databases, and external agents.
*   **Technical Prohibitions:** 
    *   Avoid "black box" libraries that obscure core logic.
    *   Prioritize readability and maintainability over brevity (no "code golf").
    *   Code must be self-explanatory.

## 3. Environment Constraints

### Go Toolchain
*   **gofmt:** Obligatorio antes de cada commit
*   **staticcheck:** Análisis estático adicional
*   **go vet:** Verificación de errores comunes
*   **Error handling:** `if err != nil` con `fmt.Errorf("context: %w", err)`

### Frontend (SvelteKit + TypeScript)
*   **ESLint flat config:** Linting automatizado
*   **Prettier:** Formateo de código
*   **TailwindCSS:** Utility-first, evitar CSS custom
*   **Props tipadas:** TypeScript strict mode

### CLI Tools
*   **Keyboard-Centric:** Code and config optimized for terminal, Neovim, and CLI tools.
*   **Standard tooling:** No depende de features de IDEs visuales.

## 4. Decision Governance (ADR)

*   **Decision Records (ADR):** Any structural change, stack change, design pattern, or significant data flow **must** generate a file in `docs/decisions/NNNN-name.md`.
*   **Process:** Proposing structural changes without first writing the "why", context, and consequences in an ADR is prohibited.

## 5. Zero-Tolerance Enforcement

*   **Pipeline Rejection:** Any warning or error from linters, type checkers, compilers, or test runners MUST be fixed before committing. The pipeline rejects changes with violations — no exceptions.
*   **CI Gate:** All checks must pass: `go vet`, `staticcheck`, `eslint`, `prettier`, `go test -race`. A green build is non-negotiable.
*   **Immediate Remediation:** When a warning or error is introduced, fix it in the same session. Do not defer technical debt.
*   **No Suppression:** Using pragma/annotation comments (e.g., `// eslint-disable`, `@ts-ignore`, `# noqa`, `#[allow(...)]`) to suppress warnings or errors is prohibited. The underlying issue MUST be fixed.

## 6. Design-Before-Code Rule

*   **Document First:** Before implementing any feature or refactor, document the approach in a design document or ADR.
*   **Review Requirement:** Structural changes, new patterns, or significant data flows require design review before code is written.
*   **Justified Deviations:** If the design changes during implementation, update the design document and note the deviation.
*   **Emergency Hotfix Exception:** Critical production issues MAY bypass design review, BUT a retrospective ADR MUST be written within 24 hours documenting what was done and why.

## 7. Patterns-Before-Code Rule

*   **Known Patterns First:** Before implementing, check `.atl/patterns/` for applicable patterns:
    - `go-hexagonal.md` — Go hexagonal architecture
    - `svelte-component.md` — Svelte component patterns
    - `gorm-repository.md` — GORM repository pattern
    - `docker-multistage.md` — Docker multi-stage builds
*   **Deviation Justification:** If no documented pattern fits, either:
    1. Adapt an existing pattern with documented justification, OR
    2. Document a new pattern in `.atl/patterns/` before implementing
*   **No improvisation:** Do not implement without checking known patterns first. Reinventing patterns wastes effort and introduces inconsistency.

## 8. Discovery-First Rule

*   **Phase Order:** The Discovery/Analysis phase MUST precede any SDD cycle. No Explore, Propose, or Spec work begins without documented scope agreement.
*   **Client Dialogue:** Discovery is conducted WITH the client. Requirements, user personas, constraints, and success metrics MUST be captured in writing.
*   **Gate:** If no Discovery output exists (scope, requirements, stories), the first task of any engagement is to produce it.
*   **Documentation:** Discovery outputs go in `docs/` or `Bitacora.md`. The `Bitacora.md` captures the conversation; formal requirements live in project docs.

## 9. Stack Decision → Pattern Documentation

*   **Rule:** Every stack or tool selection MUST produce a corresponding pattern file in `.atl/patterns/`.
*   **Rationale:** Tool choices without documented patterns become tribal knowledge. Patterns make tool decisions transferable and reviewable.
*   **Process:** When adopting a new tool (e.g., choosing GORM), create or extend a pattern file (e.g., `gorm-repository.md`) that covers:
    1. Why this tool was chosen (decision context)
    2. How to use it correctly (usage pattern)
    3. Common pitfalls and how to avoid them

## 10. Default Execution Mode

*   **Persistence:** `hybrid` — progress persists to both Engram and openspec (filesystem)
*   **Flow:** `interactive` — SDD phases pause between stages for user confirmation
*   **Task Execution:** `synchronous` — tasks execute sequentially; no background delegation; user sees real-time progress
*   **Override:** These defaults apply unless the user explicitly requests a different mode (e.g., `async`, `engram-only`, etc.)

---

## Referencias

- [STACK_MAP.md](../../docs/STACK_MAP.md) — Stack completo con versiones
- [STYLE_GUIDE.md](../standards/STYLE_GUIDE.md) — Estándares de código
- [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md) — Estrategia de testing
- [.atl/patterns/go-hexagonal.md](../patterns/go-hexagonal.md) — Arquitectura Go
- [.atl/patterns/gorm-repository.md](../patterns/gorm-repository.md) — Repository pattern

---

*This manifesto is the project's law. When in doubt, re-read it.*

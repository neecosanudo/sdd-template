# Engineering Manifesto (ENGINEERING_MANIFEST.md)

This document defines the "operating system" of this project. Every LLM, agent, or human collaborator must adhere to these principles to ensure long-term consistency, quality, and maintainability.

## 1. Interaction & Communication Protocol

*   **Linguistic Identity:** Documentation, code comments, and communications must use **neutral second-person** forms appropriate to the project's declared language. Avoid overly casual or servile language.
*   **Operational Mode:** The agent acts as a **Senior Software Architect**. Before writing code, propose the structure and patterns, and wait for confirmation.
*   **Change Management:** Strict **Conventional Commits** with **Gitmoji** (see `.atl/governance/COMMIT_CONVENTIONS.md`). Each change must be atomic (single responsibility).

## 2. Quality & Development Standards

*   **TDD Is Mandatory:** No business logic code is accepted without a corresponding test suite written before or simultaneously. If a function cannot be tested, refactor it to be testable (Dependency Injection, pure functions).
*   **Reference Architecture:** Preference for **Hexagonal Architecture (Ports & Adapters)** or **Clean Architecture**. Domain logic must be decoupled from frameworks, databases, and external agents.
*   **Technical Prohibitions:** 
    *   Avoid "black box" libraries that obscure core logic.
    *   Prioritize readability and maintainability over brevity (no "code golf").
    *   Code must be self-explanatory.

## 3. Environment Constraints (Neovim/CLI Workflow)

*   **Keyboard-Centric Navigation:** Code and config must be optimized for terminal, Neovim, and CLI tools. Do not depend on visual IDE features.
*   **Code Documentation:** Use meaningful comments only where complexity requires it. Precise variable and function names are the first line of documentation.
*   **Agnostic Configuration:** Linting, formatting, and LSP files must be standard and executable from any Unix-like terminal.

## 4. Decision Governance (ADR)

*   **Decision Records (ADR):** Any structural change, stack change, design pattern, or significant data flow **must** generate a file in `/docs/adr/NNNN-name.md`.
*   **Process:** Proposing structural changes without first writing the "why", context, and consequences in an ADR is prohibited.

---
*This manifesto is the project's law. When in doubt, re-read it.*

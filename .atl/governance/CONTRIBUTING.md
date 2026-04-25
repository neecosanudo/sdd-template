# Contribution Guide (CONTRIBUTING.md)

Welcome! To maintain sanity and engineering quality, follow these guidelines.

## 1. Language
*   **Default:** English for all documentation, commit messages, and code comments.
*   **Customization:** If you prefer to work in **Spanish** or another language, declare it in the initial ADR (`docs/adr/0002-project-language.md`).

## 2. Workflow (Git Flow Simplified)
*   `main`: Stable, production-ready.
*   `feature/*`: New features.
*   `fix/*`: Bug fixes.
*   `refactor/*`: Code improvements without behavior change.

## 3. Development Process
1.  **Explore:** Understand the domain.
2.  **Design:** Propose the architecture, wait for confirmation.
3.  **TDD:** Write the failing test first.
4.  **Implement:** Make the test pass.
5.  **Refactor:** Clean up per `.atl/standards/STYLE_GUIDE.md`.
6.  **Commit:** Atomic commit with Gitmoji (see `.atl/governance/COMMIT_CONVENTIONS.md`).

## 4. Pull Request Requirements
*   All tests must pass.
*   Coverage must be maintained or increased.
*   Include an ADR if structural decisions were made.

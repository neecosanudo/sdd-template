# Style Guide (STYLE_GUIDE.md)

Readability is our top priority. Code should look like it was written by one person.

> **Note:** The following rules are guidelines. Specific languages (Go, Rust, Python, etc.) may have stronger conventions. When in conflict, the language's standard tooling (gofmt, rustfmt, black) takes precedence.

## 1. General Principles
*   **KISS (Keep It Simple, Stupid):** Do not overcomplicate.
*   **YAGNI (You Ain't Gonna Need It):** Do not build for "maybe" scenarios.
*   **SOLID:** Apply especially for clean architecture decoupling.

## 2. Naming Conventions
*   **Variables/Functions:** `camelCase`. Descriptive names (`getUserBalance` not `ub`).
*   **Classes/Components:** `PascalCase`.
*   **Constants:** `SCREAMING_SNAKE_CASE`.
*   **Files:** `kebab-case`.

> These are examples. Adapt to your language's idiomatic style (e.g., Go uses `MixedCaps` for exports, Rust uses `snake_case` for functions).

## 3. Code Structure
*   **Import Order:**
    1. Standard library.
    2. External libraries.
    3. Project aliases (`@domain/...`, `internal/...`).
    4. Relative imports.
*   **Small Functions:** One function = one responsibility. If >20 lines, consider refactoring.
*   **Comments:** Use comments to explain **WHY**, not **WHAT**. Let code explain the "what".

## 4. Formatting
*   Use automatic formatting tools (Prettier, Gofmt, Rustfmt, Black — whichever your language provides).
*   Do not argue about spacing. Let the tool enforce it.

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

## 4. Naming Intent

*   **Single-Letter Variables Prohibited:** Variable names MUST communicate purpose. `i`, `x`, `c` are not acceptable.
    - Exception: Loop counters with single-letter convention (e.g., `for i := 0; i < n; i++`) are acceptable in short loops only.
    - Exception: Mathematical contexts where single letters are idiomatic (e.g., `x`, `y` coordinates).
*   **Deviation Requires Comment:** If you use a non-descriptive name, add a comment explaining why: `// x is used here because [reason]`.
*   **Purpose Over Brevity:** `userAccountBalance` over `uab`. `getUserByID` over `getUser`. Name length is not a vice.

## 5. Log Sanitization

*   **PII Redaction:** Never log Personally Identifiable Information (PII). Redact emails, names, phone numbers, addresses, etc.
    - Bad: `log.Printf("User %s logged in", user.Email)`
    - Good: `log.Printf("User %s logged in", hashEmail(user.Email))`
*   **Secrets Redaction:** Never log passwords, tokens, API keys, or credentials.
    - Bad: `log.Printf("Auth token: %s", token)`
    - Good: `log.Printf("Auth token: [REDACTED]")`
*   **Structured Logging:** Use structured log formats (JSON, key-value) for machine parsing.
    - Bad: `log.Printf("User login from ip %s at %s", ip, timestamp)`
    - Good: `log.Printf("action=login user_id=%s ip=%s timestamp=%s", userID, ip, timestamp)`

## 6. Formatting
*   Use automatic formatting tools (Prettier, Gofmt, Rustfmt, Black — whichever your language provides).
*   Do not argue about spacing. Let the tool enforce it.

# Commit Conventions (COMMIT_CONVENTIONS.md)

We follow the **Conventional Commits** standard with **Gitmojis** for quick visual scanning by both humans and tools.

## Message Format
`<emoji> <type>(<scope>): <description>`

*   **emoji:** Corresponding Gitmoji (see table).
*   **type:** Impact type.
*   **scope (optional):** Context of change.
*   **description:** Brief explanation in present tense.

## Gitmoji & Type Table
| Type | Emoji | Description |
| :--- | :--- | :--- |
| `feat` | ✨ | New feature. |
| `fix` | 🐛 | Bug fix. |
| `docs` | 📝 | Documentation only. |
| `style` | 🎨 | Formatting, spaces, etc. |
| `refactor` | ♻️ | Code change without behavior change. |
| `test` | ✅ | Adding or fixing tests. |
| `chore` | 🏗 | Build, deps, or tooling changes. |
| `security` | 🔒 | Security fix or improvement. |

## Golden Rules
1.  **Atomic:** One commit, one task.
2.  **No AI Attribution:** Prohibited to add AI signatures or "Co-authored-by" from models.
3.  **Language:** Use the project's declared language for descriptions.

## Examples
*   `✨ feat(api): add user registration endpoint`
*   `🐛 fix(db): fix connection pool leak`
*   `🔒 security: add token validation`

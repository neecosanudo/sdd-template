# Style Guide (STYLE_GUIDE.md)

Readability is our top priority. Code should look like it was written by one person.

## 1. General Principles
*   **KISS (Keep It Simple, Stupid):** Do not overcomplicate.
*   **YAGNI (You Ain't Gonna Need It):** Do not build for "maybe" scenarios.
*   **SOLID:** Apply especially for clean architecture decoupling.

## 2. Naming Conventions

### Go (golang.org)
*   **Exports:** `MixedCaps` (`GetUserByID`, `CreateOrder`)
*   **Unexports:** `camelCase` (`validateEmail`, `calculateTotal`)
*   **Constants:** `MixedCaps` or `SCREAMING_SNAKE_CASE` (`MaxRetries`, `HTTP_STATUS_OK`)

### TypeScript / Svelte
*   **Variables/Functions:** `camelCase` (`getUserBalance`, `handleClick`)
*   **Types/Classes/Components:** `PascalCase` (`UserProfile`, `OrderItem`)
*   **Constants:** `SCREAMING_SNAKE_CASE` (`MAX_RETRIES`, `API_BASE_URL`)

### Svelte Components
*   **Component files:** `PascalCase.svelte` (`UserCard.svelte`, `OrderList.svelte`)
*   **Props:** `camelCase` exportadas (`export let userId`)

### General
*   **Files:** `kebab-case` (`user-service.ts`, `order_handler.go`)
*   **Descriptive names:** `getUserBalance` not `ub`, `userEmail` not `ue`

> **Tooling takes precedence:** `gofmt` for Go, `Prettier` for TypeScript/Svelte.

## 3. Code Structure

### Go Import Order
```go
import (
    // 1. Standard library
    "context"
    "errors"
    "fmt"
    "net/http"
    "time"

    // 2. External libraries (gorm.io, github.com, etc.)
    "github.com/golang-jwt/jwt/v5"
    "gorm.io/gorm"

    // 3. Project modules (your modules)
    "project/domain/entities"
    "project/domain/ports"

    // 4. Relative imports (if any)
)
```

### TypeScript Import Order
```typescript
// 1. Types/interfaces
import type { User, Order } from './types';

// 2. External libraries
import { SvelteKit } from '@sveltejs/kit';

// 3. $lib aliases
import { db } from '$lib/server/db';

// 4. Relative imports
import { UserCard } from './components/UserCard.svelte';
```

### SvelteKit File Structure
```
src/
├── routes/           # Pages (+page.svelte, +page.server.ts)
├── lib/
│   ├── components/   # Reusable components
│   ├── server/      # Server-only code (DB connections)
│   └── types/       # TypeScript types
└── app.css          # Global styles (TailwindCSS)
```

*   **Small Functions:** One function = one responsibility. If >20 lines, consider refactoring.
*   **Comments:** Use comments to explain **WHY**, not **WHAT**. Let code explain the "what".

## 4. Go-Specific

### gofmt (Obligatorio)
```bash
# Formatear antes de cada commit
go fmt ./...
```

### staticcheck
```bash
# Análisis estático adicional
go install honnef.co/go/tools/cmd/staticcheck@latest
staticcheck ./...
```

### Error Handling
```go
// ✅ Correcto: if err != nil con context
if err != nil {
    return fmt.Errorf("CreateUser %s: %w", email, err)
}

// ❌ Incorrecto: ignorar error
user, _ := repo.FindByID(id)

// ✅ Correcto: error wrapping
return fmt.Errorf("operation: %w", err)
```

### Struct Tags
```go
type User struct {
    ID        uint           `gorm:"primaryKey"`
    Email     string         `gorm:"uniqueIndex;not null"`
    Password  string         `gorm:"-"` // `-` means ignored by GORM
    CreatedAt time.Time      `json:"created_at"`
}
```

## 5. TypeScript/Svelte-Specific

### Prettier + ESLint
```bash
# Format
npx prettier --write .

# Lint
npx eslint .
```

### No `any` Sin Justificación
```typescript
// ❌ Incorrecto
function processData(data: any) { ... }

// ✅ Correcto
function processData(data: unknown) {
    if (typeof data === 'string') { ... }
}
```

### Props Tipadas (Svelte)
```svelte
<script lang="ts">
    export let userId: number;
    export let userName: string;
    export let isActive: boolean = false;
</script>
```

## 6. TailwindCSS-Specific

### Utility-First
```svelte
<!-- ✅ Correcto: utility classes -->
<div class="p-4 bg-white rounded-lg shadow">

<!-- ❌ Incorrecto: custom CSS cuando hay utility -->
<div class="custom-card">
```

### @apply Solo en Componentes Reutilizables
```svelte
<!-- ✅ Correcto: en un componente reutilizable -->
<style>
    .btn {
        @apply px-4 py-2 bg-blue-500 text-white rounded;
    }
</style>

<!-- ❌ Incorrecto: abuso de @apply como escape hatch -->
<div class="@apply font-bold text-xl">
```

## 7. Naming Intent

*   **Single-Letter Variables Prohibited:** Variable names MUST communicate purpose. `i`, `x`, `c` are not acceptable.
    - Exception: Loop counters with single-letter convention (e.g., `for i := 0; i < n; i++`) are acceptable in short loops only.
    - Exception: Mathematical contexts where single letters are idiomatic (e.g., `x`, `y` coordinates).
*   **Deviation Requires Comment:** If you use a non-descriptive name, add a comment explaining why.
*   **Purpose Over Brevity:** `userAccountBalance` over `uab`. `getUserByID` over `getUser`. Name length is not a vice.

## 8. Log Sanitization

*   **PII Redaction:** Never log Personally Identifiable Information (PII). Redact emails, names, phone numbers, addresses, etc.
    - Bad: `log.Printf("User %s logged in", user.Email)`
    - Good: `log.Printf("User %s logged in", hashEmail(user.Email))`
*   **Secrets Redaction:** Never log passwords, tokens, API keys, or credentials.
    - Bad: `log.Printf("Auth token: %s", token)`
    - Good: `log.Printf("Auth token: [REDACTED]")`
*   **Structured Logging:** Use structured log formats (JSON, key-value) for machine parsing.
    - Bad: `log.Printf("User login from ip %s at %s", ip, timestamp)`
    - Good: `log.Printf("action=login user_id=%s ip=%s timestamp=%s", userID, ip, timestamp)`

## 9. Formatting
*   Use automatic formatting tools: `go fmt` for Go, `prettier` for TypeScript/Svelte.
*   Run before every commit. Let the tool enforce it.

---

## Referencias

- [go.md](../../docs/tools/go.md) — Go toolchain y convenciones
- [sveltekit.md](../../docs/tools/sveltekit.md) — SvelteKit estructura
- [tailwindcss.md](../../docs/tools/tailwindcss.md) — TailwindCSS utility-first

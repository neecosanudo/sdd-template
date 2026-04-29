# Testing — Estrategia de Testing Completa

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [go.md](go.md) | [TESTING_STRATEGY.md](../../.atl/standards/TESTING_STRATEGY.md)

---

## 1. Estrategia General

```
┌─────────────────────────────────────────────────────────────┐
│                        TEST PYRAMID                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                        ┌───────────┐                        │
│                       │   E2E     │  Playwright           │
│                      │  (few)    │  Critical paths       │
│                     └───────────┘                         │
│                    ┌───────────────┐                      │
│                   │ Integration   │  Vitest (FE)         │
│                  │   (some)     │  adapters            │
│                 └───────────────┘                       │
│                ┌───────────────────┐                     │
│               │      Unit         │  Vitest + Go test   │
│              │    (many)         │  Pure functions     │
│             └───────────────────┘                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Go Testing con Testify

### Table-Driven Tests

```go
package domain_test

import (
    "testing"
    
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
    
    "project/domain"
)

func TestValidateEmail(t *testing.T) {
    tests := []struct {
        name    string
        email   string
        wantErr bool
   }{
        {
            name:    "valid email",
            email:   "user@example.com",
            wantErr: false,
        },
        {
            name:    "invalid - no @",
            email:   "userexample.com",
            wantErr: true,
        },
        {
            name:    "invalid - no domain",
            email:   "user@",
            wantErr: true,
        },
        {
            name:    "invalid - empty",
            email:   "",
            wantErr: true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := domain.ValidateEmail(tt.email)
            if tt.wantErr {
                assert.Error(t, err)
            } else {
                assert.NoError(t, err)
            }
        })
    }
}
```

### Subtests con t.Run

```go
func TestUserService_CreateUser(t *testing.T) {
    t.Run("success", func(t *testing.T) {
        repo := &mocks.MockUserRepository{}
        service := NewUserService(repo)
        
        req := CreateUserRequest{Email: "test@example.com", Name: "Test"}
        
        user, err := service.CreateUser(req)
        
        require.NoError(t, err)
        assert.Equal(t, req.Email, user.Email)
        assert.Equal(t, req.Name, user.Name)
        assert.NotZero(t, user.ID)
    })
    
    t.Run("duplicate email", func(t *testing.T) {
        repo := &mocks.MockUserRepository{
            ErrAlreadyExists: errors.New("duplicate"),
        }
        service := NewUserService(repo)
        
        _, err := service.CreateUser(CreateUserRequest{Email: "existing@example.com"})
        
        assert.Error(t, err)
        assert.True(t, errors.Is(err, ErrAlreadyExists))
    })
}
```

### Testify Assertions

```go
import "github.com/stretchr/testify/assert"

// Assertions comunes
assert.Equal(t, expected, actual)
assert.NotEqual(t, notExpected, actual)
assert.Nil(t, obj)
assert.NotNil(t, obj)
assert.True(t, condition)
assert.False(t, condition)
assert.Contains(t, string, substring)
assert.Len(t, collection, length)
assert.NoError(t, err)
assert.Error(t, err)

// require (fatal on failure)
require.NoError(t, err) // Para precondiciones
```

### Parallel Tests

```go
func TestDatabaseQueries(t *testing.T) {
    t.Parallel()
    
    tests := []struct {
        name  string
        query string
    }{
        {"get all", "SELECT * FROM users"},
        {"get by id", "SELECT * FROM users WHERE id = ?"},
    }
    
    for _, tt := range tests {
        tt := tt // Captura variable
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()
            // Test logic
        })
    }
}
```

---

## 3. Vitest para Frontend

### Setup

```bash
npm install -D vitest @testing-library/svelte @testing-library/jest-dom jsdom
```

### Configuración vitest

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
    plugins: [svelte()],
    test: {
        environment: 'jsdom',
        globals: true,
        setupFiles: ['./src/test/setup.ts'],
        include: ['src/**/*.{test,spec}.{js,ts}']
    }
});
```

### Ejemplo de Test de Componente

```typescript
// src/lib/components/UserCard.test.ts
import { render, screen } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import UserCard from './UserCard.svelte';

describe('UserCard', () => {
    const mockUser = {
        id: 1,
        name: 'John Doe',
        email: 'john@example.com'
    };
    
    it('renders user name and email', () => {
        render(UserCard, { props: { user: mockUser } });
        
        expect(screen.getByText('John Doe')).toBeInTheDocument();
        expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });
    
    it('shows edit button when canEdit is true', () => {
        render(UserCard, { props: { user: mockUser, canEdit: true } });
        
        const button = screen.getByRole('button', { name: /edit/i });
        expect(button).toBeInTheDocument();
    });
    
    it('does not show edit button when canEdit is false', () => {
        render(UserCard, { props: { user: mockUser, canEdit: false } });
        
        const button = screen.queryByRole('button', { name: /edit/i });
        expect(button).not.toBeInTheDocument();
    });
});
```

### Mocks

```typescript
import { vi } from 'vitest';

vi.mock('$lib/server/db', () => ({
    db: {
        user: {
            Find: vi.fn().mockResolvedValue([mockUser])
        }
    }
}));
```

---

## 4. Playwright para E2E

### Setup

```bash
npm install -D @playwright/test
npx playwright install --with-deps chromium
```

### Configuración

```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
    testDir: './e2e',
    fullyParallel: true,
    forbidOnly: !!process.env.CI,
    retries: process.env.CI ? 2 : 0,
    workers: process.env.CI ? 1 : undefined,
    reporter: 'html',
    use: {
        baseURL: 'http://localhost:4173',
        trace: 'on-first-retry',
    },
    projects: [
        { name: 'chromium', use: { browserName: 'chromium' } }
    ]
});
```

### Test E2E Login

```typescript
// e2e/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login Flow', () => {
    test('should login with valid credentials', async ({ page }) => {
        await page.goto('/login');
        
        // Fill form
        await page.getByLabel('Email').fill('test@example.com');
        await page.getByLabel('Password').fill('password123');
        
        // Submit
        await page.getByRole('button', { name: 'Sign In' }).click();
        
        // Verify redirect to dashboard
        await expect(page).toHaveURL('/dashboard');
        
        // Verify success message
        await expect(page.getByText('Welcome back!')).toBeVisible();
    });
    
    test('should show error with invalid credentials', async ({ page }) => {
        await page.goto('/login');
        
        await page.getByLabel('Email').fill('wrong@example.com');
        await page.getByLabel('Password').fill('wrongpassword');
        
        await page.getByRole('button', { name: 'Sign In' }).click();
        
        await expect(page.getByRole('alert')).toContainText('Invalid credentials');
    });
});
```

---

## 5. Coverage Thresholds por Capa

| Capa | Target | Herramienta |
|------|--------|-------------|
| **Domain** (entidades, lógica pura) | 100% | `go test -cover` / Vitest |
| **Application** (casos de uso) | >= 80% | `go test -cover` / Vitest |
| **Adapters** (GORM, HTTP) | >= 70% | `go test -cover` / Vitest |
| **Infrastructure** (DB, external) | >= 60% | `go test -cover` / Vitest |

### Configurar Coverage Go

```bash
# Terminal
go test ./... -v -coverprofile=coverage.out
go tool cover -func=coverage.out

# Ver report HTML
go tool cover -html=coverage.out -o coverage.html
```

### Configurar Coverage Vitest

```typescript
// vitest.config.ts
export default defineConfig({
    test: {
        coverage: {
            provider: 'v8',
            reporter: ['text', 'html'],
            thresholds: {
                lines: 80,
                functions: 80,
                branches: 70,
                statements: 80
            }
        }
    }
});
```

---

## 6. Comandos de Testing

```bash
# Go Backend
go test ./... -v -cover              # Tests con coverage
go test ./... -race                  # Race detector
go test ./... -coverprofile=out.dat  # Coverage file
go test -run TestPattern              # Filtrar por nombre

# Vitest Frontend
npm run test                          # Tests unitarios
npm run test -- --ui                  # UI de tests
npm run test -- --coverage            # Con coverage
npx playwright test                   # E2E

# Pipeline CI
go test ./... -v -race -cover
npm run test -- --coverage
npx playwright test
```

---

## 7. Referencias

- [TESTING_STRATEGY.md](../../.atl/standards/TESTING_STRATEGY.md) — Estrategia completa
- [tdd.md](../decisions/tdd.md) — ADR de TDD
- [go.md](go.md) — Go testing patterns
- [sveltekit.md](sveltekit.md) — Testing SvelteKit

---

*Testing en 3 capas es mandatorio. Coverage thresholds por capa según tabla.*

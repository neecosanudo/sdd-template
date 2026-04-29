# Testing Strategy & Quality Standards (TESTING_STRATEGY.md)

This project uses **Spec-Driven Development (SDD)**. Tests are the validation of specifications, not an afterthought.

## 1. SDD & Testing Cycle
1.  **Spec:** Define expected behavior via specs.
2.  **Design:** Define how to test it.
3.  **Apply:** Implement tests *before* or *simultaneously* with logic (TDD).
4.  **Verify:** SDD verification runs the full suite.

## 2. Test Levels

### Backend: Go testing + testify
*   **Unit Tests:** `go test ./domain/...` — Pure domain logic, no DB.
*   **Integration Tests:** `go test ./infrastructure/...` — GORM, HTTP handlers.
*   **E2E Tests:** `go test ./... -tags=e2e` — Full stack with real DB.

### Frontend: Vitest + Playwright
*   **Unit Tests:** Vitest `src/**/*.test.ts` — Components, utilities.
*   **Integration Tests:** Vitest con mocks de API.
*   **E2E Tests:** Playwright `e2e/**/*.spec.ts` — Critical user flows.

## 3. Contract Validation: Swagger/OpenAPI

Tools: **swaggo/swag** (v1.16.6) + **http-swagger/v2**

*   **Contract is law:** Implementation MUST match spec.
*   Generate docs: `swag init -g cmd/main.go -o docs/`
*   CI validates compliance with generated swagger.json.

## 4. Coverage Standards por Capa

| Capa | Target | Herramienta |
|------|--------|-------------|
| **Domain** (entities, ports) | 100% | `go test -cover` |
| **Application** (usecases) | >= 80% | `go test -cover` |
| **Adapters** (GORM, HTTP) | >= 70% | `go test -cover` |
| **Infrastructure** (DB, external) | >= 60% | `go test -cover` |

### Ejemplo: Table-Driven Test (Go)

```go
func TestValidateEmail(t *testing.T) {
    tests := []struct {
        name    string
        email   string
        wantErr bool
    }{
        {"valid", "test@example.com", false},
        {"no @", "testexample.com", true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            err := ValidateEmail(tt.email)
            if (err != nil) != tt.wantErr {
                t.Errorf("ValidateEmail() error = %v, wantErr %v", err, tt.wantErr)
            }
        })
    }
}
```

### Ejemplo: Vitest Component Test

```typescript
import { render, screen } from '@testing-library/svelte';
import { describe, it, expect } from 'vitest';
import UserCard from './UserCard.svelte';

describe('UserCard', () => {
    it('renders user name', () => {
        render(UserCard, { props: { user: { name: 'John' } } });
        expect(screen.getByText('John')).toBeInTheDocument();
    });
});
```

### Ejemplo: Playwright E2E Login

```typescript
test('login flow', async ({ page }) => {
    await page.goto('/login');
    await page.getByLabel('Email').fill('test@example.com');
    await page.getByLabel('Password').fill('password');
    await page.getByRole('button', { name: 'Sign In' }).click();
    await expect(page).toHaveURL('/dashboard');
});
```

## 5. Security by Default

*   **Least Privilege:** Minimize permissions.
*   **Input Validation:** Never trust external input.
*   **SAST:** `go vet`, `staticcheck`, `govulncheck`.

## 6. Strict TDD (RED-GREEN-REFACTOR)

### 6.1 Mandatory Cycle
1.  **RED:** Write failing test FIRST.
2.  **GREEN:** Minimum code to pass.
3.  **REFACTOR:** Improve keeping tests green.
4.  **Repeat:** Never break the cycle.

### 6.2 Enforced
*   No implementation without failing test first.
*   Coverage thresholds are non-negotiable.
*   Pipeline rejects PRs with coverage below threshold.

## 7. Batch-Verify Workflow

### 7.1 Single-Pass
1. Run all tests.
2. Fix all failures in one session.
3. Re-run to confirm green.
4. Commit only when everything passes.

### 7.2 Result
*   Single pass/fail: either all pass (PASS) or change rejected (FAIL).
*   Partial fixes not acceptable.

## 8. Golden Rules
*   **Dependency Injection:** Required for testability.
*   **Coverage:** Domain 100%, Application >= 80%, Adapters >= 70%.
*   **Naming:** Describe behavior (`test_should_handle_empty_input`).

---

## Referencias

- [testing.md](../../docs/tools/testing.md) — Herramientas completas
- [tdd.md](../../docs/decisions/tdd.md) — ADR de TDD
- [CICD_PIPELINE.md](CICD_PIPELINE.md) — Pipeline de tests

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

### 6.3 TDD Batch Mode (All RED → All GREEN)

*   **Concept:** Write ALL failing tests for the entire feature before writing ANY implementation code.
*   **Workflow:**
    1. **Analyze specs** → identify all test cases needed
    2. **All RED** → write every test that should fail (no implementation yet)
    3. **All GREEN** → implement code until all tests pass
    4. **Refactor** → improve code while keeping tests green
*   **Benefits:**
    *   Ensures complete test coverage before implementation begins
    *   Prevents "test after" syndrome where tests are written to match existing code
    *   Forces clear understanding of requirements upfront
*   **When to use:** Complex features, multiple interconnected tests, or batch SDD work

## 7. Batch-Verify Workflow

### 7.1 Single-Pass
1. Run all tests.
2. Fix all failures in one session.
3. Re-run to confirm green.
4. Commit only when everything passes.

### 7.2 Result
*   Single pass/fail: either all pass (PASS) or change rejected (FAIL).
*   Partial fixes not acceptable.

## 8. Test Utilities & Patterns

### 8.1 Clock Interface for Time-Dependent Logic

*   **Problem:** Tests that depend on `time.Now()` or `time.Sleep()` are non-deterministic and hard to test.
*   **Solution:** Inject a Clock interface instead of using system time directly.

```go
// domain/ports/clock.go
package ports

// Clock defines the interface for time operations.
type Clock interface {
    Now() time.Time
    Since(t time.Time) time.Duration
}

// RealClock uses system time (default for production)
type RealClock struct{}

func (RealClock) Now() time.Time { return time.Now() }
func (RealClock) Since(t time.Time) time.Duration { return time.Since(t) }

// FixedClock returns a constant time (for testing)
type FixedClock struct {
    FixedTime time.Time
}

func (f FixedClock) Now() time.Time { return f.FixedTime }
func (f FixedClock) Since(t time.Time) time.Duration { return f.FixedTime.Sub(t) }
```

*   **Usage in UseCase:**

```go
type TokenGenerator struct {
    clock Clock
}

func NewTokenGenerator(opts ...Option) *TokenGenerator {
    cfg := defaultConfig()
    for _, o := range opts {
        o(cfg)
    }
    return &TokenGenerator{clock: cfg.clock}
}

// Option pattern for configuration
type Option func(*config)

func WithClock(c Clock) Option {
    return func(cfg *config) {
        cfg.clock = c
    }
}
```

*   **Testing with FixedClock:**

```go
func TestTokenExpiry(t *testing.T) {
    fixedTime := time.Date(2024, 1, 1, 12, 0, 0, 0, time.UTC)
    generator := NewTokenGenerator(WithClock(FixedClock{FixedTime: fixedTime}))
    // Test deterministic behavior
}
```

### 8.2 Factory Functions with Functional Options Pattern

*   **Problem:** Constructors with many parameters are hard to use and test.
*   **Solution:** Use functional options for flexible, declarative configuration.

```go
type Config struct {
    maxRetries  int
    timeout     time.Duration
    logger      Logger
    cacheEnabled bool
}

// Default values
func defaultConfig() Config {
    return Config{
        maxRetries:   3,
        timeout:      30 * time.Second,
        logger:       nil, // No logger by default
        cacheEnabled: true,
    }
}

// Functional options
type Option func(*Config)

func WithMaxRetries(n int) Option {
    return func(c *Config) {
        c.maxRetries = n
    }
}

func WithTimeout(d time.Duration) Option {
    return func(c *Config) {
        c.timeout = d
    }
}

func WithLogger(l Logger) Option {
    return func(c *Config) {
        c.logger = l
    }
}

func WithCache(enabled bool) Option {
    return func(c *Config) {
        c.cacheEnabled = enabled
    }
}

// Constructor with options
func NewService(opts ...Option) *Service {
    cfg := defaultConfig()
    for _, opt := range opts {
        opt(&cfg)
    }
    return &Service{
        maxRetries:  cfg.maxRetries,
        timeout:     cfg.timeout,
        logger:      cfg.logger,
        cache:       newCache(cfg.cacheEnabled),
    }
}
```

*   **Usage:**

```go
// Production: use defaults
service := NewService()

// Testing: override specific values
mockLogger := &MockLogger{}
service := NewService(
    WithMaxRetries(1),
    WithTimeout(5*time.Second),
    WithLogger(mockLogger),
    WithCache(false),
)
```

*   **Benefits:**
    *   No required parameters (all have sensible defaults)
    *   Optional parameters are self-documenting
    *   Easy to test: override only what you need
    *   Backward compatible: add new options without breaking existing code

## 8. Golden Rules
*   **Dependency Injection:** Required for testability.
*   **Coverage:** Domain 100%, Application >= 80%, Adapters >= 70%.
*   **Naming:** Describe behavior (`test_should_handle_empty_input`).

---

## Referencias

- [testing.md](../../docs/tools/testing.md) — Herramientas completas
- [tdd.md](../../docs/decisions/tdd.md) — ADR de TDD
- [CICD_PIPELINE.md](CICD_PIPELINE.md) — Pipeline de tests

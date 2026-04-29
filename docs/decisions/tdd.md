# ADR-002: TDD Mandatorio

**Estado**: Aprobado
**Fecha**: 2026-04-29
**Decisión**: Test-Driven Development es obligatorio para toda lógica de dominio

---

## 1. Contexto

El código sin tests se acumula deuda técnica silenciosamente. Cada vez que se hace refactoring, no hay forma de verificar que el comportamiento se mantiene. El equipo necesita una disciplina que garantice calidad desde el inicio.

---

## 2. Decisión

**TDD es no-negociable**. Todo código de dominio debe tener tests escritos ANTES o SIMULTÁNEAMENTE con la implementación.

### Ciclo RED → GREEN → REFACTOR

```
1. RED:    Escribir test que falla (el código no existe aún)
2. GREEN:  Implementar mínimo código para que pase
3. REFACTOR: Mejorar código manteniendo tests verdes
4. Repetir
```

### Ejemplo Concreto: ValidateEmail

```go
// 1. RED - Escribir test primero
package domain_test

import (
    "testing"
    "project/domain"
)

func TestValidateEmail(t *testing.T) {
    err := domain.ValidateEmail("invalid-email")
    if err == nil {
        t.Error("expected error for invalid email, got nil")
    }
}
```

```go
// 2. GREEN - Implementación mínima
package domain

func ValidateEmail(email string) error {
    if !strings.Contains(email, "@") {
        return errors.New("invalid email format")
    }
    return nil
}
```

```go
// 3. REFACTOR - Mejorar manteniendo verde
func ValidateEmail(email string) error {
    if email == "" {
        return errors.New("email is required")
    }
    if !strings.Contains(email, "@") {
        return errors.New("email must contain @")
    }
    if strings.Count(email, "@") > 1 {
        return errors.New("email must contain exactly one @")
    }
    return nil
}
```

---

## 3. Coverage Thresholds por Capa

| Capa | Target | Razón |
|------|--------|-------|
| **Domain** | 100% | Lógica pura, sin dependencias externas |
| **Application** | >= 80% | Casos de uso, orchestration |
| **Adapters** | >= 70% | GORM, HTTP handlers |
| **Infrastructure** | >= 60% | DB connections, external APIs |

---

## 4. Código Sin Tests en Code Review

> ⚠️ **Regla de Zero-Tolerance**: PRs con código de dominio sin tests serán rechazados en code review.

```
Criteria:
- Lógica de dominio (domain/) requiere 100% coverage
- Casos de uso (application/) requiere >= 80% coverage
- Handlers y adapters requieren >= 70% coverage
- Infraestructura (DB, external) >= 60% coverage
```

---

## 5. Alternativas Rechazadas

| Alternativa | Razón del Rechazo |
|-------------|-------------------|
| **Tests al final** | Incentivo perverso: código "funciona", tests se saltan |
| **Coverage opcional** | Se convierte en opcional para "prisas" |
| **TDD "cuando se pueda"** | TDD no es optional |

---

## 6. Consecuencias

- **Positivas**: Código más mantenible, refactoring seguro, documentación viva vía tests
- **Negativas**: Mayor tiempo inicial de desarrollo (compensado con menor tiempo de debugging)
- **Riesgo**: Desgaste del equipo si se aplica de forma rígida sin contexto

---

## 7. Referencias

- [testing.md](../tools/testing.md) — Guía de herramientas
- [TESTING_STRATEGY.md](../../.atl/standards/TESTING_STRATEGY.md) — Estrategia operativa
- [ENGINEERING_MANIFEST.md](../../.atl/governance/ENGINEERING_MANIFEST.md) — Zero-tolerance enforcement

---

*TDD no es opcional. Es la forma de garantizar que el código hace lo que dice.*

# ADR-004: Documentación en Español AR, Código en Inglés

**Estado**: Aprobado
**Fecha**: 2026-04-29
**Decisión**: Documentación en español argentino, código fuente en inglés

---

## 1. Contexto

El equipo de desarrollo escribe código que será leído por humanos de diferentes procedencias. Necesitamos una convención clara sobre qué idioma usar en cada artefacto.

---

## 2. Decisión

| Artefacto | Idioma | Razón |
|-----------|--------|-------|
| **Documentación** (`docs/`, `.atl/`) | Español AR | Claridad para stakeholders, memoria institucional |
| **Código fuente** (`.go`, `.ts`, `.svelte`) | Inglés | Convenciones universales, tooling en inglés |
| **Commits** | Inglés (Conventional Commits) | Git ecosystem en inglés |
| **Variables y funciones** | Inglés | Estándar universal |
| **Errores y logs** | Inglés | Logs en sistemas son en inglés |
| **ADR titles** | Inglés | Identificadores universales |

---

## 3. Ejemplos

### ✅ Documentación Correcta

```markdown
<!-- docs/decisions/api-first.md -->
# ADR-001: API First

## 1. Contexto

El frontend y backend necesitan acordar un contrato...

## 2. Decisión

**API First es mandatorio**...
```

### ✅ Código Correcto

```go
// domain/entities/user.go
package entities

type User struct {
    ID        uint
    Email     string
    Name      string
    CreatedAt time.Time
}

// ValidateEmail checks if the email format is valid.
func (u *User) ValidateEmail() error {
    if !strings.Contains(u.Email, "@") {
        return errors.New("invalid email format")
    }
    return nil
}
```

### ❌ Código Incorrecto

```go
// ❌ NO HACER ESTO
type Usuario struct {
    ID       uint
    Nombre   string  // Mezcla de idiomas
    Correo   string
}
```

---

## 4. Excepciones

| Excepción | Razón |
|-----------|-------|
| **Errores específicos** | Mensajes de error en español para usuarios finales (si aplica) |
| **Test fixtures locales** | Datos de prueba pueden estar en español |
| **Documentación de dominio** | Domain concepts en español cuando no hay traducción directa |

---

## 5. Tabla de Referencia Rápida

| Escribe en... | Si es... | Ejemplo |
|--------------|----------|---------|
| **Español** | Documentación | `## Getting Started` → `## Primeros Pasos` |
| **Español** | Comments en docs | `// El usuario ingresa su email` |
| **Inglés** | Código fuente | `type User struct` |
| **Inglés** | Funciones | `func CreateUser()` |
| **Inglés** | Variables | `userEmail := "test@example.com"` |
| **Inglés** | Errores | `errors.New("invalid email")` |
| **Inglés** | Commits | `feat: add user registration` |

---

## 6. Consecuencias

- **Positivas**: Stakeholders hispanohablantes entienden docs sin barrera, código mantiene estándar universal
- **Negativas**: Dificulta contribuciones externas de habla no-hispana
- **Riesgo**: Mezcla accidental de idiomas en código o docs

---

## 7. Referencias

- [STACK_MAP.md](../STACK_MAP.md) — Stack principal
- [ENGINEERING_MANIFEST.md](../../.atl/governance/ENGINEERING_MANIFEST.md) — Gobernanza

---

*Español para documentación, inglés para código. Mezclar idiomas es confuso.*

# Testing Strategy

> **Propósito**: Definir el approach, herramientas y coverage targets para testing.
>
> **MODO**: Template — completar con la estrategia específica del proyecto.

---

## Testing Pyramid

### Unit Tests
- **Qué**: Lógica pura — utils, stores con estado síncrono, funciones de dominio
- **Dónde**: Archivos `*_test.ts` / `*_test.go` co-located con el archivo que testea
- **Coverage objetivo**: [TODO: definir %]

### Integration Tests
- **Qué**: API endpoints, stores con mocked API client, handlers HTTP
- **Dónde**: [TODO: definir carpeta]
- **Coverage objetivo**: [TODO: definir %]

### E2E Tests
- **Qué**: Flujos críticos del usuario
- **Dónde**: [TODO: definir carpeta]
- **Herramienta**: [TODO: Playwright / Cypress / etc.]

---

## Herramientas

| Capa | Herramienta | Uso |
|------|-------------|-----|
| Unit (frontend) | [TODO: Vitest / Jest] | Test runner + assertions |
| Unit (backend) | [TODO: Go test / pytest] | Test runner nativo |
| Integration | [TODO: herramienta] | Pruebas de integración |
| E2E | [TODO: Playwright / Cypress] | Browser automation |
| Property-based | [TODO: fast-check / hypothesis] | Invariantes de dominio |
| Coverage | [TODO: herramienta] | Reporte de cobertura |

---

## Reglas

1. **Tests se escriben ANTES o SIMULTÁNEAMENTE al código** — no se hace commit de código sin test coverage donde corresponde
2. **Toda lógica de dominio debe tener test unitario** — funciones puras, transformaciones, validaciones
3. **Strict TDD Mode** (si aplica): RED test (fallando) → GREEN (pasa) → REFACTOR

<!-- [TODO: Agregar reglas específicas del proyecto] -->

---

## Coverage Targets

| Layer | Target | Actual |
|-------|--------|--------|
| [TODO: backend domain] | [TODO: %] | — |
| [TODO: frontend logic] | [TODO: %] | — |
| [TODO: components] | [TODO: %] | — |
| [TODO: e2e flows] | [TODO: cantidad] | — |

---

## Estructura de Archivos de Test

```
[TODO: Documentar la estructura de archivos de test del proyecto]
```

---

## Comandos

```bash
# [TODO: Comandos específicos del proyecto]
# Ej:
# go test ./... -count=1
# npm run test
# npm run test:coverage
```

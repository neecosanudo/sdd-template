# Engineering Manifesto

Ley del proyecto. Todo lo que no es negociable.

## 1. Identidad

- **Docs:** Español (AR)
- **Código:** Inglés
- **Comentarios:** Explican el POR QUÉ, no el QUÉ

## 2. TDD Es Mandatorio

- Sin tests → no se acepta código
- Tests primero (RED → GREEN → REFACTOR)
- Cobertura: 100% domain, ≥80% application
- **No suppression:** Prohibido `// eslint-disable`, `@ts-ignore`, etc.

## 3. Arquitectura

**Hexagonal (Ports & Adapters):**
```
domain/     → lógica pura
application/ → casos de uso
infrastructure/ → adapters
```

- Lógica de dominio desacoplada de frameworks y DBs
- No "black box" libraries

## 4. Zero-Tolerance

- Pipeline rechaza CUALQUIER warning/error
- `gofmt` obligatorio, `staticcheck`, `go vet`, `eslint`
- Fix inmediato → no dejar deuda para después

## 5. Reglas de Oro

| Regla | Descripción |
|-------|-------------|
| **Design-Before-Code** | Documentá antes de implementar |
| **Patterns-Before-Code** | Revisá `.atl/patterns/` primero |
| **Discovery-First** | Entendé el problema antes de SDD |
| **Verify→Tasks** | Si Verify falla → Tasks, no Design |

## 6. TDD Batch Mode

1. Escribí TODOS los tests que fallan (RED)
2. Implementá hasta que pasen (GREEN)
3. Refactorá

## 7. Decisiones

- **ADR obligatorio** para cambios estructurales → `docs/decisions/`
- **Bitacora inmediata** → cuando se decide algo, registrás INMEDIATAMENTE

## 8. Seguridad

- **Least Privilege:** Solo lo necesario
- **Input Validation:** Asumir que todo input es malicioso
- **Security-First Refactoring:** Refactor → Verificar → Aplicar seguridad

## 9. Modo Default

| Config | Valor |
|--------|-------|
| Persistence | `engram` |
| Flow | `auto` → `interactive` antes de Archive |
| Execution | `synchronous` |

---

*Este documento es la ley. Cuando dudes → releélo.*
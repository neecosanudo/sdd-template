# ADR-001: API First / Contract-Driven Development

**Estado**: Aprobado
**Fecha**: 2026-04-29
**Decisión**: API First — Especificación Swagger escrita ANTES de implementar

---

## 1. Contexto

El frontend y backend necesitan acordar un contrato de API antes de comenzar desarrollo. Históricamente, los equipos implementaban en paralelo sin coordinación, resultando en:
- Endpoints mal diseñados que requerían cambios costosos
- Frontend esperando datos que el backend no proveía
- Documentación inconsistente con la implementación

---

## 2. Decisión

**API First es mandatorio**. La especificación OpenAPI/Swagger se escribe y revisa ANTES de cualquier implementación de handlers.

```
Workflow obligatorio:
1. Diseñador/Architect escribe spec OpenAPI (YAML/JSON)
2. Frontend y backend revisan la spec juntos
3. Se itera hasta acordar el contrato
4. Backend implementa handlers que cumplen el contrato
5. Generación automática de documentación con swag
6. Verificación automática de compliance en CI
```

---

## 3. Alternativas Rechazadas

| Alternativa | Razón del Rechazo |
|-------------|-------------------|
| **Code-First** | Contrato emerge del código, difícil de revisar antes; frontend queda bloqueado |
| **Sin documentación** | Conocimiento tácito que se pierde; onboarding lento |
| **Docs manuales** | Se desactualizan rápidamente; no hay verificación automática |

---

## 4. Consecuencias

### ✅ Positivas
- Frontend puede empezar a desarrollar contra mocks basados en la spec
- Backend tiene contrato claro antes de implementar
- Documentación se mantiene sincronizada automáticamente
- Contrato versionado permite evolución controlada

### ⚠️ Negativas
- Requiere tiempo adicional en fase de diseño
- Spec inicial puede necesitar cambios (mitigado con revisión temprana)
- Herramientas adicionales (swag) en el toolchain

---

## 5. Implementación

Ver [swagger-openapi.md](../tools/swagger-openapi.md) para guía completa.

```bash
# Instalar swag
go install github.com/swaggo/swag/cmd/swag@latest

# Generar docs después de escribir handlers
swag init -g cmd/main.go -o docs/
```

---

## 6. Referencias

- [swagger-openapi.md](../tools/swagger-openapi.md) — Guía de herramientas
- [hexagonal-architecture.md](hexagonal-architecture.md) — Arquitectura de handlers

---

*API First es la única forma de desarrollar en paralelo sin bloqueos.*

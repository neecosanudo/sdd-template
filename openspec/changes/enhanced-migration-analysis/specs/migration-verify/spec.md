# migration-verify Specification

## Purpose

Define los requisitos del patrón de verificación para migración. Este patrón documenta los recursos que el agente DEBE usar durante los pasos 5 (Verify) y 6 (Archive) para confirmar que la migración no perdió funcionalidad.

## ADDED Requirements

### Requirement: Checklist de Funcionalidades Críticas (Recurso 8)

El agente DEBE ejecutar un checklist de funcionalidades antes de declarar la migración completa.

#### Scenario: Verificación pre-archive

- GIVEN la migración está en paso Verify
- WHEN el agente ejecuta la verificación
- THEN el agente DEBE crear un checklist markdown con columnas: Item | PASS | FAIL
- AND el checklist DEBE cubrir estas categorías: UI Elements, Interactions, States, Edge Cases, Responsive
- AND cada item DEBE ser verificable (observable, no subjetivo)

#### Scenario: Checklist falla parcialmente

- GIVEN uno o más items del checklist están marcados FAIL
- WHEN el agente evalúa el resultado
- THEN el agente DEBE identificar los gaps y volver al paso Apply
- AND NO DEBE declarar la migración completa hasta que TODOS los items sean PASS

#### Scenario: Checklist pasa 100%

- GIVEN todos los items del checklist están marcados PASS
- WHEN el agente evalúa el resultado
- THEN el agente DEBE proceder al paso Archive
- AND el checklist completado DEBE adjuntarse como evidencia de verificación

---

### Requirement: Análisis de Diffs (Recurso 9)

El agente DEBE comparar el comportamiento original vs migrado cuando ambos coexisten.

#### Scenario: Código original y migrado coexisten

- GIVEN el código original y el migrado están disponibles en el repositorio
- WHEN el agente ejecuta el paso Verify o Archive
- THEN el agente DEBE producir una tabla de comparación con columnas: Feature | Original | Migrated | Status
- AND Status DEBE ser uno de: MATCH, GAP, ENHANCED

#### Scenario: Código original ya fue eliminado

- GIVEN el código original fue removido (solo existe el migrado)
- WHEN el agente ejecuta el paso Verify
- THEN el Análisis de Diffs DEBE comparar contra el discovery document
- AND verificar que los features identificados como "most important" están presentes

#### Scenario: Análisis de diffs en paso Archive

- GIVEN la migración llega a paso Archive
- WHEN el agente prepara el cierre
- THEN el agente DEBE producir una versión final del Análisis de Diffs
- AND esta versión DEBE ser incluida en el commit de archive como documentación

---

### Requirement: Flujo de Verificación

El agente DEBE seguir un workflow estricto de verificación con reintentos.

#### Scenario: Workflow completo exitoso

- GIVEN la migración está en paso Verify
- WHEN el agente ejecuta el flujo de verificación
- THEN el agente DEBE seguir esta secuencia:
  1. Ejecutar Checklist de Funcionalidades Críticas (Recurso 8)
  2. Si hay FAIL → identificar gaps, volver a Apply
  3. Si 100% PASS → ejecutar Análisis de Diffs (Recurso 9)
  4. Si hay GAP en diffs → volver a Apply
  5. Si todos MATCH o ENHANCED → proceder a Archive
- AND el agente DEBE documentar cada iteración del ciclo

#### Scenario: Archive solo con verificación completa

- GIVEN el agente intenta ejecutar el paso Archive
- WHEN no se ha completado la verificación (checklist no 100% PASS)
- THEN el agente DEBE rechazar el archive
- AND DEBE retornar al paso Verify

---

### Requirement: Estructura del Archivo migration-verify.md

El patrón DEBE documentarse en `.atl/patterns/migration-verify.md` con recursos de verificación y workflow.

#### Scenario: El archivo contiene los recursos requeridos

- GIVEN se crea `.atl/patterns/migration-verify.md`
- THEN el archivo DEBE contener:
  - Recurso 8: Checklist de Funcionalidades Críticas con formato de tabla PASS/FAIL
  - Recurso 9: Análisis de Diffs con formato de comparación side-by-side
  - Sección: Verification Workflow con el flujo checklist → gaps → Apply → re-verify
  - Regla explícita: archive solo con 100% PASS
- AND cada recurso DEBE incluir Purpose, When to use, Format, Example
- AND los ejemplos DEBEN ser concisos y orientados al agente

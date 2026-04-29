# code-migration Specification

## Purpose

Define los requisitos del patrón de migración de código. Este spec documenta las modificaciones al archivo existente `.atl/patterns/code-migration.md`: corrección de terminología y adición de referencias cruzadas a los nuevos archivos de patrón.

## ADDED Requirements

### Requirement: Terminología Canónica en Pasos de Migración

El patrón DEBE usar "Explore" en lugar de "Analyse" en todos los nombres de paso, referencias y texto descriptivo.

#### Scenario: Nombres de paso actualizados

- GIVEN el archivo `code-migration.md` §2 usa "Analyse" como nombre del paso 1
- WHEN se aplica este cambio
- THEN todas las ocurrencias de "Analyse" como nombre de paso DEBEN ser reemplazadas por "Explore"
- AND la tabla de mapeo en §2 DEBE mostrar `1 | Explore | ...`
- AND el título §2.1 DEBE ser "Paso 1: Explore"
- AND los §2.2 a §2.6 DEBEN conservar sus nombres existentes (Design, Tasks, Apply, Verify, Archive)

#### Scenario: Referencias internas actualizadas

- GIVEN existen referencias a "Analyse" como fase/paso en el texto del archivo
- WHEN se aplica este cambio
- THEN todas las referencias textuales al paso "Analyse" DEBEN cambiarse a "Explore"
- AND la nota aclaratoria sobre "Analyse" vs "Analysis" DEBE eliminarse o actualizarse para explicar que se usa "Explore" (alineado con el glosario canónico)

---

### Requirement: Referencias Cruzadas en Paso 1 (Explore)

El paso 1 del proceso de migración DEBE referenciar los archivos de discovery y análisis.

#### Scenario: Referencias agregadas en §2.1

- GIVEN el paso 1 (Explore) describe el objetivo de separar lógica de negocio del plumbing
- WHEN se aplica este cambio
- THEN el paso 1 DEBE incluir referencias a:
  - `.atl/patterns/migration-discovery.md` para el protocolo de entrevista pre-migración
  - `.atl/patterns/migration-analysis.md` para los recursos 1 (Mapa Visual), 2 (Árbol de Componentes), 3 (Flujo de Estados), 4 (Árbol de Navegación), 6 (Inventario de Interacciones)
- AND las referencias DEBEN ser links markdown funcionales

---

### Requirement: Referencias Cruzadas en Paso 2 (Design)

El paso 2 del proceso de migración DEBE referenciar los recursos de análisis aplicables al diseño.

#### Scenario: Referencias agregadas en §2.2

- GIVEN el paso 2 (Design) describe el mapeo de conceptos origen a destino
- WHEN se aplica este cambio
- THEN el paso 2 DEBE incluir referencias a:
  - `.atl/patterns/migration-analysis.md` para los recursos 5 (Matriz de Funcionalidades) y 7 (Flujo de Datos)
- AND las referencias DEBEN ser links markdown funcionales

---

### Requirement: Referencias Cruzadas en Paso 5 (Verify)

El paso 5 del proceso de migración DEBE referenciar los recursos de verificación.

#### Scenario: Referencias agregadas en §2.5

- GIVEN el paso 5 (Verify) describe la validación de paridad de comportamiento
- WHEN se aplica este cambio
- THEN el paso 5 DEBE incluir referencias a:
  - `.atl/patterns/migration-verify.md` para los recursos 8 (Checklist de Funcionalidades) y 9 (Análisis de Diffs)
- AND DEBE incluir el workflow de verificación definido en migration-verify.md

---

### Requirement: Referencias Cruzadas en Paso 6 (Archive)

El paso 6 del proceso de migración DEBE referenciar el análisis de diffs final.

#### Scenario: Referencias agregadas en §2.6

- GIVEN el paso 6 (Archive) describe el cierre y commit del cambio
- WHEN se aplica este cambio
- THEN el paso 6 DEBE incluir referencia a:
  - `.atl/patterns/migration-verify.md` Recurso 9 (Análisis de Diffs) para la comparación final antes del commit
- AND DEBE requerir que el análisis de diffs final esté adjunto al commit de archive

---

### Requirement: Sección de Referencias Actualizada

La sección §7 (Referencias) DEBE incluir los nuevos archivos de patrón.

#### Scenario: Nuevos archivos en la lista de referencias

- GIVEN la sección §7 lista referencias a otros patrones
- WHEN se aplica este cambio
- THEN la sección DEBE incluir links a:
  - `migration-discovery.md` — Protocolo de discovery pre-migración
  - `migration-analysis.md` — Recursos de análisis para pasos 1-2
  - `migration-verify.md` — Recursos de verificación para pasos 5-6
- AND los links DEBEN ser funcionales (archivos existen en `.atl/patterns/`)

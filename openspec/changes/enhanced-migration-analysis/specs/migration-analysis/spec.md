# migration-analysis Specification

## Purpose

Define los requisitos del patrón de análisis para migración. Este patrón documenta 7 recursos técnicos que el agente DEBE usar durante los pasos 1 (Explore) y 2 (Design) del proceso de migración de 6 pasos.

## ADDED Requirements

### Requirement: Mapa Visual (Recurso 1)

El agente DEBE documentar la estructura visual de la UI usando ASCII art o emoji grid. Este recurso se usa SIEMPRE al migrar código con UI.

#### Scenario: App con interfaz visual

- GIVEN la app a migrar tiene interfaz visual (UI)
- WHEN el agente ejecuta el paso Explore
- THEN el agente DEBE producir un mapa visual ASCII con boxes, labels y jerarquía
- AND el mapa DEBE mostrar header, sidebar, main content areas y footer si existen

#### Scenario: App sin interfaz visual

- GIVEN la app a migrar NO tiene UI (CLI, API, librería)
- WHEN el agente ejecuta el paso Explore
- THEN el Mapa Visual es OPCIONAL y puede omitirse

---

### Requirement: Árbol de Componentes con Props (Recurso 2)

El agente DEBE documentar jerarquía de componentes y flujo de datos cuando el nesting supera 2 niveles.

#### Scenario: Component nesting profundo

- GIVEN la app tiene componentes anidados a más de 2 niveles
- WHEN el agente ejecuta el paso Explore
- THEN el agente DEBE producir un árbol markdown con props en brackets
- AND el formato DEBE ser: `ComponentName [prop1, prop2]`

#### Scenario: Component nesting plano

- GIVEN el nesting es ≤ 2 niveles
- WHEN el agente ejecuta el paso Explore
- THEN el Árbol de Componentes es OPCIONAL

---

### Requirement: Flujo de Estados (Recurso 3)

El agente DEBE mapear estados y transiciones cuando las entidades tienen múltiples estados.

#### Scenario: Entidad con estados múltiples

- GIVEN una entidad tiene ≥ 3 estados (ej: PLANNED, REAL, COMPLETED)
- WHEN el agente ejecuta el paso Explore
- THEN el agente DEBE producir un diagrama de estados ASCII o Mermaid
- AND el diagrama DEBE mostrar todos los estados y transiciones entre ellos

#### Scenario: Entidad con ≤ 2 estados

- GIVEN una entidad tiene ≤ 2 estados (ej: ON/OFF)
- WHEN el agente ejecuta el paso Explore
- THEN el Flujo de Estados es OPCIONAL

---

### Requirement: Árbol de Navegación / Rutas (Recurso 4)

El agente DEBE documentar la estructura de rutas cuando la app tiene múltiples páginas/screens.

#### Scenario: App multi-página

- GIVEN la app tiene múltiples páginas o pantallas
- WHEN el agente ejecuta el paso Explore
- THEN el agente DEBE producir un árbol markdown de rutas
- AND el formato DEBE ser: `/ruta → PageName` con sub-rutas indentadas

#### Scenario: App single-page

- GIVEN la app es una sola página sin rutas
- WHEN el agente ejecuta el paso Explore
- THEN el Árbol de Navegación es OPCIONAL

---

### Requirement: Matriz de Funcionalidades vs Componentes (Recurso 5)

El agente DEBE mapear features a ubicaciones de implementación para prevenir pérdida de funcionalidad.

#### Scenario: Migración de app con features

- GIVEN la app tiene features identificadas
- WHEN el agente ejecuta el paso Design
- THEN el agente DEBE producir una tabla markdown con columnas: Feature | Component | Logic | State
- AND cada feature DEBE estar mapeada a al menos un componente y su lógica asociada

---

### Requirement: Inventario de Interacciones (Recurso 6)

El agente DEBE catalogar todos los event handlers cuando la app tiene manejo de eventos complejo.

#### Scenario: App con event handling complejo

- GIVEN la app tiene event handlers (onClick, onChange, onSubmit, etc.)
- WHEN el agente ejecuta el paso Explore
- THEN el agente DEBE producir una tabla markdown con columnas: Event | Handler | Component | Action
- AND cada handler DEBE describir la acción resultante

#### Scenario: App sin event handling complejo

- GIVEN la app no tiene interacciones de usuario (ej: CLI batch)
- WHEN el agente ejecuta el paso Explore
- THEN el Inventario de Interacciones es OPCIONAL

---

### Requirement: Flujo de Datos (Recurso 7)

El agente DEBE documentar cómo se mueven los datos cuando la app usa stores, contextos o APIs.

#### Scenario: App con stores/APIs

- GIVEN la app usa state management (stores, contexts) o APIs externas
- WHEN el agente ejecuta el paso Design
- THEN el agente DEBE producir un diagrama de flujo de datos ASCII o Mermaid
- AND el diagrama DEBE mostrar: User Input → Form → Validation → API → Store → Component

#### Scenario: App sin data flow externo

- GIVEN la app no usa stores, contextos ni APIs
- WHEN el agente ejecuta el paso Design
- THEN el Flujo de Datos es OPCIONAL

---

### Requirement: Estructura del Archivo migration-analysis.md

El patrón DEBE documentarse en `.atl/patterns/migration-analysis.md` con 7 recursos.

#### Scenario: El archivo contiene los 7 recursos

- GIVEN se crea `.atl/patterns/migration-analysis.md`
- THEN el archivo DEBE contener los 7 recursos (1-7) organizados por paso SDD:
  - Paso 1 (Explore): Recursos 1, 2, 3, 4, 6
  - Paso 2 (Design): Recursos 5, 7
- AND cada recurso DEBE incluir: Purpose, When to use, Format, Example
- AND cada ejemplo DEBE ser conciso (≤ 5 líneas) y orientado al agente
- AND los ejemplos DEBEN usar ASCII/emoji (no imágenes externas)

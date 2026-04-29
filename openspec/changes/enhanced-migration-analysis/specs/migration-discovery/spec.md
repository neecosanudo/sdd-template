# migration-discovery Specification

## Purpose

Define los requisitos del patrón de discovery pre-migración. Este patrón establece el protocolo que el agente DEBE ejecutar antes de iniciar cualquier migración de código: detección de intención, entrevista al usuario y producción de documento de discovery.

## ADDED Requirements

### Requirement: Trigger de Discovery Pre-Migración

El agente DEBE detectar intención de migración y ejecutar discovery ANTES de cualquier paso de migración.

El discovery es pre-SDD — NO forma parte del paso Explore (Analyse). Si el usuario usa palabras como "migrate", "bring code", "port", "traer código", "migrar", el agente DEBE pausar y ejecutar la entrevista de discovery primero.

#### Scenario: Usuario pide migrar una app

- GIVEN el usuario dice "migrate esta app de React a SvelteKit"
- WHEN el agente detecta la keyword "migrate"
- THEN el agente DEBE ejecutar discovery (entrevista de 5 preguntas) antes de iniciar Explore
- AND el agente NO DEBE comenzar análisis de código sin discovery completado

#### Scenario: Usuario usa variantes de "migrate"

- GIVEN el usuario dice "bring this code over to Go" o "port the component"
- WHEN el agente detecta las keywords "bring code", "port"
- THEN el agente DEBE ejecutar discovery igual que con "migrate"
- AND la detección DEBE ser case-insensitive

#### Scenario: Discovery ya completado

- GIVEN el discovery ya fue ejecutado para esta migración
- WHEN el usuario vuelve a mencionar "migrate" en la misma sesión
- THEN el agente DEBE referenciar el documento de discovery existente
- AND NO DEBE repetir la entrevista

---

### Requirement: Entrevista Estructurada al Usuario

El agente DEBE conducir una entrevista de 5 preguntas antes de migrar. Las preguntas son obligatorias y DEBEN hacerse en orden.

#### Scenario: Entrevista completa en orden

- GIVEN el discovery ha sido disparado
- WHEN el agente inicia la entrevista
- THEN el agente DEBE hacer las 5 preguntas en este orden:
  1. What is the MOST important thing this app does?
  2. What features do you use every day?
  3. Is there anything you love that makes you say "this is great"?
  4. Are there small details or touches that seem minor but are important?
  5. What would make you reject the migrated version?
- AND el agente DEBE esperar respuesta del usuario después de cada pregunta

#### Scenario: Usuario no sabe responder una pregunta

- GIVEN el agente hace una pregunta de la entrevista
- WHEN el usuario responde "no sé" o "not sure"
- THEN el agente DEBE marcar esa pregunta como "sin respuesta"
- AND continuar con la siguiente pregunta
- AND NO DEBE insistir ni repetir la pregunta

---

### Requirement: Documento de Discovery

El agente DEBE producir un documento de discovery con las respuestas del usuario.

#### Scenario: Producción del discovery document

- GIVEN la entrevista de 5 preguntas fue completada
- WHEN el agente produce el output
- THEN el agente DEBE generar un documento con formato Q&A que contenga las 5 preguntas y sus respuestas
- AND el documento DEBE guardarse como referencia para los pasos de migración subsiguientes
- AND cada pregunta con respuesta "sin respuesta" DEBE marcarse claramente

#### Scenario: Referenciar discovery durante migración

- GIVEN el discovery document existe
- WHEN el agente ejecuta cualquier paso de migración (Explore, Design, Apply, Verify)
- THEN el agente DEBE consultar el discovery document
- AND priorizar los elementos identificados como "most important" y "dealbreaker" en las decisiones de migración

---

### Requirement: Estructura del Archivo migration-discovery.md

El patrón DEBE documentarse en `.atl/patterns/migration-discovery.md` con tres secciones.

#### Scenario: El archivo contiene las secciones requeridas

- GIVEN se crea `.atl/patterns/migration-discovery.md`
- THEN el archivo DEBE contener:
  - Sección 1: Trigger — keywords que disparan discovery y regla de pre-SDD
  - Sección 2: Entrevista Estructurada — las 5 preguntas en formato Q&A con instrucciones para el agente
  - Sección 3: Output — formato del discovery document y cómo referenciarlo
- AND cada sección DEBE ser autocontenida y referenciable independientemente

#### Scenario: Ejemplos concisos

- GIVEN la sección de Entrevista incluye ejemplos
- THEN cada ejemplo DEBE ser conciso (3-5 líneas máximo)
- AND los ejemplos DEBEN estar orientados al agente (no tutoriales para humanos)

# ADR 0001: Registro de Decisiones de Arquitectura

## Estado
Aceptado

## Contexto
Necesitamos un método sistemático para registrar las decisiones técnicas, su razonamiento y las implicaciones a futuro. Sin esto, el conocimiento se pierde y los agentes de IA (SDD) podrían intentar cambiar el rumbo del proyecto sin contexto.

## Decisión
Adoptamos el formato de **Architecture Decision Records (ADR)** para cualquier decisión significativa que afecte el stack, la arquitectura o el flujo de datos.

## Consecuencias
*   **Positivas:** Transparencia, trazabilidad histórica y consistencia en el desarrollo con agentes.
*   **Negativas:** Requiere un pequeño esfuerzo extra de documentación antes de la implementación.
*   **Neutrales:** Los archivos residirán en `/docs/adr/`.

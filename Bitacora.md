# Bitácora — Registro de Conversación

> **Propósito**: Capturar el diálogo continuo entre vos (el usuario) y el agente AI. Esta es la *historia informal* de su colaboración — decisiones tomadas, contexto compartido, motivaciones explicadas.
>
> **Por qué en la raíz?** `Bitácora.md` vive en la raíz del repositorio para visibilidad inmediata como registro de conversación. Esto es intencional — ver `docs/GOVERNANCE.md` para la justificación de gobernanza.
>
> **Diferencia de DECISION_LOG.md**: `DECISION_LOG.md` registra decisiones arquitectónicas formales con racional completo y consecuencias. `Bitácora.md` captura la *conversación* — el ida y vuelta que llevó a esas decisiones. Cuando una entrada de Bitácora se vuelve significativa, DEBERÍA promoverse a `DECISION_LOG.md`.

## Cómo usar este archivo

### ¿Quién escribe aquí?
- **Ambos usuario y agente**. El agente DEBERÍA registrar decisiones significativas después de llegar a un acuerdo. El usuario PUEDE agregar contexto, correcciones, o pensamientos adicionales.

### ¿Cuándo escribir?
- Después de cualquier discusión técnica significativa
- Cuando los requisitos cambian o se aclaran
- Cuando se revelan restricciones o suposiciones
- Cuando el usuario dice "recuerda esto" o "anota esto"

### Formato de entrada

```markdown
### YYYY-MM-DD — Título Breve

**Contexto:** ¿Cuál era la situación o pregunta?
**Decisión:** ¿Qué se acordó o decidió?
**Resultado:** ¿Por qué fue la elección correcta?
**Participantes:** @usuario, @agente (opcional)
```

## Entradas

### 2026-05-10 — template-v3-update: Template SDD actualizado a v3

**Contexto:** El template SDD estaba en versión 2.1.0 con estructura `.atl/`. El usuario solicitó una actualización mayor a v3 con nueva estructura en `docs/` y modo de persistencia engram-only.
**Decisión:** Se realizó una reescritura completa del template con los siguientes cambios:
- Nueva estructura de docs en `docs/` (AGENT.md, CONTEXT.md, DISCOVERY.md, GOVERNANCE.md, STANDARDS.md)
- Eliminación de la carpeta `.atl/` y archivos relacionados
- Actualización del README para reflejar la nueva estructura
- Conversión de Bitácora.md a español (AR)
- Creación de 5 documentos de patrones en `docs/patterns/`
- Makefile genérico (sin hardcodeo de Go)
**Resultado:** El template ahora es agnóstico del stack, compatible con cualquier tecnología, y documenta patrones comunes para Go, Docker, Git, Svelte y scope creep.
**Participantes:** @usuario, @agente

---

### 2026-04-27 — Descubrimiento del Proyecto e Inicialización del Template

**Contexto:** El sdd-template estaba posicionado solo como un framework SDD. El usuario quiere que también sirva como herramienta de descubrimiento de proyectos para el diálogo inicial con clientes.
**Decisión:** Fortalecer el template con: README comprehensivo (discovery + SDD), Bitácora.md para registro de conversación, STACK_MAP.md para insights cross-projects, y WORKING_STANDARD.md documentando el ciclo completo análisis→diseño→tareas→aplicación→verificación.
**Resultado:** Un proyecto no empieza con código — empieza con comprensión. El template debe guiar a los usuarios a través de esa comprensión ANTES de entrar al ciclo SDD. Esto hace el template útil desde el día cero.
**Participantes:** @usuario, @agente

---

*Agregar nuevas entradas arriba de esta línea. Mantener la entrada más reciente al tope.*
# Orchestrator Deviance Log — Desviaciones del Protocolo

> **Propósito**: Registrar cada vez que el orquestador (agente AI) se desvía del protocolo SDD documentado, la justificación que presentó en el momento, y cómo debería haber actuado correctamente.
>
> **Anexo a**: `docs/patterns/scope-creep.md`
>
> **Responsable de escribir**: El ORQUESTADOR, inmediatamente después de ser corregido por el usuario o de auto-detectar la desviación.

---

## Formato de Entrada

Cada entrada sigue esta estructura:

```
### YYYY-MM-DD — Título breve

**Fase del ciclo**: {Fase SDD actual}
**Tipo de desviación**: {Inline | Scope Creep | Salteo de protocolo | Contexto inflado | Otro}

**Lo que pasó**:
{Descripción concisa de la situación}

**Lo que dije/justifiqué**:
{Texto textual o paráfrasis de la justificación}

**Lo correcto**:
{Cómo debería haber actuado según el protocolo}

**Documentos violados**:
- `docs/AGENT.md` — secciones X, Y

**Corregido por**: {@usuario | auto-detección}
```

---

## Entradas

<!-- Las entradas se agregan aquí durante el desarrollo del proyecto -->
<!-- [TODO: Agregar entradas de desviaciones según ocurran] -->

---

### Cómo actualizar este archivo

- El orquestador DEBE escribir aquí cada vez que el usuario lo corrija por una desviación
- También DEBE escribir cuando se auto-detecte una desviación (aunque el usuario no la haya notado)
- No esperar al Archive — escribir INMEDIATAMENTE después de la corrección
- Ser honesto: incluir la justificación textual aunque sea vergonzosa
- El objetivo NO es castigar, es aprender: cada entrada es una lección para futuras sesiones

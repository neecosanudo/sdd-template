# Patrón: Descubrimiento Pre-Migración

**Pattern ID**: migration-discovery
**Versión**: 1.0
**dependencias**: [code-migration.md](code-migration.md) | [glossary.md](../glossary.md)

---

## 1. Trigger

### Detección de Intención de Migración

El agente DEBE detectar intención de migración cuando el usuario usa palabras como:

- "migrate" / "migrar"
- "bring code" / "traer código"
- "port" / "portar"
- "convert" / "convertir"
- "rewrite" / "reescribir"

### Protocolo de Descubrimiento

1. **Al detectar intención**: Detener inmediatamente cualquier acción de migración
2. **Ejecutar discovery**: Realizar entrevista estructurada (§2) ANTES de cualquier análisis
3. **Producir documento**: Documentar respuestas en formato Q&A (§3)
4. **Solo entonces**: Continuar con Explore según code-migration.md §2.1

> **Nota**: Discovery es pre-SDD. No es parte de Explore. El agente debe crear el documento de discovery antes de iniciar cualquier análisis de código.

---

## 2. Entrevista Estructurada

### Las 5 Preguntas Obligatorias

Realizar en orden. No omitir ninguna. Si el usuario no sabe responder, marcar "sin respuesta".

---

**P1: ¿Cuál es la cosa MÁS importante que hace esta aplicación?**

> Entender el propósito core. Ejemplo: "Gestiona inventario de una ferretería con 200 productos."

---

**P2: ¿Qué funcionalidades usas todos los días?**

> Identificar el día a día real. Ejemplo: "Solo el catálogo y los pedidos."

---

**P3: ¿Hay algo que ames y te haga decir "esto es genial"?**

> Descubrir features destacadas. Ejemplo: "La búsqueda por foto de producto."

---

**P4: ¿Hay detalles pequeños que parecen menores pero son importantes para vos?**

> Detectar edge cases críticos. Ejemplo: "El aviso de stock bajo a las 8pm es clave."

---

**P5: ¿Qué haría que rechaces la versión migrada?**

> Definir criterios de rechazo. Ejemplo: "Si los pedidos no se pueden hacer por teléfono."

---

### Reglas de la Entrevista

| Regla | Descripción |
|-------|-------------|
| Orden | Mantener el orden de las preguntas |
| Completitud | Las 5 son obligatorias |
| Tiempo | Max 15 min por pregunta si el usuario divaga |
| Sin inferencias | No asumir respuestas basadas en código |

---

## 3. Output

### Documento de Discovery

Formato de salida después de la entrevista:

```markdown
# Discovery: [Nombre del Proyecto]

## Fecha
YYYY-MM-DD

## Preguntas y Respuestas

### P1: ¿Cuál es la cosa MÁS importante...?
**Respuesta**: [Texto del usuario]

### P2: ¿Qué funcionalidades usas todos los días?
**Respuesta**: [Texto del usuario]

### P3: ¿Hay algo que ames...?
**Respuesta**: [Texto del usuario]

### P4: ¿Hay detalles pequeños...?
**Respuesta**: [Texto del usuario]

### P5: ¿Qué haría que rechaces...?
**Respuesta**: [Texto del usuario]

## Notas
[Cualquier contexto adicional relevante]

## Estado
- [ ] P1 respondida
- [ ] P2 respondida
- [ ] P3 respondida
- [ ] P4 respondida
- [ ] P5 respondida
```

### Marcador "sin respuesta"

Si una pregunta no fue respondida o el usuario dice "no sé":

```markdown
**Respuesta**: sin respuesta
```

> **Importante**: El marcador "sin respuesta" indica áreas de riesgo. El agente debe informar al usuario que estas preguntas sin respuesta afectan la calidad de la migración.

---

## Cross-References

- [code-migration.md](code-migration.md) — Proceso de 6 pasos SDD-alineados
- [migration-analysis.md](migration-analysis.md) — Recursos de análisis post-discovery
- [migration-verify.md](migration-verify.md) — Verificación de paridad funcional

---

*Discovery pre-migración: 5 preguntas obligatorias, documento Q&A, "sin respuesta" como marcador de riesgo.*

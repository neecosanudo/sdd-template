# Patrón: Verificación Post-Migración

**Pattern ID**: migration-verify
**Versión**: 1.0
**dependencias**: [code-migration.md](code-migration.md) | [glossary.md](../glossary.md)

---

## 1. Checklist de Funcionalidades Críticas

### Purpose

Verificar que TODAS las funcionalidades críticas de la versión original están presentes y funcionando en la versión migrada.

### When to Use

Ejecutar después de Apply, antes de cualquier diff. 100% PASS requerido para continuar.

### Format

Tabla de verificación con columnas: Item | PASS | FAIL

| Item | PASS | FAIL |
|------|------|------|
| UI Elements | [ ] | [ ] |
| Interactions | [ ] | [ ] |
| States | [ ] | [ ] |
| Edge Cases | [ ] | [ ] |
| Responsive | [ ] | [ ] |

### Categorías Detalladas

#### UI Elements
- [ ] Elementos visuales presentes (botones, formularios, cards)
- [ ] Estilos equivalentes (colores, tipografía, espaciado)
- [ ] Layout responsivo funciona

#### Interactions
- [ ] Click handlers funcionan
- [ ] Form submissions procesan correctamente
- [ ] Navegación entre páginas funciona

#### States
- [ ] Estados iniciales cargan correctamente
- [ ] Transiciones de estado funcionan
- [ ] Estados de error se muestran apropiadamente

#### Edge Cases
- [ ] Empty states manejados
- [ ] Datos faltantes no rompen la UI
- [ ] Casos límite manipulados correctamente

#### Responsive
- [ ] Mobile view funcional
- [ ] Tablet view funcional
- [ ] Desktop view funcional

### Regla de Aprobación

> **100% PASS requerido**. Si cualquier item tiene FAIL, volver a Apply y arreglar antes de continuar.

---

## 2. Análisis de Diffs

### Purpose

Comparar feature por feature entre código original y código migrado.

### When to Use

Después de que el checklist pasa 100%. Requiere documento de discovery.

### Format

Tabla: Feature | Original | Migrated | Status

| Feature | Original | Migrated | Status |
|---------|----------|----------|--------|
| Login form | Email + password validation | Email + password validation | MATCH |
| Cart | Add/remove items | Add/remove items | MATCH |
| Search | Basic text search | Fuzzy search | ENHANCED |
| Export | Not implemented | CSV export | GAP |

### Status Values

| Status | Meaning |
|--------|---------|
| **MATCH** | Comportamiento idéntico al original |
| **GAP** | Funcionalidad original eliminada o no migrada |
| **ENHANCED** | Funcionalidad mejorada respecto al original |

### Cuando Original es "Not Found"

Si el código original no tiene una funcionalidad pero el usuario la mencionó en discovery:

- Marcar como **GAP** en la columna Original
- Comparar contra lo documentado en discovery

---

## 3. Verification Workflow

### Flujo Completo

```
1. EJECUTAR CHECKLIST
   │
   ├─> FAIL → Volver a Apply → Arreglar → Volver a step 1
   │
   └─> 100% PASS → CONTINUAR
              │
              ▼
2. EJECUTAR DIFF ANALYSIS
   │
   ├─> GAP encontrado → Volver a Apply → Arreglar → Volver a step 1
   │
   └─> Todos MATCH/ENHANCED → CONTINUAR
                              │
                              ▼
3. ARCHIVE
```

### Reglas del Loop

- **Checklist FAIL**: Volver a Apply, arreglar item específico, re-ejecutar checklist
- **Diff GAP**: Volver a Apply, investigar causa, re-migrar feature
- **Diff ENHANCED**: Documentar mejora y continuar (no requiere volver a Apply)

### Criterio Final de Archivo

Para archivar, TODOS los siguientes deben ser ciertos:

1. Checklist = 100% PASS
2. Diff Analysis = todos MATCH o ENHANCED (cero GAP)
3. Ningún diff ENHANCED sin documentación en discovery

---

## Cross-References

- [code-migration.md](code-migration.md) — Proceso de 6 pasos SDD-alineados
- [migration-discovery.md](migration-discovery.md) — Documento de discovery original
- [migration-analysis.md](migration-analysis.md) — Recursos de análisis (Rec 1-7)

---

*Verificación post-migración: checklist 100% PASS, diff analysis sin GAP, loop Apply→Verify hasta Archive.*

# Cómo Agregar una Nueva Herramienta al Template

Guía paso a paso para humanos que quieren extender el template con herramientas no cubiertas.

---

## Resumen

| Paso | Acción | Archivo(s) |
|------|--------|------------|
| 1 | Verificar herramienta en STACK_MAP.md | docs/STACK_MAP.md |
| 2 | Copiar TEMPLATE.md como boilerplate | docs/tools/<nueva>.md |
| 3 | Completar todas las secciones | docs/tools/<nueva>.md |
| 4 | Crear patrón si es necesario | .atl/patterns/<tool-pattern>.md |
| 5 | Actualizar STACK_MAP.md | docs/STACK_MAP.md |
| 6 | Actualizar README.md si corresponde | README.md |

---

## Paso 1: Verificar en STACK_MAP.md

Antes de crear una guía nueva:

```bash
# Buscar si la herramienta ya está documentada
grep -r "herramienta" docs/STACK_MAP.md

# Verificar si existe guía
ls docs/tools/<nombre>.md
```

**Si la herramienta existe**: Revisar si necesita actualización de versión.

**Si NO existe**: Continuar con el proceso.

---

## Paso 2: Copiar TEMPLATE.md

```bash
cp docs/tools/TEMPLATE.md docs/tools/<nombre-de-herramienta>.md
```

**Ejemplo**:
```bash
cp docs/tools/TEMPLATE.md docs/tools/redis.md
```

---

## Paso 3: Completar las Secciones

Abrir el archivo copiado y completar:

### 3.1 Frontmatter (línea 1)
```
# <Herramienta> — Descripción Corta
```

### 3.2 Metadatos
```
**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Categoría**: backend | frontend | database | devops | auth | testing
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | `herramienta-relacionada.md` (crear)
```

### 3.3 Secciones Requeridas

| Sección | Contenido |
|---------|-----------|
| **## 1. What** | Qué es la herramienta, propósito |
| **## 2. Why** | Por qué usarla (ventajas sobre alternativas) |
| **## 3. When to Use** | Casos de uso, cuándo SÍ y cuándo NO |
| **## 4. Installation** | Comandos de instalación, configuración inicial |
| **## 5. Basic Usage** | Ejemplo mínimo funcional |
| **## 6. Patterns** | Patrones recomendados (o referencia a .atl/patterns/) |
| **## 7. Anti-Patterns** | Errores comunes a evitar |
| **## 8. References** | Links a documentación oficial, related guides |

---

## Paso 4: Crear Patrón si Corresponde

Si la herramienta requiere patrones específicos de arquitectura:

```bash
cp .atl/patterns/TEMPLATE.md .atl/patterns/<herramienta>-<concepto>.md
```

**Ejemplo**: `docker-multistage.md` para Docker.

**No crear patrón** si:
- La herramienta es simple (solo instalación + uso básico)
- Ya existe patrón que cubre el caso
- Es una alternativa dentro de categoría existente

---

## Paso 5: Actualizar STACK_MAP.md

Agregar la herramienta a `docs/STACK_MAP.md`:

### 5.1 Sección §1 (Stack Principal)

Si la herramienta es significativa (usada en producción):

```markdown
| **Nueva Categoría** | <Herramienta> | <versión> | <notas> |
```

### 5.2 Sección §7 (Referencias Cruzadas)

```markdown
| <Herramienta> | [docs/tools/<nombre>.md](../tools/<nombre>.md) | <dependencias> |
```

### 5.3 Matriz de Compatibilidad

Si afecta compatibilidad:

```markdown
| **Grupo** | ✅ | Notas |
```

---

## Paso 6: Actualizar README.md

Solo si la herramienta pertenece al stack principal:

```markdown
| **Categoría** | <Herramienta> | <versión> |
```

**No actualizar** si:
- Es herramienta de desarrollo secundario
- Solo aplica a ciertos proyectos (ej: Redis para caching)
- Prototipo rápido

---

## Checklist de Verificación

```bash
# 1. Guía existe y tiene todas las secciones
ls docs/tools/<nombre>.md

# 2. STACK_MAP.md actualizado
grep -A2 "<Herramienta>" docs/STACK_MAP.md

# 3. Referencias válidas
bash verify-template.sh

# 4. Código ejemplo funciona (si aplica)
# Ejecutar ejemplo mínimo de la guía
```

---

## Ejemplo Completo: Agregar Redis

```bash
# 1. Verificar
ls docs/tools/redis.md  # No existe

# 2. Copiar template
cp docs/tools/TEMPLATE.md docs/tools/redis.md

# 3. Editar redis.md
# - Frontmatter: "# Redis — Cache en Memoria"
# - Completar secciones 1-8
# - Versión de STACK_MAP.md

# 4. Crear patrón (si es nuevo tipo de caching)
# No necesario - cache es concepto conocido

# 5. Actualizar STACK_MAP.md
# - §1: | **Cache** | Redis | 7.0-alpine | Cache en memoria |
# - §7: | Redis | [docs/tools/redis.md](../tools/redis.md) | gorm.md |
# - Compatibilidad: agregar a matriz

# 6. README.md - NO actualizar
# Redis no es stack principal, es opcional

# 7. Verificar
bash verify-template.sh
```

---

## Reglas de Decisión

| Situación | Acción |
|-----------|--------|
| Herramienta ya existe pero con versión diferente | Actualizar STACK_MAP.md, no duplicar guía |
| Herramienta es reemplazo directo (Bun vs npm) | Actualizar guía existente, agregar nota "reemplaza X" |
| Herramienta es alternativa (MySQL vs PostgreSQL) | Mantener ambas, clara sección "Cuándo NO usar" |
| Herramienta es completamente nueva | Crear de TEMPLATE.md, agregar a STACK_MAP.md si es significativa |

---

## Obtener Ayuda

Si tenés dudas:
1. Revisar `docs/tools/TEMPLATE.md` para estructura
2. Ver `.atl/agent/TOOL_EXPANSION.md` para flujo de agente
3. Consultar `docs/STACK_MAP.md` para formato de versiones
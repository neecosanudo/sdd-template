# Design: SDD v2.1.0 Operation Rules

## Enfoque Técnico

Este cambio implementa un conjunto de reglas de operación que automatizan y estandarizan el flujo SDD. El objetivo es reducir fricción en ciclos de desarrollo mediante: punto de entrada fijo para agentes, ejecución automática con reintentos, validación estricta de tests, y cierre limpio con git.

## Decisiones de Arquitectura

### Decisión: ENTRY.md Structure

**Opción elegida**: Estructura de navegación por contexto de tarea

La estructura del archivo `.atl/ENTRY.md` se organiza en cuatro secciones principales:

| Sección | Propósito | Contenido |
|---------|-----------|-----------|
| **Start Here** | Punto de entrada obligatorio | Lectura obligatoria para cualquier agente nuevo |
| **SDD Cycle** | Fases y flujo de trabajo | Diagrama del ciclo completo con transiciones |
| **Rules** | Reglas de operación | Los 5 requisitos (ENTRY, VERIFY, TDD, ARCHIVE) |
| **Patterns** | Dónde buscar ejemplos | Referencias a patrones documentados |

**Alternativas consideradas**:

- Navegación alfabética — rechazada porque no tiene en cuenta el contexto de tarea
- Un solo documento largo — rechazado porque dificulta encontrar información específica

**Justificación**: Un punto de entrada fijo reduce la búsqueda arbitraria de archivos y asegura que todos los agentes operen con el mismo contexto inicial.

---

### Decisión: Default Execution Mode

**Opción elegida**: Modo Engram-only como predeterminado, con fallback a interactive antes de Archive

Cambios en `.atl/specs/sdd-workflow.md`:

| Sección | Cambio |
|---------|--------|
| Persistence Mode | `hybrid` → `engram` (default) |
| Flow Mode | `interactive` → `auto` (default) |
| Antes de Archive | Forzar transición a `interactive` para confirmación |

**Alternativas consideradas**:

- Mantener `hybrid` como default — rechazado porque introduce fricción innecesaria en proyectos donde Engram es suficiente
- Auto-completo sin intervención — rechazado porque Archive requiere confirmación humana

**Justificación**: Engram-only reduce la carga cognitiva de gestionar archivos en disco. El fallback a interactive antes de Archive asegura que ningún cambio se cometa sin validación humana.

---

### Decisión: Verify Loop

**Opción elegida**: Loop automático con contador de intentos (max 3)

```
Tasks → Apply → Verify
   ↑              ↓
   ←—— FAIL —————
        (retry)
   ↓
Max 3 intentos
   ↓
Si aún FAIL → Reportar y esperar intervención humana
```

**Alternativas consideradas**:

- Loop infinito — rechazado porque puede causing endless cycles en errores de diseño
- Solo un retry — rechazado porque muchos failures son transitorios (timing, race conditions)

**Justificación**: 3 intentos cubren la mayoría de casos de falla transitoria mientras previenen loops infinitos. El límite claro permite detectar problemas estructurales rápidamente.

---

### Decisión: TDD Assertion Check

**Opción elegida**: Análisis estático de archivos de test para detectar ausencia de assertions

Patrones de búsqueda por lenguaje:

| Lenguaje | Patrones a detectar | Patrón de rechazo |
|----------|---------------------|-------------------|
| Go | `assert.`, `require.`, `testing.Assert`, `testing.T.Error` | Ausencia total de estos patrones |
| TypeScript | `expect(`, `should(`, `assert(` | Ausencia total de estos patrones |
| Python | `assert`, `self.assert`, `pytest.raises` | Ausencia total de estos patrones |

**Proceso de validación**:

1. Leer archivo de test
2. Buscar patrones de assert usando regex
3. Si no se encuentra ningún patrón → FAIL con mensaje específico
4. Si se encuentra al menos uno → PASS

**Alternativas consideradas**:

- Ejecutar test y verificar que no falle en vacío — rechazado porque un test sin assertions siempre pasa
- Pedir cobertura de código al 100% — rechazado porque es demasiado estricto para el alcance de esta regla

**Justificación**: Esta regla previene el anti-patrón de "tests que siempre pasan" porque no verifican nada. Es una validación mínima que fuerza a escribir afirmaciones reales.

---

### Decisión: Archive Closing Protocol

**Opción elegida**: Protocolo de cierre en 4 pasos

```
1. git status → verificar estado actual
2. git add -A → agregar todos los cambios
3. git commit -m "feat(sdd): ..." → crear commit estructurado
4. git status → verificar que esté limpio
5. Generar informe final de cambios
```

**Formato de commit**:

```
feat(sdd): implement operation rules v2.1.0

- ENTRY-001: Add .atl/ENTRY.md fixed entry point
- ENTRY-002: Set Engram-only as default mode
- VERIFY-001: Implement automatic verify loop
- TDD-001: Add test assertion validation
- ARCHIVE-001: Add clean git closing protocol
```

**Alternativas consideradas**:

- Squash de todos los commits — rechazado porque destruye historial de trabajo
- Commits manuales por usuario — rechazado porque no hay garantía de estructura

**Justificación**: El protocolo automático asegura consistencia y elimina el paso manual de "recordar hacer commit". El formato convencional facilita navegación futura.

---

## Flujo de Datos

```
┌─────────────────────────────────────────────────────────────────┐
│                    SDD Cycle (v2.1.0)                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Explore → Propose → Spec → Design → Tasks                    │
│                                              │                 │
│                                              ▼                 │
│   Archive ← Interactive ← Verify Loop (auto retry x3)          │
│                                              │                 │
│                                              ▼                 │
│                                         Apply                   │
│                                              │                 │
│                                              ▼                 │
│   TDD Validation ──► (FAIL) ──► RETURN TO TASKS                  │
│        │                                                      │
│        └──────────► (PASS) ──► CONTINUE                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Cambios en Archivos

| Archivo | Acción | Descripción |
|---------|--------|-------------|
| `.atl/ENTRY.md` | **Crear** | Punto de entrada fijo con navegación por contexto |
| `.atl/specs/sdd-workflow.md` | **Modificar** | Actualizar default modes (engram + auto) y agregar verify loop section |
| `openspec/config.yaml` | **Modificar** | Agregar configuración de default mode y TDD strict |
| `README.md` | **Modificar** | Actualizar versión a v2.1.0 |

## Interfaces y Contratos

### Configuración de Modo (openspec/config.yaml)

```yaml
schema: spec-driven

strict_tdd: true

default_mode:
  persistence: engram
  flow: auto

verify:
  - If fail, retake from Tasks
  - Auto retry up to 3 times
  - If still fail, report and wait for human

archive:
  - Auto commit on close
  - Require interactive confirmation before commit

tdd:
  - Require assertion in all tests
  - Reject tests without assert patterns
```

### ENTRY.md Navigation Contract

El archivo `.atl/ENTRY.md` debe mantener las siguientes referencias:

```markdown
# SDD Template - Entry Point

## Start Here
[Links to: .atl/specs/sdd-workflow.md]

## SDD Cycle
[Links to: .atl/specs/sdd-workflow.md]

## Rules
- ENTRY-001: .atl/ENTRY.md (este archivo)
- ENTRY-002: Modo Engram-only por defecto
- VERIFY-001: Loop automático hasta 100%
- TDD-001: Validación de assertions
- ARCHIVE-001: Cierre con git limpio

## Patterns
[Links to: .atl/patterns/README.md]
```

## Estrategia de Testing

| Capa | Qué probar | Cómo |
|------|-----------|------|
| **Unit** | Funciones de validación de assertions | Mock de archivos de test, verificar detection |
| **Integration** | Verify loop con reintentos | Simular failures y verificar retry logic |
| **E2E** | Ciclo completo SDD con las nuevas reglas | Ejecutar un cambio real con las reglas |

**Nota**: La implementación de estas reglas no requiere cambios en la base de código existente. Son configuraciones y documentos nuevos.

## Migración / Rollout

No se requiere migración de datos. Los cambios son:

- Aditivos: nuevos archivos y configuración
- No destructivos: la configuración anterior sigue disponible si se necesita fallback

**Plan de rollout**:

1. Crear `.atl/ENTRY.md` — disponible inmediatamente
2. Actualizar `.atl/specs/sdd-workflow.md` — afecta nuevos ciclos SDD
3. Actualizar `openspec/config.yaml` — afecta nuevo comportamiento de verify/archival
4. Actualizar `README.md` — documentación visible

## Preguntas Abiertas

- [x] Todas las decisiones han sido tomadas por el usuario
- [x] No hay blockers técnicos identificados
- [ ] Ninguna — el diseño está listo para Tasks
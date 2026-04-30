# Patrón: Migración de Código

**Pattern ID**: code-migration
**Versión**: 1.0
**dependencias**: [go-hexagonal.md](go-hexagonal.md) | [svelte-component.md](svelte-component.md) | [gorm-repository.md](gorm-repository.md) | [docs/tools/react.md](../../docs/tools/react.md) | [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md)

---

## 1. Principio Fundamental

> **Origin-Agnostic, Destination-Specific**

La migración de código externo al stack opinionado sigue un principio estricto:

- **NO** documentamos "cómo migrar DESDE X" (orígenes son ilimitados)
- **SÍ** documentamos "cómo migrar HACIA Y" (destinos son finitos)

El stack tiene tres destinos:
1. **Go Hexagonal** — backend
2. **SvelteKit** — frontend
3. **Godot** — juegos

---

## 2. Proceso de 6 Pasos (Alineado con SDD)

Todo código externo debe pasar por estos 6 pasos. Cada paso mapea 1:1 con una fase del ciclo SDD:

| Paso | Nombre SDD | Qué hace |
|------|------------|----------|
| 1 | **Explore** | Separar lógica de negocio del plumbing |
| 2 | **Design** | Mapear conceptos origen → destino |
| 3 | **Tasks** | Desglosar migración en tareas concretas |
| 4 | **Apply** | Reescribir en destino + TDD |
| 5 | **Verify** | Validar paridad de comportamiento |
| 6 | **Archive** | Cerrar cambio y commitear |

> **Nota**: El ciclo SDD usa Explore, Design, Tasks, Apply, Verify, Archive (ver glossary §1). En migración, Explore refiere al análisis de código fuente, no a investigación con cliente.

### 2.1 Paso 1: Explore

**Fase SDD**: `Explore`

**Objetivo**: Identificar qué es lógica de negocio y qué es framework plumbing.

```
Lógica de negocio = reglas que resuelven el problema del dominio
Plumbing = código que conecta componentes o maneja framework
```

**Regla**: Si el código no hace ninguna validación o cálculo de dominio, es plumbing y debe descartarse o reescribirse.

> **Recursos de Explore**: Ver [migration-discovery.md](migration-discovery.md) para discovery pre-migración, y [migration-analysis.md](migration-analysis.md) recursos 1-5 (Mapa Visual, Árbol de Componentes, Flujo de Estados, Árbol de Navegación, Inventario de Interacciones).

### 2.2 Paso 2: Design

**Fase SDD**: `Design`

**Objetivo**: Diseñar cómo se verá el código en el destino.

Usar las tablas de mapeo en §3 según el destino (Go/SvelteKit/Godot). No implementar todavía — solo planificar.

**Output**: Notas de diseño con conceptos mapeados.

> **Recursos de Design**: Ver [migration-analysis.md](migration-analysis.md) recursos 6 y 7 (Matriz de Funcionalidades, Flujo de Datos).

### 2.3 Paso 3: Tasks

**Fase SDD**: `Tasks`

**Objetivo**: Desglosar la migración en tareas pequeñas y secuenciales.

Ejemplo de desglose:
- Task 1: Migrar modelos/structs
- Task 2: Migrar lógica de negocio
- Task 3: Migrar tests
- Task 4: Adaptar entry points (handlers, componentes)

**Regla**: Cada task debe caber en una sola sesión.

### 2.4 Paso 4: Apply

**Fase SDD**: `Apply`

**Objetivo**: Implementar el código migrado.

**Dentro de Apply, se ejecuta TDD obligatorio**:

1. **RED**: Escribir test que falla (antes de implementar)
2. **GREEN**: Implementación mínima para pasar el test
3. **REFACTOR**: Mejorar sin romper tests

Seguir [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md) §6 (Strict TDD).

También seguir las convenciones del destino:
- [go-hexagonal.md](go-hexagonal.md) — Arquitectura hexagonal
- [svelte-component.md](svelte-component.md) — Componentes Svelte
- [gorm-repository.md](gorm-repository.md) — Persistencia GORM

### 2.5 Paso 5: Verify

**Fase SDD**: `Verify`

**Objetivo**: Confirmar que el código migrado se comporta igual que el original.

Verificar:
- Tests pasan
- Comportamiento observado = comportamiento esperado
- No hay regressions en el resto del sistema

**Si Verify falla**: Volver al paso apropiado (2, 3, o 4), arreglar, y re-verificar. Ver [WORKING_STANDARD.md](../standards/WORKING_STANDARD.md) §5 (Iteration Rule).

> **Recursos de Verify**: Ver [migration-verify.md](migration-verify.md) §1 (Checklist), §2 (Análisis de Diffs), §3 (Verification Workflow).

### 2.6 Paso 6: Archive

**Fase SDD**: `Archive`

**Objetivo**: Cerrar el cambio y persistir el estado final.

- Commitear con Conventional Commits + Gitmoji
- Documentar en `Bitacora.md` qué se migró y por qué
- Si es decisión arquitectónica, crear ADR en `docs/decisions/`

> **Recursos de Archive**: Ver [migration-verify.md](migration-verify.md) §2 (Análisis de Diffs) para comparación final.

---

## 3. Tablas de Mapeo por Destino

### 3.1 → Go Hexagonal

| Concepto de Origen → | Idiom Go | Referencia |
|---------------------|----------|------------|
| Class | `struct` + methods | [go-hexagonal.md](go-hexagonal.md) §2 |
| ActiveRecord | Port + Adapter (Repository) | [go-hexagonal.md](go-hexagonal.md) §3, [gorm-repository.md](gorm-repository.md) |
| Controller | HTTP Handler | [go-hexagonal.md](go-hexagonal.md) §4 |
| Service Layer | UseCase (application layer) | [go-hexagonal.md](go-hexagonal.md) §3 |
| ORM calls | Repository interface + GORM adapter | [gorm-repository.md](gorm-repository.md) |
| Dependency injection | Constructor injection | [go-hexagonal.md](go-hexagonal.md) §6 |

### 3.2 → SvelteKit

| Concepto de Origen → | Idiom SvelteKit | Referencia |
|---------------------|-----------------|------------|
| React Component | `.svelte` file | [svelte-component.md](svelte-component.md) §1 |
| `useState` | `let` (reactive) o `$state()` | [svelte-component.md](svelte-component.md) §3 |
| `useEffect` | `onMount()` / `$:` statement | [svelte-component.md](svelte-component.md) §3 |
| Props | `export let prop: type` | [svelte-component.md](svelte-component.md) §2 |
| Context API | Svelte context (`getContext`) | [svelte-component.md](svelte-component.md) §5 |
| Event handler | `on:event` | [svelte-component.md](svelte-component.md) §1 |

### 3.3 → Godot

| Concepto de Origen → | Idiom Godot | Referencia |
|---------------------|-------------|------------|
| React Component | Node (scena `.tscn`) | Godot docs |
| `useState` | `@export var` + `_ready()` | Godot docs |
| `useEffect` | `_ready()` / `_process()` | Godot docs |
| Props | `@export` annotations | Godot docs |
| State management | `StateMachine` pattern | Godot docs |

---

## 4. Prototipo vs Producción

### ⚠️ Regla Crítica: Prototipos React son DESECHABLES

Los prototipos React son **SOLO REFERENCIA**, no código fuente. Ver [docs/tools/react.md](../../docs/tools/react.md) §1:

| Tipo | Acción |
|------|--------|
| **Prototipo React** | Extraer lógica de negocio, descartar UI |
| **UI del prototipo** | REDISEÑAR en SvelteKit, no migrar |
| **Lógica de negocio** | Migrar siguiendo proceso de 6 pasos (§2) |

### Cuándo Reescribir vs Adaptar

- **Reescribir**: Lógica de negocio compleja, validaciones, cálculos
- **Adaptar**: Helpers simples (date formatting, string utils)
- **Descartar**: Componentes UI, CSS layouts, framework-specific code

---

## 5. Estrategia de Testing para Código Migrado

### TDD Obligatorio

Para toda lógica de negocio migrada:

1. **Escribir tests FIRST** — antes de cualquier implementación
2. **Validar comportamiento** (input → output), no estructura interna
3. **Tests de integración** en fronteras entre código migrado y nuevo

### Cobertura Mínima

| Capa | Target | Notas |
|------|--------|-------|
| Domain (lógica migrada) | 100% | No excuses |
| Application | >= 80% | Si hay use cases |
| Adapters | >= 70% | Repository, handlers |

### Ejemplo: Test para Lógica Migrada

```go
// BEFORE implementing migration:
// Escribir test que describe el comportamiento esperado

func TestCalculateDiscount(t *testing.T) {
    tests := []struct {
        name       string
        price      float64
        discountPct float64
        want       float64
    }{
        {"10% off 100", 100.0, 10.0, 90.0},
        {"20% off 50", 50.0, 20.0, 40.0},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := CalculateDiscount(tt.price, tt.discountPct)
            if got != tt.want {
                t.Errorf("CalculateDiscount() = %v, want %v", got, tt.want)
            }
        })
    }
}
```

---

## 6. Anti-Patrones

### ❌ PROHIBIDO: Copy-Paste + Syntax Fix

Copiar código y solo arreglar sintaxis NO es migración. Es reescribir mal.

**Por qué**: Preserva-framework thinking, no adopta idioms del nuevo stack.

### ❌ PROHIBIDO: Preservar Framework Patterns

Mantener patrones específicos del framework original en el destino.

**Por qué**: Cada stack tiene sus convenciones. El código debe sentirse nativo.

### ❌ PROHIBIDO: Migrar UI sin Rediseño

Trasladar layouts, CSS, o componentes UI sin adaptarlos al nuevo framework.

**Por qué**: UI prototypes son descartables. Ver §4.

### ❌ PROHIBIDO: Saltarse Tests

"No necesito tests porque el código ya funcionaba" es excusa inválida.

**Por qué**: El código migrado puede tener bugs de interpretación. Tests son mandatorios.

---

## 7. Referencias

- [go-hexagonal.md](go-hexagonal.md) — Arquitectura hexagonal para Go
- [gorm-repository.md](gorm-repository.md) — Patrón Repository con GORM
- [svelte-component.md](svelte-component.md) — Componentes SvelteKit
- [docs/tools/react.md](../../docs/tools/react.md) — Regla de prototipos descartables
- [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md) — Estrategia de testing y TDD
- [WORKING_STANDARD.md](../standards/WORKING_STANDARD.md) — Ciclo de desarrollo estándar
- [migration-discovery.md](migration-discovery.md) — Descubrimiento pre-migración
- [migration-analysis.md](migration-analysis.md) — Recursos de análisis (7 recursos)
- [migration-verify.md](migration-verify.md) — Verificación post-migración

---

*Patrón de migración: origen-agnóstico, destino-específico. 6 pasos SDD-alineados, TDD mandatorio, prototipos descartables.*
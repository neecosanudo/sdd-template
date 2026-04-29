# Patrón: Migración de Código

**Pattern ID**: code-migration
**Versión**: 1.0
**dependencias**: [go-hexagonal.md](go-hexagonal.md) | [svelte-component.md](svelte-component.md) | [gorm-repository.md](gorm-repository.md) | [react.md](../../docs/tools/react.md) | [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md)

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

## 2. Proceso de 5 Pasos

Todo código externo debe pasar por estos 5 pasos antes de integrarse:

| Paso | Nombre | Descripción |
|------|--------|-------------|
| 1 | **Analyze** | Separar lógica de negocio del plumbing (framework code) |
| 2 | **Map** | Mapear conceptos de origen → idioms del destino usando tablas |
| 3 | **Rewrite** | Reescribir en destino usando patrones de `.atl/patterns/` |
| 4 | **Test First** | Escribir tests ANTES de implementar (TDD obligatorio) |
| 5 | **Verify** | Verificar paridad de comportamiento con el original |

### 2.1 Paso 1: Analyze

**Objetivo**: Identificar qué es lógica de negocio y qué es framework plumbing.

```
Lógica de negocio = reglas que resuelven el problema del dominio
Plumbing = código que conecta componentes o maneja framework
```

**Regla**: Si el código no hace ninguna validación o cálculo de dominio, es plumbing y debe descartarse o reescribirse.

### 2.2 Paso 2: Map

**Objetivo**: Usar las tablas de mapeo por destino para encontrar equivalentes.

Consultar las tablas en §3 según el destino (Go/SvelteKit/Godot).

### 2.3 Paso 3: Rewrite

**Objetivo**: Implementar en el destino usando los patrones del proyecto.

Seguir las convenciones documentadas en:
- [go-hexagonal.md](go-hexagonal.md) — Arquitectura hexagonal
- [svelte-component.md](svelte-component.md) — Componentes Svelte
- [gorm-repository.md](gorm-repository.md) — Persistencia GORM

### 2.4 Paso 4: Test First

**Objetivo**: Escribir tests que validen comportamiento ANTES de escribir implementación.

Seguir [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md) §6 (Strict TDD):
- RED: Escribir test que falla
- GREEN: Implementación mínima para pasar
- REFACTOR: Mejorar sin romper tests

### 2.5 Paso 5: Verify

**Objetivo**: Confirmar que el código migrado se comporta igual que el original.

Verificar:
- Tests pasan
- Comportamiento observado = comportamiento esperado
- No hay regressions en el resto del sistema

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

Los prototipos React son **SOLO REFERENCIA**, no código fuente. Ver [react.md](../../docs/tools/react.md) §1:

| Tipo | Acción |
|------|--------|
| **Prototipo React** | Extraer lógica de negocio, descartar UI |
| **UI del prototipo** | REDISEÑAR en SvelteKit, no migrar |
| **Lógica de negocio** | Migrar siguiendo proceso de 5 pasos |

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
- [react.md](../../docs/tools/react.md) — Regla de prototipos descartables
- [TESTING_STRATEGY.md](../standards/TESTING_STRATEGY.md) — Estrategia de testing y TDD
- [WORKING_STANDARD.md](../standards/WORKING_STANDARD.md) — Ciclo de desarrollo estándar

---

*Patrón de migración: origen-agnóstico, destino-específico. 5 pasos, TDD mandatorio, prototipos descartables.*
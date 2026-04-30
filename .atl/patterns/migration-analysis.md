# Patrón: Análisis de Migración

**Pattern ID**: migration-analysis
**Versión**: 1.0
**dependencias**: [code-migration.md](code-migration.md) | [glossary.md](../glossary.md)

---

## Overview

Este documento agrupa los 7 recursos de análisis utilizados durante la migración.
Se organizan por paso SDD: Step 1 (Explore) y Step 2 (Design).

---

## Step 1: Explore

Los siguientes recursos se ejecutan durante la fase Explore de la migración.

---

### Recurso 1: Mapa Visual

**Purpose**: Representar visualmente la estructura de UI del código origen.

**When to Use**: Obligatorio cuando se migra código con UI visible (páginas, componentes visuales).

**Format**: ASCII art con cajas, labels y jerarquía.

```
+------------------+
|   Header         |
+--------+---------+
| Side   | Content |
| Menu   |         |
+--------+---------+
|   Footer        |
+------------------+
```

**Example**:
```
+------------------+
|   App Header     |
+--------+---------+
| Nav    | Dashboard|
|        | + Widget |
+--------+---------+
| Status Bar       |
+------------------+
```

---

### Recurso 2: Árbol de Componentes

**Purpose**: Mostrar la composición jerárquica de componentes.

**When to Use**: Obligatorio cuando la UI tiene más de 2 niveles de anidación.

**Format**: Árbol markdown con props en brackets.

**Example**:
```
App
├── Layout
│   ├── Header [title, user]
│   └── Sidebar [items]
│       └── MenuItem [label, icon]
└── Content
    ├── Dashboard [user]
    └── Widget [data]
```

---

### Recurso 3: Flujo de Estados

**Purpose**: Mapear los estados discretos de una entidad.

**When to Use**: Obligatorio cuando una entidad tiene 3 o más estados.

**Format**: Diagrama ASCII o Mermaid.

**Example**:
```
┌──────────┐
│  draft   │
└────┬─────┘
     │ submit
     ▼
┌──────────┐
│ pending  │◄──── retry
└────┬─────┘
     │ approve
     ▼
┌──────────┐
│ approved │
└──────────┘
```

---

### Recurso 4: Árbol de Navegación

**Purpose**: Documentar la estructura de rutas/páginas.

**When to Use**: Obligatorio cuando la app tiene múltiples páginas o rutas.

**Format**: Árbol markdown de rutas.

**Example**:
```
/
├── /login
├── /dashboard
│   ├── /dashboard/stats
│   └── /dashboard/settings
└── /products
    ├── /products/:id
    └── /products/new
```

---

### Recurso 5: Inventario de Interacciones

**Purpose**: Catalogar eventos, handlers y acciones del sistema.

**When to Use**: Para entender el comportamiento dinámico más allá de la UI estática.

**Format**: Tabla Event | Handler | Component | Action.

**Example**:
| Event | Handler | Component | Action |
|-------|---------|-----------|--------|
| click | onAdd | CartButton | addItem |
| submit | onCheckout | OrderForm | validateOrder |
| select | onFilter | ProductList | filterByCategory |

---

## Step 2: Design

Los siguientes recursos se ejecutan durante la fase Design de la migración.

---

### Recurso 6: Matriz de Funcionalidades

**Purpose**: mapear Features → Components → Logic → State para planificar migración.

**When to Use**: Durante diseño, para identificar qué lógica pertenece a qué capa.

**Format**: Tabla Feature | Component | Logic | State.

**Example**:
| Feature | Component | Logic | State |
|---------|-----------|-------|-------|
| Login | LoginForm | validateEmail, hashPassword | user session |
| Catalog | ProductList | filter, sort | product array |
| Cart | CartWidget | addItem, removeItem | cart items |

---

### Recurso 7: Flujo de Datos

**Purpose**: Visualizar el ciclo completo desde input de usuario hasta persistencia.

**When to Use**: Para entender cómo los datos fluyen a través del sistema.

**Format**: ASCII con flechas o Mermaid.

```
User Input → Form Validation → API Call → Store → Component Update
```

**Example**:
```
User clicks "Buy"
  → validateCart()
  → POST /orders
  → order saved to DB
  → UI shows confirmation
```

---

## Cross-References

- [code-migration.md](code-migration.md) — Proceso de 6 pasos SDD-alineados
- [migration-discovery.md](migration-discovery.md) — Descubrimiento pre-migración
- [migration-verify.md](migration-verify.md) — Verificación post-migración

---

*Análisis de migración: 7 recursos organizados por paso SDD (Explore + Design).*

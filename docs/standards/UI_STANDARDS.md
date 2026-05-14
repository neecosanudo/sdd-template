# UI Standards — Layout y Patrones

> **DOCUMENTACIÓN ACTIVA**
>
> Este archivo define los patrones de layout y CSS usados en el proyecto.
>
> **MODO**: Template — completar con los estándares específicos del proyecto.

---

## 1. Layout System

<!-- [TODO: Describir el layout system del proyecto] -->

Ejemplos:
- Sidebar + Content Area (flex)
- Content area: `flex-1 min-w-0` para ocupar el resto
- Wrapper principal: `overflow-y-auto min-h-0`

### Regla del min-h-0

> **CRÍTICO**: En un flex container, si un child tiene `overflow-y-auto`, el parent debe tener `min-h-0` para que el scroll funcione correctamente.

---

## 2. Responsive Breakpoints

<!-- [TODO: Definir los breakpoints del proyecto] -->

| Breakpoint | Ancho | Uso |
|------------|-------|-----|
| `sm:` | 640px+ | [TODO: uso] |
| `md:` | 768px+ | [TODO: uso] |
| `lg:` | 1024px+ | [TODO: uso] |

> **ERROR COMÚN**: `xs` no es un breakpoint válido en Tailwind v3. Usar siempre `sm:` para móvil.

---

## 3. Padding Pattern

**El padding va en los componentes, no en los wrappers.**

- Content areas usan padding internamente
- Los wrappers exteriores NO deben tener padding duplicado
- Si un componente ya tiene padding, el wrapper que lo contiene no debe agregar más

---

## 4. Color System

<!-- [TODO: Definir el sistema de colores del proyecto] -->

```css
:root {
  --color-bg: #ffffff;
  --color-surface: #f9fafb;
  --color-border: #d1d5db;
  --color-text: #111827;
  --color-primary: #6366f1;
}
```

---

## 5. Typography

<!-- [TODO: Definir la escala tipográfica del proyecto] -->

| Clase | Uso |
|-------|-----|
| `text-xs` | [TODO: uso] |
| `text-sm` | [TODO: uso] |
| `text-base` | [TODO: uso] |
| `text-lg` | [TODO: uso] |
| `text-xl` | [TODO: uso] |

---

## 6. Component Patterns

<!-- [TODO: Documentar los patrones de componentes del proyecto] -->

### Cards y Superficies
```html
<div class="bg-white rounded-2xl border p-4">
  <!-- contenido -->
</div>
```

### Botones
```html
<button class="px-3 py-1.5 rounded-lg text-sm font-medium transition-colors">
  Acción
</button>
```

---

> **Cómo actualizar este archivo**: Cuando establezcas un nuevo patrón de UI o descubras una regla que debería estar documentada, agregala aquí.

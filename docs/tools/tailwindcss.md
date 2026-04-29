# TailwindCSS — Utility-First CSS

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [sveltekit.md](sveltekit.md) | [react.md](react.md) | [STYLE_GUIDE.md](../../.atl/standards/STYLE_GUIDE.md)

---

## 1. Filosofía Utility-First

> **Core principle**: Utility classes over custom CSS. Build designs directly in markup.

### ❌ BAD: CSS Custom

```css
/* styles.css */
.my-card {
    background: white;
    padding: 1rem;
    border-radius: 0.5rem;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.my-button {
    background: #3b82f6;
    color: white;
    padding: 0.5rem 1rem;
    border-radius: 0.25rem;
}
```

### ✅ GOOD: TailwindCSS

```svelte
<div class="bg-white p-4 rounded-lg shadow-md">
    <button class="bg-blue-500 text-white px-4 py-2 rounded">
        Click me
    </button>
</div>
```

---

## 2. Tabla Comparativa: TailwindCSS 3.4 (SvelteKit) vs 4.1 (React)

| Aspecto | SvelteKit (3.4.1) | React (4.1.14) |
|---------|-------------------|----------------|
| **Config File** | `tailwind.config.js` | ❌ No necesita |
| **Plugin** | PostCSS | `@tailwindcss/vite` |
| **npm package** | `tailwindcss@3.4.1` | `tailwindcss@4.1.14` |
| **PostCSS** | ✅ Requiere | ❌ No requiere |
| **CSS imports** | `@tailwind base;` en app.css | `@import "tailwindcss";` |
| **Dark mode** | `dark:` prefix | `dark:` prefix |
| **Custom config** | `tailwind.config.js` | CSS `@theme {}` block |

### SvelteKit: Configuración Completa

```javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
    content: ['./src/**/*.{html,js,svelte,ts}'],
    darkMode: 'class',
    theme: {
        extend: {
            colors: {
                primary: '#3b82f6',
                secondary: '#8b5cf6'
            },
            spacing: {
                '128': '32rem'
            }
        }
    },
    plugins: [
        require('@tailwindcss/forms')
    ]
};
```

```css
/* src/app.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
    body {
        @apply bg-gray-50 text-gray-900;
    }
}
```

### React: Configuración con Vite Plugin

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
    plugins: [
        react(),
        tailwindcss()
    ]
});
```

```css
/* src/index.css */
@import "tailwindcss";

@theme {
    --color-primary: #3b82f6;
    --color-secondary: #8b5cf6;
}
```

---

## 3. Restricción de @apply

> ⚠️ **@apply solo en componentes reutilizables**. NO usar como "escape hatch" para evitar aprender utility classes.

### ✅ Correcto: @apply en Componentes

```svelte
<!-- src/lib/components/Button.svelte -->
<script>
    export let variant = 'primary';
</script>

<button class="btn btn-{variant}">
    <slot />
</button>

<style>
    .btn {
        @apply px-4 py-2 rounded font-medium transition-colors;
    }
    .btn-primary {
        @apply bg-blue-500 text-white hover:bg-blue-600;
    }
    .btn-secondary {
        @apply bg-gray-200 text-gray-900 hover:bg-gray-300;
    }
</style>
```

### ❌ Incorrecto: @apply como Escape Hatch

```svelte
<!-- ❌ NO HACER ESTO -->
<script>
    let customStyles = "font-bold text-xl";
</script>

<div class={customStyles}>
    <!-- Abusando @apply -->
</div>
```

---

## 4. Responsive Design

```svelte
<div class="
    grid
    grid-cols-1
    sm:grid-cols-2
    md:grid-cols-3
    lg:grid-cols-4
    gap-4
">
    <!-- Cards que se adaptan -->
    {#each items as item}
        <div class="bg-white p-4 rounded-lg shadow hover:shadow-lg transition-shadow">
            {item.name}
        </div>
    {/each}
</div>
```

---

## 5. Dark Mode

```svelte
<!-- Toggle manual -->
<script>
    let dark = false;
</script>

<button
    on:click={() => dark = !dark}
    class="dark:text-yellow-400"
>
    {dark ? '🌙' : '☀️'}
</button>

<body class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
    <!-- Contenido -->
</body>
```

---

## 6. Design Tokens (Customizables)

```javascript
// tailwind.config.js - SvelteKit
module.exports = {
    theme: {
        extend: {
            colors: {
                brand: {
                    50: '#f0f9ff',
                    500: '#0ea5e9',
                    900: '#0c4a6e'
                }
            },
            fontFamily: {
                sans: ['Inter', 'system-ui', 'sans-serif']
            }
        }
    }
}
```

```css
/* React - Tailwind 4.x CSS @theme */
@theme {
    --color-brand-50: #f0f9ff;
    --color-brand-500: #0ea5e9;
    --color-brand-900: #0c4a6e;
    --font-family-sans: 'Inter', system-ui, sans-serif;
}
```

---

## 7. Buenas Prácticas

| Regla | Razón |
|-------|-------|
| **Utility-first** | Evitar CSS custom, mantener consistencia |
| **@apply mínimo** | Usar solo en componentes reutilizables |
| **Responsive prefixes** | sm:, md:, lg:, xl: para breakpoints |
| **Dark mode class** | Preferir `dark:` class sobre media query |
| **Custom config** | Definir tokens de diseño, no valores hardcodeados |

---

## 8. Referencias

- [sveltekit.md](sveltekit.md) — Integración SvelteKit
- [react.md](react.md) — Integración React
- [STYLE_GUIDE.md](../../.atl/standards/STYLE_GUIDE.md) — Estándares de código

---

*Utility-first CSS es mandatorio. Evitar CSS custom tanto como sea posible.*

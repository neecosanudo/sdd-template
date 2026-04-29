# SvelteKit — Framework Frontend Principal

**Versión**: SvelteKit 2.0.0
**Dependencias**: Svelte 4.2.0, TypeScript 5.3.3, Vite 5.0.3, TailwindCSS 3.4.1
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [tailwindcss.md](tailwindcss.md) | [svelte-component.md](../../.atl/patterns/svelte-component.md) | [testing.md](testing.md)

---

## 1. Visión General

> ⚠️ **IMPORTANTE**: SvelteKit es el framework frontend PRINCIPAL. React (docs/react.md) es SOLO para prototipos rápidos.

SvelteKit 2.0 proporciona:
- Routing basado en archivos (`src/routes/`)
- Server-side rendering (SSR) y Static Site Generation (SSG)
- Form actions con `use:enhance`
- TypeScript nativo

---

## 2. Estructura de Proyecto

```
src/
├── routes/
│   ├── +page.svelte              # Página principal
│   ├── +page.server.ts           # Load function + server data
│   ├── +layout.svelte            # Layout compartido
│   ├── +layout.server.ts         # Layout data
│   └── api/
│       └── users/
│           └── +server.ts        # API endpoint REST
├── lib/
│   ├── components/               # Componentes reutilizables
│   │   ├── Button.svelte
│   │   └── UserCard.svelte
│   ├── server/                   # Código solo server
│   │   └── db.ts                # Conexión GORM
│   └── types/                    # Tipos TypeScript
│       └── user.ts
└── app.html                      # Template HTML
```

### Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                      routes/                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │
│  │ +page.svelte│  │+layout.svelte│  │ +server.ts API │  │
│  └──────┬──────┘  └──────┬──────┘  └────────┬────────┘  │
│         │                │                  │           │
│  ┌──────▼──────┐  ┌──────▼──────┐           │           │
│  │+page.server │  │+layout.sv   │           │           │
│  │    .ts      │  │   .ts       │           │           │
│  └──────┬──────┘  └─────────────┘           │           │
└─────────┼───────────────────────────────────┼───────────┘
          │                                   │
          ▼                                   ▼
┌─────────────────────┐           ┌─────────────────────┐
│     load()          │           │   API Handlers      │
│  (server/client)    │           │   (+server.ts)      │
└─────────────────────┘           └─────────────────────┘
          │                                   │
          ▼                                   ▼
┌─────────────────────────────────────────────────────┐
│                      $lib/                           │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────┐  │
│  │ components/ │  │   server/    │  │   types/    │  │
│  └──────────────┘  └──────────────┘  └────────────┘  │
└─────────────────────────────────────────────────────┘
```

---

## 3. Routing y Load Functions

### Página Simple

```svelte
<!-- src/routes/users/+page.svelte -->
<script lang="ts">
    import type { PageData } from './$types';

    export let data: PageData;
</script>

<h1>Users ({data.users.length})</h1>

<ul>
    {#each data.users as user}
        <li>{user.name} ({user.email})</li>
    {/each}
</ul>
```

### Server Load Function

```typescript
// src/routes/users/+page.server.ts
import type { PageServerLoad } from './$types';
import { error } from '@sveltejs/kit';

export const load: PageServerLoad = async ({ locals }) => {
    // locals.db es el cliente GORM injectado en el app state
    const users = await locals.db.User.Find()
        .Order("id DESC")
        .Limit(100)

    if (!users || users.length === 0) {
        throw error(404, 'Users not found');
    }

    return { users };
};
```

---

## 4. Form Actions con use:enhance

### Formulario con Progressive Enhancement

```svelte
<!-- src/routes/login/+page.svelte -->
<script lang="ts">
    import { enhance } from '$app/forms';
    import type { ActionData } from './$types';

    export let form: ActionData;
</script>

<form method="POST" use:enhance>
    <label>
        Email
        <input name="email" type="email" required />
    </label>
    
    <label>
        Password
        <input name="password" type="password" required />
    </label>
    
    {#if form?.error}
        <p class="error">{form.error}</p>
    {/if}
    
    <button type="submit">Login</button>
</form>
```

### Server Action

```typescript
// src/routes/login/+server.ts
import type { Actions } from './$types';
import { fail, redirect } from '@sveltejs/kit';

export const actions: Actions = {
    default: async ({ request, locals }) => {
        const data = await request.formData();
        const email = data.get('email') as string;
        const password = data.get('password') as string;

        const user = await authenticate(email, password);
        
        if (!user) {
            return fail(401, { error: 'Invalid credentials' });
        }

        throw redirect(303, '/dashboard');
    }
};
```

---

## 5. API Endpoints (+server.ts)

> **Nota**: En un proyecto SvelteKit + Go backend, los API routes son implementados en Go usando `net/http` stdlib, no en TypeScript. El frontend SvelteKit usa `fetch()` para comunicarse con el backend.

```typescript
// src/routes/api/users/+server.ts
// Este archivo es un ejemplo de integración frontend.
// El backend real está en Go (ver cmd/server/main.go)
import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

// Ejemplo: como el frontend chamaría al backend Go
export const GET: RequestHandler = async ({ url, fetch }) => {
    const limit = url.searchParams.get('limit') ?? '10';
    const res = await fetch(`/api/users?limit=${limit}`);
    const users = await res.json();
    return json(users);
};
```

---

## 6. Integración con TailwindCSS 3.4

### Configuración

```javascript
// tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
    content: ['./src/**/*.{html,js,svelte,ts}'],
    darkMode: 'class',
    theme: {
        extend: {
            colors: {
                primary: '#3b82f6'
            }
        }
    },
    plugins: [
        require('@tailwindcss/forms')
    ]
};
```

### Uso en Componentes

```svelte
<!-- Componente con TailwindCSS -->
<div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <header class="bg-white shadow dark:bg-gray-800">
        <nav class="mx-auto max-w-7xl px-4 py-4">
            <a href="/" class="text-primary-600">Logo</a>
        </nav>
    </header>
    
    <main class="mx-auto max-w-7xl py-6">
        <slot />
    </main>
</div>
```

---

## 7. Comandos del Proyecto

```bash
# Desarrollo
npm run dev              # Inicia dev server en localhost:5173

# Build (SSG)
npm run build            # Genera sitio estático en build/

# Preview
npm run preview          # Preview del build localmente

# Tipado
npx svelte-check         # Verifica tipos Svelte + TypeScript
```

---

## 8. TypeScript y SvelteKit

### Tipado de Props

```svelte
<script lang="ts">
    export let title: string;
    export let count: number = 0;
    export let items: string[];
</script>
```

### Tipado de Form Actions

```typescript
// $types.d.ts (generado automáticamente)
import type { ActionData } from './$types';

// En el componente
export let form: ActionData<typeof actions>;
```

---

## 9. Referencias

- [tailwindcss.md](tailwindcss.md) — Utility-first CSS
- [svelte-component.md](../../.atl/patterns/svelte-component.md) — Patrones de componentes
- [testing.md](testing.md) — Testing con Vitest + @testing-library/svelte

---

*SvelteKit es el framework de producción. Usar sintaxis Svelte 4 (no runes) para compatibilidad.*

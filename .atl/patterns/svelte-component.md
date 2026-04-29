# Patrón: Componentes Svelte

**Pattern ID**: svelte-component
**Versión**: 1.0
**dependencias**: [sveltekit.md](../../docs/tools/sveltekit.md) | [tailwindcss.md](../../docs/tools/tailwindcss.md) | [testing.md](../../docs/tools/testing.md)

---

## 1. Estructura de Componente

```svelte
<script lang="ts">
    // Props con tipos
    export let title: string;
    export let count: number = 0;
    export let items: string[] = [];
    
    // State reactivo (Svelte 4 syntax)
    let value = 'initial';
    
    // Reactive statement
    $: doubled = count * 2;
    $: if (count > 10) console.warn('Count is high');
    
    // Event handlers
    function handleClick() {
        count += 1;
    }
    
    function handleSubmit(e: Event) {
        e.preventDefault();
        // ...
    }
</script>

<!-- Template con TailwindCSS -->
<div class="p-4 bg-white rounded-lg shadow">
    <h2 class="text-xl font-bold">{title}</h2>
    
    <p>Count: {count} (doubled: {doubled})</p>
    
    <ul class="mt-2 space-y-1">
        {#each items as item, i}
            <li>{i + 1}. {item}</li>
        {/each}
    </ul>
    
    <button 
        on:click={handleClick}
        class="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
    >
        Increment
    </button>
</div>

<style>
    /* Scoped styles - usar TailwindCSS primero */
    /* .local-style { } */
</style>
```

---

## 2. Props Tipadas

### Props Primitivas

```svelte
<script lang="ts">
    export let name: string;
    export let age: number;
    export let active: boolean = false;
</script>
```

### Props con Objetos

```svelte
<script lang="ts">
    interface User {
        id: number;
        name: string;
        email: string;
    }
    
    export let user: User;
    export let onSave: (user: User) => void;
</script>
```

### Validación de Props con Runtime

```svelte
<script lang="ts" context="module">
    // Optional: schema validation with zod or similar
</script>

<script lang="ts">
    import { onMount } from 'svelte';
    
    export let userId: number;
    
    // Validate at runtime
    $: if (userId < 0) {
        throw new Error('userId must be positive');
    }
</script>
```

---

## 3. Reactive Statements

```svelte
<script lang="ts">
    let count = 0;
    let doubled: number;
    let quadrupled: number;
    
    // Simple reactive
    $: doubled = count * 2;
    
    // Chain reactive
    $: quadrupled = doubled * 2;
    
    // Conditional reactive
    $: {
        console.log('count changed:', count);
        if (count > 100) {
            alert('Count is very high!');
        }
    }
</script>
```

---

## 4. Form Actions con use:enhance

### Componente de Formulario

```svelte
<!-- src/routes/users/+page.svelte -->
<script lang="ts">
    import { enhance } from '$app/forms';
    import type { ActionData } from './$types';
    
    export let form: ActionData;
</script>

<form method="POST" use:enhance class="max-w-md mx-auto">
    <div class="mb-4">
        <label for="name" class="block text-sm font-medium">Name</label>
        <input
            type="text"
            id="name"
            name="name"
            class="mt-1 block w-full rounded border-gray-300"
            required
        />
    </div>
    
    {#if form?.error}
        <p class="text-red-600 text-sm">{form.error}</p>
    {/if}
    
    <button
        type="submit"
        class="w-full bg-blue-500 text-white py-2 px-4 rounded hover:bg-blue-600"
    >
        Create User
    </button>
</form>
```

### Server Action

```typescript
// src/routes/users/+page.server.ts
import type { Actions } from './$types';
import { fail } from '@sveltejs/kit';

export const actions: Actions = {
    default: async ({ request }) => {
        const data = await request.formData();
        const name = data.get('name') as string;
        
        if (!name || name.length < 2) {
            return fail(400, { error: 'Name must be at least 2 characters' });
        }
        
        // Create user logic...
        await createUser({ name });
        
        return { success: true };
    }
};
```

---

## 5. Presentational vs Container Components

### Presentational (UI-only)

```svelte
<!-- src/lib/components/UserCard.svelte -->
<script lang="ts">
    interface User {
        id: number;
        name: string;
        email: string;
    }
    
    export let user: User;
    export let onEdit: (() => void) | undefined = undefined;
</script>

<div class="p-4 border rounded-lg">
    <h3 class="font-semibold">{user.name}</h3>
    <p class="text-gray-600">{user.email}</p>
    
    {#if onEdit}
        <button 
            on:click={onEdit}
            class="mt-2 text-blue-500 hover:underline"
        >
            Edit
        </button>
    {/if}
</div>
```

### Container (con datos)

```svelte
<!-- src/routes/users/+page.svelte -->
<script lang="ts">
    import UserCard from '$lib/components/UserCard.svelte';
    import type { PageData } from './$types';
    
    export let data: PageData;
    
    function handleEdit(userId: number) {
        // Navigate or open modal
    }
</script>

<div class="grid gap-4 md:grid-cols-2">
    {#each data.users as user}
        <UserCard 
            {user} 
            onEdit={() => handleEdit(user.id)} 
        />
    {/each}
</div>
```

---

## 6. Testing de Componentes

```typescript
// src/lib/components/UserCard.test.ts
import { render, screen } from '@testing-library/svelte';
import { describe, it, expect, vi } from 'vitest';
import UserCard from './UserCard.svelte';

describe('UserCard', () => {
    const mockUser = {
        id: 1,
        name: 'John Doe',
        email: 'john@example.com'
    };
    
    it('renders user information', () => {
        render(UserCard, { props: { user: mockUser } });
        
        expect(screen.getByText('John Doe')).toBeInTheDocument();
        expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });
    
    it('shows edit button when onEdit is provided', () => {
        const onEdit = vi.fn();
        render(UserCard, { props: { user: mockUser, onEdit } });
        
        const button = screen.getByRole('button', { name: /edit/i });
        expect(button).toBeInTheDocument();
    });
});
```

---

## 7. Referencias

- [sveltekit.md](../../docs/tools/sveltekit.md) — SvelteKit completo
- [tailwindcss.md](../../docs/tools/tailwindcss.md) — Utility-first CSS
- [testing.md](../../docs/tools/testing.md) — Testing con Vitest

---

*Svelte 4 syntax (no runes). Props tipadas, reactive statements, scoped styles.*

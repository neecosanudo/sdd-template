# React — Prototipos Únicamente

> ⚠️ **ADVERTENCIA CRÍTICA**: React es un stack SECUNDARIO para prototipos rápidos. El framework frontend PRINCIPAL es **SvelteKit** (ver [sveltekit.md](sveltekit.md)). NO usar React en proyectos de producción.

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Bundler**: Vite 6.2.0
**TypeScript**: ~5.8.2
**Styling**: TailwindCSS 4.1.14 con @tailwindcss/vite
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [sveltekit.md](sveltekit.md) | [tailwindcss.md](tailwindcss.md)

---

## 1. Cuándo Usar React (y Cuándo NO)

| Caso | ✅ Usar React | ❌ Usar SvelteKit |
|------|--------------|-------------------|
| Prototipo rápido | ✅ | ❌ |
| Validación de concepto | ✅ | ❌ |
| Demo para stakeholders | ✅ | ❌ |
| Proyecto de producción | ❌ | ✅ SvelteKit |
| Feature flags complejos | ⚠️ Cuidado | ✅ |
| SPA compleja | ⚠️ | ✅ |

---

## 2. Stack de Prototipado

```json
{
    "dependencies": {
        "react": "19.0.0",
        "react-dom": "19.0.0"
    },
    "devDependencies": {
        "@tailwindcss/vite": "4.1.14",
        "@testing-library/react": "^5.0.0",
        "@vitejs/plugin-react": "^5.0.4",
        "tailwindcss": "4.1.14",
        "typescript": "~5.8.2",
        "vite": "6.2.0"
    }
}
```

---

## 3. Hooks Básicos

### useState

```tsx
import { useState } from 'react';

interface User {
    id: number;
    name: string;
}

export function UserList() {
    const [users, setUsers] = useState<User[]>([]);
    const [loading, setLoading] = useState(false);

    return (
        <div>
            <button onClick={() => setLoading(true)}>
                Load Users
            </button>
            {loading && <p>Loading...</p>}
            <ul>
                {users.map(u => (
                    <li key={u.id}>{u.name}</li>
                ))}
            </ul>
        </div>
    );
}
```

### useEffect

```tsx
import { useEffect, useState } from 'react';

export function DataFetcher({ userId }: { userId: number }) {
    const [user, setUser] = useState<User | null>(null);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        fetch(`/api/users/${userId}`)
            .then(res => res.json())
            .then(setUser)
            .catch(err => setError(err.message));
    }, [userId]);

    if (error) return <p>Error: {error}</p>;
    if (!user) return <p>Loading...</p>;
    return <h1>{user.name}</h1>;
}
```

### useRef

```tsx
import { useRef } from 'react';

export function AutoFocusInput() {
    const inputRef = useRef<HTMLInputElement>(null);

    return (
        <input
            ref={inputRef}
            type="text"
            placeholder="Focus me on mount"
        />
    );
}
```

### useCallback

```tsx
import { useCallback, useState } from 'react';

export function Counter() {
    const [count, setCount] = useState(0);

    const increment = useCallback(() => {
        setCount(c => c + 1);
    }, []);

    return (
        <div>
            <p>Count: {count}</p>
            <button onClick={increment}>+</button>
        </div>
    );
}
```

---

## 4. Integración TailwindCSS 4.1

### vite.config.ts

```typescript
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

### Uso en Componentes

```tsx
export function LoginForm() {
    return (
        <form className="min-h-screen bg-gray-50 flex items-center justify-center">
            <div className="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
                <h1 className="text-2xl font-bold mb-6">Login</h1>
                
                <label className="block mb-4">
                    <span className="text-sm font-medium">Email</span>
                    <input
                        type="email"
                        className="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
                    />
                </label>
                
                <button
                    type="submit"
                    className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700"
                >
                    Sign In
                </button>
            </div>
        </form>
    );
}
```

---

## 5. Tabla Comparativa: React vs SvelteKit

| Aspecto | React (Prototipos) | SvelteKit (Producción) |
|---------|-------------------|------------------------|
| **Props** | `<Component prop={value} />` | `export let prop: type;` |
| **State** | `useState<T>(initial)` | `let value = initial` (reactive statement con `$:`) |
| **Effects** | `useEffect(fn, deps)` | `onMount(() => {...})`, `$: if (x) {...}` |
| **Loop** | `{items.map(item => (...))}` | `{#each items as item}...{/each}` |
| **Conditional** | `{condition && <Element />}` | `{#if condition}...{/if}` |
| **Caso de uso** | Prototipos, demos | Proyectos de producción |
| **Testing** | @testing-library/react | @testing-library/svelte |
| **Build** | Vite 6.2 | Vite 5.0 (SvelteKit) |
| **SSR** | ❌ Manual | ✅ Integrado |
| **Routing** | react-router | Basado en archivos |

---

## 6. Proyecto de Ejemplo

```bash
# Crear prototipo React
npm create vite@latest prototype -- --template react-ts
cd prototype

# Instalar TailwindCSS 4.1
npm install -D tailwindcss@4.1.14 @tailwindcss/vite
npm install @testing-library/react

# Estructura típica
src/
├── components/
│   └── UserCard.tsx
├── App.tsx
├── main.tsx
└── index.css
```

---

## 7. Referencias

- [sveltekit.md](sveltekit.md) — Framework principal
- [tailwindcss.md](tailwindcss.md) — Utility-first CSS
- [STACK_MAP.md](../STACK_MAP.md) — Versiones exactas

---

*Recordar: SvelteKit es el framework de producción. React es SOLO para prototipos rápidos que luego se migrarán a SvelteKit o se descartarán.*

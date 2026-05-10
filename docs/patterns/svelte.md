# Patrones y Conflictos — Svelte / SvelteKit

> Este archivo documenta comportamientos del framework que pueden generar errores silenciosos o difíciles de diagnosticar. Léelo antes de escribir código Svelte en este proyecto.

---

## 1. Llaves `{}` en Contenido de Texto

### Problema

Svelte interpreta **cualquier `{...}` en cualquier texto del template** como una expresión de JavaScript. Esto incluye texto dentro de párrafos, atributos `alt`, slots de caption, etc.

```svelte
<!-- Esto CRASHEA: Svelte busca variables `label` y `href` -->
<Text type="caption">{label, href}</Text>
```

### Solución

Usar la sintaxis de **escape** `{'{...}'}`:

```svelte
<!-- Correcto: Svelte renderiza "{label, href}" como texto literal -->
<Text type="caption">{'{label, href}'}</Text>
```

O asignar a una variable:

```svelte
<script>
    const captionText = '{label, href}';
</script>
<Text type="caption">{captionText}</Text>
```

### Detección

El error se manifiesta como `'text' is not defined` o `'level' is not defined` en la consola del navegador durante desarrollo. El compilador NO atrapa esto — solo aparece en runtime.

---

## 2. Props Faltantes en Componentes

### Problema

Los componentes pueden no tener valores predeterminados para todas sus props. Si un componente se inserta sin una prop requerida, el valor será `undefined` y puede causar errores en runtime.

### Solución

Siempre definir valores por defecto con `export let`:

```svelte
<!-- Siempre con defaults -->
<script>
    export let items = [];
    export let title = '';
    export let variant = 'default';
</script>
```

---

## 3. Eventos y `createEventDispatcher`

### Problema

Los componentes NO forwarding automático de eventos personalizados. Hay dos formas de escuchar eventos en un componente padre:

- **Eventos del DOM nativo** (click, submit, etc.): el componente hijo debe tener `on:click` sin handler para forwardear. El padre usa `on:click={handler}`.
- **Eventos personalizados** (search, pageChange, etc.): el componente hijo DEBE usar `createEventDispatcher` y llamar `dispatch('search', { value })`.

### Confusión común: `on:action` vs `on:click`

```svelte
<!-- EmptyState.svelte tiene on:click en su botón (forwarding DOM) -->
<button on:click>{actionLabel}</button>

<!-- El padre NO puede usar on:action — debe usar on:click -->
<EmptyState on:click={handleClearFilters} />    <!-- ✅ Correcto -->
<EmptyState on:action={handleClearFilters} />   <!-- ❌ No funciona -->
```

### Regla general

| Tipo de evento | En hijo | En padre |
|:---|:---|:---|
| DOM nativo (click, submit) | `on:click` (sin handler) | `on:click={handler}` |
| Personalizado (search, change) | `dispatch('search', data)` | `on:search={handler}` |

---

## 4. Reactividad con `$:`  vs Stores

### Problema

Usar `$page`, `$params`, `$data` de SvelteKit sin entender que son **stores** (no variables reactivas normales). Las stores usan `$` prefijo automático.

```svelte
<script>
    import { page } from '$app/stores';
    // ✅ Correcto: $page es el store suscrito automáticamente
    $: activePath = $page.url.pathname;
</script>
```

### NO mezclar con `$:` reactivo

```svelte
<script>
    let count = 0;
    $: doubled = count * 2;  // ✅ Reactivo normal

    import { page } from '$app/stores';
    // $page es automágico — NO necesitas $: para suscribirte
    console.log($page.url.pathname);  // ✅ Siempre actualizado
</script>
```

---

## 5. `$$restProps` y Fragmentación de Atributos

### Problema

Cuando un componente pasa atributos extra a un elemento interno con `{...$$restProps}`, esos atributos se aplican al elemento HTML. Si el componente renderiza múltiples elementos, `$$restProps` se aplica al PRIMERO.

### Solución

Usar `$$restProps` solo cuando el componente tiene un elemento raíz único. Para casos complejos, exponer props específicas.

---

## 6. SSR vs Cliente — Código Síncrono de Browser

### Problema

SvelteKit prerenderiza en Node.js. Código como `window.scrollY`, `document.title`, `navigator.clipboard` CRASHEA en SSR.

### Solución

```svelte
<script>
    import { onMount } from 'svelte';

    let scrollY = 0;

    onMount(() => {
        // ✅ onMount solo se ejecuta en el cliente
        scrollY = window.scrollY;
    });
</script>
```

---

## 7. Documentación de Errores Conocidos (RunTime)

| Error | Causa | Solución |
|:---|:---|:---|
| `'text' is not defined` | `{...}` interpretado como JS en texto | Escapar con `{'{...}'}` |
| `'level' is not defined` | Lo mismo, otra variable | Escapar con `{'{...}'}` |
| `'content' is not defined` | `{@html ...}` interpretado como directiva | Escapar con `{'{'}@html ...{'}'}` |
| `500 favicon.ico` | Archivo favicon faltante o 0 bytes | Proveer SVG o PNG válido en `static/` |
| `window is not defined` | Código browser en SSR | Mover a `onMount()` |
| `Cannot read properties of undefined` | Prop faltante en componente | Agregar valor default `export let prop = defaultValue` |

---

## 8. Prerender y Errores 404 Durante Build

### Problema

SvelteKit en modo `adapter-static` prerenderiza TODAS las páginas. Si una página enlaza a otra que NO existe (porque no se creó aún o porque es un placeholder), el prerender CRASHEA la build con un error 404.

Este proyecto usa `/showcase` como catálogo de componentes, y showcase enlaza a rutas como `/blog`, `/series`, `/contacto` que aún no existen. Esto rompe la build.

### Solución

Configurar `handleHttpError` en `svelte.config.js` para ignorar 404s de rutas conocidas que aún no existen:

```js
// svelte.config.js
prerender: {
    handleHttpError: ({ path }) => {
        if (path.startsWith('/blog') || path.startsWith('/series') || path.startsWith('/contacto')) {
            return; // Ignorar — rutas planificadas pero no implementadas
        }
        throw new Error(`Prerender 404: ${path}`);
    }
}
```

### handleMissingId

Similarmente, si un link apunta a un ancla `#` que no existe en la página destino (ej: `#main-content` en una página sin ese id), SvelteKit falla con `handleMissingId`. Se puede configurar igual:

```js
prerender: {
    handleMissingId: 'ignore' // o una función como handleHttpError
}
```

---

## 9. Directorios .bak como Rutas Válidas

### Problema

SvelteKit descubre rutas basándose en la estructura de directorios. **CUALQUIER** directorio con un archivo `+page.svelte` se convierte en una ruta, incluidos los directorios con extensión `.bak`, `.old`, `.backup`.

```bash
src/routes/
├── blog/
├── blog.bak/        # ← ESTO TAMBIÉN ES UNA RUTA: /blog.bak
└── quien-es-neeco/
```

Si movés un directorio a `.bak` durante depuración, SvelteKit va a tratar de prerenderizar `/blog.bak` y todas sus subrutas. Si hay páginas que enlazan a ese path, aparecen errores confusos.

### Solución

- **NO** uses `.bak` para "desactivar" rutas. En su lugar:
  - Eliminá el directorio temporalmente
  - O movelo FUERA de `src/routes/` (ej: a `src/_archive/`)
  - O usá `git stash` para volver atrás
- Si necesitás archivos de respaldo, moveselos a una carpeta fuera de `src/routes/`

---

## 10. Múltiples Advertencias A11Y con `svelte-ignore`

### Problema

En Svelte 4, suprimir múltiples advertencias a11y con `svelte-ignore` puede no funcionar correctamente con el formato separado por espacios:

```svelte
<!-- ❌ Puede que NO suprima ambas advertencias -->
<!-- svelte-ignore a11y-click-events-have-key-events a11y-no-static-element-interactions -->
<div on:click={handler}>...</div>
```

### Solución

Usar `svelte-ignore` en líneas separadas:

```svelte
<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<div on:click={handler} on:keydown={handleKey}>...</div>
```

O mejor aún: agregar el manejador de teclado en lugar de ignorar la advertencia.

---

## 11. Documentación de Errores Conocidos (Build Time)

Además de la tabla de runtime de la sección 7, estos errores aparecen en **build/compilación**:

| Error | Causa | Solución |
|:---|:---|:---|
| `Prerender 404: /blog` | Link a ruta que no existe | Configurar `handleHttpError` o crear la ruta |
| `handleMissingId: #main-content` | Link a ancla inexistente | Configurar `handleMissingId: 'ignore'` o agregar el id |
| `ParseError: </div> attempted to close...` | Desbalance de tags en template | Revisar apertura/cierre de HTML en el componente |
| Route `/blog.bak` discovered | Directorio `.bak` dentro de `src/routes/` | Mover respaldos fuera de `src/routes/` |
| `Unexpected token` en `<script>` | Tipo TS sin `lang="ts"` en tag script | Agregar `lang="ts"` al tag `<script>` |
| `'content' is not defined` | `{@html content}` en texto del template | Escapar: `{'{'}@html content{'}'}` |

---

## 12. `lang="ts"` Obligatorio en `<script>` con TypeScript

### Problema

Cualquier bloque `<script>` en un archivo `.svelte` que use sintaxis TypeScript (anotaciones de tipo, interfaces, genéricos, `ReturnType<>`, `as Type`, etc.) DEBE tener `lang="ts"`. Sin él, Vite/svelte-check lanza `Unexpected token` en la primera expresión TS.

```svelte
<!-- ❌ CRASHEA: type annotation sin lang="ts" -->
<script>
    let searchTimer: ReturnType<typeof setTimeout>;
</script>

<!-- ✅ Correcto -->
<script lang="ts">
    let searchTimer: ReturnType<typeof setTimeout>;
</script>
```

### Detección

El error aparece como `Pre-transform error: Unexpected token` en el compilador de Vite, apuntando a la línea del tipo. Es INMEDIATO — ni siquiera llega a la pantalla.

### Regla simple

**Si el `<script>` tiene DOS PUNTOS (`:`) en una declaración de variable, necesita `lang="ts"`.** No hay excepciones.

---

## 13. Escapar Directivas Svelte en Texto de Template

### Problema

Dentro del template HTML de un `.svelte`, las secuencias `{@...}`, `{#...}`, `{/:...}` se interpretan como **directivas Svelte**, no como texto literal. Si querés mostrarlas como documentación o descripción, Svelte intentará ejecutarlas y tirará errores como `'content' is not defined`.

```svelte
<!-- ❌ CRASHEA: Svelte interpreta {@html content} como directiva -->
<Text>Elimina el {@html content} que era vector de XSS.</Text>

<!-- ✅ Correcto: escapar las llaves -->
<Text>Elimina el {'{'}@html content{'}'} que era vector de XSS.</Text>
```

### Qué secuelas escapar

| Secuencia | Se escapa como | Se usa en |
|:---|:---|:---|
| `{@html ...}` | `{'{'}@html ...{'}'}` | Documentación de componentes |
| `{#each ...}` | `{'{'}#each ...{'}'}` | Comentarios, docs |
| `{#if ...}` | `{'{'}#if ...{'}'}` | Comentarios, docs |
| `{:else}` | `{'{'}:else{'}'}`  | Comentarios, docs |
| `{/if}` | `{'{'/if{'}'}` | Comentarios, docs |

### Detección

`vite-plugin-svelte` lanza: `'content' is not defined` o `'fallbackContent' is not defined`. Las "variables" que reporta son en realidad el texto que sigue a la directiva falsa.

---

## 14. Tipado de Props Arrays con TypeScript

### Problema

Svelte permite `export let items = []` sin tipo, lo que infiere `any[]`. Esto produce errores `Implicit any` en modo strict y puede causar errores en runtime.

### Solución

Usar anotaciones de tipo explícitas en todas las props de tipo array:

```svelte
<!-- ❌ Incorrecto: infiere any[] -->
<script>
    export let items = [];
</script>

<!-- ✅ Correcto: tipo explícito -->
<script lang="ts">
    export let items: string[] = [];
</script>
```

---

## 15. Index Signatures con `as const`

### Problema

Cuando un objeto de estilos/variantes se accede con bracket notation (`classes[variant]`), TypeScript requiere que el tipo del key sea exacto. Si el objeto tiene valores string genéricos, falla con:

```
Element implicitly has an 'any' type because index expression is not of type 'number'
```

### Solución

Usar `as const` en el objeto para hacerlo `readonly` y narrows los tipos:

```svelte
<!-- ❌ Incorrecto: Record<string, string> falla con bracket notation -->
<script lang="ts">
    const variantClasses = {
        accent: 'bg-[var(--color-accent)]',
        clay: 'bg-[var(--color-clay)]'
    };
    // variantClasses[variant] → Error: no index signature
</script>

<!-- ✅ Correcto: as const narrows los keys -->
<script lang="ts">
    const variantClasses = {
        accent: 'bg-[var(--color-accent)]',
        clay: 'bg-[var(--color-clay)]',
        outline: 'bg-transparent border border-[var(--color-accent)]'
    } as const;

    export let variant: 'accent' | 'clay' | 'outline' = 'accent';
</script>

<span class={variantClasses[variant]}>...</span>
```

---

## 16. Tipado de Event Handlers

### Problema

Sin tipo, el parámetro `e` en un event handler es `any`. Esto pierde la guía de tipos para `e.target`, `e.preventDefault()`, etc.

### Solución

Tipar el parámetro con el tipo de evento correspondiente:

```svelte
<!-- ❌ Incorrecto: any implícito -->
<script>
    function handleClick(e) {
        e.preventDefault(); // any - sin autocompletado
    }
</script>

<!-- ✅ Correcto: MouseEvent -->
<script lang="ts">
    function handleClick(e: MouseEvent) {
        e.preventDefault();
        // e.target es HTMLElement
    }
</script>
```

### Tipos comunes

| Evento | Tipo | Uso |
|:---|:---|:---|
| click en elemento | `MouseEvent` | Botones, links |
| submit de form | `SubmitEvent` | Forms |
| input en campo | `Event` + cast | Inputs, textareas |
| keydown/keyup | `KeyboardEvent` | Navegación de teclado |
| change | `Event` | Selects, checkboxes |

---

## 17. PageData en Tests de Ruta

### Problema

Los tests de rutas SvelteKit usan `load()` que devuelve datos tipados. Sin tipo, se usa `as any` que pierde toda la verificación.

### Solución

Importar `PageData` desde `$types` y usarlo para tipar el resultado:

```typescript
// ❌ Incorrecto: any
const result = await load({ fetch: global.fetch } as any);

// ✅ Correcto: PageData tipado
import type { PageData } from './$types';
const result = (await load({ fetch: global.fetch } as any)) as PageData;
```

---

## 18. Prefijo `+` Reservado en Archivos de Test dentro de `src/routes/`

### Problema

SvelteKit reserva el prefiio `+` exclusivamente para archivos de ruta especiales: `+page.svelte`, `+layout.svelte`, `+error.svelte`, `+page.ts`, `+page.server.ts`, etc. Si un archivo de test dentro de `src/routes/` usa el prefiio `+` (por ejemplo, `+page.test.ts`), SvelteKit lo detecta como un archivo de ruta inválido y **tira error 500 en TODO el sitio**.

```bash
src/routes/admin/posts/[id]/
├── +page.svelte          # ✅ Ruta válida
├── +page.test.ts         # ❌ ¡INVÁLIDO! Causa: "Files prefixed with + are reserved"
└── page.test.ts          # ✅ Correcto — test sin prefijo +
```

### Impacto

- El sitio completo devuelve HTTP 500
- El mensaje de error es: `"Files prefixed with + are reserved (saw src/routes/.../+page.test.ts)"`
- No es un error aislado de la ruta — afecta todas las páginas

### Solución

**NUNCA uses `+` en archivos de test dentro de `src/routes/`:**

| ❌ Incorrecto | ✅ Correcto |
|:---|:---|
| `src/routes/blog/+page.test.ts` | `src/routes/blog/page.test.ts` |
| `src/routes/admin/posts/[id]/+page.test.ts` | `src/routes/admin/posts/[id]/page.test.ts` |

---

> **Cómo actualizar este archivo**: Cuando encuentres un error de framework que no está documentado aquí, agregalo. No importa si parece obvio — lo que es obvio hoy se olvida mañana.
# Patrones y Errores — TailwindCSS

> **DOCUMENTACIÓN ACTIVA**
>
> Este archivo describe patrones y errores comunes de TailwindCSS. Léelo antes de escribir estilos en este proyecto.

---

## 1. Breakpoint `xs` No Existe

### Problema
`xs` no es un breakpoint válido en Tailwind CSS v3. Usar clases como `hidden xs:inline` no tiene efecto.

### Solución
Usar `sm:` (640px+) para móvil.

```html
<!-- INCORRECTO — xs no existe -->
<span class="hidden xs:inline">Texto</span>

<!-- CORRECTO -->
<span class="hidden sm:inline">Texto</span>
```

---

## 2. Variables CSS

### Patrón correcto
Usar variables CSS del proyecto con fallback:

```css
:root {
  --color-bg: #ffffff;
  --color-surface: #f9fafb;
  --color-border: #d1d5db;
  --color-text: #111827;
  --color-primary: #6366f1;
}
```

```html
<div style="background: var(--color-surface, #f9fafb);">
```

<!-- [TODO: Personalizar las variables CSS según el proyecto] -->

---

## 3. Overflow en Flex Children

### Problema
Un flex child con `overflow-y-auto` no scrollea si el parent no tiene `min-h-0`.

### Solución
```html
<!-- Parent debe tener min-h-0 -->
<div class="flex-1 min-w-0 overflow-y-auto min-h-0">
  <!-- contenido scrolleable -->
</div>
```

---

## 4. Padding Duplicado

### Problema
Un wrapper tiene `p-4` y el componente hijo también tiene `p-4`.

### Solución
El padding va en el componente, no en el wrapper. Si el componente ya tiene padding, el wrapper no debe agregar más.

---

## 5. Documentación de Errores Conocidos

<!-- [TODO: Poblarlo con errores reales del proyecto] -->

| Error | Causa | Solución |
|-------|-------|----------|
| [TODO: error] | [TODO: causa] | [TODO: solución] |
| [TODO: error] | [TODO: causa] | [TODO: solución] |

---

> **Cómo actualizar este archivo**: Cuando encuentres un error de TailwindCSS que no está documentado aquí, agrégalo.

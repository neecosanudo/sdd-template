# Patrones y Conflictos — React

> **DOCUMENTACIÓN ACTIVA**
>
> Este archivo documenta comportamientos del framework que pueden generar errores silenciosos o difíciles de diagnosticar. Léelo antes de escribir código React en este proyecto.

---

## 1. Estado y Re-renders

### Problema
Los componentes se re-renderizan cuando cambia el estado local, las props, el contexto, o el padre se re-renderiza. Las funciones inline y objetos recreados en cada render causan renders innecesarios.

### Solución
```tsx
// ❌ MAL: Función inline recreada en cada render
<Button onClick={() => handleClick(id)} />

// ✅ BIEN: useCallback para evitar re-renders
const handleClick = useCallback(() => {
  handleAction(id);
}, [id, handleAction]);
```

<!-- [TODO: Adaptar según la versión de React del proyecto] -->

---

## 2. El Problema de los Arrays en useEffect

### Problema
Pasar arrays/objetos como dependencia de `useEffect` causa loops infinitos porque cada render crea un nuevo array (nueva referencia).

### Solución
```tsx
// ❌ MAL: `data` es un objeto, nueva referencia cada render
useEffect(() => {
  save(data);
}, [data]); // ← ¡Loop infinito!

// ✅ BIEN: useEffect por cada slice de estado
useEffect(() => {
  saveItem1(data.item1);
}, [data.item1]);

useEffect(() => {
  saveItem2(data.item2);
}, [data.item2]);
```

**Regla:** Si un objeto cambia frecuentemente, separalo en efectos individuales.

---

## 3. Modales y Event Bubbling

### Problema
Los modales suelen tener un backdrop que cierra el modal. El click dentro del contenido del modal también cierra el modal si no se detiene la propagación.

### Solución
```tsx
// ✅ BIEN: Solo el backdrop cierra el modal
<div className="fixed inset-0" onClick={onClose}>
  <div className="modal-content" onClick={e => e.stopPropagation()}>
    {children}
  </div>
</div>
```

---

## 4. Manejo de localStorage con try-catch

### Problema
`localStorage` puede lanzar excepciones en Safari private browsing, almacenamiento lleno, o datos corruptos.

### Solución
```tsx
try {
  const saved = localStorage.getItem(key);
  if (saved) {
    return JSON.parse(saved);
  }
} catch (e) {
  console.error(`Error loading ${key}:`, e);
}
return fallbackValue;
```

---

## 5. Fragmentación de Estado Global

### Problema
Tener TODO el estado global en un solo componente o store causa que cualquier cambio re-renderice todo el árbol.

### Solución a futuro
Separar el estado en stores/custom hooks atómicos por dominio:
```tsx
function useUsers() { ... }
function useSettings() { ... }
function useNotifications() { ... }
```

---

## 6. Documentación de Errores Conocidos

<!-- [TODO: Poblarlo con errores reales del proyecto] -->

| Error | Causa | Solución |
|-------|-------|----------|
| `Cannot read properties of undefined (reading 'map')` | Array no inicializado | Siempre inicializar con `[]` |
| `Maximum update depth exceeded` | Loop infinito en useEffect | Verificar dependencias |
| `Rendered more hooks than during the previous render` | Hook condicional | Nunca hooks dentro de if/for |
| [TODO: error del proyecto] | [TODO: causa] | [TODO: solución] |

---

> **Cómo actualizar este archivo**: Cuando encuentres un error de React que no está documentado aquí o un patrón que te hizo perder tiempo, agrégalo.

# Patrones y Conflictos — TypeScript

> **DOCUMENTACIÓN ACTIVA**
>
> Este archivo documenta comportamientos del lenguaje y configuración que pueden generar errores. Léelo antes de escribir TypeScript en este proyecto.

---

## 1. Strict Mode

### Problema
Sin `strict: true` en `tsconfig.json`, TypeScript no detecta errores comunes como `null`/`undefined` no verificados.

### Solución
Habilitar strict mode:
```json
{
  "compilerOptions": {
    "strict": true
  }
}
```
<!-- [TODO: Ajustar según la configuración del proyecto] -->

---

## 2. Interfaces vs Types

### Recomendación
- Usar `interface` para objetos que se extienden o implementan (props de componentes, contratos de API)
- Usar `type` para uniones, tuplas, y utilidades

```typescript
// Interface para props de componente
interface ButtonProps {
  variant: 'primary' | 'secondary';
  onClick: () => void;
  children: React.ReactNode;
}

// Type para uniones
type ViewMode = 'agenda' | 'moulds' | 'tasks';
```

---

## 3. Path Aliases

### Problema
Path alias como `@/` requieren configuración en **dos lugares**: `tsconfig.json` y `vite.config.ts` (o el bundler que uses).

### Regla
Si agregás un nuevo path alias, actualizá AMBOS archivos.

<!-- [TODO: Documentar los path alias específicos del proyecto] -->

---

## 4. El Tipo `Partial<T>` en Formularios

### Riesgo
`Partial<T>` hace que TODAS las propiedades sean opcionales. Si el código asume que una propiedad existe, puede crashear:

```typescript
// ❌ Peligro: obj.prop puede ser undefined
const value = obj.prop;

// ✅ Seguro: verificar antes de usar
const value = obj.prop ?? 'default';
```

**Regla:** Siempre validar y proveer defaults cuando trabajás con `Partial<T>`.

---

## 5. Index Signatures con `Record<string, T>`

### Problema
Acceder a una key que no existe devuelve `undefined` sin error de tipo:

```typescript
const map: Record<string, number> = {};
const val = map['no-existe']; // undefined — sin error
```

### Solución
Siempre verificar o proveer default:
```typescript
const value = map[key] ?? defaultValue;
```

---

## 6. Documentación de Errores Conocidos

<!-- [TODO: Poblarlo con errores reales del proyecto] -->

| Error | Causa | Solución |
|-------|-------|----------|
| `[TODO: error message]` | [TODO: causa] | [TODO: solución] |
| `[TODO: error message]` | [TODO: causa] | [TODO: solución] |

---

> **Cómo actualizar este archivo**: Cuando encuentres un error de TypeScript que no está documentado aquí o un patrón que te hizo perder tiempo, agrégalo.

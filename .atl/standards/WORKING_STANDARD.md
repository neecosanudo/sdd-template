# Working Standard

Ciclo operativo: cómo convertir conversaciones en software.

## Ciclo SDD

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
```

**Regla clave:** Si Verify falla → volver a Tasks, NO a Design. Repetir hasta 100%.

---

## Fases

### Explore
Entender el problema CON el usuario.
- Scope, requisitos, user stories, constraints
- Output: `docs/` o `Bitacora.md`

### Design
Planificar la solución.
- Arquitectura, modelo de datos, contratos API
- Output: `docs/adr/NNNN-name.md`

### Tasks
Descomponer en pasos concretos.
- Cada tarea → completable en una sesión
- Output: `tasks.md`

### Apply
Escribir código.
- Cargar skills relevantes ANTES
- Si TDD strict → tests primero
- Commands: `go test`, `npm run test`, lint

### Verify
Validar contra specs.
- Tests pasan, no lint errors, no type errors
- Si falla → volver a Tasks → Apply → Verify (loop automático)

### Archive
Cerrar el cambio.
- Commit con Conventional Commits + Gitmoji
- Git limpio
- Informe final

---

## Reglas de Oro

1. **Análisis antes de Diseño** — nunca diseñues sin entender el problema
2. **Diseño antes de Tasks** — nunca descompongas sin plan
3. **Tasks antes de Apply** — nunca codifiques sin saber qué construís
4. **Verify antes de Archive** — nunca cierres sin validar
5. **Iterar hasta limpio** — un Verify fallido es feedback, no failure

**Sync execution:** Las fases ejecutan sync, no async, salvo que el usuario pida lo contrario.

---

## Defaults

- **Persistence:** `engram`
- **Flow:** `auto` → `interactive` antes de Archive
- **Execution:** `synchronous`

---

*Este es el ciclo operativo. Cuando dudas → releélo.*
# Working Standard

Ciclo operativo: como convertir conversaciones en software.

## 3 Etapas del Proyecto

```
Discovery -> Pre-SDD -> SDD Cycle (Loop)
```

### Discovery (Analisis inicial)
**Antes de cualquier codigo.** Definir:
- Vision del proyecto (que es, para quien es, que problema resuelve)
- User personas
- MVP scope y ciclos de entrega
- Roadmap de entregas incrementales

**Output:** Documento en `docs/` o `Bitacora.md`

### Pre-SDD (Preparacion)
**Antes de cada ciclo SDD.** Verificar:
- [ ] Historias de usuarios definidas
- [ ] Ciclos MVP completados o en curso
- [ ] Contexto claro para planificar la change

**Si NO** -> Volver a Discovery/MVP.
**Si SI** -> Listo para Pre-SDD -> SDD.

### SDD (Ciclo formal)
**Contexto claro, inicia el ciclo de 7 fases.**

---

## Ciclo SDD (7 Fases)

```
Explore -> Propose -> Spec -> Design -> Tasks -> Apply -> Verify -> Archive
```

**Regla clave:** Si Verify falla -> volver a Tasks, NO a Design. Repetir hasta 100%.

---

## Modo de Ejecucion (Default)

```
[Interactive] -> [Auto: Tasks -> Apply -> Verify] -> [Interactive] -> Archive
```

| Fases | Modo | Comportamiento |
|-------|------|----------------|
| Explore -> Design | `interactive` | Preguntar, esperar confirmacion |
| Tasks -> Apply -> Verify | `auto` | Ejecutar solo, loop hasta 100% |
| Antes de Archive | `interactive` | Confirmacion final |

**Override:** Usuario puede pedir "todo auto" o "todo interactive" por sesion.

---

## Fases Detalladas

### Explore
Entender el problema CON el usuario.
- Scope, requisitos, user stories, constraints

### Design
Planificar la solucion.
- Arquitectura, modelo de datos, contratos API

### Tasks
Descomponer en pasos concretos.
- Cada tarea -> completable en una sesion

### Apply
Escribir codigo.
- Cargar skills relevantes ANTES
- Si TDD strict -> tests primero (RED -> GREEN)
- Si test sin assert -> RECHAZAR

### Verify
Validar contra specs.
- Si falla -> volver a Tasks -> Apply -> Verify (loop automatico)
- Max 3 intentos
- Si pasa -> volver a interactive antes de Archive

### Archive
Cerrar el cambio.
- `git add -A` -> Commit -> `git status` (limpio) -> Informe final

---

## Reglas de Oro

1. **Discovery antes de Pre-SDD** - nunca inicies SDD sin contexto
2. **Pre-SDD antes de SDD** - verificar que MVP este completo
3. **Analisis antes de Diseño** - nunca diseñes sin entender el problema
4. **Diseño antes de Tasks** - nunca descompongas sin plan
5. **Verify antes de Archive** - nunca cierres sin validar
6. **Iterar hasta limpio** - un Verify fallido es feedback, no failure

---

*Este es el ciclo operativo. Cuando dudas -> releelo.*
*Si no sabes en que etapa esta el proyecto -> PREGUNTA.*

# Template SDD v2.1.0

Template para proyectos Spec-Driven Development (SDD) con stack Go + TDD.

## Quick Start

```bash
sdd init                    # Inicializar SDD
make up                    # Levantar proyecto
make test                  # Ejecutar tests
make lint                  # Linting
```

---

## Flujo de Proyecto: 3 Etapas

Este template maneja 3 etapas de trabajo:

```
Discovery -> Pre-SDD -> SDD Cycle (Loop)
```

### 1. Discovery (Analisis inicial)

Antes de cualquier codigo, responder estas preguntas:

- **¿Que es el proyecto?** - Definir vision, proposito, problema a resolver
- **¿Para quien es?** - User personas, necesidades
- **¿Que se necesita entregar?** - MVP scope, features minimos
- **¿Cuales son los ciclos MVP?** - Roadmap de entregas incrementales

**Output:** Documento de Discovery en `docs/` o `Bitacora.md`

### 2. Pre-SDD (Preparacion antes de SDD)

Antes de iniciar un ciclo SDD:

- ¿Las historias de usuarios estan definidas?
- ¿Los ciclos MVP estan completos?
- ¿Se tiene el contexto necesario para planificar la change?

**Si NO** -> Volver a Discovery/MVP.

**Si SI** -> Listo para Pre-SDD.

**Pre-SDD output:** Requirements claros, scope definido, listo para SDD.

### 3. SDD (Ciclo de desarrollo)

Una vez con el contexto claro:

```
Explore -> Propose -> Spec -> Design -> Tasks -> Apply -> Verify -> Archive
```

---

## Modo de Ejecucion

**Default (no pedir nada):**
```
[Interactive] -> [Auto: Tasks -> Apply -> Verify] -> [Interactive] -> Archive
```

1. **Explore -> Propose -> Spec -> Design**: Modo **interactive** (el agente pregunta, el usuario responde)
2. **Tasks -> Apply -> Verify**: Modo **auto** (ejecuta solo, loop automatico hasta 100%)
3. **Antes de Archive**: Vuelve a **interactive** para confirmacion

El usuario puede pedir: "ejecutalo todo en auto" o "ejecutalo todo en interactive", pero eso Override solo esa sesion. El default vuelve al formato mixto.

---

## Prompt de Entrada (copiar y pegar al iniciar una sesion)

```
Eres el orquestador SDD de este proyecto. Antes de hacer cualquier cosa:

1. Lee .atl/ENTRY.md - es tu punto de entrada obligatorio
2. Verifica el estado del proyecto: git status
3. Si hay cambios sin commitear, pregunta al usuario que hacer

Este proyecto sigue el flujo:
- Discovery -> Pre-SDD -> SDD
- Modo default: interactive (Explore -> Design) + auto (Tasks -> Verify) + interactive (antes Archive)

Si no sabes en que etapa esta el proyecto, PREGUNTA al usuario antes de proceder.
```

---

## Regla Clave

> **Si Verify falla, se retoma desde Tasks, no desde Design.**

El loop automatico ejecuta Tasks -> Apply -> Verify hasta 100% (max 3 intentos).

---

## Docs

- [.atl/ENTRY.md](.atl/ENTRY.md) - Punto de entrada (LEELO PRIMERO)
- [.atl/governance/](.atl/governance/) - Governance
- [.atl/standards/](.atl/standards/) - Estandares tecnicos
- [.atl/patterns/](.atl/patterns/) - Patrones de codigo
- [STACK_MAP.md](STACK_MAP.md) - Stack completo

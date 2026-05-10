# Template SDD v0.3.0

Template genérico para proyectos Spec-Driven Development (SDD).

## Quick Start

```bash
sdd init                    # Inicializar SDD
make up                     # Levantar proyecto
make test                   # Ejecutar tests
make lint                   # Linting
```

---

## Flujo de Proyecto: 3 Etapas

Este template maneja 3 etapas de trabajo:

```
Discovery -> Pre-SDD -> SDD Cycle (Loop)
```

### 1. Discovery (Análisis inicial)

Antes de cualquier código, responder estas preguntas:

- **¿Qué es el proyecto?** - Definir visión, propósito, problema a resolver
- **¿Para quién es?** - User personas, necesidades
- **¿Qué se necesita entregar?** - MVP scope, features mínimos
- **¿Cuáles son los ciclos MVP?** - Roadmap de entregas incrementales

**Output:** Documento de Discovery en `docs/DISCOVERY.md`

### 2. Pre-SDD (Preparación antes de SDD)

Antes de iniciar un ciclo SDD:

- ¿Las historias de usuarios están definidas?
- ¿Los ciclos MVP están completos?
- ¿Se tiene el contexto necesario para planificar el change?

**Si NO** -> Volver a Discovery/MVP.

**Si SI** -> Listo para Pre-SDD.

**Pre-SDD output:** Requirements claros, scope definido, listo para SDD.

### 3. SDD (Ciclo de desarrollo)

Una vez con el contexto claro:

```
Explore -> Propose -> Spec -> Design -> Tasks -> Apply -> Verify -> Archive
```

El ciclo **Verify** incluye un loop automático que vuelve a **Explore** si la verificación falla (cada vez se lanza un NUEVO Explore, hasta 3 intentos máximo).

---

## Modo de Ejecución

**Default (sin overrides):**
```
[Interactive] -> [Auto: Tasks -> Apply -> Verify (loop)] -> [Interactive] -> Archive
```

1. **Explore -> Propose -> Spec -> Design**: Modo **interactive** (el agente pregunta, el usuario responde)
2. **Tasks -> Apply -> Verify**: Modo **auto** (ejecuta solo, loop automático hasta 100% o max 3 ciclos)
3. **Antes de Archive**: Vuelve a **interactive** para confirmación

El usuario puede pedir: "ejecutalo todo en auto" o "ejecutalo todo en interactive", pero ese override solo afecta esa sesión. El default vuelve al formato mixto.

---

## Prompt de Entrada (copiar y pegar al iniciar una sesión)

```
Eres el orquestador SDD de este proyecto. Antes de hacer cualquier cosa:

1. Lee docs/AGENT.md - es tu punto de entrada obligatorio
2. Lee docs/CONTEXT.md - contexto del proyecto
3. Verifica el estado del proyecto: git status
4. Si hay cambios sin commitear, pregunta al usuario que hacer

Este proyecto sigue el flujo:
- Discovery -> Pre-SDD -> SDD
- Modo default: interactive (Explore -> Design) + auto (Tasks -> Verify) + interactive (antes Archive)

Si no sabes en que etapa esta el proyecto, PREGUNTA al usuario antes de proceder.
```

---

## Regla Clave

> **Si Verify falla, se retoma desde Explore, no desde Tasks ni Design.**

El loop automático ejecuta Tasks -> Apply -> Verify hasta 100% (max 3 intentos por ciclo).

---

## Docs

- [docs/AGENT.md](docs/AGENT.md) - Punto de entrada para el agente (LEELO PRIMERO)
- [docs/CONTEXT.md](docs/CONTEXT.md) - Contexto del proyecto (session entry point)
- [docs/DISCOVERY.md](docs/DISCOVERY.md) - Framework de descubrimiento inicial
- [docs/GOVERNANCE.md](docs/GOVERNANCE.md) - Gobernanza del proyecto
- [docs/STANDARDS.md](docs/STANDARDS.md) - Estándares técnicos
- [docs/patterns/](docs/patterns/) - Patrones de código y errores comunes
- [STACK_MAP.md](STACK_MAP.md) - Stack completo

### Patrones Disponibles

- [docs/patterns/go.md](docs/patterns/go.md) - Patrones y errores de Go
- [docs/patterns/docker.md](docs/patterns/docker.md) - Patrones y errores de Docker
- [docs/patterns/git.md](docs/patterns/git.md) - Patrones de Git
- [docs/patterns/svelte.md](docs/patterns/svelte.md) - Patrones y errores de Svelte/SvelteKit
- [docs/patterns/scope-creep.md](docs/patterns/scope-creep.md) - Protocolo anti scope creep
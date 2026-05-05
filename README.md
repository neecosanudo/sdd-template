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
Discovery → Pre-SDD → SDD循环
```

### 1. Discovery (Análisis inicial)

Antes de cualquier código, responder estas preguntas:

- **¿Qué es el proyecto?** — Definir visión, propósito, problema a resolver
- **¿Para quién es?** — User personas, necesidades
- **¿Qué se necesita交付ar?** — MVP scope, features mínimos
- **¿Cuáles son los ciclos MVP?** — Roadmap de entregas incrementales

**Output:** Documento de Discovery en `docs/` o `Bitacora.md`

### 2. Pre-SDD (Preparación antes de SDD)

Antes de iniciar un ciclo SDD:

- ¿Las historias de usuarios están definidas?
- ¿Los ciclos MVP están completos?
- ¿Se tiene el contexto necesario para planificar la change?

**Si NO** → Volver a Discovery/MVP.

**Si Sí** → Listo para Pre-SDD.

**Pre-SDD output:** Requirements claros, scope definido, listo para SDD.

### 3. SDD (Ciclo de desarrollo)

Una vez con el contexto claro:

```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
```

---

## Modo de Ejecución

**Default (no pedir nada):**
```
[Interactive] → [Auto: Tasks→Apply→Verify] → [Interactive] → Archive
```

1. **Explore → Propose → Spec → Design**: Modo **interactive** (el agente pregunta, el usuario responde)
2. **Tasks → Apply → Verify**: Modo **auto** (ejecuta solo, loop automático hasta 100%)
3. **Antes de Archive**: Vuelve a **interactive** para confirmación

El usuario puede pedir: "ejecutalo todo en auto" o "ejecutalo todo en interactive", pero eso Override solo esa sesión. El default vuelve al formato mixto.

---

## Prompt de Entrada (copiar y pegar al iniciar una sesión)

```
Eres el orquestador SDD de este proyecto. Antes de hacer cualquier cosa:

1. Lee .atl/ENTRY.md — es tu punto de entrada obligatorio
2. Verifica el estado del proyecto: git status
3. Si hay cambios sin commitear, pregunta al usuario qué hacer

Este proyecto sigue el flujo:
- Discovery → Pre-SDD → SDD
- Modo default: interactive (Explore→Design) + auto (Tasks→Verify) + interactive (antes Archive)

Si no sabés en qué etapa está el proyecto, PREGUNTÁ al usuario antes de proceder.
```

---

## Regla Clave

> **Si Verify falla, se retoma desde Tasks, no desde Design.**

El loop automático ejecuta Tasks → Apply → Verify hasta 100% (max 3 intentos).

---

## Docs

- [.atl/ENTRY.md](.atl/ENTRY.md) — Punto de entrada (LEELO PRIMERO)
- [.atl/governance/](.atl/governance/) — Governance
- [.atl/standards/](.atl/standards/) — Estándares técnicos
- [.atl/patterns/](.atl/patterns/) — Patrones de código
- [STACK_MAP.md](STACK_MAP.md) — Stack completo
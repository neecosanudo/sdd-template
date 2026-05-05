# Template SDD v2.1.0

Template para proyectos Spec-Driven Development (SDD) con stack Go + TDD.

## Quick Start

```bash
sdd init                    # Inicializar SDD
make up                    # Levantar proyecto
make test                  # Ejecutar tests
make lint                  # Linting
```

## SDD Cycle

Explore → Propose → Spec → Design → **Tasks** → **Apply** → **Verify** → (si fail → Tasks)

> Si Verify falla, se retoma desde Tasks, no desde Design.

## Docs

- [.atl/governance/](.atl/governance/) — Governance
- [.atl/standards/](.atl/standards/) — Estándares técnicos
- [.atl/patterns/](.atl/patterns/) — Patrones de código
- [STACK_MAP.md](STACK_MAP.md) — Stack completo
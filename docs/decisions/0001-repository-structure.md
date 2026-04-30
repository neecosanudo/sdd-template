# ADR-0001: Estructura del Directorio `.atl/`

**Estado**: Aprobado
**Fecha**: 2026-04-29

## Contexto

El template necesita un repositorio canónico de metadatos del proyecto:
estándares operativos, patrones reutilizables, gobernanza, specs de
navegación y glosario terminológico. Sin estructura definida, estos
artefactos se dispersan en raíz, `docs/`, o no existen.

## Decisión

Centralizar toda la metadata del proyecto bajo `.atl/` con cuatro
subdirectorios:

| Directorio | Contenido | Ejemplos |
|------------|-----------|----------|
| `.atl/governance/` | Reglas no negociables | ENGINEERING_MANIFEST, COMMIT_CONVENTIONS |
| `.atl/standards/` | Reglas operacionales | WORKING_STANDARD, TESTING_STRATEGY |
| `.atl/patterns/` | Prácticas reutilizables | go-hexagonal, code-migration |
| `.atl/specs/` | Especificaciones template | navigation.spec.md |

La raíz queda reservada para: `README.md`, `Bitacora.md`, `STACK_MAP.md`,
`docs/`, `openspec/`.

## Consecuencias

**Positivas**: Ubicación predecible para agentes; separación template vs
código proyecto; escalable.
**Negativas**: Curva de aprendizaje inicial; dos lugares de documentación.
**Riesgo**: Agentes no entrenados crean archivos en raíz — mitigado por
`navigation.spec.md`.

## Referencias

- `.atl/specs/navigation.spec.md` — Reglas de navegación
- `.atl/glossary.md` — Definiciones de Pattern/Standard/Governance
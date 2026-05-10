# CONTEXT.md

> **PROPOSITO**: Este archivo es el punto de entrada para una nueva sesion. Lean esto ANTES de tocar cualquier codigo.
>
> **MODO**: Template — completar con informacion del proyecto real.

---

## 1. Que es este proyecto?

[TODO: Descripcion de una linea del proyecto]

[DESCRIPCION DETALLADA: Cual es el proposito? Que problema resuelve? Quien lo usa?]

---

## 2. Stack Tecnologico

| Capa | Tecnologia | Detalle |
|------|-----------|---------|
| **Backend** | [TODO] | [TODO] |
| **Frontend** | [TODO] | [TODO] |
| **Base de Datos** | [TODO] | [TODO] |
| **Infra** | [TODO] | [TODO] |
| **Build** | [TODO] | [TODO] |

---

## 3. Metodologia SDD

### Ciclo completo
```
Explore → Propose → Spec → Design → Tasks → Apply → Verify → Archive
                                                       ↑
                                                       │
                                           ┌───────────┴───────────┐
                                           │    Verify ≠ 100% OK   │
                                           │  (errors/warnings/    │
                                           │   suggestions)        │
                                           └───────────┬───────────┘
                                                       │
                                                   Explore
                                                   (automatico,
                                                    NUEVO cada vez)
                                                       │
                                                     Tasks
                                                       │
                                                     Apply
                                                       │
                                                     Verify
                                                       │
                                           ┌───────────┴───────────┐
                                           │    Clean?             │
                                           │      YES → Archive    │
                                           │      NO  → Explore ↑  │
                                           └───────────────────────┘
```

### Branch Strategy
- `main` → produccion versionada
- `dev` → integracion (de aca salen los features)
- `feature/<name>` → cada ciclo SDD en su rama
- Archive → squash merge **1 commit** a `dev`
- Cada N ciclos → tag semver + merge `dev` → `main`

### Reglas clave
- **No AI attribution** en commits (prohibido Co-Authored-By)
- **Conventional Commits** con gitmoji
- **Zero tolerance** para warnings y errores

---

## 4. Estado Actual del Proyecto

### Completado

| Ciclo | Cambio | Rama | Merge a dev | Archivos |
|-------|--------|------|-------------|----------|
| [TODO] | [TODO] | [TODO] | [TODO] | [TODO] |

### Pendiente

| Ciclo | Cambio | Depende de |
|-------|--------|-----------|
| [TODO] | [TODO] | [TODO] |

---

## 5. Artefactos Engram Clave

| Artifact | Topic Key | ID |
|----------|-----------|-----|
| SDD Init | `sdd-init-[user]/[project]` | [TODO] |
| Skill Registry | `skill-registry` | [TODO] |
| [TODO] | [TODO] | [TODO] |

---

## 6. Como Arrancar

```bash
# Ver estado
git log --oneline -10

# Pararse en dev
git checkout dev

# Iniciar nuevo ciclo SDD
# 1. git checkout -b feature/<name> dev
# 2. Ejecutar el ciclo completo usando los skills SDD
# 3. Archive: squash merge a dev

# [TODO: Comandos especificos del proyecto]
```

---

## 7. Proximo Paso Recomendado

[TODO: Que se recomienda hacer a continuacion? Usar el formato de learn-golang como referencia]

---

*Template v0.3.0 — [TODO: reemplazar con fecha de ultima actualizacion]*

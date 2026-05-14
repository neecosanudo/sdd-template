# Guía de Migración: [Source] → [Target]

> **Propósito**: Documentar el proceso de migración de una tecnología a otra, incluyendo la estrategia, el mapeo de componentes, y las trampas comunes.
>
> **Completar con**: Source (tecnología origen), Target (tecnología destino), y las tablas según corresponda.

---

## 1. Estrategia de Migración

| Aspecto | Enfoque |
|---------|---------|
| **Dirección** | Bottom-Up (infraestructura primero) o Top-Down (UI primero) |
| **Granularidad** | Por capa (dominio → stores → componentes) o por feature |
| **Verificación** | Tests en cada paso vs verificación manual |
| **Rollback** | Por commit, por feature, o por release |

<!-- [TODO: Definir la estrategia específica para esta migración] -->

---

## 2. Stack

| Capa | Source | Target |
|------|--------|--------|
| **Frontend** | [TODO: framework/versión] | [TODO: framework/versión] |
| **Lenguaje** | [TODO: lenguaje] | [TODO: lenguaje] |
| **Build** | [TODO: build tool] | [TODO: build tool] |
| **Estilos** | [TODO: CSS approach] | [TODO: CSS approach] |
| **Backend** | [TODO: backend tech] | [TODO: backend tech] |
| **Base de Datos** | [TODO: DB tech] | [TODO: DB tech] |
| **Testing** | [TODO: testing tools] | [TODO: testing tools] |
| **Infra** | [TODO: infra tools] | [TODO: infra tools] |

---

## 3. Mapeo de Componentes

| Componente Source | Componente Target | API/Data | Estado |
|-------------------|-------------------|----------|--------|
| [TODO: source] | [TODO: target] | [TODO: API mapping] | ⬜ Pendiente |
| [TODO: source] | [TODO: target] | [TODO: API mapping] | ⬜ Pendiente |

---

## 4. Fases de Migración

### Fase 1: [Nombre]
<!-- [TODO: Descripción de la fase] -->

### Fase 2: [Nombre]
<!-- [TODO: Descripción de la fase] -->

### Fase 3: [Nombre]
<!-- [TODO: Descripción de la fase] -->

---

## 5. Trampas Conocidas

| Trampa | Descripción | Mitigación |
|--------|-------------|------------|
| [TODO: trampa] | [TODO: descripción] | [TODO: cómo evitarla] |
| [TODO: trampa] | [TODO: descripción] | [TODO: cómo evitarla] |

---

## 6. Checklist de Migración

- [ ] [TODO: paso de pre-migración]
- [ ] [TODO: paso de migración]
- [ ] [TODO: paso de verificación]
- [ ] [TODO: paso de limpieza]

---

> **Cómo usar este archivo**: Copiá `FROM-TO.md` a `docs/patterns/migrations/source-to-target.md` y completá los placeholders con los detalles específicos de tu migración.

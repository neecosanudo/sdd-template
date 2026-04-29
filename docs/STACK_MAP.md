# Stack Map — opinionated-stack-template

**Última actualización**: 2026-04-29
**Versión del template**: opinionated-stack-template
**Propósito**: Catálogo de herramientas con versiones exactas y matriz de compatibilidad

---

## 1. Stack Principal

| Categoría | Herramienta | Versión | Notas |
|-----------|-------------|---------|-------|
| **Backend Core** | Go | 1.25.0 | stdlib net/http, sin frameworks |
| | GORM | v1.31.1 | ORM para acceso a datos |
| | postgres driver | v1.6.0 | gorm.io/driver/postgres |
| | sqlite driver | v1.6.0 | gorm.io/driver/sqlite |
| **Backend Auth** | golang-jwt/jwt | v5.3.1 | Tokens JWT |
| | golang.org/x/crypto | v0.50.0 | bcrypt para passwords |
| **API Documentation** | swaggo/swag | v1.16.6 | Generador Swagger |
| | http-swagger | v2 | UI Swagger embebida |
| **Testing Backend** | stretchr/testify | v1.8.4 | Aserciones y mocks |
| **Frontend Principal** | SvelteKit | 2.0.0 | Framework web |
| | Svelte | 4.2.0 | Lenguaje de templates |
| | TypeScript | 5.3.3 | Tipado estático |
| | Vite | 5.0.3 | Bundler y dev server |
| | @sveltejs/adapter-static | 3.0.0 | SSG adapter |
| | @sveltejs/vite-plugin-svelte | 3.0.0 | Plugin Vite para Svelte |
| | TailwindCSS | 3.4.1 | Utility-first CSS |
| **Frontend Prototipos** | React | 19.0.0 | Solo para prototipos |
| | Vite (React) | 6.2.0 | Bundler para React |
| | TypeScript (React) | ~5.8.2 | Tipado para React |
| | @vitejs/plugin-react | ^5.0.4 | Plugin Vite para React |
| | TailwindCSS (React) | 4.1.14 | @tailwindcss/vite plugin |
| **DevOps** | Docker | multi-stage | Build + runtime separados |
| | docker-compose | — | Orquestación de contenedores |
| | PostgreSQL | 16-alpine | Producción |
| | alpine | 3.21 | Runtime base |
| **Testing Frontend** | Vitest | ^2.0.0 | Unit testing |
| | @testing-library/svelte | ^5.3.1 | Testing Svelte |
| | @testing-library/jest-dom | ^6.9.1 | Matchers DOM |
| | @playwright/test | 1.50.1 | E2E testing |

---

## 2. Matriz de Compatibilidad

### Símbolos
- ✅ **Compatible**: Verificado que funciona juntos
- ⚠️ **Compatible con advertencia**: Funciona pero hay consideraciones
- ❌ **Incompatible**: No usar juntos

### Matriz por Grupo

| Grupo | Estado | Notas de compatibilidad |
|-------|--------|----------------|
| **Backend Core** (Go + GORM + Postgres driver) | ✅ | Go 1.25.0 + v1.31.1 + v1.6.0 |
| **Backend Auth** (Go + JWT + bcrypt) | ✅ | v5.3.1 + v0.50.0 sobre Go 1.25 |
| **Frontend SvelteKit** (SvelteKit + Svelte + Vite + TS) | ✅ | 2.0.0 + 4.2.0 + 5.0.3 + 5.3.3 |
| **Frontend React** (React + Vite + TS) | ✅ | Solo para prototipos, no producción |
| **Styling SvelteKit** (TailwindCSS 3.4 + PostCSS) | ✅ | PostCSS 8 incluido via SvelteKit |
| **Styling React** (TailwindCSS 4.1 + @tailwindcss/vite) | ✅ | Plugin Vite oficial, no PostCSS |
| **Docker Backend** (Go builder + Alpine runtime) | ✅ | golang:1.25-alpine3.21 → alpine:3.21 |
| **Docker Frontend** (Bun) | ✅ | oven/bun:1-alpine para build |
| **DB Production** (PostgreSQL 16-alpine) | ✅ | GORM v1.6.0 driver compatible |
| **DB Dev** (SQLite + GORM) | ✅ | GORM v1.6.0 driver, dev/testing únicamente |

---

## 3. Decisiones Arquitectónicas Recurrentes

| # | Decisión | Descripción |
|---|----------|-------------|
| D1 | **API First** | Contrato Swagger escrito ANTES de implementar |
| D2 | **TDD Mandatorio** | RED → GREEN → REFACTOR para toda lógica de dominio |
| D3 | **Arquitectura Hexagonal** | domain/application/infrastructure con ports & adapters |
| D4 | **Documentación en Español AR** | docs/ en español, código en inglés |
| D5 | **GORM Repository Pattern** | Interfaces en domain, implementaciones en infrastructure |
| D6 | **Docker Multi-stage** | Build reproducible con usuario no-root |
| D7 | **Testing en 3 capas** | Unit (Vitest/Go test) → Integration → E2E (Playwright) |
| D8 | **Zero-Tolerance Pipeline** | go vet, staticcheck, eslint, prettier, go test -race |

---

## 4. Stack del Proyecto

### Inicialización de Nuevo Proyecto

```bash
# Backend Go
mkdir backend && cd backend
go mod init github.com/org/project/backend
go get -d gorm.io/gorm@v1.31.1
go get -d gorm.io/driver/postgres@v1.6.0
go get -d gorm.io/driver/sqlite@v1.6.0
go get -d github.com/golang-jwt/jwt/v5@v5.3.1
go get -d golang.org/x/crypto@v0.50.0
go get -d github.com/stretchr/testify@v1.8.4

# Frontend SvelteKit (principal)
npm create svelte@latest frontend -- --template skeleton --types typescript
cd frontend
npm install
npm install -D tailwindcss@3.4.1 postcss autoprefixer @tailwindcss/forms
npx svelte-add@latest tailwindcss
npm install @sveltejs/adapter-static@3.0.0

# Frontend React (prototipos únicamente)
npm create vite@latest prototype -- --template react-ts
cd prototype
npm install
npm install -D tailwindcss@4.1.14 @tailwindcss/vite @testing-library/react

# Docker
docker compose up -d
```

### Versiones Exactas por Archivo

```
go.mod:
  module github.com/org/project
  go 1.25.0
  require (
    gorm.io/gorm v1.31.1
    gorm.io/driver/postgres v1.6.0
    gorm.io/driver/sqlite v1.6.0
    github.com/golang-jwt/jwt/v5 v5.3.1
    golang.org/x/crypto v0.50.0
    github.com/stretchr/testify v1.8.4
  )

frontend/package.json (SvelteKit):
  "devDependencies": {
    "@sveltejs/adapter-static": "3.0.0",
    "@sveltejs/kit": "2.0.0",
    "@sveltejs/vite-plugin-svelte": "3.0.0",
    "svelte": "4.2.0",
    "tailwindcss": "3.4.1",
    "typescript": "5.3.3",
    "vite": "5.0.3"
  }

frontend/package.json (React prototype):
  "dependencies": {
    "react": "19.0.0",
    "react-dom": "19.0.0"
  },
  "devDependencies": {
    "@tailwindcss/vite": "4.1.14",
    "@testing-library/react": "^5.0.0",
    "@vitejs/plugin-react": "^5.0.4",
    "tailwindcss": "4.1.14",
    "typescript": "~5.8.2",
    "vite": "6.2.0"
  }
```

---

## 5. Estructura Típica de Proyecto

```
proyecto/
├── backend/                          # Go + GORM (Hexagonal)
│   ├── cmd/
│   │   └── main.go                    # Punto de entrada, wiring
│   ├── domain/
│   │   ├── entities/                  # Entidades de negocio
│   │   └── ports/                     # Interfaces (Repository, Service)
│   ├── application/
│   │   └── usecases/                 # Lógica de aplicación
│   ├── infrastructure/
│   │   └── adapters/
│   │       ├── persistence/           # GORM repositories
│   │       └── http/                  # Handlers, middleware
│   ├── docs/                          # Swagger generado
│   └── Dockerfile                     # Multi-stage
│
├── frontend/                          # SvelteKit + TailwindCSS
│   ├── src/
│   │   ├── routes/                    # Pages (+page.svelte)
│   │   ├── lib/                       # Componentes, utilidades
│   │   └── app.css                    # TailwindCSS
│   ├── static/                        # Assets estáticos
│   ├── Dockerfile                     # Multi-stage Bun
│   └── package.json
│
├── prototype/                         # React (prototipos ONLY)
│   ├── src/
│   ├── Dockerfile
│   └── package.json
│
├── docker-compose.yml                 # Orquestación completa
│
├── .atl/                             # Infrastructure del template
│   ├── governance/
│   │   └── ENGINEERING_MANIFEST.md
│   ├── standards/
│   │   ├── STYLE_GUIDE.md
│   │   ├── TESTING_STRATEGY.md
│   │   ├── WORKING_STANDARD.md
│   │   └── CICD_PIPELINE.md
│   └── patterns/
│       ├── go-hexagonal.md
│       ├── svelte-component.md
│       ├── gorm-repository.md
│       └── docker-multistage.md
│
├── docs/
│   ├── STACK_MAP.md                   # Este archivo
│   ├── tools/                         # Guías de herramientas
│   │   ├── go.md
│   │   ├── sveltekit.md
│   │   ├── react.md
│   │   ├── gorm.md
│   │   ├── docker.md
│   │   ├── postgresql.md
│   │   ├── sqlite.md
│   │   ├── tailwindcss.md
│   │   ├── swagger-openapi.md
│   │   ├── jwt-auth.md
│   │   └── testing.md
│   └── decisions/                     # ADRs
│       ├── api-first.md
│       ├── tdd.md
│       ├── hexagonal-architecture.md
│       └── spanish-language.md
│
├── Bitacora.md                        # Conversación con cliente
├── README.md                          # Entry point
└── LEARNINGS_MAP.md                   # Cross-project learnings
```

---

## 6. Stack NO Usado

| Herramienta Rechazada | Razón |
|----------------------|-------|
| **Express/Fastify** | Backend usa `net/http` stdlib + handlers directos |
| **TypeORM/Ent** | GORM v1.31.1 por su madurez y compatibilidad |
| **Next.js/Nuxt** | SvelteKit 2.0 es el framework principal |
| **Rails/Django/Laravel** | Opinionado pero no alineado con stack Go |
| **Webpack** | Vite 5.0 por velocidad de desarrollo |
| **CSS-in-JS** | TailwindCSS utility-first |
| **MySQL/MongoDB** | PostgreSQL 16 para producción, SQLite para dev |
| **Session Auth** | JWT con golang-jwt/v5 |
| **CircleCI/Travis** | GitHub Actions según CICD_PIPELINE.md |

---

## 7. Referencias Cruzadas

| Guía | Ubicación | Dependencias |
|------|-----------|--------------|
| Go toolchain | [docs/tools/go.md](tools/go.md) | STACK_MAP.md |
| SvelteKit | [docs/tools/sveltekit.md](tools/sveltekit.md) | STACK_MAP.md |
| React | [docs/tools/react.md](tools/react.md) | STACK_MAP.md, sveltekit.md |
| GORM | [docs/tools/gorm.md](tools/gorm.md) | STACK_MAP.md, go.md, postgresql.md |
| Docker | [docs/tools/docker.md](tools/docker.md) | STACK_MAP.md |
| PostgreSQL | [docs/tools/postgresql.md](tools/postgresql.md) | STACK_MAP.md, gorm.md, docker.md |
| SQLite | [docs/tools/sqlite.md](tools/sqlite.md) | STACK_MAP.md, gorm.md |
| TailwindCSS | [docs/tools/tailwindcss.md](tools/tailwindcss.md) | STACK_MAP.md, sveltekit.md, react.md |
| Swagger/OpenAPI | [docs/tools/swagger-openapi.md](tools/swagger-openapi.md) | STACK_MAP.md, go.md |
| JWT Auth | [docs/tools/jwt-auth.md](tools/jwt-auth.md) | STACK_MAP.md, go.md |
| Testing | [docs/tools/testing.md](tools/testing.md) | STACK_MAP.md, go.md, TESTING_STRATEGY.md |
| ADR: API First | [docs/decisions/api-first.md](decisions/api-first.md) | swagger-openapi.md |
| ADR: TDD | [docs/decisions/tdd.md](decisions/tdd.md) | testing.md, TESTING_STRATEGY.md |
| ADR: Hexagonal | [docs/decisions/hexagonal-architecture.md](decisions/hexagonal-architecture.md) | go-hexagonal.md |
| ADR: Spanish | [docs/decisions/spanish-language.md](decisions/spanish-language.md) | Ninguna |

---

*Este documento es la fuente de verdad para versiones y compatibilidad. Actualizar antes de agregar nuevas herramientas al stack.*

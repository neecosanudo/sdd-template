# Stack Map — kimbo (neecosanudo)

> **Fecha de mapeo**: 2026-04-29
> **Alcance**: Todos los proyectos en `/home/kimbo/projects/`
> **Metodología**: Lectura exhaustiva de archivos de configuración reales, documentación y estructura de código

---

## Lenguajes & Frameworks Core

### Go
- **Versión**: 1.25.0 (go.mod en personal-web-page)
- **Usado para**: Backend de personal-web-page (API REST, auth, uploads, blog)
- **Características**:
  - gorm.io/gorm v1.31.1 (ORM)
  - gorm.io/driver/postgres v1.6.0 (PostgreSQL)
  - gorm.io/driver/sqlite v1.6.0 (SQLite para dev)
  - github.com/golang-jwt/jwt/v5 v5.3.1 (JWT auth)
  - github.com/aws/aws-sdk-go-v2 v1.41.6 (S3/MinIO)
  - golang.org/x/crypto v0.50.0 (bcrypt)
  - github.com/swaggo/swag v1.16.6 + http-swagger/v2 (Swagger/OpenAPI)
  - github.com/stretchr/testify v1.8.4 (testing)

### TypeScript
- **Versión**: 5.3.3 (personal-web-page frontend), ~5.8.2 (agenda)
- **Usado para**: Frontend SvelteKit y React, tipado estático

### Svelte / SvelteKit
- **Versión**: Svelte 4.2.0, SvelteKit 2.0.0 (personal-web-page)
- **Usado para**: Frontend de personal-web-page (blog, admin panel)
- **Dependencias clave**:
  - @sveltejs/adapter-static 3.0.0
  - @sveltejs/vite-plugin-svelte 3.0.0
  - @tiptap/core ^2.10.4 (rich text editor)
  - svelte-dnd-action ^0.9.69 (drag & drop)
  - tailwindcss 3.4.1

### React
- **Versión**: 19.0.0 (agenda)
- **Usado para**: Frontend de agenda (Cronos - Gestor de Tiempo)
- **Dependencias clave**:
  - @vitejs/plugin-react ^5.0.4
  - framer-motion ^12.38.0 (animaciones)
  - lucide-react ^0.546.0 (iconos)
  - date-fns ^4.1.0 (fechas)
  - clsx ^2.1.1 + tailwind-merge ^3.5.0

---

## Herramientas de Build & Dev

### Vite
- **Versión**: 5.0.3 (personal-web-page SvelteKit), 6.2.0 (agenda React)
- **Config**:
  - personal-web-page: `vite.config.ts` con proxy a backend (`/api`, `/health`, `/swagger`)
  - agenda: `vite.config.ts` con plugins React + TailwindCSS v4, HMR configurable via `DISABLE_HMR`

### Bun
- **Versión**: 1-alpine (Docker)
- **Usado para**: Runtime de frontend en Docker (personal-web-page)
- **Comandos**: `bun run dev`, `bun run build`, `bun run preview`

### Node.js
- **Versión requerida**: >=22.14.0 (personal-web-page), no especificado (agenda)
- **Package managers**: npm (package-lock.json presente)

### Go Tools
- **go vet**: Linting estático
- **gofmt**: Formateo automático
- **govulncheck**: Análisis de vulnerabilidades (en CI)

---

## Base de Datos & ORM

### PostgreSQL
- **Versión**: 16-alpine (Docker)
- **Uso**: Producción y desarrollo (personal-web-page)
- **Driver**: gorm.io/driver/postgres v1.6.0
- **Config**: `postgres://app:app@postgres:5432/app?sslmode=disable`

### SQLite
- **Uso**: Desarrollo local (alternativa a PostgreSQL)
- **Driver**: gorm.io/driver/sqlite v1.6.0 (requiere CGO)
- **Config**: `file:./data/app.db?cache=shared&_journal_mode=WAL`

### GORM (ORM)
- **Versión**: v1.31.1
- **Características**:
  - Auto-migraciones
  - gorm.io/datatypes v1.2.7 (tipos de datos especiales)
  - Soporte para múltiples dialectos

### Migraciones
- **Ubicación**: `backend/migrations/` (personal-web-page)
- **Formato**: SQL plano (ej: `001_create_content_table.sql`)

---

## Frontend Stack

### personal-web-page
- **Framework**: SvelteKit 2.0.0
- **Styling**: TailwindCSS 3.4.1 + PostCSS + Autoprefixer
- **Rich Text**: Tiptap ^2.10.4 (BlockEditor personalizado)
- **Build**: Vite 5.0.3 con @sveltejs/vite-plugin-svelte 3.0.0
- **Adapter**: @sveltejs/adapter-static 3.0.0 (SSG/SSR según ruta)
- **State**: Svelte stores (`lib/stores/`)
- **Routing**: File-based routing de SvelteKit
- **Estructura**:
  ```
  frontend/src/
  ├── lib/           # Componentes, stores, tipos, utilidades
  │   ├── api/       # Cliente API
  │   ├── components/# Organisms, admin, UI
  │   ├── stores/    # Svelte stores
  │   └── types/     # TypeScript types
  ├── routes/        # SvelteKit routes (public, admin)
  └── tests/         # Tests unitarios
  ```

### agenda (Cronos)
- **Framework**: React 19.0.0
- **Styling**: TailwindCSS 4.1.14 (v4 con @tailwindcss/vite plugin)
- **Animation**: Framer Motion ^12.38.0
- **Icons**: Lucide React ^0.546.0
- **Build**: Vite 6.2.0 con React plugin
- **Estructura**:
  ```
  src/
  ├── components/     # UI components (Backlog, Timeline, Forms)
  │   └── ui/        # Base UI (Button, Input, Modal, Dropdown)
  ├── lib/           # Utilidades
  ├── App.tsx        # Root component
  └── main.tsx       # Entry point
  ```

---

## Backend Stack

### personal-web-page (Go)
- **Framework**: net/http estándar (sin framework de terceros)
- **Arquitectura**: Hexagonal (Ports & Adapters)
  ```
  backend/
  ├── cmd/server/     # Entry point (main.go)
  ├── internal/
  │   ├── adapter/   # Adapters (GORM)
  │   ├── api/       # API contracts/DTOs
  │   ├── config/    # Configuration loading
  │   ├── database/  # DB connection
  │   ├── domain/    # Domain logic (PURE)
  │   ├── handler/   # HTTP handlers
  │   ├── middleware/ # Middleware (CORS, rate limiting, auth)
  │   ├── repository/# Repository interfaces/impl
  │   ├── service/   # Business logic services
  │   └── testutil/  # Test utilities (test DB, auth helpers)
  ├── pkg/
  │   ├── database/  # DB utilities
  │   └── s3/        # S3/MinIO client
  └── migrations/     # SQL migrations
  ```
- **Routing**: `internal/router/` (configuración de rutas)
- **Middleware**:
  - CORS (configurable vía `CORS_ALLOWED_ORIGINS`)
  - Rate limiting (`RATE_LIMIT_REQ`, `RATE_LIMIT_WINDOW`)
  - Auth (JWT via `Authorization: Bearer`)
  - Security headers (CSP)
  - Body size limit (`MAX_BODY_SIZE`)
- **Auth**:
  - JWT (golang-jwt/jwt/v5)
  - bcrypt para passwords (golang.org/x/crypto/bcrypt)
  - Login lockout (`MAX_FAILED_LOGINS`, `LOGIN_LOCKOUT_DURATION`)
- **Object Storage**:
  - AWS SDK v2 para S3-compatible (MinIO local, Cloudflare R2 prod)
  - Endpoints configurables vía `R2_ENDPOINT`, `R2_BUCKET_NAME`
- **Swagger/OpenAPI**:
  - swag v1.16.6 + http-swagger/v2
  - Documentación en código (// @title, // @route...)
  - Swagger UI en `/swagger/index.html`

### agenda (Express)
- **Framework**: Express ^4.21.2
- **Uso**: Probablemente API backend para Cronos (pendiente de desarrollo)
- **TypeScript**: Configurado con @types/express
- **Runtime**: Node.js con tsx para ejecución directa

---

## DevOps & Infra

### Docker
- **personal-web-page**:
  - **Frontend**: `Dockerfile` multi-stage
    - Stage 1: `oven/bun:1-alpine` (development) - live reload
    - Stage 2: `oven/bun:1-alpine` (build) - `bun run build`
    - Stage 3: `oven/bun:1-alpine` (production) - `bun run preview`
  - **Backend**: `backend/Dockerfile` multi-stage
    - Stage 1: `golang:1.25-alpine3.21` (builder) - CGO_ENABLED=1 (sqlite)
    - Stage 2: `alpine:3.21` (runtime) - non-root user (UID 1000)
  - **Compose**: `docker-compose.yml`
    - Services: frontend (bun dev), backend (Go binary), postgres:16-alpine, minio (S3-compatible)
    - Healthchecks configurados
    - Volumes: `pgdata`, `minio_data`
  - **Imágenes**:
    - `oven/bun:1-alpine`
    - `golang:1.25-alpine3.21`
    - `postgres:16-alpine`
    - `quay.io/minio/minio:RELEASE.2025-09-07T16-13-09Z`

### GitHub Actions (CI)
- **personal-web-page** (`.github/workflows/ci.yml`):
  - **Go Version**: 1.23 (en CI, aunque local es 1.25.0)
  - **CGO_ENABLED**: 0 (en CI, aunque local requiere 1 para sqlite)
  - **Jobs**:
    1. `vet`: `go vet ./...`
    2. `test`: `go test ./... -count=1 -cover`
    3. `build`: `go build ./...`
    4. `security`: `govulncheck ./...`
  - **Triggers**: push/PR a `main` y `dev`

### Environment Management
- **personal-web-page**:
  - `.env.example` comprehensivo con todos los parámetros
  - Variables separadas por secciones: Server, App Env, Database, JWT, Auth Policy, Rate Limiting, Request Limits, S3 Storage
  - `APP_ENV`: `development` | `production`
  - Configuración cargada vía `internal/config/`

---

## Testing

### Estrategia General
- **TDD Mandatorio**: "No business logic code is accepted without a corresponding test suite" (ENGINEERING_MANIFEST.md)
- **Ciclo**: RED → GREEN → REFACTOR (obligatorio)
- **Cobertura objetivo**: 100% por paquete en lógica de dominio

### Frontend Testing (personal-web-page)
- **Framework**: Vitest ^2.0.0
- **Librerías**:
  - @testing-library/svelte ^5.3.1
  - @testing-library/jest-dom ^6.9.1
  - @vitest/ui ^2.0.0
  - @vitest/coverage-v8 ^2.0.0
- **Environment**: happy-dom ^20.9.0 (unit), jsdom ^29.0.2 (E2E)
- **Comandos**:
  - `npm run test` (vitest)
  - `npm run test:ui` (vitest --ui)
  - `npm run test:coverage` (vitest --coverage)
  - `npm run test:e2e` (playwright test)
- **E2E**: @playwright/test 1.50.1 (Chromium only, Firefox/WebKit pending)
- **Config**: `vitest.config.ts` con environment happy-dom, coverage reporters: text, json, html

### Backend Testing (personal-web-page)
- **Framework**: Go testing (stdlib)
- **Librería**: github.com/stretchr/testify v1.8.4 (assertions, mocks)
- **Comandos**:
  - `go test ./... -count=1` (run tests)
  - `go test -cover ./...` (coverage)
- **Test Utilities**: `internal/testutil/`
  - `NewTestDB()` - SQLite en memoria por test
  - Auth helpers para tests protegidos
  - Server test helpers
- **Integration Tests**: `internal/integration/` (tests end-to-end de API)
- **Estructura**: Un archivo `*_test.go` por cada archivo de implementación

### Testing en otros proyectos
- **agenda**: Solo `tsc --noEmit` como linting (NO hay tests configurados)
- **suite/**: Sin configuración de testing (proyectos vacíos o planeados)

---

## Documentación

### Idioma
- **Principal**: Español (AR) - decidido por ADR 0001 (personal-web-page)
- **Términos técnicos**: En inglés (backend, Golang, Docker, Svelte)
- **Justificación**: Audiencia objetivo hispanohablante, autor argentino

### Estructura de Documentación
- **Bitacora.md** (raíz): Conversación continua user-agent
- **docs/adr/**: Architecture Decision Records (formato `NNNN-name.md`)
  - ADR 0001: Idioma del Proyecto (Español AR)
  - ADR 0002: Convención de Commits (Gitmoji + Conventional)
- **docs/LEARNINGS_MAP.md**: Aprendizajes transversales entre proyectos
- **.atl/**: Infraestructura de gobernanza
  - `governance/`: Manifesto, commits, contribución, versioning
  - `standards/`: Style guide, testing, CI/CD, working standard
  - `patterns/`: Patrones de ingeniería agnósticos
  - `agent/`: Comportamiento de agentes IA
  - `decisions/`: Decision log
  - `specs/`: Navegación y gobernanza

### APIs & Contratos
- **Swagger/OpenAPI**: swag v1.16.6 + http-swagger/v2
  - Documentación en código fuente (Go comments)
  - Swagger UI disponible en `/swagger/index.html`
  - Contrato es "ley": validación en boundaries

### Contributing & Guidelines
- **CONTRIBUTING.md**: Estrategia GitFlow ligero, conventional commits, PR workflow
- **commitlint.config.js**: Enforcement de conventional commits (feat, fix, docs, etc.)
- **.githooks/commit-msg**: Enforcement de Gitmoji + Conventional Commits
- **Gitmojis**: :art:, :bug:, :memo:, :nail_care:, :fire:, :white_check_mark:, :wrench:, :zap:, :rocket:, etc.

---

## Metodología & Workflow

### Spec-Driven Development (SDD)
- **Ciclo**: Explore → Propose → Spec → Design → Tasks → Apply → Verify (until OK) → Archive
- **Batch-Verify**: Verificación single-pass (todo pasa o nada se commitea)
- **Iteración**: Si verify falla → volver a fase apropiada → re-verify
- **Discovery-First**: No SDD sin descubrimiento previo (Regla #8)
- **Default Modes** (ENGINEERING_MANIFEST.md):
  - Persistence: `hybrid` (Engram + openspec)
  - Execution: `interactive` (pausas entre fases)
  - Tasks: `synchronous` (sin delegación)

### Branching Strategy (GitFlow Ligero)
- **Ramas principales**:
  - `main`: Producción (protegida)
  - `dev`: Integración (protegida)
- **Ramas de feature**:
  - `feature/` - Nuevas funcionalidades
  - `fix/` - Corrección de bugs
  - `hotfix/` - Correcciones urgentes
  - `release/` - Preparación de release
- **Commits**: Conventional Commits + Gitmoji
  - Formato: `:emoji: type(scope): description`
  - Tipos: feat, fix, docs, style, refactor, test, chore, ci, perf, build, revert

### ADRs (Architecture Decision Records)
- **Ubicación**: `docs/adr/NNNN-name.md`
- **Cuándo**: Cambios estructurales, stack, patrones, flujos de datos significativos
- **Formato**: Estado, Contexto, Decisión, Justificación, Consecuencias, Fecha
- **Regla**: Prohibido proponer cambios estructurales sin ADR previo

---

## Decisiones Arquitectónicas Recurrentes

1. **Hexagonal Architecture (Ports & Adapters)** — evidenciado en personal-web-page
   - Domain logic desacoplada de frameworks, BD, agentes externos
   - Interfaces en domain, implementaciones en adapters
   - Evidencia: `internal/domain/`, `internal/adapter/`, `internal/service/`

2. **TDD Mandatorio** — evidenciado en personal-web-page y .atl/standards/
   - 100% coverage en lógica de dominio
   - Ciclo RED-GREEN-REFACTOR obligatorio
   - Tests antes o simultáneos al código

3. **Security by Design** — evidenciado en múltiples .atl/standards/
   - Least Privilege (containers non-root, API keys scoped)
   - Input Validation (never trust, schema validation en boundaries)
   - Security-First Refactoring (nunca skippear security)

4. **API First / Contract-Driven** — evidenciado en personal-web-page
   - Swagger/OpenAPI como contrato (la ley)
   - Validación automática en pipeline CI
   - Documentación en código

5. **Discovery-First (Rule #8)** — evidenciado en ENGINEERING_MANIFEST.md
   - Fase de descubrimiento ANTES de cualquier ciclo SDD
   - Alcance acordado por escrito
   - Documentación en Bitacora.md + docs/

6. **Documentation in Spanish (AR)** — evidenciado por ADR 0001
   - Todo: comentarios, docs, commits (descriptions)
   - Términos técnicos en inglés preservados

7. **Memory Alignment & Performance** — evidenciado en .atl/patterns/
   - Ordenar campos de structs de mayor a menor footprint
   - Mejor cache locality, reducción de padding

8. **Dependency Inversion** — evidenciado en arquitectura hexagonal
   - Lógica de alto nivel no depende de bajo nivel
   - Inyección de dependencias para testabilidad

---

## Patrones Transversales

### 1. Conventional Commits + Gitmoji
- **Formato**: `:emoji: type(scope): description`
- **Enforcement**: commitlint.config.js + .githooks/commit-msg
- **Proyectos**: personal-web-page (implementado), sdd-template (documentado como template)

### 2. .atl/ Governance Structure
- **Estructura**: governance/, standards/, patterns/, agent/, decisions/, specs/
- **Proyectos**: personal-web-page (completo), sdd-template (template), components-designer (vacío), low-iq-code/godot-tetris-minimalist (completo)

### 3. Docker Multi-Stage Builds
- **Frontend**: Bun/Node build → producción mínima
- **Backend**: Go build con CGO → Alpine runtime + non-root user
- **Proyectos**: personal-web-page (implementado)

### 4. Clean Code Principles
- **KISS**: Keep It Simple, Stupid
- **YAGNI**: You Ain't Gonna Need It
- **SOLID**: Especialmente para desacoplamiento
- **Proyectos**: personal-web-page (documentado en STYLE_GUIDE.md)

### 5. Naming Conventions
- **Go**: MixedCaps (exports), camelCase (privados)
- **TypeScript/Svelte**: camelCase (vars/funcs), PascalCase (components), SCREAMING_SNAKE_CASE (constantes)
- **Archivos**: kebab-case (Svelte), camelCase (utilities)
- **Regla Universal**: Nombres descriptivos sobre abreviaturas
- **Proyectos**: personal-web-page (documentado), agenda (seguido en código)

---

## Versiones Compatibles (Matriz)

| Componente | Versión | Compatible con | Notas |
|------------|---------|----------------|-------|
| **Go** | 1.25.0 | personal-web-page | En CI usan 1.23, local 1.25.0 |
| **Svelte** | 4.2.0 | personal-web-page | |
| **SvelteKit** | 2.0.0 | personal-web-page | |
| **TypeScript** | 5.3.3 | personal-web-page (SvelteKit) | |
| **TypeScript** | ~5.8.2 | agenda (React) | |
| **Vite** | 5.0.3 | personal-web-page (SvelteKit) | |
| **Vite** | 6.2.0 | agenda (React) | |
| **React** | 19.0.0 | agenda | |
| **TailwindCSS** | 3.4.1 | personal-web-page | |
| **TailwindCSS** | 4.1.14 | agenda | v4 con plugin Vite específico |
| **Node.js** | >=22.14.0 | personal-web-page | |
| **Bun** | 1-alpine | personal-web-page (Docker) | |
| **PostgreSQL** | 16-alpine | personal-web-page | |
| **GORM** | v1.31.1 | personal-web-page | |
| **Vitest** | ^2.0.0 | personal-web-page | |
| **Playwright** | 1.50.1 | personal-web-page | Chromium only |
| **Express** | ^4.21.2 | agenda | |
| **Godot** | No especificado | low-iq-code/godot-tetris-minimalist | Juego, no web |

---

## Estructura Típica de Proyecto (con .atl/)

```
project-root/
├── .atl/                          # SDD Governance Infrastructure
│   ├── agent/                     # Agent behavior rules (AGENT_BEHAVIOR.md)
│   ├── decisions/                 # Decision log (DECISION_LOG.md)
│   ├── governance/                # Project manifesto, commit conventions, versioning
│   │   ├── ENGINEERING_MANIFEST.md
│   │   ├── COMMIT_CONVENTIONS.md
│   │   ├── CONTRIBUTING.md
│   │   └── VERSIONING.md
│   ├── patterns/                  # Engineering patterns
│   │   ├── go-hexagonal.md
│   │   ├── svelte-component.md
│   │   └── ...
│   ├── specs/                     # SDD specs (navigation, governance)
│   │   └── navigation.spec.md
│   └── standards/                 # Style, Testing, Security, CI/CD, Working Standard
│       ├── STYLE_GUIDE.md
│       ├── TESTING_STRATEGY.md
│       ├── CICD_PIPELINE.md
│       ├── RELEASE_AND_RUN.md
│       └── WORKING_STANDARD.md
├── .githooks/                    # Git hooks (commit-msg para Gitmoji)
├── .github/                       # GitHub workflows (CI)
│   └── workflows/
│       └── ci.yml
├── docs/                          # Product-specific documentation
│   ├── adr/                       # Architecture Decision Records
│   │   ├── 0001-project-language.md
│   │   └── 0002-commit-convention.md
│   ├── LEARNINGS_MAP.md           # Cross-project learnings (per-project)
│   └── branching-strategy.md
├── Bitacora.md                    # Conversation log (user-agent)
├── CONTRIBUTING.md                # Contribution guidelines
├── README.md                      # Project documentation
├── docker-compose.yml             # Docker infrastructure (si aplica)
├── Dockerfile                     # Multi-stage build (si aplica)
├── .env.example                   # Environment variables template
├── commitlint.config.js           # Commit convention enforcement
├── frontend/                      # SvelteKit/React frontend (si aplica)
│   ├── src/
│   ├── package.json
│   ├── tsconfig.json
│   ├── vite.config.ts
│   └── vitest.config.ts
└── backend/                       # Go backend (si aplica)
    ├── cmd/server/                # Entry point
    ├── internal/                  # Private application code
    │   ├── adapter/               # Adapters (GORM, external services)
    │   ├── domain/                # Domain logic (PURE)
    │   ├── service/               # Business logic
    │   ├── repository/            # Data access interfaces/impl
    │   ├── handler/               # HTTP handlers
    │   ├── middleware/             # HTTP middleware
    │   ├── config/                # Configuration
    │   ├── api/                   # API contracts/DTOs
    │   ├── database/              # DB connection
    │   └── testutil/              # Test utilities
    ├── pkg/                       # Public packages
    │   ├── database/
    │   └── s3/
    ├── migrations/                # SQL migrations
    └── go.mod
```

**Nota**: Esta estructura es la "ideal" documentada en sdd-template. Solo personal-web-page la cumple completamente. Los otros proyectos están en diversos estados de adopción.

---

## Resumen de Proyectos

### personal-web-page (Completo, Producción-Ready)
- **Stack**: Go 1.25.0 + SvelteKit 2.0.0 + PostgreSQL 16 + Docker
- **Estado**: .atl/ completo, testing completo, CI configurado, Docker infrastructure
- **Características**: Blog, auth JWT, uploads S3/MinIO, admin panel, Swagger docs

### agenda / Cronos (En Desarrollo)
- **Stack**: React 19.0.0 + Vite 6.2.0 + TailwindCSS 4.1.14 + Express + Google AI SDK
- **Estado**: Generado desde AI Studio, estructura básica, SIN .atl/, SIN tests
- **Características**: Gestor de tiempo, agenda, moldes de eventos, rutinas dinámicas

### suite/sdd-template (Template)
- **Stack**: Go 1.25.0 mencionado, pero es template de infraestructura
- **Estado**: .atl/ completo, documentación completa, NO es código ejecutable
- **Propósito**: Template para nuevos proyectos con SDD

### suite/components-designer (Planificado/Vacío)
- **Stack Planeado**: Wails + Svelte (según ADR 0001, pero archivo vacío)
- **Estado**: .atl/ structure creada, pero SIN código, SIN wails.json
- **Nota**: Probablemente migrado o renombrado

### suite/api-document (Vacío)
- **Estado**: Directorio completamente vacío, sin archivos
- **Nota**: Proyecto no iniciado

### low-iq-code/godot-tetris-minimalist (Game Dev)
- **Stack**: Godot (juego Tetris)
- **Estado**: .atl/ completo, openspec/ con specs de Tetris
- **Características**: NO es web, es desarrollo de videojuegos

---

## Herramientas NO Usadas (Evidenciadas)

- **NO Rust, Python, Java**: Solo Go y TypeScript/JavaScript
- **NO Next.js, Nuxt, Angular**: Solo SvelteKit y React (Vite)
- **NO Prisma, Sequelize**: Solo GORM
- **NO Kubernetes**: Solo Docker + docker-compose
- **NO Turborepo, Nx**: Sin monorepo tools
- **NO pnpm, yarn**: npm (package-lock.json)
- **NO ESLint en agenda**: Solo tsc --noEmit
- **NO tests en agenda**: Falta configurar Vitest o Jest

---

## Conclusión

El usuario **kimbo** tiene un stack enfocado en:
1. **Go** para backends con arquitectura hexagonal
2. **SvelteKit** (preferido) y **React** (para prototipos rápidos con AI Studio)
3. **TypeScript** como lenguaje estándar frontend
4. **PostgreSQL** + **GORM** para persistencia
5. **Docker** + **GitHub Actions** para DevOps
6. **SDD (Spec-Driven Development)** como metodología con infraestructura `.atl/`
7. **TDD mandatorio** con 100% coverage en lógica de dominio
8. **Documentación en Español (AR)** con convenciones Gitmoji + Conventional Commits

La madurez técnica es **alta** en personal-web-page (proyecto principal), **media** en agenda (recién iniciado), y **template** en suite/ (sdd-template como base para futuros proyectos).

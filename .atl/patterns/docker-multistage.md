# Patrón: Docker Multi-Stage Build

**Pattern ID**: docker-multistage
**Versión**: 1.0
**dependencias**: [docker.md](../../docs/tools/docker.md) | [postgresql.md](../../docs/tools/postgresql.md) | [go.md](../../docs/tools/go.md)

---

## 1. Concepto y Beneficios

```
┌─────────────────────────────────────────────────────────────────┐
│                    MULTI-STAGE BUILD                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Stage 1: Builder                                                │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │ FROM golang:1.25-alpine3.21                             │     │
│  │ [toolchain completo, git, certificados]                  │     │
│  │                                                          │     │
│  │ COPY go.mod go.sum                                      │     │
│  │ RUN go mod download                                     │     │
│  │                                                          │     │
│  │ COPY . .                                                 │     │
│  │ RUN go build -o binary ./cmd/main.go                    │     │
│  └─────────────────────────────────────────────────────────┘     │
│                           │                                     │
│                           │ copy binary only                     │
│                           ▼                                     │
│  Stage 2: Runtime                                                │
│  ┌─────────────────────────────────────────────────────────┐     │
│  │ FROM alpine:3.21                                        │     │
│  │ [mínimo: ca-certificates, usuario non-root]             │     │
│  │                                                          │     │
│  │ COPY --from=builder /build/binary /usr/local/bin/       │     │
│  │ EXPOSE 8080                                             │     │
│  │ ENTRYPOINT ["/usr/local/bin/binary"]                   │     │
│  └─────────────────────────────────────────────────────────┘     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Beneficios**:
- Imagen final pequeña (alpine base ~5MB vs golang ~800MB)
- Sin toolchain de build en producción
- Reducción de superficie de ataque

---

## 2. Dockerfile Go Multi-Stage Completo

```dockerfile
# Etapa 1: Builder
# Usar imagen específica de alpine para mejor compatibilidad
FROM golang:1.25-alpine3.21 AS builder

# Instalar dependencias necesarias para build
RUN apk add --no-cache \
    git \
    ca-certificates \
    tzdata

WORKDIR /build

# Copiar módulos (Layer cache friendly)
COPY go.mod go.sum ./
RUN go mod download

# Copiar código fuente
COPY . .

# Build con optimization flags
# CGO_ENABLED=0: static binary, no cgo dependencies
# -w -s: strip debug symbols, smaller binary
RUN CGO_ENABLED=0 GOOS=linux \
    go build \
    -ldflags='-w -s' \
    -o server \
    ./cmd/main.go

# Verificar que el binary se creó
RUN file server

# Etapa 2: Runtime (minimal)
FROM alpine:3.21 AS runtime

# Instalar runtime dependencies
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    && addgroup -g 1000 app \
    && adduser -u 1000 -G app -s /bin/sh -D app

WORKDIR /home/app

# Copiar binary y certificados desde builder
COPY --from=builder /build/server .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Usuario non-root (security)
USER app

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Puerto
EXPOSE 8080

ENTRYPOINT ["./server"]
```

---

## 3. Dockerfile Frontend Bun Multi-Stage

```dockerfile
# Etapa 1: Builder
FROM oven/bun:1-alpine AS builder

WORKDIR /app

# Copiar package files primero (cache layer)
COPY package*.json ./

# Instalar dependencias (frozen lockfile)
RUN bun install --frozen-lockfile

# Copiar source
COPY . .

# Build para producción
RUN bun run build

# Verificar build output
RUN ls -la build/

# Etapa 2: Runtime (nginx serving static)
FROM alpine:3.21 AS runtime

# Instalar nginx
RUN apk add --no-cache nginx

# Copiar build output
COPY --from=builder /app/build /var/www/html

# Copiar nginx config
COPY nginx.conf /etc/nginx/http.d/default.conf

# Permisos
RUN addgroup -g 1000 app && \
    adduser -u 1000 -G app -s /bin/sh -D app && \
    chown -R app:app /var/www/html /etc/nginx/http.d

USER app

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf

```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.html;

    # SPA routing - todas las rutas a index.html
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
}
```

---

## 4. docker-compose.yml Completo

```yaml
services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: backend
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgres://postgres:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}?sslmode=disable
      - JWT_SECRET=${JWT_SECRET}
      - APP_ENV=production
    depends_on:
      postgres:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
    networks:
      - internal

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: frontend
    ports:
      - "3000:80"
    depends_on:
      - backend
    restart: unless-stopped
    networks:
      - internal

  postgres:
    image: postgres:16-alpine
    container_name: postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d ${POSTGRES_DB}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - internal

networks:
  internal:
    driver: bridge

volumes:
  postgres_data:
```

### .env file

```bash
# .env (NO hacer commit)
POSTGRES_PASSWORD=your-secure-password
POSTGRES_DB=mydb
JWT_SECRET=your-256-bit-secret-key-here
```

---

## 5. Buenas Prácticas

### Usuario Non-Root

```dockerfile
# Crear usuario SIN privilegios de root
RUN addgroup -g 1000 app && \
    adduser -u 1000 -G app -s /bin/sh -D app

# Usar el usuario para todo
USER app
```

### HEALTHCHECK

```dockerfile
# Backend HTTP
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Backend sin HTTP (solo proceso)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD kill -0 || exit 1

# PostgreSQL
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
```

### .dockerignore

```
# Version control
.git
.gitignore

# Documentation
*.md
docs/

# Development files
.env*
docker-compose*.yml

# Tests
*_test.go
**/*_test.go
tests/
*.test.ts
*.spec.ts

# IDE
.idea/
.vscode/

# OS
.DS_Store
Thumbs.db

# Build artifacts (reconstruir siempre)
bin/
dist/
build/
```

### Certificados CA para HTTPS

```dockerfile
# Install certificates in runtime
FROM alpine:3.21
RUN apk add --no-cache ca-certificates

# Copy from builder
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
```

---

## 6. Comandos Útiles

```bash
# Build sin cache
docker build --no-cache -t myapp:backend ./backend

# Build con target específico
docker build --target runtime -t myapp:backend ./backend

# Ver imágenes resultantes
docker images | grep myapp

# Ver tamaño de imagen
docker history myapp:backend

# Limpiar build cache
docker builder prune

# Multi-platform build
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    -t myapp:latest \
    --push \
    .
```

---

## 7. Referencias

- [docker.md](../../docs/tools/docker.md) — Guía completa
- [postgresql.md](../../docs/tools/postgresql.md) — PostgreSQL config
- [go.md](../../docs/tools/go.md) — Go toolchain

---

*Multi-stage es mandatorio. Runtime NUNCA incluye toolchain de build.*

# Docker — Contenedores y Orquestación

**Imágenes Base**: alpine:3.21, golang:1.25-alpine3.21, oven/bun:1-alpine
**Orquestación**: docker-compose
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [docker-multistage.md](../../.atl/patterns/docker-multistage.md) | [postgresql.md](postgresql.md)

---

## 1. Docker Multi-Stage para Go Backend

### Dockerfile Backend Completo

```dockerfile
# Etapa 1: Builder
FROM golang:1.25-alpine3.21 AS builder

# Instalar dependencias de build
RUN apk add --no-cache git ca-certificates

WORKDIR /build

# Copiar módulos
COPY go.mod go.sum ./
RUN go mod download

# Copiar código
COPY . .

# Build binario
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags='-w -s' \
    -o server \
    ./cmd/main.go

# Etapa 2: Runtime
FROM alpine:3.21 AS runtime

# Instalar certificados y usuario non-root
RUN apk add --no-cache ca-certificates tzdata \
    && addgroup -g 1000 app \
    && adduser -u 1000 -G app -s /bin/sh -D app

WORKDIR /home/app

# Copiar binario y certificados
COPY --from=builder /build/server .
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Usuario non-root
USER app

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Puerto y entrypoint
EXPOSE 8080

ENTRYPOINT ["./server"]
```

### .dockerignore (Backend)

```
# Archivos innecesarios
.git
.gitignore
*.md
docs/
tests/
*_test.go
Makefile
docker-compose.yml
.env*
```

---

## 2. Dockerfile Frontend con Bun

```dockerfile
# Etapa 1: Builder
FROM oven/bun:1-alpine AS builder

WORKDIR /app

# Copiar package files
COPY package*.json ./

# Instalar dependencias
RUN bun install --frozen-lockfile

# Copiar código
COPY . .

# Build
RUN bun run build

# Etapa 2: Runtime (serve estático)
FROM alpine:3.21 AS runtime

RUN apk add --no-cache nginx

# Copiar build output
COPY --from=builder /app/build /var/www/html
COPY nginx.conf /etc/nginx/http.d/default.conf

# Usuario non-root
RUN addgroup -g 1000 app && \
    adduser -u 1000 -G app -s /bin/sh -D app

RUN chown -R app:app /var/www/html /etc/nginx/http.d
USER app

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf

```nginx
server {
    listen 80;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

---

## 3. docker-compose.yml

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
      - DATABASE_URL=postgres://postgres:secret@postgres:5432/mydb?sslmode=disable
      - JWT_SECRET=${JWT_SECRET}
      - NODE_ENV=production
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

  postgres:
    image: postgres:16-alpine
    container_name: postgres
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

---

## 4. Buenas Prácticas

### Usuario Non-Root

```dockerfile
# Crear usuario antes de copiar código
RUN addgroup -g 1000 app && \
    adduser -u 1000 -G app -s /bin/sh -D app

USER app  # Usar siempre el usuario no-root
```

### HEALTHCHECK

```dockerfile
# Backend (wget o curl)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Postgres (pg_isready)
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
```

### Multi-Stage

```dockerfile
# ✅ CORRECTO: Multi-stage reduce tamaño final
FROM golang:1.25 AS builder
# ... build ...

FROM alpine:3.21 AS runtime
# Solo el binario, no el toolchain

# ❌ INCORRECTO: No usar golang:alpine como runtime
FROM golang:1.25-alpine
# Toolchain innecesario en producción
```

### Certificados CA

```dockerfile
# Instalar certificados para HTTPS
RUN apk add --no-cache ca-certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
```

---

## 5. Comandos Esenciales

```bash
# Desarrollo
docker compose up              # Crear y levantar
docker compose up -d            # Detached mode
docker compose logs -f backend  # Ver logs

# Rebuild
docker compose build            # Reconstruir imágenes
docker compose build --no-cache # Sin cache

# Limpieza
docker compose down -v          # Detener y eliminar volúmenes
docker compose down --rmi local # Eliminar imágenes locales

# Debug
docker compose exec backend sh  # Shell en contenedor
docker compose ps              # Estado de contenedores
```

---

## 6. Variables de Entorno

| Variable | Propósito | Ejemplo |
|----------|-----------|---------|
| `DATABASE_URL` | Connection string PostgreSQL | `postgres://user:pass@host:5432/db` |
| `JWT_SECRET` | Secreto para JWT | `$(openssl rand -hex 32)` |
| `PORT` | Puerto del servidor | `8080` |

---

## 7. Referencias

- [docker-multistage.md](../../.atl/patterns/docker-multistage.md) — Patrón completo
- [postgresql.md](postgresql.md) — Configuración PostgreSQL
- [STACK_MAP.md](../STACK_MAP.md) — Versiones de imágenes

---

*Docker multi-stage es obligatorio. El runtime NUNCA debe incluir el toolchain de build.*

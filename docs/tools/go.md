# Go — Herramienta y Convenciones

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Herramienta**: `go` (stdlib)
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [testing.md](testing.md) | [jwt-auth.md](jwt-auth.md) | [STYLE_GUIDE.md](../../.atl/standards/STYLE_GUIDE.md)

---

## 1. Verificación de Versión

```bash
go version
# Output esperado: go version go1.25.0 linux/amd64
```

---

## 2. Toolchain Esencial

| Comando | Propósito | Cuándo Usar |
|---------|-----------|-------------|
| `go fmt` | Formatea código | Siempre antes de commit |
| `go vet` | Análisis estático | Pre-commit, CI |
| `go test` | Ejecuta tests | Durante desarrollo, CI |
| `go build` | Compila binario | Pre-deploy, CI |
| `go mod tidy` | Limpia deps | Después de agregar/quitar imports |
| `govulncheck` | Vulnerabilidades | Pre-release, CI |

### Ejemplo de Uso en Pipeline

```bash
# Pipeline local (pre-commit)
go fmt ./...
go vet ./...
go test ./... -v -cover -race

# Pipeline CI/CD
go mod download
go build -o bin/server ./cmd/main.go
govulncheck ./...
```

---

## 3. Convenciones de Código

### Nomenclatura: MixedCaps

```go
// ✅ Exports usan MixedCaps
func CalculateTotal(items []Item) int64 { ... }
type UserService struct { ... }
const MaxRetryAttempts = 3

// ❌ snake_case NO se usa en Go
func calculate_total(items []Item) int64 { ... }
```

### Estructura de Proyecto: internal/

```
cmd/              # Punto de entrada
internal/
  ├── domain/      # Entidades, interfaces (NO dependencias externas)
  ├── application/ # Casos de uso, lógica de aplicación
  └── infrastructure/
      ├── adapters/    # Implementaciones (GORM, HTTP handlers)
      └── persistence/ # Repositorios GORM
```

### Manejo de Errores: if err != nil

```go
// ✅ Patrón correcto
func GetUser(id uint) (*User, error) {
    user, err := repo.FindByID(id)
    if err != nil {
        return nil, fmt.Errorf("GetUser %d: %w", id, err)
    }
    return user, nil
}

// ❌ Ignorar error
func GetUser(id uint) *User {
    user, _ := repo.FindByID(id) // ¡NO HACER ESTO!
    return user
}

// ❌ cradle robbers
user, err := repo.FindByID(id)
if err == nil {
    // Solo asignar si no hay error
}
```

### Error Wrapping

```go
// ✅ Context + wrapped error
if err != nil {
    return fmt.Errorf("CreateUser %s: context=%s: %w", email, ctx, err)
}

// ✅ Sin contexto si el error ya lo tiene
if err != nil {
    return err // Ya tiene contexto, no duplicar
}
```

---

## 4. go.mod y go.sum

### go.mod (SIEMPRE hacer commit)

```go
module github.com/org/project/backend

go 1.25.0

require (
    gorm.io/gorm v1.31.1
    gorm.io/driver/postgres v1.6.0
    github.com/golang-jwt/jwt/v5 v5.3.1
)
```

### go.sum (SIEMPRE hacer commit)

- Certifica que `go.mod` y los binaries instalados coinciden
- Go 1.25+ lo maneja automáticamente con `go mod tidy`

---

## 5. Casos de Uso Típicos

### API REST con net/http stdlib

```go
type UserHandler struct {
    service *UserService
}

func (h *UserHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    switch r.Method {
    case http.MethodGet:
        h.handleGet(w, r)
    case http.MethodPost:
        h.handlePost(w, r)
    default:
        http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
    }
}
```

### CLI Tools

```bash
# Build para múltiples plataformas
GOOS=linux GOARCH=amd64 go build -o bin/server-linux ./cmd/main.go
GOOS=windows GOARCH=amd64 go build -o bin/server.exe ./cmd/main.go
```

### Workers/Background Jobs

```go
func StartWorker(ctx context.Context, handler MessageHandler) {
    for {
        select {
        case <-ctx.Done():
            return
        case msg := <-queue:
            if err := handler.Process(ctx, msg); err != nil {
                log.Printf("Worker error: %v", err)
            }
        }
    }
}
```

---

## 6. Configuración de Entorno

| Variable | Propósito | Ejemplo |
|----------|-----------|---------|
| `GOPATH` | Ruta de módulos | `/home/user/go` |
| `GO111MODULE` | Module mode | `on` (default 1.23+) |
| `CGO_ENABLED` | Habilitar C bindings | `1` para SQLite |

```bash
# Desarrollo local
export GOPATH=$HOME/go
export GO111MODULE=on

# Verificar
go env GOPATH GO111MODULE
```

---

## 7. Integración con Otras Guías

- **Testing**: Ver [testing.md](testing.md) — `go test`, testify, table-driven tests
- **Auth**: Ver [jwt-auth.md](jwt-auth.md) — JWT + bcrypt
- **GORM**: Ver [gorm.md](gorm.md) — Repository pattern
- **Docker**: Ver [docker.md](docker.md) — Multi-stage builds
- **Swagger**: Ver [swagger-openapi.md](swagger-openapi.md) — API docs

---

*Go es el lenguaje principal del backend. Todo código de dominio debe poder compilar sin dependencias externas al framework.*

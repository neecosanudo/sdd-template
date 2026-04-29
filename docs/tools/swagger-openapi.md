# Swagger / OpenAPI — Documentación de APIs

**Versión swag**: v1.16.6
**UI**: http-swagger v2 (Swagger UI embebida)
**Enfoque**: API First — Spec escrita ANTES de implementar
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [go.md](go.md) | [api-first.md](../decisions/api-first.md) | [testing.md](testing.md)

---

## 1. Enfoque API First

> **Regla**: La especificación Swagger/OpenAPI debe escribirse ANTES del código del handler.

```
Workflow API First:
1. Escribir spec OpenAPI (YAML/JSON)
2. Revisión del contrato (frontend + backend)
3. Implementar handlers que cumplan el contrato
4. Generar documentación con swag
5. Verificar compliance automáticamente
```

### Ejemplo de Spec Primero

```yaml
# api.yaml - ANTES de cualquier código
openapi: 3.0.3
info:
  title: User API
  version: 1.0.0
paths:
  /users:
    get:
      summary: List users
      responses:
        '200':
          description: List of users
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'
```

---

## 2. Instalación de Swag

```bash
# Instalar swag CLI
go install github.com/swaggo/swag/cmd/swag@latest

# Verificar
swag --version
# Output: v1.16.6
```

---

## 3. Anotaciones en Handlers Go

### Anotaciones Disponibles

| Anotación | Propósito | Ejemplo |
|-----------|-----------|---------|
| `@Summary` | Título breve de la operación | `@Summary Get user by ID` |
| `@Description` | Descripción detallada | `@Description Returns user...` |
| `@Param` | Parámetros de request | `@Param id path int true "User ID"` |
| `@Success` | Respuesta exitosa | `@Success 200 {User}` |
| `@Failure` | Respuestas de error | `@Failure 400 {Error} error` |
| `@Router` | Path y método HTTP | `@Router /users/{id} [get]` |
| `@SecurityDefinitions` | Auth requerida | `@SecurityDefinitions Bearer` |

### Handler Completo con Anotaciones

```go
package infrastructure/adapters/http

// @title User Service API
// @version 1.0
// @description API for user management
// @host localhost:8080
// @BasePath /

type UserHandler struct {
    service *UserService
}

// GetUserByID godoc
// @Summary Get user by ID
// @Description Returns the user with the specified ID
// @Tags users
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Success 200 {object} User
// @Failure 400 {object} ErrorResponse
// @Failure 404 {object} ErrorResponse
// @Router /users/{id} [get]
func (h *UserHandler) GetUserByID(w http.ResponseWriter, r *http.Request) {
    idStr := strings.TrimPrefix(r.URL.Path, "/users/")
    id, err := strconv.ParseUint(idStr, 10, 64)
    if err != nil {
        respondError(w, http.StatusBadRequest, "invalid id")
        return
    }

    user, err := h.service.GetUserByID(uint(id))
    if err != nil {
        if errors.Is(err, ErrNotFound) {
            respondError(w, http.StatusNotFound, "user not found")
            return
        }
        respondError(w, http.StatusInternalServerError, "internal error")
        return
    }

    respondJSON(w, http.StatusOK, user)
}

// CreateUser godoc
// @Summary Create a new user
// @Description Creates a new user with the provided data
// @Tags users
// @Accept json
// @Produce json
// @Param user body CreateUserRequest true "User data"
// @Success 201 {object} User
// @Failure 400 {object} ErrorResponse
// @Failure 409 {object} ErrorResponse "User already exists"
// @Router /users [post]
func (h *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
    var req CreateUserRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        respondError(w, http.StatusBadRequest, "invalid request body")
        return
    }

    user, err := h.service.CreateUser(req)
    if err != nil {
        if errors.Is(err, ErrAlreadyExists) {
            respondError(w, http.StatusConflict, "user already exists")
            return
        }
        respondError(w, http.StatusInternalServerError, "internal error")
        return
    }

    respondJSON(w, http.StatusCreated, user)
}
```

### Modelos con Anotaciones

```go
// @name User
// @struct
type User struct {
    ID        uint      `json:"id"`
    Email     string    `json:"email"`
    Name      string    `json:"name"`
    CreatedAt time.Time `json:"created_at"`
}

// @name CreateUserRequest
type CreateUserRequest struct {
    Email string `json:"email" binding:"required,email"`
    Name  string `json:"name" binding:"required,min=1,max=100"`
    Password string `json:"password" binding:"required,min=8"`
}

// @name ErrorResponse
type ErrorResponse struct {
    Error   string `json:"error"`
    Message string `json:"message,omitempty"`
}
```

---

## 4. Generación de Documentación

### Comando swag init

```bash
# Generar docs en docs/
swag init -g cmd/main.go -o docs/

# Con parse de directorios específicos
swag init -g cmd/main.go -o docs/ --parseInternal --parseDependency
```

### Estructura Generada

```
docs/
├── swagger.json      # Especificación OpenAPI
├── swagger.yaml      # Alternativa YAML
└── docs.go           # Go embed (para servir)
```

### Servir Swagger UI

```go
package main

import (
    _ "project/docs"  // Swag generated
    httpSwagger "github.com/swaggo/http-swagger/v2"
)

func main() {
    // Swagger UI en /swagger/
    http.HandleFunc("/swagger/", httpSwagger.Handler(
        httpSwagger.URL("/swagger/doc.json"),
    ))
}
```

---

## 5. Configuración de Middleware (net/http)

```go
import (
    "net/http"
    "github.com/swaggo/http-swagger/v2"
    _ "project/docs"
)

func main() {
    mux := http.NewServeMux()

    // Swagger
    mux.HandleFunc("/swagger/", httpSwagger.Handler(
        httpSwagger.URL("/swagger/doc.json"),
    ))

    // API routes
    mux.HandleFunc("/users", userHandler)
}
```

---

## 6. Referencias

- [api-first.md](../decisions/api-first.md) — ADR de API First
- [go.md](go.md) — Convenciones Go
- [testing.md](testing.md) — Contract testing

---

*API First es mandatorio. La spec Swagger es el contrato entre frontend y backend.*

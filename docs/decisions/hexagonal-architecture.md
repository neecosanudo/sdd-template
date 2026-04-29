# ADR-003: Arquitectura Hexagonal

**Estado**: Aprobado
**Fecha**: 2026-04-29
**Decisión**: Arquitectura Hexagonal (Ports & Adapters) para todo el código de backend

---

## 1. Contexto

El código de dominio no debe depender de frameworks, databases, ni libraries externas. Si mañana cambiamos de GORM a Ent, o de PostgreSQL a MongoDB, el dominio debe permanecer intacto. Necesitamos una arquitectura que permita cambiar implementaciones sin tocar lógica de negocio.

---

## 2. Decisión

**Arquitectura Hexagonal** con la siguiente estructura:

```
backend/
├── domain/
│   ├── entities/          # Entidades de negocio (sin dependencias)
│   └── ports/             # Interfaces que el dominio EXPONE
│       ├── user_repository.go
│       └── notification_service.go
│
├── application/
│   └── usecases/          # Lógica de aplicación (depende solo de ports)
│       ├── create_user.go
│       └── send_notification.go
│
└── infrastructure/
    └── adapters/
        ├── persistence/   # Implementaciones concretas
        │   ├── gorm_user_repository.go  # GORM implementation
        │   └── sqlite_user_repository.go
        └── http/          # Implementaciones HTTP
            └── user_handler.go
```

### Diagrama de Capas

```
┌─────────────────────────────────────────────────────────────┐
│                      HTTP Handler                            │
│                  (infrastructure/adapters/http)              │
└─────────────────────────┬───────────────────────────────────┘
                          │ depends on Port (interface)
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    Use Case (application)                     │
│                   (depends on Ports)                        │
└─────────────────────────┬───────────────────────────────────┘
                          │ depends on Port (interface)
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    Port (domain/ports)                       │
│              UserRepository interface { ... }                 │
└─────────────────────────┬───────────────────────────────────┘
                          │ implemented by
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              Adapter (infrastructure/adapters)               │
│              GormUserRepository implements                    │
│                  UserRepository                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Dependency Inversion

> **Regla**: Las flechas de dependencia SIEMPRE apuntan hacia el dominio.

```go
// domain/ports/user_repository.go
// El dominio define la interfaz que necesita

package domain/ports

type UserRepository interface {
    Create(user *User) error
    FindByID(id uint) (*User, error)
    FindAll(limit, offset int) ([]*User, error)
    Update(user *User) error
    Delete(id uint) error
}
```

```go
// infrastructure/adapters/persistence/gorm_user_repository.go
// La implementación concreta (GORM) implementa la interfaz del dominio

package adapters/persistence

type GormUserRepository struct {
    db *gorm.DB
}

// GormUserRepository implements domain/ports.UserRepository
func (r *GormUserRepository) Create(user *User) error {
    return r.db.Create(user).Error
}
```

---

## 4. Ejemplo Completo

### Entidad en Domain

```go
// domain/entities/user.go
package domain/entities

type User struct {
    ID       uint
    Email    string
    Name     string
    Password string // Already hashed
}
```

### Puerto en Domain

```go
// domain/ports/user_repository.go
package domain/ports

type UserRepository interface {
    Create(user *User) error
    FindByEmail(email string) (*User, error)
}
```

### Caso de Uso en Application

```go
// application/usecases/create_user.go
package application/usecases

type CreateUserRequest struct {
    Email    string
    Name     string
    Password string
}

type CreateUserResponse struct {
    User *entities.User
}

type CreateUserUseCase struct {
    repo           ports.UserRepository
    passwordHasher Hasher
}

func (uc *CreateUserUseCase) Execute(ctx context.Context, req CreateUserRequest) (*CreateUserResponse, error) {
    // Check if exists
    existing, _ := uc.repo.FindByEmail(req.Email)
    if existing != nil {
        return nil, ErrUserAlreadyExists
    }
    
    // Hash password
    hashed, err := uc.passwordHasher.Hash(req.Password)
    if err != nil {
        return nil, err
    }
    
    // Create user
    user := &entities.User{
        Email:    req.Email,
        Name:     req.Name,
        Password: hashed,
    }
    
    if err := uc.repo.Create(user); err != nil {
        return nil, err
    }
    
    return &CreateUserResponse{User: user}, nil
}
```

### Wiring en main.go

```go
// cmd/main.go
package main

func main() {
    // Infrastructure setup
    db, _ := gorm.Open(postgres.Open(dsn), &gorm.Config{})
    
    // Adapter: GORM implementation
    userRepo := adapters.NewGormUserRepository(db)
    passwordHasher := adapters.NewBcryptHasher()
    
    // Use case: receives ports (interfaces), not adapters
    createUserUC := usecases.NewCreateUserUseCase(userRepo, passwordHasher)
    
    // Handler: receives use case
    userHandler := http.NewUserHandler(createUserUC)
    
    // ...
}
```

---

## 5. Alternativas Rechazadas

| Alternativa | Razón del Rechazo |
|-------------|-------------------|
| **Active Record** | Modelo 'contaminado' con lógica de DB |
| **Transaction Script** | Todo en funciones procedimentales |
| **Sin arquitectura** | Código en el handler = imposible de testear |

---

## 6. Consecuencias

- **Positivas**: Domain testable sin DB, cambio de tecnología sin tocar dominio, claridad de responsabilidades
- **Negativas**: Mayor cantidad de archivos/indirección, curva de aprendizaje inicial
- **Riesgo**: Over-engineering en proyectos triviales (< 3 endpoints)

---

## 7. Referencias

- [go-hexagonal.md](../../.atl/patterns/go-hexagonal.md) — Patrón completo
- [gorm-repository.md](../../.atl/patterns/gorm-repository.md) — Repository pattern
- [gorm.md](../tools/gorm.md) — GORM con hexagonal

---

*Hexagonal Architecture es mandatorio. El dominio NO depende de frameworks.*

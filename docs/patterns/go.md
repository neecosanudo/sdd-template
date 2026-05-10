# Patrón: Go Hexagonal Architecture

**Pattern ID**: go-hexagonal
**Versión**: 1.0
**dependencias**: [hexagonal-architecture.md](../../docs/decisions/hexagonal-architecture.md) | [go.md](../../docs/tools/go.md) | [gorm-repository.md](gorm-repository.md)

---

## 1. Estructura de Directorios

```
backend/
├── cmd/
│   └── main.go              # Punto de entrada, wiring
│
├── domain/
│   ├── entities/
│   │   ├── user.go
│   │   └── order.go
│   └── ports/
│       ├── user_repository.go    # Interfaces (el dominio EXPONE)
│       └── notification_service.go
│
├── application/
│   └── usecases/
│       ├── create_user.go
│       ├── get_user.go
│       └── notification_service.go
│
└── infrastructure/
    └── adapters/
        ├── persistence/
        │   ├── gorm_user_repository.go
        │   └── gorm_order_repository.go
        └── http/
            ├── user_handler.go
            └── middleware/
                └── auth.go
```

### Diagrama ASCII

```
┌──────────────────────────────────────────────────────────────────┐
│                            main.go                                │
│                    (Wiring de dependencias)                       │
└───────────────────────────┬──────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌───────────────┐  ┌───────────────┐  ┌───────────────────────┐
│   UseCase     │  │   UseCase     │  │      Handler           │
│ (application) │  │               │  │  (infrastructure)      │
└───────┬───────┘  └───────────────┘  └───────────┬───────────┘
        │                                         │
        │      ┌──────────────────────┐          │
        └──────►    Port (interface)   ◄─────────┘
                 │  domain/ports/       │
                 └──────────────────────┘
                            ▲
                            │ implements
        ┌───────────────────┴───────────────────┐
        │                                       │
        ▼                                       ▼
┌───────────────┐                    ┌─────────────────────┐
│   GORM        │                    │   HTTP Handler      │
│ Repository    │                    │                     │
│(infrastructure│                    │(infrastructure)     │
└───────────────┘                    └─────────────────────┘
```

---

## 2. Interfaz en Domain

```go
// domain/ports/user_repository.go
package ports

import (
    "project/domain/entities"
)

// UserRepository define el contrato que el dominio necesita.
// La implementación concreta está en infrastructure/.
type UserRepository interface {
    Create(user *entities.User) error
    FindByID(id uint) (*entities.User, error)
    FindByEmail(email string) (*entities.User, error)
    FindAll(limit, offset int) ([]*entities.User, error)
    Update(user *entities.User) error
    Delete(id uint) error
}

// Hasher define el contrato para hashing de passwords.
type Hasher interface {
    Hash(password string) (string, error)
    Compare(password, hash string) bool
}
```

---

## 3. Caso de Uso (Application Layer)

```go
// application/usecases/create_user.go
package usecases

import (
    "context"
    "errors"
    
    "project/domain/entities"
    "project/domain/ports"
)

var (
    ErrUserAlreadyExists = errors.New("user already exists")
    ErrInvalidEmail       = errors.New("invalid email format")
)

// CreateUserUseCase encapsula la lógica de crear un usuario.
type CreateUserUseCase struct {
    repo     ports.UserRepository
    hasher   ports.Hasher
}

// NewCreateUserUseCase crea una nueva instancia con dependencias inyectadas.
func NewCreateUserUseCase(repo ports.UserRepository, hasher ports.Hasher) *CreateUserUseCase {
    return &CreateUserUseCase{
        repo:   repo,
        hasher: hasher,
    }
}

// Execute implementa el caso de uso.
func (uc *CreateUserUseCase) Execute(ctx context.Context, req CreateUserRequest) (*UserResponse, error) {
    // Validar email
    if err := validateEmail(req.Email); err != nil {
        return nil, ErrInvalidEmail
    }
    
    // Verificar si ya existe
    existing, err := uc.repo.FindByEmail(req.Email)
    if err != nil && !errors.Is(err, ErrNotFound) {
        return nil, err
    }
    if existing != nil {
        return nil, ErrUserAlreadyExists
    }
    
    // Hash password
    hashedPassword, err := uc.hasher.Hash(req.Password)
    if err != nil {
        return nil, err
    }
    
    // Crear entidad
    user := &entities.User{
        Email:    req.Email,
        Name:     req.Name,
        Password: hashedPassword,
    }
    
    // Persistir
    if err := uc.repo.Create(user); err != nil {
        return nil, err
    }
    
    return &UserResponse{
        ID:    user.ID,
        Email: user.Email,
        Name:  user.Name,
    }, nil
}

// Request/Response DTOs
type CreateUserRequest struct {
    Email    string
    Name     string
    Password string
}

type UserResponse struct {
    ID    uint
    Email string
    Name  string
}
```

---

## 4. Implementación GORM en Infrastructure

```go
// infrastructure/adapters/persistence/gorm_user_repository.go
package adapters

import (
    "errors"
    "fmt"
    
    "gorm.io/gorm"
    
    "project/domain/entities"
    "project/domain/ports"
)

var ErrNotFound = errors.New("entity not found")

// GormUserRepository implementa ports.UserRepository usando GORM.
type GormUserRepository struct {
    db *gorm.DB
}

// NewGormUserRepository crea repositorio con inyección de *gorm.DB.
func NewGormUserRepository(db *gorm.DB) *GormUserRepository {
    return &GormUserRepository{db: db}
}

// Compile-time interface check
var _ ports.UserRepository = (*GormUserRepository)(nil)

func (r *GormUserRepository) Create(user *entities.User) error {
    return r.db.Create(user).Error
}

func (r *GormUserRepository) FindByID(id uint) (*entities.User, error) {
    var user entities.User
    if err := r.db.First(&user, id).Error; err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, ErrNotFound
        }
        return nil, fmt.Errorf("FindByID %d: %w", id, err)
    }
    return &user, nil
}

func (r *GormUserRepository) FindByEmail(email string) (*entities.User, error) {
    var user entities.User
    if err := r.db.Where("email = ?", email).First(&user).Error; err != nil {
        if errors.Is(err, gorm.ErrRecordNotFound) {
            return nil, ErrNotFound
        }
        return nil, fmt.Errorf("FindByEmail %s: %w", email, err)
    }
    return &user, nil
}

func (r *GormUserRepository) FindAll(limit, offset int) ([]*entities.User, error) {
    var users []*entities.User
    if err := r.db.Limit(limit).Offset(offset).Find(&users).Error; err != nil {
        return nil, err
    }
    return users, nil
}

func (r *GormUserRepository) Update(user *entities.User) error {
    return r.db.Save(user).Error
}

func (r *GormUserRepository) Delete(id uint) error {
    return r.db.Delete(&entities.User{}, id).Error
}
```

---

## 5. Bcrypt Hasher Adapter

```go
// infrastructure/adapters/bcrypt_hasher.go
package adapters

import "golang.org/x/crypto/bcrypt"

type BcryptHasher struct {
    cost int
}

func NewBcryptHasher() *BcryptHasher {
    return &BcryptHasher{cost: 12}
}

func (h *BcryptHasher) Hash(password string) (string, error) {
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), h.cost)
    return string(bytes), err
}

func (h *BcryptHasher) Compare(password, hash string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}
```

---

## 6. Wiring en main.go

```go
// cmd/main.go
package main

import (
    "os"
    
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
    
    "project/application/usecases"
    "project/domain/ports"
    "project/infrastructure/adapters"
)

func main() {
    // 1. Setup infrastructure
    dsn := os.Getenv("DATABASE_URL")
    db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
    if err != nil {
        panic(err)
    }
    
    // 2. Create adapters (implementations)
    var userRepo ports.UserRepository = adapters.NewGormUserRepository(db)
    var hasher ports.Hasher = adapters.NewBcryptHasher()
    
    // 3. Create use cases (receives interfaces, not implementations)
    createUserUC := usecases.NewCreateUserUseCase(userRepo, hasher)
    
    // 4. Create handlers (receives use cases)
    userHandler := NewUserHandler(createUserUC)
    
    // 5. Setup router with handlers
    // ...
}
```

---

## 7. Verificación de Interface en Compile-Time

```go
// Compile-time check que GormUserRepository implementa UserRepository
var _ ports.UserRepository = (*GormUserRepository)(nil)
```

Si GormUserRepository no implementa todos los métodos de UserRepository, el código no compila. Esto detecta errores temprano.

---

## 8. Referencias

- [hexagonal-architecture.md](../../docs/decisions/hexagonal-architecture.md) — ADR de arquitectura
- [gorm-repository.md](gorm-repository.md) — GORM repository pattern
- [go.md](../../docs/tools/go.md) — Convenciones Go

---

*Hexagonal architecture: domain define ports, infrastructure implementa adapters.*

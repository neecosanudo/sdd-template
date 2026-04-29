# Patrón: GORM Repository

**Pattern ID**: gorm-repository
**Versión**: 1.0
**dependencias**: [gorm.md](../../docs/tools/gorm.md) | [go-hexagonal.md](go-hexagonal.md) | [postgresql.md](../../docs/tools/postgresql.md) | [sqlite.md](../../docs/tools/sqlite.md)

---

## 1. Estructura General

```
domain/
├── entities/
│   ├── user.go
│   └── order.go
└── ports/
    └── user_repository.go    # Interface (domain owns it)

infrastructure/
└── adapters/
    └── persistence/
        ├── gorm_user_repository.go
        └── gorm_order_repository.go
```

La **interface vive en domain**, la **implementación vive en infrastructure**.

---

## 2. Interfaz en Domain

```go
// domain/ports/user_repository.go
package ports

import (
    "project/domain/entities"
)

// UserRepository define el contrato para persistencia de usuarios.
// Implementations están en infrastructure/adapters/persistence/.
type UserRepository interface {
    Create(user *entities.User) error
    FindByID(id uint) (*entities.User, error)
    FindByEmail(email string) (*entities.User, error)
    FindAll(opts FindAllOptions) ([]*entities.User, int64, error)
    Update(user *entities.User) error
    Delete(id uint) error
}

// FindAllOptions encapsula opciones de query para FindAll.
type FindAllOptions struct {
    Limit  int
    Offset int
    Status string // Optional filter
}
```

---

## 3. Implementación GORM

```go
// infrastructure/adapters/persistence/gorm_user_repository.go
package persistence

import (
    "errors"
    "fmt"
    
    "gorm.io/gorm"
    
    "project/domain/entities"
    "project/domain/ports"
)

var ErrNotFound = errors.New("user not found")

type GormUserRepository struct {
    db *gorm.DB
}

// NewGormUserRepository recibe *gorm.DB por constructor (inyección).
func NewGormUserRepository(db *gorm.DB) *GormUserRepository {
    return &GormUserRepository{db: db}
}

// Compile-time interface check
var _ ports.UserRepository = (*GormUserRepository)(nil)

func (r *GormUserRepository) Create(user *entities.User) error {
    if err := r.db.Create(user).Error; err != nil {
        return fmt.Errorf("Create user: %w", err)
    }
    return nil
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

func (r *GormUserRepository) FindAll(opts ports.FindAllOptions) ([]*entities.User, int64, error) {
    var users []*entities.User
    var total int64
    
    query := r.db.Model(&entities.User{})
    
    if opts.Status != "" {
        query = query.Where("status = ?", opts.Status)
    }
    
    // Count total
    if err := query.Count(&total).Error; err != nil {
        return nil, 0, fmt.Errorf("Count users: %w", err)
    }
    
    // Fetch paginated
    if err := query.Limit(opts.Limit).Offset(opts.Offset).Find(&users).Error; err != nil {
        return nil, 0, fmt.Errorf("FindAll users: %w", err)
    }
    
    return users, total, nil
}

func (r *GormUserRepository) Update(user *entities.User) error {
    if err := r.db.Save(user).Error; err != nil {
        return fmt.Errorf("Update user %d: %w", user.ID, err)
    }
    return nil
}

func (r *GormUserRepository) Delete(id uint) error {
    if err := r.db.Delete(&entities.User{}, id).Error; err != nil {
        return fmt.Errorf("Delete user %d: %w", id, err)
    }
    return nil
}
```

---

## 4. Transacciones

```go
// CreateOrderWithItems usa transacción para crear orden + items.
func (r *GormOrderRepository) CreateOrderWithItems(order *entities.Order, items []*entities.OrderItem) error {
    return r.db.Transaction(func(tx *gorm.DB) error {
        // Crear orden
        if err := tx.Create(order).Error; err != nil {
            return fmt.Errorf("create order: %w", err)
        }
        
        // Asignar order ID a items
        for _, item := range items {
            item.OrderID = order.ID
        }
        
        // Crear items
        if err := tx.Create(items).Error; err != nil {
            return fmt.Errorf("create items: %w", err)
        }
        
        return nil
    })
}
```

---

## 5. Scoping Patterns (Filtros Reutilizables)

```go
// Scoping functions que retornan func(*gorm.DB) *gorm.DB
// Permiten componer queries de forma declarativa

// WithStatus filtra por status activo
func WithStatus(status string) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        return db.Where("status = ?", status)
    }
}

// WithEmail filtra por email
func WithEmail(email string) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        return db.Where("email = ?", email)
    }
}

// WithCreatedAfter filtra por fecha de creación
func WithCreatedAfter(t time.Time) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        return db.Where("created_at > ?", t)
    }
}

// Uso en FindAll
func (r *GormUserRepository) FindActiveUsers() ([]*entities.User, error) {
    var users []*entities.User
    err := r.db.Scopes(WithStatus("active")).Find(&users).Error
    return users, err
}

// Múltiples scopes
func (r *GormUserRepository) FindFilteredUsers(email string, status string) ([]*entities.User, error) {
    var users []*entities.User
    err := r.db.Scopes(
        WithEmail(email),
        WithStatus(status),
    ).Find(&users).Error
    return users, err
}
```

---

## 6. N+1 Query Prevention

### ❌ BAD: N+1 Query Problem

```go
// ¡ESTE CÓDIGO TIENE N+1!
func GetAllOrdersBAD(db *gorm.DB) ([]*Order, error) {
    var orders []*Order
    if err := db.Find(&orders).Error; err != nil {
        return nil, err
    }
    
    // N+1: hace un query por cada orden
    for _, order := range orders {
        db.Where("order_id = ?", order.ID).Find(&order.Items)
    }
    
    return orders, nil
}
```

### ✅ GOOD: Preload

```go
// SOLUCIÓN: Preload relaciones
func GetAllOrdersGOOD(db *gorm.DB) ([]*Order, error) {
    var orders []*Order
    
    // Un solo query con JOIN
    err := db.
        Preload("Items").
        Preload("User").
        Find(&orders).Error
    
    return orders, err
}
```

### Ejemplo con Transaction (evitar N+1 en creación)

```go
// Crear orden con items en una transacción
// Sin N+1 porque todo se hace en el mismo tx
func (r *GormOrderRepository) CreateOrderWithItemsTx(tx *gorm.DB, order *Order, items []Item) error {
    // Crear orden
    if err := tx.Create(order).Error; err != nil {
        return err
    }
    
    // Bulk insert items (un solo query)
    for i := range items {
        items[i].OrderID = order.ID
    }
    if err := tx.Create(&items).Error; err != nil {
        return err
    }
    
    return nil
}
```

---

## 7. Tipo Concreto: User + Product

```go
// domain/entities/user.go
package entities

import (
    "time"
    "gorm.io/gorm"
)

type User struct {
    ID        uint           `gorm:"primaryKey"`
    Email     string         `gorm:"uniqueIndex;not null"`
    Name      string         `gorm:"size:100;not null"`
    Password  string         `gorm:"not null"`
    Status    string         `gorm:"size:20;default:'active'"`
    CreatedAt time.Time
    UpdatedAt time.Time
    DeletedAt gorm.DeletedAt `gorm:"index"`
}

// domain/entities/product.go
package entities

type Product struct {
    ID          uint      `gorm:"primaryKey"`
    Name        string    `gorm:"size:200;not null"`
    Description string    `gorm:"type:text"`
    Price       float64   `gorm:"not null"`
    Stock       int       `gorm:"default:0"`
    CategoryID  uint      `gorm:"index"`
    Category    Category  `gorm:"foreignKey:CategoryID"`
    CreatedAt   time.Time
    UpdatedAt   time.Time
}
```

---

## 8. Referencias

- [gorm.md](../../docs/tools/gorm.md) — Guía completa de GORM
- [go-hexagonal.md](go-hexagonal.md) — Arquitectura hexagonal
- [postgresql.md](../../docs/tools/postgresql.md) — PostgreSQL production
- [sqlite.md](../../docs/tools/sqlite.md) — SQLite para dev/testing

---

*GORM repository con *gorm.DB inyectado. Interface en domain, implementación en infrastructure.*

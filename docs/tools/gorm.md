# GORM — Object-Relational Mapping

**Versión**: GORM v1.31.1
**Driver PostgreSQL**: gorm.io/driver/postgres v1.6.0
**Driver SQLite**: gorm.io/driver/sqlite v1.6.0
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [go.md](go.md) | [postgresql.md](postgresql.md) | [sqlite.md](sqlite.md) | [gorm-repository.md](../../.atl/patterns/gorm-repository.md) | [docker.md](docker.md)

---

## 1. Modelos con Tags GORM

### Modelo Básico

```go
package domain/entities

type User struct {
    ID        uint      `gorm:"primaryKey"`
    Email     string    `gorm:"uniqueIndex;not null;size:255"`
    Name      string    `gorm:"size:100;not null"`
    Password  string    `gorm:"not null"`
    CreatedAt time.Time
    UpdatedAt time.Time
    DeletedAt gorm.DeletedAt `gorm:"index"` // Soft delete
}

// En la migración
db.AutoMigrate(&User{})
```

### Relaciones

```go
type Order struct {
    ID      uint    `gorm:"primaryKey"`
    UserID  uint    `gorm:"not null"`
    User    User    `gorm:"foreignKey:UserID"`
    Total   float64 `gorm:"not null"`
    Status  string  `gorm:"size:50;default:'pending'"`
}

// Relación uno a muchos
type User struct {
    // ...
    Orders []Order `gorm:"foreignKey:UserID"`
}
```

---

## 2. Auto-Migración vs Migraciones Manuales

### AutoMigrate (Desarrollo)

```go
// ⚠️ SOLO en desarrollo
func InitDB(db *gorm.DB) error {
    return db.AutoMigrate(
        &User{},
        &Order{},
        &Product{},
    )
}
```

### Migraciones Manuales (Producción)

```go
// migrations/001_create_users.up.sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_deleted_at ON users(deleted_at);

// migrations/001_create_users.down.sql
DROP TABLE IF EXISTS users;
```

---

## 3. Patrón Repository con GORM

### Interfaz en Domain

```go
// domain/ports/user_repository.go
package domain/ports

type UserRepository interface {
    Create(user *User) error
    FindByID(id uint) (*User, error)
    FindAll(limit, offset int) ([]*User, error)
    Update(user *User) error
    Delete(id uint) error
}
```

### Implementación en Infrastructure

```go
// infrastructure/adapters/persistence/gorm_user_repository.go
package adapters/persistence

type GormUserRepository struct {
    db *gorm.DB
}

// Constructor con inyección de dependencia
func NewGormUserRepository(db *gorm.DB) *GormUserRepository {
    return &GormUserRepository{db: db}
}

func (r *GormUserRepository) Create(user *User) error {
    return r.db.Create(user).Error
}

func (r *GormUserRepository) FindByID(id uint) (*User, error) {
    var user User
    if err := r.db.First(&user, id).Error; err != nil {
        return nil, fmt.Errorf("FindByID %d: %w", id, err)
    }
    return &user, nil
}

func (r *GormUserRepository) FindAll(limit, offset int) ([]*User, error) {
    var users []*User
    if err := r.db.Limit(limit).Offset(offset).Find(&users).Error; err != nil {
        return nil, err
    }
    return users, nil
}

func (r *GormUserRepository) Update(user *User) error {
    return r.db.Save(user).Error
}

func (r *GormUserRepository) Delete(id uint) error {
    return r.db.Delete(&User{}, id).Error
}
```

---

## 4. Transacciones

```go
func (r *GormOrderRepository) CreateOrderWithItems(order *Order, items []Item) error {
    return r.db.Transaction(func(tx *gorm.DB) error {
        // Crear orden
        if err := tx.Create(order).Error; err != nil {
            return err
        }
        
        // Asignar items a la orden
        for i := range items {
            items[i].OrderID = order.ID
        }
        
        // Crear items
        if err := tx.Create(&items).Error; err != nil {
            return err
        }
        
        return nil
    })
}
```

---

## 5. Preloading y Scoping

### Preload (Carga de Relaciones)

```go
// ✅ GOOD: Preload evita N+1
var orders []Order
db.Preload("User").Preload("Items").Find(&orders)

// ❌ BAD: N+1 query - hace query por cada orden
var orders []Order
db.Find(&orders)
for _, order := range orders {
    db.Where("order_id = ?", order.ID).Find(&order.Items)
}
```

### Scoping (Filtros Reutilizables)

```go
// application/queries/user_queries.go
func WithStatus(status string) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        return db.Where("status = ?", status)
    }
}

func WithEmail(email string) func(db *gorm.DB) *gorm.DB {
    return func(db *gorm.DB) *gorm.DB {
        return db.Where("email = ?", email)
    }
}

// Uso
users := []User{}
db.Scopes(WithStatus("active"), WithEmail("")).Find(&users)
```

---

## 6. Pitfalls Comunes

### ⚠️ N+1 Queries

```go
// ❌ BAD: N+1
func GetAllOrders() ([]Order, error) {
    var orders []Order
    db.Find(&orders)
    
    for i := range orders {
        db.Where("user_id = ?", orders[i].UserID).First(&orders[i].User)
    }
    return orders, nil
}

// ✅ GOOD: Preload
func GetAllOrders() ([]Order, error) {
    var orders []Order
    err := db.Preload("User").Find(&orders).Error
    return orders, err
}
```

### ⚠️ Migraciones en Producción

```go
// ❌ NUNCA usar AutoMigrate en producción
db.AutoMigrate(&User{}) // ¡PELIGRO!

// ✅ Usar migraciones manuales versionadas
// migrations/001_create_users.up.sql
```

### ⚠️ Pool de Conexiones

```go
// Configuración de pool (en main.go)
sqlDB, err := db.DB()
if err != nil {
    return err
}

// Pool settings
sqlDB.SetMaxIdleConns(10)
sqlDB.SetMaxOpenConns(100)
sqlDB.SetConnMaxLifetime(time.Hour)
```

---

## 7. String de Conexión (DSN)

### PostgreSQL

```go
dsn := "host=localhost user=postgres password=secret dbname=mydb port=5432 sslmode=disable TimeZone=UTC"
db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
```

### SQLite (Desarrollo)

```go
// En memoria (para tests)
dsn := "file::memory:?cache=shared"
db, err := gorm.Open(sqlite.Open(dsn), &gorm.Config{})

// Archivo local (desarrollo)
dsn := "file:./dev.db"
db, err := gorm.Open(sqlite.Open(dsn), &gorm.Config{})
```

---

## 8. Referencias Cruzadas

- [postgresql.md](postgresql.md) — Configuración PostgreSQL
- [sqlite.md](sqlite.md) — Configuración SQLite (dev/testing)
- [gorm-repository.md](../../.atl/patterns/gorm-repository.md) — Patrón completo
- [go.md](go.md) — Convenciones Go
- [docker.md](docker.md) — Docker para GORM + PostgreSQL

---

*GORM es el ORM de producción. Usar el patrón Repository para mantener el dominio libre de dependencias.*

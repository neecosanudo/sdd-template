# Patrones y Conflictos — Go

> Este archivo documenta comportamientos del lenguaje y la stdlib que pueden generar errores silenciosos o difíciles de diagnosticar. Léelo antes de escribir código Go en este proyecto.

---

## 1. Inicialización de Slices y Maps

### Problema

En Go, los **valores cero** de slices y maps son `nil`. Escribir en un map `nil` causa **panic**. Leer de un map `nil` devuelve el valor cero (OK). Append a un slice `nil` funciona (Go lo inicializa automáticamente).

```go
var m map[string]int
m["clave"] = 42  // ❌ PANIC: assignment to entry in nil map

var s []string
s = append(s, "hola")  // ✅ Funciona, append inicializa
```

### Solución

```go
// ✅ Siempre inicializar maps con make()
m := make(map[string]int)
m["clave"] = 42

// O con literal
m := map[string]int{
    "clave": 42,
}

// Slices: solo inicializar si sabes la capacidad
s := make([]string, 0, 10)  // capacidad inicial
```

---

## 2. Punteros vs Valores en Receivers

### Problema

Los métodos con **receptor de valor** operan sobre una copia. Los métodos con **receptor de puntero** operan sobre el original. La confusión aparece cuando:

```go
type Config struct {
    Name string
}

func (c Config) SetNameBad(name string) {
    c.Name = name  // ❌ No modifica el original
}

func (c *Config) SetNameGood(name string) {
    c.Name = name  // ✅ Modifica el original
}
```

### Regla general

| Receptor | Cuándo usarlo |
|:---|:---|
| `(c Config)` | Métodos que NO modifican el struct (getters, validaciones) |
| `(c *Config)` | Métodos que modifican el struct (setters, actualizaciones) |
| `(c *Config)` | Structs grandes (evita copiar) |
| `(c Config)` | Structs pequeños e inmutables |

**Consistencia**: Si algún método del tipo usa puntero receptor, TODOS deberían usarlo.

---

## 3. Manejo de Errores — Zero Values vs Errores

### Problema

Go no tiene excepciones. Las funciones devuelven `(result, error)`. Ignorar el error es válido sintácticamente pero peligroso.

```go
result, _ := algunaFuncion()  // ❌ Error silenciado
```

### Solución

Siempre verificar errores. Usar sentinel errors y error wrapping:

```go
var ErrNotFound = errors.New("not found")

func Buscar(id string) (Resultado, error) {
    // ...
    if noEncontrado {
        return Resultado{}, ErrNotFound
    }
    return resultado, nil
}

// Caller
resultado, err := Buscar("123")
if err != nil {
    if errors.Is(err, ErrNotFound) {
        // manejar no encontrado
    }
    return fmt.Errorf("buscar %s: %w", id, err)
}
```

---

## 4. Nil Interface vs Nil Pointer

### Problema

Una interfaz en Go es `nil` SOLO si tanto el tipo como el valor son `nil`. Un puntero `nil` dentro de una interfaz NO es `nil`.

```go
var p *int = nil
var i interface{} = p
fmt.Println(i == nil)  // ❌ false! La interfaz tiene tipo (*int)
```

### Solución

No devolver punteros nil envueltos en interfaces. Mejor devolver `nil` explícito:

```go
func GetWriter() io.Writer {
    // ...
    return nil  // ✅ Devuelve interface nil, no (*bytes.Buffer)(nil)
}
```

---

## 5. Slice como Referencia

### Problema

Un slice comparte el array subyacente. Modificar elementos en un slice derivado afecta al original.

```go
original := []int{1, 2, 3, 4, 5}
sub := original[1:3]
sub[0] = 99
fmt.Println(original)  // [1, 99, 3, 4, 5]  😱
```

### Solución

Usar `copy()` cuando necesites aislamiento:

```go
sub := make([]int, 2)
copy(sub, original[1:3])
sub[0] = 99
fmt.Println(original)  // [1, 2, 3, 4, 5]  ✅
```

---

## 6. Gorutinas y Variables de Ciclo

### Problema

Las gorutinas capturan la **misma variable** del ciclo, no su valor en cada iteración:

```go
for _, v := range items {
    go func() {
        fmt.Println(v)  // ❌ Todas ven el ÚLTIMO valor de v
    }()
}
```

### Solución

Pasar el valor como parámetro:

```go
for _, v := range items {
    go func(val string) {
        fmt.Println(val)  // ✅ Cada gorutina tiene su copia
    }(v)
}
```

---

## 7. Documentación de Errores Conocidos

| Error | Causa | Solución |
|:---|:---|:---|
| `assignment to entry in nil map` | Map no inicializado | Usar `make(map[K]V)` |
| `nil pointer dereference` | Puntero nil sin verificar | Validar antes de acceder |
| Data race | Acceso concurrente sin sync | Usar `sync.Mutex` o canales |
| Defer en ciclo | Defer se ejecuta al salir de la función, no del ciclo | Mover el ciclo a su propia función |
| Slice compartido | Modificación por referencia compartida | Usar `copy()` |

---

## 8. GORM Repository Pattern

### Estructura

```
domain/
├── entities/
│   └── user.go
└── ports/
    └── user_repository.go    # Interface (domain owns it)

infrastructure/
└── adapters/
    └── persistence/
        └── gorm_user_repository.go
```

La **interface vive en domain**, la **implementación vive en infrastructure**.

### Interfaz en Domain

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

### Implementación GORM

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
```

### Scoping Patterns (Filtros Reutilizables)

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

### N+1 Query Prevention

```go
// ❌ BAD: N+1 Query Problem
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

// ✅ GOOD: Preload
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

---

## 9. GORM Error Table

| Error | Causa | Solución |
|:---|:---|:---|
| `gorm.ErrRecordNotFound` | Registro no existe | Verificar ID o usar First() con error check |
| `UNIQUE constraint failed` | Duplicado en campo unique | Validar antes de insertar o capturar error |
| `FOREIGN KEY constraint failed` | FK referencing non-existent record | Verificar que el registro padre exista |
| `no such table` | Tabla no creada | Ejecutar migraciones con AutoMigrate |
| `connecting to database refused` | PostgreSQL no corriendo | Verificar docker-compose up |
| `relation "users" does not exist` | Migration no ejecutada | `db.AutoMigrate(&User{})` |

---

> **Cómo actualizar este archivo**: Cuando encuentres un error de lenguaje que no está documentado aquí, agregalo. Especialmente errores que aparecen en compilación vs runtime.
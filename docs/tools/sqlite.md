# SQLite — Desarrollo y Testing

> ⚠️ **ADVERTENCIA CRÍTICA**: SQLite es SOLO para desarrollo y testing. **NUNCA** usar en producción. Para producción, ver [postgresql.md](postgresql.md).

**Versión**: SQLite via GORM driver v1.6.0
**Uso**: Desarrollo local, tests unitarios, CI local
**Driver**: gorm.io/driver/sqlite
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [gorm.md](gorm.md) | [testing.md](testing.md)

---

## 1. Configuración GORM con SQLite

### String de Conexión

```go
import "gorm.io/driver/sqlite"

// En memoria (para tests - cada test obtiene conexión limpia)
dsn := "file::memory:?cache=shared"
db, err := gorm.Open(sqlite.Open(dsn), &gorm.Config{})

// Archivo local (desarrollo)
dsn := "file:./dev.db"
db, err := gorm.Open(sqlite.Open(dsn), &gorm.Config{})
```

---

## 2. Switch PostgreSQL ↔ SQLite

### Via Environment Variable

```go
func InitDB() (*gorm.DB, error) {
    var dsn string
    var dialector gorm.Dialector

    if os.Getenv("DATABASE_URL") != "" {
        // Producción: PostgreSQL
        dialector = postgres.Open(os.Getenv("DATABASE_URL"))
    } else if os.Getenv("SQLITE_DB") != "" {
        // Desarrollo: SQLite
        dialector = sqlite.Open(os.Getenv("SQLITE_DB"))
    } else {
        // Default: SQLite en memoria
        dialector = sqlite.Open("file::memory:?cache=shared")
    }

    return gorm.Open(dialector, &gorm.Config{})
}
```

### Via Build Tags

```go
//go:build sqlite
// +build sqlite

package db

func NewDatabase() (*gorm.DB, error) {
    return gorm.Open(sqlite.Open("file::memory:?cache=shared"), &gorm.Config{})
}
```

```go
//go:build !sqlite
// +build !sqlite

package db

func NewDatabase() (*gorm.DB, error) {
    dsn := os.Getenv("DATABASE_URL")
    if dsn == "" {
        return nil, errors.New("DATABASE_URL required for PostgreSQL")
    }
    return gorm.Open(postgres.Open(dsn), &gorm.Config{})
}
```

### Uso

```bash
# Con SQLite
SQLITE_DB=./dev.db go run ./cmd/main.go

# Con PostgreSQL
DATABASE_URL=postgres://... go run ./cmd/main.go

# Build para SQLite (tests)
go test -tags sqlite ./...
```

---

## 3. SQLite en Memoria para Tests

```go
// setup_test.go
func SetupTestDB(t *testing.T) *gorm.DB {
    db, err := gorm.Open(sqlite.Open("file::memory:?cache=shared"), &gorm.Config{})
    if err != nil {
        t.Fatalf("failed to connect to test db: %v", err)
    }

    // Migrar esquema
    db.AutoMigrate(&User{}, &Order{})

    // Enable foreign keys (SQLite requiere esto explícitamente)
    db.Exec("PRAGMA foreign_keys = ON")

    return db
}

func TestUserRepository(t *testing.T) {
    db := SetupTestDB(t)
    repo := NewGormUserRepository(db)

    // ... tests
}
```

### Pool de Conexiones Compartido (SQLite en memoria)

```go
// ⚠️ SQLite en memoria requiere connection sharing
// Para tests que comparten la misma DB:

// Helper para tests de integración
func SetupSharedMemoryDB(t *testing.T) *gorm.DB {
    db, err := gorm.Open(sqlite.Open("file::memory:?mode=memory&cache=shared"), &gorm.Config{})
    if err != nil {
        t.Fatal(err)
    }
    
    // Importante: mantener conexión abierta
    sqlDB, _ := db.DB()
    sqlDB.SetMaxOpenConns(1)
    
    return db
}
```

---

## 4. Diferencias PostgreSQL vs SQLite

| Aspecto | PostgreSQL | SQLite |
|---------|-----------|--------|
| Concurrencia | Excelente | Limitada |
| Foreign Keys | ✅ Nativos | ⚠️ Requieren PRAGMA |
| JSONB | ✅ Avanzado | ⚠️ Básico (JSON) |
| Arrays | ✅ Nativos | ❌ No |
| Full-text search | ✅ Avanzado | ⚠️ Básico (FTS5) |
| Window functions | ✅ | ⚠️ Limitado |
| Parallel queries | ✅ | ❌ |
| Redes | ✅ TCP/IP | ❌ Archivo local |

---

## 5. Migraciones Compatibles

### GORM AutoMigrate

```go
// Compatible con ambos drivers
db.AutoMigrate(&User{}, &Order{})
```

### Raw SQL (cuidado con sintaxis)

```go
// ⚠️ NO usar sintaxis PostgreSQL específica en migrations
// ❌ BAD
db.Exec(`CREATE INDEX CONCURRENTLY ...`)

// ✅ GOOD (compatible)
db.Exec(`CREATE INDEX ...`)
```

---

## 6. Referencias

- [gorm.md](gorm.md) — GORM con SQLite
- [postgresql.md](postgresql.md) — Producción con PostgreSQL
- [testing.md](testing.md) — Tests con SQLite en memoria
- [STACK_MAP.md](../STACK_MAP.md) — Versiones

---

*SQLite es SOLO para desarrollo y testing. Production usa PostgreSQL 16.*

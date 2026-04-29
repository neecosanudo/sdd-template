# PostgreSQL — Base de Datos de Producción

**Versión**: PostgreSQL 16-alpine
**Driver GORM**: gorm.io/driver/postgres v1.6.0
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [gorm.md](gorm.md) | [docker.md](docker.md) | [sqlite.md](sqlite.md)

---

## 1. Configuración via Environment Variables

| Variable | Propósito | Ejemplo |
|----------|-----------|---------|
| `DATABASE_URL` | Connection string completa | `postgres://postgres:secret@localhost:5432/mydb?sslmode=disable` |
| `DB_HOST` | Host de la base | `postgres` (docker-compose) |
| `DB_PORT` | Puerto | `5432` |
| `DB_USER` | Usuario | `postgres` |
| `DB_PASSWORD` | Password | `secret` |
| `DB_NAME` | Nombre de base | `mydb` |
| `DB_SSLMODE` | Modo SSL | `disable` (dev), `require` (prod) |

### DSN Format

```
postgres://[user]:[password]@[host]:[port]/[dbname]?sslmode=[mode]
```

Ejemplo completo:
```
postgres://postgres:mysecretpassword@localhost:5432/mydb?sslmode=disable&TimeZone=UTC
```

---

## 2. Conexión desde Go con GORM

```go
package main

import (
    "fmt"
    "os"
    
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
)

func InitDB() (*gorm.DB, error) {
    dsn := os.Getenv("DATABASE_URL")
    if dsn == "" {
        // Fallback manual
        dsn = fmt.Sprintf(
            "host=%s user=%s password=%s dbname=%s port=%s sslmode=%s TimeZone=UTC",
            os.Getenv("DB_HOST", "localhost"),
            os.Getenv("DB_USER", "postgres"),
            os.Getenv("DB_PASSWORD", "secret"),
            os.Getenv("DB_NAME", "mydb"),
            os.Getenv("DB_PORT", "5432"),
            os.Getenv("DB_SSLMODE", "disable"),
        )
    }

    db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
    if err != nil {
        return nil, fmt.Errorf("failed to connect to db: %w", err)
    }

    // Configurar pool de conexiones
    sqlDB, err := db.DB()
    if err != nil {
        return nil, err
    }
    
    sqlDB.SetMaxIdleConns(10)
    sqlDB.SetMaxOpenConns(100)
    sqlDB.SetConnMaxLifetime(time.Hour)

    return db, nil
}
```

---

## 3. Ciclo de Vida de la Base de Datos

### Creación (Docker)

```bash
#docker-compose.yml ya crea la base automáticamente
#Pero podemos inicializar con scripts:
#volumes:
#  - ./init-scripts:/docker-entrypoint-initdb.d
```

### Migraciones con GORM (Development)

```go
// ⚠️ SOLO desarrollo - ver gorm.md para producción
func Migrate(db *gorm.DB) error {
    return db.AutoMigrate(
        &User{},
        &Order{},
        &Product{},
    )
}
```

### Migraciones Manuales (Producción)

```sql
-- migrations/001_create_users.up.sql
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_created_at ON users(created_at);
```

### Backups

```bash
# Backup
pg_dump -h localhost -U postgres -d mydb -F custom -f backup.dump

# Backup con compresión
pg_dump -h localhost -U postgres -d mydb | gzip > backup.sql.gz

# Restauración
pg_restore -h localhost -U postgres -d mydb -F custom backup.dump
```

---

## 4. Buenas Prácticas

### Índices

```sql
-- Índice para queries frecuentes
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Índice parcial (solo registros activos)
CREATE INDEX idx_users_email ON users(email) WHERE deleted_at IS NULL;

-- Índice compuesto
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
```

### Constraints

```sql
-- NOT NULL
ALTER TABLE users ALTER COLUMN email SET NOT NULL;

-- UNIQUE
ALTER TABLE users ADD CONSTRAINT users_email_key UNIQUE (email);

-- CHECK
ALTER TABLE orders ADD CONSTRAINT chk_positive_total CHECK (total >= 0);

-- FK con ON DELETE
ALTER TABLE orders 
ADD CONSTRAINT fk_user 
FOREIGN KEY (user_id) REFERENCES users(id) 
ON DELETE RESTRICT;
```

### UUID como Primary Key

```go
// Usar UUID para IDs públicos (más seguro que sequential)
type User struct {
    ID        uuid.UUID `gorm:"type:uuid;default:gen_random_uuid();primaryKey"`
    Email     string    `gorm:"uniqueIndex;not null"`
    // ...
}
```

### Timestamps con TimeZone

```sql
-- SIEMPRE usar TIMESTAMP WITH TIME ZONE
created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
```

### JSONB para Datos Semiestructurados

```sql
-- Columna metadata JSONB
ALTER TABLE users ADD COLUMN metadata JSONB;

-- Query JSONB
SELECT * FROM users WHERE metadata->>'role' = 'admin';
```

---

## 5. Docker con Datos Persistentes

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:16-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: secret

volumes:
  postgres_data:
```

---

## 6. Referencias

- [gorm.md](gorm.md) — Uso de GORM con PostgreSQL
- [sqlite.md](sqlite.md) — SQLite para desarrollo local
- [docker.md](docker.md) — Docker Compose completo
- [STACK_MAP.md](../STACK_MAP.md) — Versiones exactas

---

*PostgreSQL 16 es la base de datos de producción. Siempre usar soft deletes y timestamps con timezone.*

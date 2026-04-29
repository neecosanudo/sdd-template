# JWT Auth — Autenticación con Tokens

**Versión**: Ver [STACK_MAP.md](../STACK_MAP.md)
**Tipo**: Access Token (15min) + Refresh Token (7d) con rotation
**Referencias**: [STACK_MAP.md](../STACK_MAP.md) | [go.md](go.md) | [testing.md](testing.md)

---

## 1. Paquetes

```go
import (
    "github.com/golang-jwt/jwt/v5"
    "golang.org/x/crypto/bcrypt"
)
```

---

## 2. Claims Estándar

```go
// CustomClaims incluye los claims estándar + personalizados
type CustomClaims struct {
    UserID   uint   `json:"user_id"`
    Email    string `json:"email"`
    Role     string `json:"role"`
    jwt.RegisteredClaims        // sub, exp, iat, iss
}

// Claims estándar JWT (jwt.RegisteredClaims):
// - sub: Subject (user ID)
// - exp: Expiration time
// - iat: Issued at
// - iss: Issuer
```

---

## 3. Generación de Tokens

### Access Token (15 minutos)

```go
func GenerateAccessToken(user *User, secret string) (string, error) {
    now := time.Now()
    
    claims := CustomClaims{
        UserID: user.ID,
        Email:  user.Email,
        Role:   user.Role,
        RegisteredClaims: jwt.RegisteredClaims{
            Subject:   strconv.FormatUint(uint64(user.ID), 10),
            ExpiresAt: jwt.NewNumericDate(now.Add(15 * time.Minute)),
            IssuedAt:  jwt.NewNumericDate(now),
            Issuer:    "my-app",
        },
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(secret))
}
```

### Refresh Token (7 días, rotation)

```go
func GenerateRefreshToken(userID uint, secret string) (string, error) {
    now := time.Now()
    
    claims := jwt.RegisteredClaims{
        Subject:   strconv.FormatUint(uint64(userID), 10),
        ExpiresAt: jwt.NewNumericDate(now.Add(7 * 24 * time.Hour)), // 7 días
        IssuedAt:  jwt.NewNumericDate(now),
        Issuer:    "my-app",
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(secret))
}
```

---

## 4. Hash de Passwords con bcrypt

```go
const bcryptCost = 12 // Minimo recomendado

// Hash password
func HashPassword(password string) (string, error) {
    bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcryptCost)
    return string(bytes), err
}

// Verify password
func CheckPassword(password, hash string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(hash), []byte(password))
    return err == nil
}
```

---

## 5. Middleware de Autenticación (net/http)

### Middleware Estructura

```go
type AuthMiddleware struct {
    secret string
}

func NewAuthMiddleware(secret string) *AuthMiddleware {
    return &AuthMiddleware{secret: secret}
}

// Middleware que extrae y valida el token
func (m *AuthMiddleware) Authenticate(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // Extraer header Authorization
        authHeader := r.Header.Get("Authorization")
        if authHeader == "" {
            http.Error(w, "missing authorization header", http.StatusUnauthorized)
            return
        }
        
        // Verificar formato "Bearer <token>"
        parts := strings.Split(authHeader, " ")
        if len(parts) != 2 || parts[0] != "Bearer" {
            http.Error(w, "invalid authorization header format", http.StatusUnauthorized)
            return
        }
        
        tokenString := parts[1]
        
        // Parse y validar token
        claims, err := m.ValidateToken(tokenString)
        if err != nil {
            http.Error(w, "invalid token", http.StatusUnauthorized)
            return
        }
        
        // Agregar claims al context
        ctx := context.WithValue(r.Context(), "claims", claims)
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}

func (m *AuthMiddleware) ValidateToken(tokenString string) (*CustomClaims, error) {
    token, err := jwt.ParseWithClaims(tokenString, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
        if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
            return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
        }
        return []byte(m.secret), nil
    })
    
    if err != nil {
        return nil, err
    }
    
    if claims, ok := token.Claims.(*CustomClaims); ok && token.Valid {
        return claims, nil
    }
    
    return nil, errors.New("invalid token")
}
```

### Uso del Middleware

```go
func main() {
    secret := os.Getenv("JWT_SECRET")
    authMw := NewAuthMiddleware(secret)

    mux := http.NewServeMux()

    // Rutas públicas
    mux.HandleFunc("/login", loginHandler)
    mux.HandleFunc("/refresh", refreshHandler)

    // Rutas protegidas con middleware
    protected := authMw.Authenticate(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        switch r.URL.Path {
        case "/profile":
            profileHandler(w, r)
        case "/orders":
            ordersHandler(w, r)
        default:
            http.NotFound(w, r)
        }
    }))

    mux.Handle("/profile", protected)
    mux.Handle("/orders", protected)

    http.ListenAndServe(":8080", mux)
}
```

---

## 6. Refresh Token Rotation

```go
// RefreshHandler - invalidate old refresh token y generar nuevo
func (h *AuthHandler) Refresh(w http.ResponseWriter, r *http.Request) {
    var req RefreshRequest
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
        respondError(w, http.StatusBadRequest, "invalid request")
        return
    }
    
    // Validar refresh token
    claims, err := h.authMw.ValidateToken(req.RefreshToken)
    if err != nil {
        respondError(w, http.StatusUnauthorized, "invalid refresh token")
        return
    }
    
    // ❌ NO hacer esto en producción - implementar blacklist
    // En producción: guardar refresh tokens en DB y verificar que no está revocado
    
    // Obtener usuario
    user, err := h.userRepo.FindByID(claims.Subject)
    if err != nil {
        respondError(w, http.StatusUnauthorized, "user not found")
        return
    }
    
    // Generar nuevos tokens (rotation)
    accessToken, _ := GenerateAccessToken(user, h.secret)
    newRefreshToken, _ := GenerateRefreshToken(user.ID, h.secret)
    
    respondJSON(w, http.StatusOK, TokenResponse{
        AccessToken:  accessToken,
        RefreshToken: newRefreshToken,
    })
}
```

---

## 7. Seguridad: Secretos en Environment Variables

> ⚠️ **WARNING**: Los secretos NUNCA deben estar hardcodeados.

```go
// ❌ INCORRECTO - ¡NO HACER ESTO!
const SECRET = "my-super-secret-key"

// ✅ CORRECTO - Variables de entorno
secret := os.Getenv("JWT_SECRET")
if secret == "" {
    log.Fatal("JWT_SECRET environment variable is required")
}
```

```bash
# .env (NO hacer commit)
JWT_SECRET=your-256-bit-secret-here

# docker-compose.yml
environment:
  - JWT_SECRET=${JWT_SECRET}
```

---

## 8. Referencias

- [go.md](go.md) — Convenciones Go
- [testing.md](testing.md) — Testing de auth

---

*JWT con bcrypt es el estándar de auth. Access tokens cortos + refresh tokens con rotation.*

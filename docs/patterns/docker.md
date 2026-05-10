# Patrones y Conflictos — Docker

> Este archivo documenta comportamientos del entorno Docker que pueden generar errores difíciles de diagnosticar o pérdida de tiempo. Léelo antes de ejecutar comandos Docker en este proyecto.

---

## 1. Volúmenes y Archivos Persistentes

### Problema

Los volúmenes montados (`bind mounts`) persisten entre ejecuciones de contenedores. Archivos generados por el contenedor quedan en el host con permisos de **root**, lo que puede causar:

- Archivos no editables desde el host sin `sudo`
- Estado corrupto de builds previas
- El contenedor siguiente arranca con estado inconsistente

### Síntomas típicos

```bash
# Error común al querer limpiar desde el host
$ rm -rf some-directory
rm: cannot remove 'some-directory/...': Permission denied

# Build que falla de forma intermitente porque hay stale cache
```

### Solución

```bash
# Limpiar desde DENTRO del contenedor (tiene permisos de root)
docker compose run --rm app rm -rf /app/some-directory

# O desde el host con sudo (menos recomendado)
sudo rm -rf some-directory
```

**Regla**: Siempre limpiar cache entre builds cuando cambien archivos de configuración o dependencias.

---

## 2. Ejecutar Comandos con `docker compose run`

### Problema

Usar `docker compose run --rm` ejecuta un comando dentro de un contenedor **nuevo**. Esto es diferente de `docker compose exec` que ejecuta en un contenedor en ejecución.

### Cuándo usar cada uno

| Comando | Cuándo usarlo |
|:---|:---|
| `docker compose run --rm app <cmd>` | Comandos únicos (build, install, lint, test) |
| `docker compose exec app <cmd>` | Comandos contra el servicio en ejecución (dev server interactivo) |

### Importante

- `docker compose run` crea un contenedor temporal. Los archivos modificados en volúmenes montados persisten.
- Siempre usar `--rm` para no dejar contenedores huérfanos.
- El directorio de trabajo dentro del contenedor suele ser `/app`.

```bash
# Ejemplos comunes
docker compose run --rm app go build ./...
docker compose run --rm app go test ./...
docker compose run --rm app rm -rf /app/some-cache
```

---

## 3. Contenedores Huérfanos y `--rm`

### Problema

Si ejecutás `docker compose run` SIN la flag `--rm`, el contenedor persiste después de que el comando termina. Con el tiempo se acumulan contenedores "exited" que consumen espacio en disco.

### Solución

Siempre usar `--rm` con `docker compose run`:

```bash
# ✅ Correcto — el contenedor se elimina al terminar
docker compose run --rm app go build ./...

# ❌ Incorrecto — el contenedor queda en estado "exited"
docker compose run app go build ./...
```

Para limpiar contenedores huérfanos existentes:

```bash
docker compose down --remove-orphans
docker container prune -f
```

---

## 4. Docker Compose Override y Perfiles

### Problema

El proyecto puede tener múltiples servicios definidos en `docker-compose.yml`. Con `docker compose up` sin argumentos se levantan TODOS los servicios definidos, incluso los que no necesitás para una tarea específica.

### Solución

Usar servicios específicos:

```bash
# Levantar solo el servicio app (postgres se levantará por depends_on)
docker compose up app

# Build del app sin levantar servicios
docker compose run --rm app go build ./...
```

---

## 5. Problemas Comunes con docker-compose.yml de Este Proyecto

### Servicios Definidos

| Servicio | Imagen | Puerto | Props |
|:---------|:-------|:-------|:------|
| `postgres` | postgres:15-alpine | 5432 | Volumen persistente |
| `app` | Dockerfile local | 8080 | Bind mount `/app` |

### DATABASE_DSN en app

El servicio `app` necesita la variable `DATABASE_DSN` para conectarse a PostgreSQL:

```
DATABASE_DSN=postgres://app:app@postgres:5432/app?sslmode=disable
```

- Host `postgres` es el nombre del servicio de base de datos
- Puerto 5432 es el puerto interno del contenedor PostgreSQL
- El puerto expuesto al host es 5432 (mapeado en docker-compose.yml)

### Verificar que postgres está listo

```bash
# Esperar a que postgres responda
docker compose exec postgres pg_isready -U app

# Ver logs
docker compose logs postgres
```

## 6. Documentación de Errores Conocidos

| Error | Causa | Solución |
|:---|:---|:---|
| `Permission denied` al borrar archivos | Archivos creados por contenedor como root | Usar `docker compose run --rm app rm -rf ...` |
| Build falla intermitentemente | Stale cache | Limpiar cache antes del build |
| `orphan containers` warning | Contenedores de ejecuciones previas sin `--rm` | `docker compose down --remove-orphans` |
| Postgres connection refused | PostgreSQL no está listo | Esperar con `pg_isready` o `sleep` |
| `DATABASE_DSN` wrong | Host/port incorrectos | Verificar `postgres:5432` en la cadena de conexión |

---

> **Cómo actualizar este archivo**: Cuando encuentres un error de Docker que no está documentado aquí o un patrón que te hizo perder tiempo, agregalo. Especialmente errores relacionados con volúmenes, permisos, puertos o estado entre ejecuciones.
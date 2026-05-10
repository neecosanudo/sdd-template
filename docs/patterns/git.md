# Git Patterns — SDD Template

## 1. SIEMPRE usar `git mv` para renombrar o mover archivos

### Problema

El comando `mv` del shell (o `mv` de Node.js) mueve archivos a nivel de filesystem, pero Git no detecta que se trata de un rename. En su lugar, Git lo interpreta como:
- `D` (deleted): el archivo original fue eliminado
- `??` (untracked): el archivo nuevo apareció de la nada

Esto destruye el historial de líneas del archivo (`git blame`, `git log --follow`) y genera ruido en los diffs.

### Ejemplo incorrecto (NO HACER)

```bash
# ❌ Git pierde el rastro del archivo
mv openspec/changes/my-change openspec/changes/archive/2026-04-26-my-change
git add -A
git commit -m "archive my-change"
# Git ve: D 4 archivos + A 4 archivos (sin relación entre ellos)
```

### Ejemplo correcto (SIEMPRE HACER)

```bash
# ✅ Git detecta el rename y preserva historial
git mv openspec/changes/my-change openspec/changes/archive/2026-04-26-my-change
git commit -m ":art: archive(my-change): move to archive"
# Git ve: R 4 archivos (rename detectado)
```

### Regla simple

**Si el origen y destino están DENTRO del mismo repo Git → `git mv`.** Sin excepciones.

### Excepciones

| Escenario | Comando |
|:---|---|
| Mover dentro del mismo repo | `git mv origen destino` |
| Copiar un archivo | `cp origen destino && git add destino` |
| Mover fuera del repo | `mv` (pero raro en este proyecto) |
| Script de automatización | Usar `git mv` en vez de `fs.rename` o `mv` |

### Verificación

Después de un `git mv`, ejecutar:

```bash
git status --short
```

Debería mostrar `R` (rename) en vez de `D` + `A`.

---

*Documentado: 2026-04-26*
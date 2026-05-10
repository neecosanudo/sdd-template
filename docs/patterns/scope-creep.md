# Protocolo de Ruta de Escape — Scope Creep & Bucles de Depuración

> Este archivo es un **freno de emergencia** para el agente AI. Cuando lo leas, evaluá si estás en uno de los patrones descritos abajo y, si es así, SEGUÍ EL PROTOCOLO. No lo ignores — está aquí porque alguien perdió tiempo valioso antes que vos.

---

## 1. Señales de Alerta Temprana

Reconocé estas señales en los primeros 5 minutos:

| Señal | Qué significa |
|:---|:---|
| Estás editando archivos que NO pidió el usuario | **Scope creep inmediato** — detenete |
| Llevás +15 minutos sin un resultado concreto | **Bucle de depuración** — parate, respirá, reevaluá |
| Creaste 3+ archivos nuevos no solicitados | **Ya pasó el límite** — revertí todo y volvé a lo mínimo |
| El plan de acción supera las 5 tareas | **Demasiado ambicioso** — dividí en cambios independientes |
| Estás "ya que estamos" refactorizando | **Excusa para hacer más de lo pedido** — NO |

**Regla de oro:** Si no está en el pedido del usuario, NO lo hagas. Si CRÉES que debería hacerse, PREGUNTÁ primero.

---

## 2. El Protocolo de los 15 Minutos

Si llevás **15 minutos corridos** sin lograr un avance concreto y verificable:

1. **Pará todo.** No sigas probando "una cosa más".
2. **Revisá el último commit conocido bueno.** ¿Hiciste checkout de ese commit y probaste que funciona?
3. **Revertí tus cambios al último estado conocido bueno.** Usá `git stash` o `git checkout` sobre los archivos tocados.
4. **Reaplicá los cambios de a UNO por vez.** Después de CADA archivo, comprobá que la build funciona.
5. Si después de 3 intentos individuales no encontrás el culpable, **preguntale al usuario**.

**Excepción:** La depuración de un solo error con una hipótesis clara y verificable NO cuenta como "sin avance". Pero si probaste 3 hipótesis y ninguna funcionó, parás.

---

## 3. Depuración de Builds — Búsqueda Binaria

Cuando una build falla y NO sabés qué cambio la rompió:

```
1. git stash  (guardá todos tus cambios)
2. Probá que HEAD compila limpio → si no, el error es preexistente
3. Aplicá los cambios de a UNO, compilando después de cada uno
4. Cuando la build rompe, el último cambio aplicado es el culpable
5. Revisá SOLO ese archivo en detalle
6. Si el error es difícil de ver, copiá el archivo a un editor externo y buská diferencias
```

**NUNCA** cambies 3 archivos, compiles, y adivinés cuál causó el error. Eso es perder el tiempo.

---

## 4. Checkpoint Commits

Antes de hacer cualquier cambio que toque archivos existentes:

```bash
git add -A && git commit -m "checkpoint: antes de [describí el cambio]"
```

Esto te da un punto de retorno limpio. Si la cosa se descontrola:

```bash
git reset --hard HEAD~1   # Volvés al estado anterior
```

**NO** skipees esto porque "es un cambio chico". Los cambios chicos son los que más se subestiman.

---

## 5. Scope Creep — Cómo Decir "No"

El usuario pide X. Vos pensás que Y también sería bueno, o que Z está mal y deberías arreglarlo. ¡NO LO HAGAS!

**Lo correcto:**

> "El cambio que pediste está listo. También noté que [Y] podría mejorarse, pero no quiero agregar scope no solicitado. ¿Querés que lo aborde en otro cambio?"

**Lo incorrecto:**

> "Aproveché y también refactoricé el sidebar, actualicé la tipografía, agregué animaciones..."

La mayoría de los scope creeps empiezan con "aproveché y también". No seas ese agente.

---

## 6. Después de un Scope Creep — Cómo Recuperarse

Si ya caíste en scope creep (como le pasó al agente anterior):

1. **Admitilo.** Decí "esto fue scope creep, no debí haberlo hecho".
2. **Ofrecé revertir.** Preguntá si querés que reviertas al estado anterior.
3. **Si el usuario quiere seguir con lo extra**, documentá que fue decisión explícita del usuario, no iniciativa propia.
4. **Documentá el incidente acá** para que el próximo agente no cometa el mismo error.

---

> **Cómo actualizar este archivo**: Si caés en un patrón nuevo de pérdida de tiempo que no está documentado, agregalo. La próxima vez que alguien (otro agente o vos mismo) tenga el mismo problema, este archivo le va a ahorrar horas.
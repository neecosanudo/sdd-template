# Pipeline CI/CD (CICD_PIPELINE.md)

Automatización de la calidad y el despliegue.

## 1. Etapas del Pipeline
Cualquier cambio propuesto por SDD debe pasar por estas etapas:

1.  **Linting:** Verificación estática del código según `STYLE_GUIDE.md`.
2.  **Test:** Ejecución de la suite completa definida en `TESTING_STRATEGY.md`.
3.  **Build:** Generación de artefactos o imágenes de Docker.
4.  **Security Scan:** Chequeo de vulnerabilidades en dependencias.
5.  **Deploy (opcional):** Despliegue automático a entornos de staging/producción.

## 2. Herramientas
*   *Definir según plataforma* (ej: GitHub Actions, GitLab CI).

## 3. Políticas de Falla
*   Si una etapa falla, el pipeline se detiene inmediatamente.
*   No se permiten merges a `main` si el pipeline no está en verde.

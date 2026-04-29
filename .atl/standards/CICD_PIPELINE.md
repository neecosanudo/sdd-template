# Pipeline CI/CD (CICD_PIPELINE.md)

Automatización de la calidad y el despliegue con GitHub Actions.

## 1. Pipeline de GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  GO_VERSION: '1.25'
  NODE_VERSION: '22'

jobs:
  # Job 1: Lint
  lint:
    name: Lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: ${{ env.GO_VERSION }}

      - name: Go vet
        run: go vet ./...

      - name: Staticcheck
        run: go install honnef.co/go/tools/cmd/staticcheck@latest && staticcheck ./...

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Frontend lint
        run: |
          cd frontend
          npm ci
          npx prettier --check .
          npx eslint .

  # Job 2: Test Backend
  test-backend:
    name: Test Backend
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: ${{ env.GO_VERSION }}

      - name: Test with race detector
        run: go test ./... -v -race -coverprofile=coverage.out

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: backend-coverage
          path: coverage.out

  # Job 3: Test Frontend
  test-frontend:
    name: Test Frontend
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Vitest
        run: |
          cd frontend
          npm ci
          npm run test -- --coverage

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: frontend-coverage
          path: frontend/coverage

  # Job 4: E2E Tests
  e2e:
    name: E2E Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker
        uses: docker/compose@v2

      - name: Start services
        run: docker compose up -d

      - name: Wait for services
        run: sleep 10

      - name: Run Playwright
        run: |
          cd frontend
          npm ci
          npx playwright install --with-deps chromium
          npx playwright test

  # Job 5: Build
  build:
    name: Build
    runs-on: ubuntu-latest
    needs: [lint, test-backend, test-frontend]
    steps:
      - uses: actions/checkout@v4

      - name: Build backend
        run: |
          cd backend
          go build -o server ./cmd/main.go

      - name: Build frontend
        run: |
          cd frontend
          npm ci
          npm run build

      - name: Docker build
        run: docker compose build

  # Job 6: Security Scan
  security:
    name: Security Scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Go vulnerability scan
        run: go install golang.org/x/vuln/cmd/govulncheck@latest && govulncheck ./...

      - name: npm audit
        run: |
          cd frontend
          npm ci
          npm audit --audit-level=high

  # Job 7: Docker
  docker:
    name: Docker Build & Push
    runs-on: ubuntu-latest
    needs: [build]
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: ghcr.io/${{ github.repository }}/backend:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## 2. Dependencias entre Jobs

```
lint ──────────────────┐
                        ├──▶ build ──▶ docker
test-backend ───────────┤
                        │
test-frontend ──────────┤
                        │
e2e ────────────────────┤
                        │
security ───────────────┘
```

## 3. Políticas de Falla

*   Si una etapa falla, el pipeline se detiene para ese job.
*   Jobs posteriores dependen de jobs anteriores (`needs:`).
*   **No se permiten merges a `main` si el pipeline no está en verde.**
*   Coverage debe cumplir thresholds antes de merge.

## 4. Commands de Verificación Local

```bash
# Pre-commit checks
go fmt ./...
go vet ./...
go test ./... -race

# Frontend
cd frontend
npm run lint
npm run test

# E2E
docker compose up -d
npx playwright test
```

---

## Referencias

- [TESTING_STRATEGY.md](TESTING_STRATEGY.md) — Coverage thresholds
- [STYLE_GUIDE.md](STYLE_GUIDE.md) — Linting rules
- [docker.md](../../docs/tools/docker.md) — Docker configuration

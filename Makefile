# Makefile — Template SDD
# Customize these targets for your project's stack

.PHONY: up down test lint build

# levante del proyecto
up:
	@echo "Levantar servicios (personalizar para tu stack)"
	docker compose up -d

# apagado del proyecto
down:
	@echo "Apagar servicios"
	docker compose down

# ejecutar tests
test:
	@echo "Ejecutar tests (personalizar comando para tu stack)"
	# go test ./... -count=1

# linting
lint:
	@echo "Ejecutar linter (personalizar para tu stack)"
	# go vet ./...

# build
build:
	@echo "Compilar proyecto (personalizar para tu stack)"
	# go build -o bin/server ./cmd/server
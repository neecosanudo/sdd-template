.PHONY: up down test lint build migrate

up:
	docker compose up -d

down:
	docker compose down

test:
	go test ./... -count=1

lint:
	go vet ./...

build:
	go build -o bin/server ./cmd/server

migrate:
	golang-migrate -path ./migrations -database "postgres://..." up

tools:
	go install github.com/cosmtrek/air@latest
	go install github.com/golang-migrate/migrate/v4/cmd/migrate@latest
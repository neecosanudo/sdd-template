# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial template structure with SDD workflow

## [0.1.0] - 2026-04-29

### Added

- Go + GORM backend stack (v1.31.1)
- SvelteKit frontend (2.0.0)
- React prototype stack (19.0.0)
- TailwindCSS integration (3.4.1 SvelteKit, 4.1.14 React)
- JWT authentication (golang-jwt/v5 v5.3.1)
- Docker multi-stage builds
- PostgreSQL 16-alpine configuration
- SQLite development setup
- Swagger/OpenAPI tooling (swag v1.16.6)
- Vitest + Playwright testing stack

### Changed

- README now references STACK_MAP.md for version information
- Tool guides updated to reference STACK_MAP.md instead of hardcoding versions

### Fixed

- Template verification script added (verify-template.sh)

---

*This changelog tracks template-level changes. Individual projects should maintain their own changelog based on their development timeline.*
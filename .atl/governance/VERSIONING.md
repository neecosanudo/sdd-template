# Versioning (VERSIONING.md)

This project follows **Semantic Versioning 2.0.0 (SemVer)** strictly.

## Format
`MAJOR.MINOR.PATCH`

1.  **MAJOR:** Incompatible API changes.
2.  **MINOR:** Backward-compatible new functionality.
3.  **PATCH:** Backward-compatible bug fixes.

## Tags
Each release must have a corresponding Git tag:
`git tag -a v1.2.3 -m "Release message"`

## Lifecycle
*   Versions increment only when code reaches `main` and passes all quality checks.
*   Pre-releases use suffixes (e.g., `1.0.0-alpha.1`).

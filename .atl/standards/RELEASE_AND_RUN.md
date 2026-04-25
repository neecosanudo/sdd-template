# Release & Run (RELEASE_AND_RUN.md)

This document defines how the project is packaged, compiled, and executed for the end user or production environment. It is **agnostic** to the project type (game, API, embedded, CLI, etc.).

## 1. Build & Compilation
*   There must be a clear, automated process for generating the executable artifact.
*   **Prefer Automation:** Scripts, Makefiles, or multi-stage containers over manual steps.
*   **Determinism:** Builds should be reproducible across environments (same input → same output).

## 2. Production Environment
*   **Configuration:** Use environment variables or injected config files. Never hardcode credentials.
*   **Security:** Run with restricted permissions (non-root, sandboxed).
*   **Logging/Monitoring:** Emit structured logs for diagnosis in production.

> **Example (not required):** For a web project, this might mean Docker + env vars. For an embedded project, this might mean a signed firmware binary with a config file on an SD card.

## 3. Versioning
*   Follow `.atl/governance/VERSIONING.md` (SemVer 2.0.0).
*   The final artifact must be versioned and tagged with a corresponding Git tag.

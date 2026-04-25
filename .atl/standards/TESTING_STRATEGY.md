# Testing Strategy & Quality Standards (TESTING_STRATEGY.md)

This project uses **Spec-Driven Development (SDD)**. Tests are the validation of specifications, not an afterthought.

## 1. SDD & Testing Cycle
1.  **Spec:** Define expected behavior via specs.
2.  **Design:** Define how to test it.
3.  **Apply:** Implement tests *before* or *simultaneously* with logic (TDD).
4.  **Verify:** SDD verification runs the full suite.

## 2. Test Levels (Language Agnostic)
*   **Unit Tests:** Pure domain logic. No side effects.
*   **Integration Tests:** Adapter-to-domain interactions.
*   **Acceptance/E2E:** Full scenarios from the spec, end-to-end.

> **Note:** These names are conventions. Adapt them to your project's language/tooling.

## 3. Contract Validation (Swagger / OpenAPI / Protobuf / etc.)
> This section applies ONLY to projects that expose interfaces (APIs, gRPC, CLI, etc.).

*   The **contract is the law**. If data crosses a boundary, it must be validated.
*   Example tools for contracts include Swagger/OpenAPI (REST), Protobuf (gRPC), JSON Schema, or any equivalent in your stack.
*   The CI pipeline should validate that implementation matches the contract automatically.
*   **Examples (not requirements):** You may use Swagger for REST APIs, Protobuf for gRPC, or any other schema validation tool.

## 4. Security by Default (Security-First)
> These principles apply regardless of the project type (web, game, embedded, CLI).

*   **Least Privilege Principle:** Every module, service, or user should only have the minimum permissions necessary.
*   **Input Validation (The "Never Trust" Rule):** All external input is potentially malicious. Validate schemas at system boundaries.
*   **SAST/DAST (if applicable):** Integrate static and dynamic analysis tools into the pipeline. For non-web projects, apply equivalent security auditing (e.g., fuzzing for CLI tools, memory checks for embedded).

## 5. Golden Rules
*   **Dependency Injection:** Required for testability.
*   **Coverage Target:** 80% minimum in domain logic (adjustable per project).
*   **Naming:** Describe behavior (`test_should_handle_empty_input`).

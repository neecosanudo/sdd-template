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

## 5. Coverage Standards

*   **Coverage Target:** 100% per-package for domain logic. No exceptions.
    - Adjustments to this threshold MUST be recorded as a decision in `.atl/decisions/DECISION_LOG.md`.
    - Exclusions are discouraged — document justification for each one.
*   **Dependency Injection:** Required for testability. Design modules for testability from the start.
*   **Naming:** Describe behavior (`test_should_handle_empty_input`).

## 6. Strict TDD (RED-GREEN-REFACTOR)

### 6.1 Mandatory Cycle
1.  **RED:** Write a failing test BEFORE writing any implementation code.
2.  **GREEN:** Write the minimum implementation to make the test pass.
3.  **REFACTOR:** Improve code quality while keeping tests green.
4.  **Repeat:** Never break the cycle — always go RED → GREEN → REFACTOR.

### 6.2 No Code Before Test
- **No implementation code is accepted without a failing test first.** This is enforced by `strict_tdd: true` in `config.yaml`.
- If a test cannot be written for existing code, refactor the code to be testable first.
- Agents MUST refuse to implement without tests when `strict_tdd: true`.

## 7. Batch-Verify Workflow

### 7.1 Single-Pass Verification
Run-all, fix-all, re-run-all in a single verification pass:
1.  **Run all tests** across all packages.
2.  **Fix all failures** in one session before committing.
3.  **Re-run all tests** to confirm green state.
4.  **Commit only when** all tests pass, no warnings, no errors.

### 7.2 Batch-Verify Result
- The batch-verify result is **single pass/fail**: either all tests pass (PASS) or the change is rejected (FAIL).
- Partial fixes are not acceptable — either everything passes or nothing is committed.

## 8. Golden Rules
*   **Dependency Injection:** Required for testability.
*   **Coverage Target:** 100% per-package (see Section 5).
*   **Naming:** Describe behavior (`test_should_handle_empty_input`).

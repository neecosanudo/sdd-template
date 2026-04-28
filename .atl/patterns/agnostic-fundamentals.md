# Engineering Patterns (Agnostic)

This directory contains deep engineering concepts that apply across all projects, regardless of the language or platform.

> **How to use these patterns:** These are not rigid rules. They are documented "gotchas" and best practices discovered through experience. If you find a new pattern that improves efficiency, safety, or maintainability, add it here.

> **Framework-specific gotchas:** Language or framework-specific patterns (Go structs, Svelte reactivity, React hooks) belong in `.atl/patterns/{tool}.md`, not in this file.

## 💾 Memory & Performance

### 1. Memory Alignment & Padding
*   **Problem:** Compilers align struct/class fields in memory by word size. If fields are ordered randomly, the system adds "padding" (wasted bytes), increasing memory usage.
*   **Solution:** Order fields from largest to smallest memory footprint, allowing the compiler to pack data more efficiently.
*   **Impact:** Reduced memory usage and better cache locality. Especially important in hot loops, embedded systems, and memory-constrained environments.
*   **Example (Go):**
    ```go
    // BAD — padded to 40 bytes
    type Bad struct {
        a bool    // 1 byte + 7 padding
        b int64   // 8 bytes
        c bool    // 1 byte + 7 padding = total 24+padding
    }
    
    // GOOD — packed to 24 bytes
    type Good struct {
        b int64   // 8 bytes
        a bool    // 1 byte
        c bool    // 1 byte = total 10+padding
    }
    ```

## 🛡 Security by Design

### 1. Least Privilege
*   **Principle:** Every module, service, or user should only have access to the resources necessary for its legitimate purpose.
*   **Application:** Specific interfaces, scoped API keys, non-root containers.

### 2. Input Validation (Never Trust)
*   **Principle:** Assume all input is malicious until validated.
*   **Application:** Schema validation at boundaries, sanitization, range checks.

### 3. Security-First Refactoring
*   **Principle:** When refactoring code, apply security principles AFTER the refactor is complete — never skip security for the sake of speed.
*   **Sequence:** Refactor → Verify correctness → Apply security hardening.
*   **Never skip:** Security hardening is not optional. If a refactor makes security harder, the refactor is incomplete.
*   **Threat Modeling:** Before and after refactoring, assess attack surface changes. Document new threats introduced or mitigated.
*   **Example:** When extracting a function for reuse, ensure it still validates inputs and follows least-privilege before considering the refactor done.

## 🔄 Spec-Driven Development (SDD) Cycle

> **Canonical reference**: For the complete working standard cycle with entry/exit criteria and the "verify until OK" iteration rule, see [`.atl/standards/WORKING_STANDARD.md`](../standards/WORKING_STANDARD.md).

### SDD Phase Sequence
1.  **Verify:** Understand current state and constraints.
2.  **Design:** Document architecture and approach.
3.  **Tasks:** Break down work into implementable units.
4.  **Apply:** Implement code following specs and design.
5.  **Verify:** Confirm implementation matches specs.

### Iteration on Failure
If verification fails, the cycle repeats for the failed batch:
**Verify (failed) → Design (fix) → Tasks (fix) → Apply (fix) → Verify (retry)**
Do NOT advance to the next batch until the current batch passes verification.

### Batch-Verify Cycle
*   **Definition:** A single-pass verification that either passes (all checks green) or fails (any check red).
*   **No partial success:** A change is either fully verified or not verified.
*   **Application:** Run all tests, linters, type checkers, and formatters in one pass. Fix all issues before committing.

## 🏗 Architectural Integrity

### 1. Dependency Inversion
*   **Problem:** High-level logic depending on low-level implementation (DB, UI) makes code hard to test and change.
*   **Solution:** Domain logic defines interfaces (Ports); external tools implement them (Adapters).

---
*This document is the patterns reference. For governance rules, see `.atl/governance/`. For standards, see `.atl/standards/`.*

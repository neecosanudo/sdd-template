# Engineering Patterns (Agnostic)

This directory contains deep engineering concepts that apply across all projects, regardless of the language or platform.

> **How to use these patterns:** These are not rigid rules. They are documented "gotchas" and best practices discovered through experience. If you find a new pattern that improves efficiency, safety, or maintainability, add it here.

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

## 🏗 Architectural Integrity

### 1. Dependency Inversion
*   **Problem:** High-level logic depending on low-level implementation (DB, UI) makes code hard to test and change.
*   **Solution:** Domain logic defines interfaces (Ports); external tools implement them (Adapters).

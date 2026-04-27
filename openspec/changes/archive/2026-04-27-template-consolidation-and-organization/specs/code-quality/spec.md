# Code Quality Specification

## Purpose

Defines code style standards focused on variable naming rationale and log sanitization rules. Extends the existing STYLE_GUIDE.md with battle-tested conventions from real projects.

## Requirements

| # | Requirement | Strength | Summary |
|---|------------|----------|---------|
| CQ-1 | Variable Naming Intent | MUST | Names communicate purpose; single-letter vars prohibited except loops/math |
| CQ-2 | Naming Deviation Justification | MUST | Any convention break must be documented with a "why" comment |
| CQ-3 | Log PII Sanitization | MUST NOT | Logs must never contain PII (names, emails, phones, addresses, IPs) |
| CQ-4 | Log Secret Sanitization | MUST NOT | Logs must never contain secrets (keys, tokens, passwords, certs) |
| CQ-5 | Structured Logging | SHOULD | Structured logging format where platform supports it |

### Requirement: Variable Naming Intent

Variable names MUST communicate intent, not type or implementation detail. The name alone SHALL tell a reader what the variable represents without needing surrounding context.

#### Scenario: Naming a variable for clarity

- GIVEN a function processes a monetary amount
- WHEN the developer chooses a variable name
- THEN the name MUST be `accountBalance` or `pendingWithdrawal`, NOT `amt`, `bal`, `x`
- AND single-character names SHALL NOT be used except for loop indices (`i`, `j`) or established math notation (`x`, `y`)

#### Scenario: Naming convention deviation

- GIVEN a variable name deviates from the convention
- WHEN the deviation is intentional (e.g., domain-specific abbreviation)
- THEN a comment MUST explain the rationale
- AND the comment SHALL be placed on the same line or immediately above

### Requirement: Log Sanitization

Log output MUST NOT expose sensitive data. Sanitization SHALL occur at the system boundary before any log statement executes.

#### Scenario: Logging user data

- GIVEN a system processes user PII (email, name, phone)
- WHEN that data reaches a log statement
- THEN the PII MUST be redacted or hashed before the log is written
- AND the raw PII value SHALL NOT appear in any log output

#### Scenario: Logging authentication flow

- GIVEN a system handles authentication tokens or API keys
- WHEN those values are present in the execution context
- THEN secrets MUST be excluded from log output entirely
- AND placeholder text like `[REDACTED]` or a hash prefix SHALL be used instead

### Requirement: Structured Logging Adoption

Projects SHOULD adopt structured logging (JSON, logfmt) where the runtime platform supports it. Structured logs enable machine parsing for monitoring and alerting.

#### Scenario: Platform supports structured logging

- GIVEN the runtime environment supports JSON-formatted log output
- WHEN a log statement is written
- THEN the log entry SHOULD include structured fields (level, timestamp, message, context)
- AND the log level SHALL be appropriate to the event severity

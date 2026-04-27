# Testing Standards Specification

## Purpose

Defines mandatory testing requirements: 100% coverage for domain logic, strict TDD enforcement, and batch-verify workflow integration. Strengthens the existing TESTING_STRATEGY.md.

## Requirements

| # | Requirement | Strength | Summary |
|---|------------|----------|---------|
| TS-1 | Domain Coverage Threshold | MUST | 100% coverage on domain logic; measured per-package |
| TS-2 | Strict TDD Cycle | MUST | RED-GREEN-REFACTOR: no code before failing test |
| TS-3 | Pre-Commit Test Execution | MUST | Full suite runs before every commit |
| TS-4 | Batch-Verify Workflow | SHALL | Run all, fix all, re-run all; single pass/fail result |
| TS-5 | Zero Warnings in Tests | MUST | Test output must be free of warnings and errors |

### Requirement: Domain Coverage Threshold

Domain logic MUST achieve 100% test coverage before any deployment. Coverage SHALL be measured per-package, not globally aggregated.

#### Scenario: Coverage falls below threshold

- GIVEN a package has 95% test coverage
- WHEN a deploy or merge is attempted
- THEN the pipeline MUST reject the change
- AND the developer MUST add tests for uncovered paths before retrying

#### Scenario: Uncoverable code exists

- GIVEN a code path is genuinely unreachable in tests (e.g., OS-specific error handler)
- WHEN coverage reports it as uncovered
- THEN the exclusion MUST be documented in `.atl/decisions/DECISION_LOG.md`
- AND the rationale SHALL explain why coverage is impossible

### Requirement: Strict TDD Enforcement

No production code SHALL be written before its corresponding failing test. Design MAY precede test writing, but implementation MUST follow the RED-GREEN-REFACTOR cycle.

#### Scenario: Writing new functionality

- GIVEN a developer starts implementing a new feature
- WHEN the first line of production code is about to be written
- THEN a failing test for that behavior MUST already exist
- AND the test SHALL fail for the expected reason (not a compilation error)

#### Scenario: Refactoring existing code

- GIVEN existing code needs restructuring without behavior change
- WHEN the refactoring begins
- THEN the existing test suite MUST pass before any changes
- AND tests SHALL continue passing throughout the refactor

### Requirement: Batch-Verify Integration

The testing workflow SHALL support batch verification: execute all verification steps, collect all failures, fix all failures, and re-execute until clean.

#### Scenario: Batch verification cycle

- GIVEN multiple verification steps exist (lint, test, coverage, build)
- WHEN the batch-verify command is triggered
- THEN all steps MUST execute regardless of individual failures
- AND the final result SHALL be a single pass/fail summary
- AND a failing batch SHALL be re-run after all fixes are applied

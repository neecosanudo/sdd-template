# Engineering Patterns Specification

## Purpose

Defines reusable engineering patterns for security refactoring, SDD cycle navigation, and batch-verify workflow. Strengthens the existing `agnostic-fundamentals.md`.

## Requirements

| # | Requirement | Strength | Summary |
|---|------------|----------|---------|
| EP-1 | Security-First Refactoring | MUST | Security review at design time; refactor before securing |
| EP-2 | SDD Cycle Documentation | SHALL | Full cycle: Verify→Design→Tasks→Apply→Verify, with iteration |
| EP-3 | Batch-Verify Cycle | SHALL | Execute all verification, collect failures, fix all, re-execute |
| EP-4 | Threat Modeling | SHALL | Part of design phase for security-sensitive features |

### Requirement: Security-First Refactoring

Security-critical code paths MUST follow the "Refactor First, Then Secure" pattern. Security reviews SHALL occur at design time, not after implementation.

#### Scenario: Adding authentication to existing code

- GIVEN an existing code path needs auth hardening
- WHEN the security feature is designed
- THEN the code path MUST first be refactored to clean architecture (ports/adapters)
- AND the auth logic SHALL be added at the boundary layer, NOT interleaved with business logic

#### Scenario: Security review timing

- GIVEN a feature with security implications is being designed
- WHEN the design phase starts
- THEN a threat modeling exercise SHALL be part of the design
- AND identified threats SHALL be documented with mitigations in the design document

### Requirement: SDD Cycle Documentation

The SDD cycle SHALL be documented as `Verify → Design → Tasks → Apply → Verify`. Each phase MUST produce a verifiable artifact before the next phase begins.

#### Scenario: Starting from verification

- GIVEN an existing codebase with no formal specs
- WHEN the SDD cycle is initiated
- THEN the first phase is Verify — audit existing code against implicit specs
- AND the verification report SHALL inform what specs need to be written

#### Scenario: Failed verification triggers iteration

- GIVEN implementation is complete and verification runs
- WHEN verification detects a mismatch between code and spec
- THEN the cycle SHALL iterate: fix the implementation OR update the spec
- AND re-verification MUST pass before the change moves to archive

### Requirement: Batch-Verify Cycle

A batch-verify workflow SHALL be available that executes all verification steps, collects failures, and retries after fixes.

#### Scenario: Pre-deploy batch verification

- GIVEN a deployment is imminent
- WHEN the batch-verify command runs
- THEN ALL verification steps (lint, test, coverage, build, contract) execute regardless of individual failures
- AND the result is a single pass/fail summary
- AND on failure, developers fix ALL issues before re-running the full batch

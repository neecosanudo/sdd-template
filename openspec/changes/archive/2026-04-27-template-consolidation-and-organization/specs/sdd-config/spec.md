# SDD Configuration Specification

## Purpose

Defines the mandatory configuration values for the SDD system in `openspec/config.yaml`. Ensures strict TDD and 100% coverage thresholds are enforced by default.

## Requirements

| # | Requirement | Strength | Summary |
|---|------------|----------|---------|
| SC-1 | Strict TDD Enabled | MUST | `strict_tdd: true` in config.yaml |
| SC-2 | Coverage Threshold | MUST | `coverage_threshold: 100` in config.yaml |
| SC-3 | TDD Block on Violation | SHALL | Agent refuses to produce implementation without tests when strict_tdd=true |

### Requirement: Strict TDD Configuration

The `strict_tdd` flag in `openspec/config.yaml` MUST be set to `true`. When enabled, SDD agents SHALL NOT produce implementation code without accompanying test code.

#### Scenario: Agent attempts code without tests

- GIVEN `strict_tdd: true` in config.yaml
- WHEN an SDD agent is about to write implementation code
- THEN the agent SHALL first verify that tests exist or are being written simultaneously
- AND if no tests exist, the agent SHALL refuse to produce implementation and report the violation

#### Scenario: Strict TDD is disabled

- GIVEN `strict_tdd: false` in config.yaml (pre-change state)
- WHEN an SDD agent is about to write implementation code
- THEN the agent MAY write implementation without tests
- AND this behavior is DEPRECATED — the post-change state enforces true

### Requirement: Coverage Threshold Configuration

The `coverage_threshold` value in `openspec/config.yaml` MUST be set to `100`. This applies to domain logic coverage, measured per-package.

#### Scenario: Coverage check during verification

- GIVEN `coverage_threshold: 100` in config.yaml
- WHEN the sdd-verify phase runs coverage checks
- THEN any package below 100% domain logic coverage SHALL cause verification to fail
- AND the failure SHALL list each package and its coverage percentage

#### Scenario: Coverage threshold override

- GIVEN a package has documented, approved exclusions in the decision log
- WHEN coverage is measured for that package
- THEN those specific paths MAY be excluded from the 100% calculation
- AND the exclusion MUST reference the decision log entry

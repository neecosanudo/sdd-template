# Engineering Governance Specification

## Purpose

Defines the top-level engineering governance rules: zero tolerance for warnings and errors, design-before-code mandate, and patterns-before-code enforcement. Strengthens the existing ENGINEERING_MANIFEST.md.

## Requirements

| # | Requirement | Strength | Summary |
|---|------------|----------|---------|
| EG-1 | Zero Tolerance for Warnings | MUST | Pipeline fails on any compiler/linter warning or test error |
| EG-2 | Design Before Code | MUST | No implementation without documented and reviewed design |
| EG-3 | Patterns Before Code | MUST | Established patterns applied before custom implementation |
| EG-4 | Warning Suppression Prohibition | MUST NOT | No pragma/annotation to suppress warnings |

### Requirement: Zero Tolerance for Warnings and Errors

The project SHALL enforce zero tolerance for compiler warnings, linter warnings, runtime warnings, and test suite errors. The CI/CD pipeline MUST fail on any deviation.

#### Scenario: Linter reports a warning

- GIVEN a code change introduces a linter warning
- WHEN the change is pushed or a pre-commit hook runs
- THEN the hook or pipeline MUST reject the change
- AND the developer MUST resolve the warning before resubmitting

#### Scenario: Test suite has a flaky test

- GIVEN a test fails intermittently
- WHEN the failure is observed in CI
- THEN the pipeline MUST fail
- AND the test MUST be fixed (stabilized) or removed with rationale in the decision log
- AND flaky tests SHALL NOT be tolerated under the zero-warning policy

### Requirement: Design Before Code

No implementation SHALL begin without a documented and reviewed design. Design documentation MUST cover architecture decisions, component boundaries, data flow, and error handling strategy.

#### Scenario: Starting a new feature

- GIVEN a feature is ready for implementation
- WHEN the developer begins writing code
- THEN a design document MUST exist at `openspec/changes/{feature}/design.md`
- AND the design MUST have been reviewed (via PR or pair review)
- AND the developer SHALL reference design decisions in commit messages

#### Scenario: Emergency hotfix

- GIVEN a critical production issue requires immediate fix
- WHEN speed takes priority over process
- THEN the fix MAY bypass full design documentation
- BUT a post-hoc design document MUST be filed within 24 hours
- AND the decision log MUST record the bypass with justification

### Requirement: Patterns Before Code

Established patterns in `.atl/patterns/` SHALL be applied before any custom implementation. Deviations MUST be justified in the decision log.

#### Scenario: Choosing an approach for a known problem

- GIVEN a problem matches a documented pattern in `.atl/patterns/`
- WHEN the developer selects an implementation approach
- THEN the documented pattern MUST be used unless explicitly overridden
- AND any override SHALL be recorded in `.atl/decisions/DECISION_LOG.md`

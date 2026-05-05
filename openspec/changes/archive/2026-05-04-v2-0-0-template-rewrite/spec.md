# Spec: v2.0.0 Template Rewrite

## Overview
This spec defines the v2.0.0 template rewrite requirements, establishing a more concise template with robust SDD governance.

## Scenarios

### Scenario 1: ATL Structure
- GIVEN a new project using template v2.0.0
- WHEN initiating SDD cycle
- THEN it uses the new .atl structure

### Scenario 2: Hexagonal Architecture
- GIVEN a developer writing Go code
- WHEN following the template
- THEN uses Hexagonal architecture (domain/entities, domain/ports, application/usecases, infrastructure/adapters)

### Scenario 3: TDD Batch Mode
- GIVEN running tests BEFORE code (TDD)
- THEN writes ALL RED tests first
- THEN writes ALL GREEN code

### Scenario 4: Verify Failure Recovery
- GIVEN Verify fails with ANY issue
- THEN retakes from Tasks phase (not Design)

## Requirements
1. Template must be concise (information density).
2. SDD cycle must use TDD Batch Mode: ALL RED, then ALL GREEN.
3. On Verify failure, retake from Tasks (not Design or Spec).
4. Go code follows Hexagonal architecture pattern.